import SwiftUI

struct ContentView: View {
    @StateObject var speechRecognitionManager = SpeechRecognitionManager()
    @State var startRecognitionError: String?

    var body: some View {
        VStack {
            if speechRecognitionManager.isRecognizing {
                GameView(gameEngine: .init(song: Songs.iWantItThatWay))
                    .environmentObject(speechRecognitionManager)
            } else {
                switch speechRecognitionManager.authorizationStatus {
                case .authorized:
                    Button("Start recognition") {
                        startRecognition()
                    }
                    if let startRecognitionError {
                        Text(startRecognitionError)
                            .foregroundColor(.red)
                    }
                case .denied:
                    Text("User denied access to speech recognition")
                        .foregroundColor(.red)
                case .restricted:
                    Text("Speech recognition restricted on this device")
                        .foregroundColor(.red)
                case .notDetermined:
                    Button("Request authorization") {
                        speechRecognitionManager.requestAuthorization()
                    }
                @unknown default:
                    fatalError("Unknown authorization status")
                }
            }
        }
        .padding()
        .onAppear {
            startRecognition()
        }
    }
    
    private func startRecognition() {
        do {
            try speechRecognitionManager.startRecognition()
        } catch {
            startRecognitionError = error.localizedDescription
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
