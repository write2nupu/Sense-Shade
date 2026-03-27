import SwiftUI

struct ContentView: View {
    
    @State private var selectedMode: Mode? = nil
    
    enum Mode {
        case instrument
        case explore
    }
    
    var body: some View {
        ZStack {
            
            Background()
            
            Color.black.opacity(0.2)
                    .ignoresSafeArea()
            if let mode = selectedMode {
                
                switch mode {
                case .instrument:
                    HueExperienceView(onBack: {
                        selectedMode = nil
                    })
                case .explore:
                    ExploreModeView(onBack: {
                        selectedMode = nil
                    })
                }
                
            } else {
                introView
            }
        }
        .animation(.easeInOut(duration: 0.4), value: selectedMode)
    }
    
    var introView: some View {
        VStack(spacing: 28) {
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("Sense")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("Shade")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white.opacity(0.9), .white.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .shadow(color: .black.opacity(0.3), radius: 8)
            
            Text("Experience color beyond sight")
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            VStack(spacing: 16) {
                
                Button {
                    selectedMode = .instrument
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "pianokeys")
                            .font(.title3)
                        
                        Text("Instrument Mode")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.25), radius: 10)
                }
                .foregroundColor(.white)
                
                Button {
                    selectedMode = .explore
                } label: {
                    HStack {
                        Image(systemName: "camera.fill")
                            .font(.title3)
                        
                        Text("Explore Mode")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.25), radius: 10)
                }
                .foregroundColor(.white)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}
