import SwiftUI

struct Background: View {
    
    @State private var animate = false
    
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.5], [0.5, 0.5], [1.0, 0.5],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0],
            ],
            colors: animate ? pastelA : pastelB
        )
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
        .onAppear {
            animate.toggle()
        }
    }
    
    private var pastelA: [Color] {
        [
            Color(red: 0.98, green: 0.70, blue: 0.78),  // rosy pink
            Color(red: 1.00, green: 0.82, blue: 0.65),  // soft peach
            Color(red: 1.00, green: 0.92, blue: 0.55),  // butter yellow
            Color(red: 0.65, green: 0.90, blue: 0.75),  // minty green
            Color(red: 0.65, green: 0.82, blue: 1.00),  // baby blue
            Color(red: 0.75, green: 0.70, blue: 1.00),  // lavender
            Color(red: 0.90, green: 0.70, blue: 1.00),  // lilac pink
            Color(red: 0.65, green: 0.95, blue: 0.90),  // seafoam
            Color(red: 1.00, green: 0.75, blue: 0.85)   // blush
        ]
    }

    private var pastelB: [Color] {
        [
            Color(red: 0.75, green: 0.70, blue: 1.00),
            Color(red: 1.00, green: 0.75, blue: 0.85),
            Color(red: 0.98, green: 0.70, blue: 0.78),
            Color(red: 1.00, green: 0.82, blue: 0.65),
            Color(red: 1.00, green: 0.92, blue: 0.55),
            Color(red: 0.65, green: 0.90, blue: 0.75),
            Color(red: 0.65, green: 0.82, blue: 1.00),
            Color(red: 0.90, green: 0.70, blue: 1.00),
            Color(red: 0.65, green: 0.95, blue: 0.90)
        ]
    }
}
