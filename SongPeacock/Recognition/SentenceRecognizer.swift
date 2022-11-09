import Combine
import Speech

class SentenceRecognizer: NSObject, ObservableObject {
    let recognition = CurrentValueSubject<String?, Never>(nil)
    private let audioEngine: AVAudioEngine
    private let speechRecognizer: SFSpeechRecognizer
    private var recognitionTask: SFSpeechRecognitionTask?
    private var hasFinished = false

    init(audioEngine: AVAudioEngine) {
        self.audioEngine = audioEngine
        speechRecognizer = .init(locale: Locale(identifier: "en-US"))!
        speechRecognizer.defaultTaskHint = .unspecified
    }

    func startNewSentenceRecognition() {
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.taskHint = .dictation

        print("----- new sentence -----")
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, delegate: self)

        let format = audioEngine.inputNode.outputFormat(forBus: 0)
        let sinkNode = AVAudioSinkNode { _, _, audioBufferList -> OSStatus in
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, bufferListNoCopy: audioBufferList) else {
                return kAudioUnitErr_FormatNotSupported
            }
            recognitionRequest.append(buffer)
            return 0
        }
        audioEngine.attach(sinkNode)
        audioEngine.connect(audioEngine.inputNode, to: sinkNode, format: nil)

        audioEngine.prepare()
        try! audioEngine.start()
    }
}

extension SentenceRecognizer: SFSpeechRecognitionTaskDelegate {
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didHypothesizeTranscription transcription: SFTranscription) {
        guard !hasFinished else { return }
        recognition.send(transcription.formattedString)
        print("recognition: ", transcription.formattedString)
    }
}
