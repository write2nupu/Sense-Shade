import SwiftUI

struct HueExperienceView: View {
    
    var onBack: () -> Void
    
    @StateObject private var audioManager = AudioManager()
    private let voiceManager = VoiceManager()
    
    @State private var activeIndex: Int? = nil
    @State private var isInteractionLocked = false
    
    @AppStorage("hasSeenInstrumentTutorial") private var hasSeenTutorial = false
    @State private var showTutorial = false
    @State private var tutorialSpoken = false
    
    let zones: [(color: Color, name: String, note: String)] = [
        (.indigo, "Indigo","C4"),
        (.purple, "Violet","D4"),
        (.cyan, "Blue", "E4"),
        (.green, "Green","F4"),
        (.yellow, "Yellow","G4"),
        (.orange, "Orange","A4"),
        (.red, "Red","B4"),
        (.pink, "Pink","C5")
    ]
    
    var body: some View {
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            AnimatedBackground()
            
            GeometryReader { geo in
                let beamWidth = geo.size.width / 8
                
                ForEach(0..<8, id: \.self) { index in
                    AmbientBeam(
                        color: zones[index].color,
                        isActive: activeIndex == index
                    )
                    .frame(width: beamWidth)
                    .position(
                        x: beamWidth * (CGFloat(index) + 0.5),
                        y: geo.size.height / 2
                    )
                }
            }
            
            GeometryReader { geo in
                let beamWidth = geo.size.width / 8
                
                HStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { index in
                        Color.clear
                            .contentShape(Rectangle())
                            .frame(width: beamWidth)
                            .onTapGesture {
                                if !isInteractionLocked && !showTutorial {
                                    triggerZone(index: index)
                                }
                            }
                    }
                }
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        audioManager.stop()
                        voiceManager.stop()
                        onBack()
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                if let index = activeIndex {
                    Text("\(zones[index].name) — \(zones[index].note)")
                        .font(.title3.weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.bottom, 40)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: activeIndex)
                }
            }
            
            if showTutorial {
                tutorialOverlay
            }
        }
        .onAppear {
            if !hasSeenTutorial {
                showTutorial = true
                hasSeenTutorial = true
                speakTutorial()
            }
        }
    }
    
    // MARK: - Beam Trigger
    
    func triggerZone(index: Int) {
        
        guard !isInteractionLocked else { return }
        
        isInteractionLocked = true
        activeIndex = index
        
        let duration = audioManager.playSample(index: index)
        let spokenText = "\(zones[index].name) — \(zones[index].note)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            voiceManager.speak(colorName: spokenText)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 1.2) {
            activeIndex = nil
            isInteractionLocked = false
        }
    }
    
    // MARK: - Tutorial Speech
    
    func speakTutorial() {
        tutorialSpoken = true
        
        voiceManager.speakIntro(
            text: """
            Instrument Mode.
            
            Each vertical beam represents a color.
            
            Tap any beam, one at a time to play its note.
            
            After the sound plays, the color name and note will be spoken aloud.
            """
        )
    }
    
    // MARK: - Tutorial UI
    
    var tutorialOverlay: some View {
        ZStack {
            
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            Color.black.opacity(0.55)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                Text("Instrument Mode")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Text("""
                Each vertical beam represents a color.
                
                Tap one beam at a time to play its note.
                
                After the sound plays,
                the color name and note will be spoken aloud.
                """)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 30)
                
                Button {
                    voiceManager.stop()
                    showTutorial = false
                } label: {
                    Text("Got it")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                .foregroundColor(.white)
                .padding(.horizontal, 60)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.12))
            )
            .padding(.horizontal, 30)
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.4), value: showTutorial)
    }
}

struct AmbientBeam: View {
    
    var color: Color
    var isActive: Bool
    
    @State private var glowIntensity: Double = 0.25
    @State private var widthScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(color.opacity(isActive ? 0.9 : 0.35))
                .frame(maxWidth: 40)
                .scaleEffect(x: widthScale)
            
            Rectangle()
                .fill(color.opacity(isActive ? 0.5 : 0.15))
                .blur(radius: isActive ? 30 : 50)
                .scaleEffect(x: widthScale)
        }
        .blendMode(.screen)
        .onAppear {
            breathe()
        }
        .onChange(of: isActive) { newValue in
            if newValue {
                pluck()
            }
        }
    }
    
    func breathe() {
        withAnimation(
            .easeInOut(duration: 4)
            .repeatForever(autoreverses: true)
        ) {
            glowIntensity = 0.45
        }
    }
    
    func pluck() {
        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
            widthScale = 1.8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeOut(duration: 0.8)) {
                widthScale = 1.0
            }
        }
    }
}

struct AnimatedBackground: View {
    
    @State private var shift: CGFloat = -200
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white.opacity(0.03),
                Color.white.opacity(0.06),
                Color.white.opacity(0.03)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .blendMode(.overlay)
        .blur(radius: 80)
        .offset(x: shift)
        .onAppear {
            withAnimation(
                .linear(duration: 20)
                .repeatForever(autoreverses: true)
            ) {
                shift = 200
            }
        }
        .ignoresSafeArea()
    }
}
