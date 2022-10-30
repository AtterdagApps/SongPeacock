import MusicKit
import SwiftUI

struct GameView: View {
    @StateObject var gameEngine: GameEngine

    var body: some View {
        VStack {
            if gameEngine.running {
                ForEach(gameEngine.previousLines) { line in
                    VStack {
                        Text(line.realLine.text)
                            .foregroundColor(.secondary)
                        Text(line.recognizedText ?? "")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 24))
                    .padding(8)
                }
                Text(gameEngine.currentLine.realLine.text)
                    .font(.system(size: 32))
                Text(gameEngine.currentLine.recognizedText ?? "")
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
    @Published private(set) var currentLine: RecognizableLine
    @Published private(set) var previousLines: [RecognizableLine] = []
    @Published private(set) var running = false
    let song: SongInfo

    init(song: SongInfo) {
        self.song = song
        currentLine = .init(realLine: song.lyrics.lines.first!)
    }

    @MainActor
    func startGame() async throws {
        let musicAuthorizationStatus = await MusicAuthorization.request()
        let searchRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: "283567164")
        let searchResponse = try await searchRequest.response()
        print(searchResponse)
        let musicPlayer = ApplicationMusicPlayer.shared
        musicPlayer.queue = [searchResponse.items.first!]
        try await musicPlayer.prepareToPlay()
        try await musicPlayer.play()
        running = true
    }

    struct RecognizableLine: Identifiable {
        var id: UUID { realLine.id }
        let realLine: SongInfo.Line
        var recognizedText: String?
    }
}

extension GameEngine {
    static func forPreview(song: SongInfo) -> GameEngine {
        let gameEngine = GameEngine(song: song)
        gameEngine.currentLine = .init(realLine: song.lyrics.lines[3])
        var recognizableLines = [RecognizableLine]()
        recognizableLines.append(.init(realLine: song.lyrics.lines[0], recognizedText: "Imagine there is a heaven"))
        recognizableLines.append(.init(realLine: song.lyrics.lines[1], recognizedText: "It is easy if you try"))
        recognizableLines.append(.init(realLine: song.lyrics.lines[2], recognizedText: "No shell below us"))
        gameEngine.previousLines = recognizableLines
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
