import Speech
import AVFoundation

class SpeechManager: NSObject, SFSpeechRecognizerDelegate {
   static let shared = SpeechManager()
   private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
   private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
   private var recognitionTask: SFSpeechRecognitionTask?
   private let audioEngine = AVAudioEngine()
   
   override init() {
       super.init()
       speechRecognizer?.delegate = self
   }
   
   func requestAuthorization(completion: @escaping (Bool) -> Void) {
       SFSpeechRecognizer.requestAuthorization { status in
           DispatchQueue.main.async {
               completion(status == .authorized)
           }
       }
   }
   
    func startRecording(resultHandler: @escaping (String) -> Void) {
            // 先停止任何正在进行的任务
            stopRecording()
            
            // 请求麦克风权限
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] allowed in
                guard allowed, let self = self else { return }
                
                do {
                    let audioSession = AVAudioSession.sharedInstance()
                    try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                    
                    self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
                    guard let recognitionRequest = self.recognitionRequest else { return }
                    
                    recognitionRequest.shouldReportPartialResults = true
                    
                    let inputNode = self.audioEngine.inputNode
                    self.recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                        if let result = result {
                            resultHandler(result.bestTranscription.formattedString)
                        }
                        
                        if error != nil {
                            self.stopRecording()
                        }
                    }
                    
                    let recordingFormat = inputNode.outputFormat(forBus: 0)
                    inputNode.removeTap(onBus: 0)  // 移除任何现有的 tap
                    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                        recognitionRequest.append(buffer)
                    }
                    
                    self.audioEngine.prepare()
                    try self.audioEngine.start()
                    
                } catch {
                    print("录音初始化失败: \(error.localizedDescription)")
                }
            }
        }
        
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
            
        // 清理
        recognitionRequest = nil
        recognitionTask = nil
            
        // 重置音频会话
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
