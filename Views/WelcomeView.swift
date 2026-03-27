import SwiftUI
import AVFoundation

struct WelcomeView: View {
    
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false
    @State private var hasSpoken = false
    @State private var breathe = false
    
    private let voiceManager = VoiceManager()
    
    var body: some View {
        ZStack {
            
            Background()
            
            Color.black.opacity(0.4).ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Spacer()
                
                ZStack {
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    .white.opacity(0.25),
                                    .white.opacity(0.1),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 10,
                                endRadius: 110
                            )
                        )
                        .frame(width: 220, height: 220)
                        .blur(radius: 18)
                        .scaleEffect(breathe ? 1.05 : 0.95)
                        .animation(
                            .easeInOut(duration: 3).repeatForever(autoreverses: true),
                            value: breathe
                        )
                    
                    Circle()
                        .stroke(Color.white.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 160, height: 160)
                    
                    Image(systemName: "waveform")
                        .font(.system(size: 65, weight: .regular))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 10)
                    .scaleEffect(breathe ? 1.05 : 0.95)
                    .animation(
                        .easeInOut(duration: 3).repeatForever(autoreverses: true),
                        value: breathe
                    )
                    .padding(.bottom, 10)
                
                Text("Sense Shade")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("""
                This app transforms color into 
                sound & voice.
                
                Experience the world beyond sight.
                
                Tap, listen, and explore the spectrum in a new way.
                """)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 40)
                
                Spacer()
                
                Button {
                    hasSeenIntro = true
                } label: {
                    Text("Begin")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.65, green: 0.55, blue: 0.85),   // muted lavender
                                    Color(red: 0.85, green: 0.60, blue: 0.75)    // dusty rose
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .clipShape(Capsule())
                        .shadow(color: .purple.opacity(0.4), radius: 12)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            speakIfNeeded()
            breathe = true
        }
    }
    
    private func speakIfNeeded() {
        guard !hasSpoken else { return }
        hasSpoken = true
        
        voiceManager.speakIntro(
            text: """
            Welcome to Sense Shade.
            This app transforms color into sound and voice.
            Experience the world beyond sight.
            Tap, listen, and explore the spectrum in a new way.
            """
        )
    }
}
