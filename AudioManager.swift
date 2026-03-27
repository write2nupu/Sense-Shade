import AVFoundation

final class AudioManager: ObservableObject {
    
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    
    private var audioFiles: [AVAudioFile] = []
    
    init() {
        setup()
    }
    
    private func setup() {
        
        let noteNames = ["C4","D4","E4","F4","G4","A4","B4","C5"]
        
        for name in noteNames {
            if let url = Bundle.main.url(forResource: name, withExtension: "wav"),
               let file = try? AVAudioFile(forReading: url) {
                audioFiles.append(file)
            }
        }
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: nil)
        
        try? engine.start()
    }
    
    func playSample(index: Int) -> Double {
        guard index < audioFiles.count else { return 0 }
        
        let file = audioFiles[index]
        
        player.stop()
        player.scheduleFile(file, at: nil)
        player.play()
        
        let duration = Double(file.length) / file.processingFormat.sampleRate
        return duration
    }
    func stop() {
        player.stop()
    }
}
