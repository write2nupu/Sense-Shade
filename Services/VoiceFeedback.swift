import AVFoundation

class VoiceManager {
    
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(colorName: String) {
        
        synthesizer.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: colorName)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
        
        synthesizer.speak(utterance)
    }
    
    func speakIntro(text: String) {
        
        synthesizer.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: text)
        
        if let voice = AVSpeechSynthesisVoice(language: "en-US") {
            utterance.voice = voice
        }
        
        utterance.rate = 0.42
        utterance.pitchMultiplier = 1.05
        utterance.volume = 1.0
        
        utterance.preUtteranceDelay = 0.2
        utterance.postUtteranceDelay = 0.2
        
        synthesizer.speak(utterance)
    }
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
