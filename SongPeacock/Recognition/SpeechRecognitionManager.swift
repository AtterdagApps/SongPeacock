import AVFoundation
import Foundation
import Speech

struct RecognizedSentence: Identifiable {
    let id = UUID()
    let text: String
}

@MainActor
class SpeechRecognitionManager: NSObject, ObservableObject {
    @Published private(set) var authorizationStatus = SFSpeechRecognizer.authorizationStatus()
    @Published private(set) var isRecognizing = false
    private let audioEngine = AVAudioEngine()
    private var recognitionTasks = [SFSpeechRecognitionTask]()
    private var useFirstRecognizer = true

    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            self.authorizationStatus = authStatus
        }
    }

    func startRecognition() throws {
        audioEngine.stop()
        recognitionTasks.forEach { $0.cancel() }
        recognitionTasks.removeAll()

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .default, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        isRecognizing = true
    }

    func createSentenceRecognition() -> SentenceRecognizer {
        .init(audioEngine: audioEngine)
    }
}
