import AVFAudio
import Combine
import MusicKit
import SwiftUI

struct GameView: View {
    @EnvironmentObject private var speechRecognitionManager: SpeechRecognitionManager
    @State private(set) var currentSentence: RecognizableSentence?
    @State private(set) var previousSentences: [RecognizableSentence] = []
    @State private(set) var running = true
    @State private var songStart: Date?
    @State private var sentenceIndex = -1
    private let song: SongInfo
    private var isPreview = false

    init(song: SongInfo) {
        self.song = song
        updateCurrentSentence(timestamp: 0)
    }

    var body: some View {
        VStack {
            if running {
                ScrollView {
                    ForEach(previousSentences.suffix(9)) { sentence in
                        VStack {
                            Text(sentence.realSentence.text)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            Text(sentence.recognizedText ?? "")
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                        }
                        .font(.system(size: 24))
                        .padding(8)
                    }
                }
                if let currentSentence {
                    VStack {
                        Text(currentSentence.realSentence.text)
                            .padding(.top)
                            .multilineTextAlignment(.center)
                        Text(currentSentence.recognizedText ?? "")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    .font(.system(size: 32))
                }
                Spacer()
//                Button("SOMEHITNASDAKMSDASKMDkmadksmakdmask") {
//                    let seconds = Date.now.timeIntervalSince1970 - songStart!.timeIntervalSince1970
//                    let duration = Duration.milliseconds(seconds * 1000)
//                    print("TIMESTAMP", duration)
//                }
            } else {
                Button("Start") {
                    Task {
                        do {
                            try await startGame()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .default).autoconnect(), perform: { now in
            guard let songStart else { return }
            let timestamp = now.timeIntervalSince1970 - songStart.timeIntervalSince1970
            updateCurrentSentence(timestamp: timestamp)
        })
        .task {
            do {
                try await startGame()
            } catch {
                print(error.localizedDescription)
            }
        }
        .onAppear {
            if isPreview {
                currentSentence = .init(realSentence: song.lyrics.sentences[3])
                var recognizableSentences = [RecognizableSentence]()
                recognizableSentences.append(.init(realSentence: song.lyrics.sentences[0], recognizedText: "Yeah"))
                recognizableSentences.append(.init(realSentence: song.lyrics.sentences[1], recognizedText: "Do are my fire"))
                recognizableSentences.append(.init(realSentence: song.lyrics.sentences[2], recognizedText: "The only desire"))
                previousSentences = recognizableSentences
                running = true
            }
        }
    }

    @MainActor
    func startGame() async throws {
        _ = await MusicAuthorization.request()
        #warning("👻 Handle denied authorization")
        let searchRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: "283567164")
        let searchResponse = try await searchRequest.response()
        let musicPlayer = ApplicationMusicPlayer.shared
        musicPlayer.queue = [searchResponse.items.first!]
        try await musicPlayer.prepareToPlay()
        try await musicPlayer.play()
        songStart = .now
        running = true
    }

    private func updateCurrentSentence(timestamp: TimeInterval) {
        let newIndex = sentenceIndex + 1
        let newSentence = song.lyrics.sentences.indices.contains(newIndex) ? song.lyrics.sentences[newIndex] : nil
        if let newSentence, newSentence.timestamp <= timestamp {
            if let currentSentence {
                previousSentences.append(currentSentence)
            }
            currentSentence = .init(
                realSentence: newSentence,
                sentenceRecognizer: speechRecognitionManager.createSentenceRecognition())
            sentenceIndex = newIndex
        }
    }

    class RecognizableSentence: ObservableObject, Identifiable {
        var id: UUID { realSentence.id }
        let realSentence: SongInfo.Sentence
        let sentenceRecognizer: SentenceRecognizer
        @Published private(set) var recognizedText: String?
        private var cancellables = Set<AnyCancellable>()

        init(realSentence: SongInfo.Sentence, sentenceRecognizer: SentenceRecognizer = .init(audioEngine: AVAudioEngine()), recognizedText: String? = nil) {
            self.realSentence = realSentence
            self.sentenceRecognizer = sentenceRecognizer
            self.recognizedText = recognizedText
            sentenceRecognizer.recognition
                .compactMap { $0 }
                .sink { self.recognizedText = $0 }
                .store(in: &cancellables)
            sentenceRecognizer.startNewSentenceRecognition()
        }
    }
}

extension GameView {
    static func forPreview(song: SongInfo) -> GameView {
        var view = GameView(song: song)
        view.isPreview = true
        return view
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView.forPreview(song: Songs.iWantItThatWay)
            .environmentObject(SpeechRecognitionManager())
    }
}

// let searchRequest = MusicCatalogResourceRequest<Album>(matching: \.upc, equalTo: "012414401625")
// let searchResponse = try await searchRequest.response()
// let albumWithTracks = try await searchResponse.items.first?.with(.tracks)
// print(albumWithTracks?.tracks)
// let searchRequest = MusicCatalogResourceRequest<Song>(matching: \.isrc, equalTo: "USJI19910614")
// let searchRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: "432157852")
// let searchResponse = try await searchRequest.response()
// print(searchResponse.items.first)
