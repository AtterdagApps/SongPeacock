import MusicKit
import SwiftUI

struct GameView: View {
    @StateObject var gameEngine: GameEngine

    var body: some View {
        VStack {
            if gameEngine.running {
                ForEach(gameEngine.previousSentences) { sentence in
                    VStack {
                        Text(sentence.realSentence.text)
                            .foregroundColor(.secondary)
                        Text(sentence.recognizedText ?? "")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 24))
                    .padding(8)
                }
                Text(gameEngine.currentSentence.realSentence.text)
                    .font(.system(size: 32))
                Text(gameEngine.currentSentence.recognizedText ?? "")
                    .font(.system(size: 32))
                    .fontWeight(.bold)
                Spacer()
            } else {
                Button("Start") {
                    Task {
                        do {
                            try await gameEngine.startGame()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        .task {
            do {
                try await gameEngine.startGame()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

class GameEngine: ObservableObject {
    @Published private(set) var currentSentence: RecognizableSentence
    @Published private(set) var previousSentences: [RecognizableSentence] = []
    @Published private(set) var running = false
    let song: SongInfo

    init(song: SongInfo) {
        self.song = song
        currentSentence = .init(realSentence: song.lyrics.sentences.first!)
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
        running = true
    }

    struct RecognizableSentence: Identifiable {
        var id: UUID { realSentence.id }
        let realSentence: SongInfo.Sentence
        var recognizedText: String?
    }
}

extension GameEngine {
    static func forPreview(song: SongInfo) -> GameEngine {
        let gameEngine = GameEngine(song: song)
        gameEngine.currentSentence = .init(realSentence: song.lyrics.sentences[3])
        var recognizableSentences = [RecognizableSentence]()
        recognizableSentences.append(.init(realSentence: song.lyrics.sentences[0], recognizedText: "Imagine there is a heaven"))
        recognizableSentences.append(.init(realSentence: song.lyrics.sentences[1], recognizedText: "It is easy if you try"))
        recognizableSentences.append(.init(realSentence: song.lyrics.sentences[2], recognizedText: "No shell below us"))
        gameEngine.previousSentences = recognizableSentences
        return gameEngine
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameEngine: .forPreview(song: Songs.iWantItThatWay))
    }
}

//let searchRequest = MusicCatalogResourceRequest<Album>(matching: \.upc, equalTo: "012414401625")
//let searchResponse = try await searchRequest.response()
//let albumWithTracks = try await searchResponse.items.first?.with(.tracks)
//print(albumWithTracks?.tracks)
//let searchRequest = MusicCatalogResourceRequest<Song>(matching: \.isrc, equalTo: "USJI19910614")
//let searchRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: "432157852")
//let searchResponse = try await searchRequest.response()
//print(searchResponse.items.first)
