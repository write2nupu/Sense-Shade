import SwiftUI
import PhotosUI
import UIKit
import AVFoundation

struct ExploreModeView: View {
    
    var onBack: () -> Void
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showCamera = false
    
    @AppStorage("hasSeenExploreTutorial") private var hasSeenExploreTutorial = false
    @State private var showTutorial = false
    @State private var tutorialSpoken = false
    
    @State private var tapLocation: CGPoint?
    
    private let voiceManager = VoiceManager()
    
    let colorPalette: [(name: String, color: UIColor)] = [
        ("Black", UIColor(red: 0, green: 0, blue: 0, alpha: 1)),
        ("Dark Gray", UIColor.darkGray),
        ("Gray", UIColor.gray),
        ("Light Gray", UIColor.lightGray),
        ("White", UIColor.white),
        
        ("Red", UIColor.red),
        ("Dark Red", UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)),
        ("Pink", UIColor.systemPink),
        
        ("Orange", UIColor.orange),
        ("Brown", UIColor.brown),
        ("Tan", UIColor(red: 0.82, green: 0.71, blue: 0.55, alpha: 1)),
        
        ("Yellow", UIColor.yellow),
        ("Green", UIColor.green),
        ("Dark Green", UIColor(red: 0, green: 0.4, blue: 0, alpha: 1)),
        ("Lime", UIColor(red: 0.7, green: 1, blue: 0, alpha: 1)),
        
        ("Cyan", UIColor.cyan),
        ("Blue", UIColor.blue),
        ("Navy", UIColor(red: 0, green: 0, blue: 0.5, alpha: 1)),
        ("Sky Blue", UIColor(red: 0.4, green: 0.7, blue: 1, alpha: 1)),
        
        ("Purple", UIColor.purple),
        ("Violet", UIColor(red: 0.6, green: 0.4, blue: 1, alpha: 1)),
        ("Lavender", UIColor(red: 0.8, green: 0.7, blue: 1, alpha: 1))
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.08, blue: 0.12),
                    Color(red: 0.15, green: 0.12, blue: 0.20)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        onBack()
                    }) {
                        Label("Back", systemImage: "chevron.left")
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding()
                Text("Explore Colors")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.75, green: 0.65, blue: 0.95)) // soft lavender
                    .shadow(color: Color(red: 0.75, green: 0.65, blue: 0.95).opacity(0.6), radius: 10)
                    .shadow(color: Color(red: 0.75, green: 0.65, blue: 0.95).opacity(0.3), radius: 25)
                Spacer()
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(
                                    LinearGradient(
                                        colors: [.purple.opacity(0.6), .blue.opacity(0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                    
                    if let image = selectedImage {
                        
                        GeometryReader { geo in
                            
                            ZStack {
                                
                                let imageSize = image.size
                                let containerSize = geo.size
                                
                                let scale = min(containerSize.width / imageSize.width,
                                                containerSize.height / imageSize.height)
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                
                                if let location = tapLocation {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                RadialGradient(
                                                    colors: [
                                                        Color.white.opacity(0.45),
                                                        Color.white.opacity(0.15),
                                                        Color.clear
                                                    ],
                                                    center: .center,
                                                    startRadius: 0,
                                                    endRadius: 30
                                                )
                                            )
                                            .frame(width: 60, height: 60)
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                            .frame(width: 22, height: 22)
                                    }
                                    .position(location)
                                }
                                
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture { location in
                                if showTutorial { return }
                                let imageSize = image.size
                                let containerSize = geo.size
                                
                                let scale = min(containerSize.width / imageSize.width,
                                                containerSize.height / imageSize.height)
                                
                                let displayedWidth = imageSize.width * scale
                                let displayedHeight = imageSize.height * scale
                                
                                let xOffset = (containerSize.width - displayedWidth) / 2
                                let yOffset = (containerSize.height - displayedHeight) / 2
                                
                                let imageRect = CGRect(
                                    x: xOffset,
                                    y: yOffset,
                                    width: displayedWidth,
                                    height: displayedHeight
                                )
                                
                                if imageRect.contains(location) {
                                    tapLocation = location
                                    handleTap(at: location, in: geo.size)
                                }
                            }
                        }
                        .padding(16)
                        .padding(16)
                    } else {
                        Text("Capture or Select a Photo")
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.52)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Camera & Library Buttons
                HStack(spacing: 20) {
                    
                    Button {
                        showCamera = true
                    } label: {
                        Label("Camera", systemImage: "camera.fill")
                            .font(.headline)
                            .padding()
                            .frame(width: 150)
                            .background(
                                Color.white.opacity(0.12)
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("Library", systemImage: "photo.fill")
                            .font(.headline)
                            .padding()
                            .frame(width: 150)
                            .background(Color.white.opacity(0.1))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
                .foregroundColor(.white)
                .padding(.bottom, 40)
            }
            if showTutorial {
                exploreTutorialOverlay
            }
        }
        .onAppear {
            if !hasSeenExploreTutorial {
                showTutorial = true
                hasSeenExploreTutorial = true
                speakExploreTutorial()
            }
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera) { image in
                selectedImage = image
            }
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                }
            }
        }
    }
    
    // MARK: - Handle Tap
    
    func handleTap(at location: CGPoint, in size: CGSize) {
        
        guard let image = selectedImage else { return }
        
        tapLocation = location
        
        if let avgColor = image.averageColor(at: location,
                                             in: size) {
            
            let colorName = classifyColor(avgColor)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                voiceManager.speak(colorName: colorName)
            }
        }
        
    }
    func speakExploreTutorial() {
        tutorialSpoken = true
        
        voiceManager.speakIntro(
            text: """
            Explore Mode.
            
            You can capture a photo or choose one from your library.
            
            Tap anywhere on the image to hear the color at that location.
            
            The detected color will be spoken aloud.
            """
        )
    }
    var exploreTutorialOverlay: some View {
        ZStack {
            
            ZStack {
                // Blur everything behind
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                
                // Darken it more
                Color.black.opacity(0.55)
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 24) {
                
                Text("Explore Mode")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Text("""
                Capture a photo or choose one from your library.
                
                Tap anywhere on the image to hear its color.
                
                The detected color will be spoken aloud.
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
                    .fill(Color.white.opacity(0.08))
            )
            .padding(.horizontal, 30)
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.4), value: showTutorial)
    }
    
    // MARK: - Color Classification
    
    func classifyColor(_ color: UIColor) -> String {
        
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard color.getHue(&hue,
                           saturation: &saturation,
                           brightness: &brightness,
                           alpha: &alpha) else {
            return "Unknown"
        }
        
        let degrees = hue * 360
        
        if saturation < 0.25 {
            if brightness > 0.85 { return "White" }
            if brightness < 0.2 { return "Black" }
            return "Gray"
        }
        
        switch degrees {
        case 0..<20, 340..<360:
            return "Red"
        case 20..<45:
            return "Orange"
        case 45..<70:
            return "Yellow"
        case 70..<160:
            return "Green"
        case 160..<200:
            return "Cyan"
        case 200..<260:
            return "Blue"
        case 260..<320:
            return "Purple"
        case 320..<340:
            return "Pink"
        default:
            return "Red"
        }
    }
}

extension UIImage {
    
    func averageColor(at tapLocation: CGPoint,
                      in imageViewSize: CGSize) -> UIColor? {
        
        guard let cgImage = self.cgImage else { return nil }
        
        let imageSize = CGSize(width: cgImage.width,
                               height: cgImage.height)
        
        let scale = min(imageViewSize.width / imageSize.width,
                        imageViewSize.height / imageSize.height)
        
        let displayedWidth = imageSize.width * scale
        let displayedHeight = imageSize.height * scale
        
        let xOffset = (imageViewSize.width - displayedWidth) / 2
        let yOffset = (imageViewSize.height - displayedHeight) / 2
        
        let clampedX = max(xOffset,
                           min(tapLocation.x, xOffset + displayedWidth))
        let clampedY = max(yOffset,
                           min(tapLocation.y, yOffset + displayedHeight))
        
        let imageX = (clampedX - xOffset) / scale
        let imageY = (clampedY - yOffset) / scale
        
        let pixelX = Int(imageX)
        let pixelY = Int(imageY)
        
        let sampleSize = 8
        
        let width = cgImage.width
        let height = cgImage.height
        
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
        let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0,
                                          width: width,
                                          height: height))
        
        guard let data = context?.data else { return nil }
        
        let ptr = data.bindMemory(to: UInt8.self,
                                  capacity: width * height * 4)
        
        var totalR: CGFloat = 0
        var totalG: CGFloat = 0
        var totalB: CGFloat = 0
        var count: CGFloat = 0
        
        for x in (pixelX - sampleSize)...(pixelX + sampleSize) {
            for y in (pixelY - sampleSize)...(pixelY + sampleSize) {
                
                if x >= 0 && x < width &&
                   y >= 0 && y < height {
                    
                    let offset = (y * width + x) * 4
                    
                    let r = CGFloat(ptr[offset]) / 255.0
                    let g = CGFloat(ptr[offset + 1]) / 255.0
                    let b = CGFloat(ptr[offset + 2]) / 255.0
                    
                    totalR += r
                    totalG += g
                    totalB += b
                    count += 1
                }
            }
        }
        
        if count == 0 { return nil }
        
        return UIColor(
            red: totalR / count,
            green: totalG / count,
            blue: totalB / count,
            alpha: 1
        )
    }
}

import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType
    var completion: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                parent.completion(image)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
