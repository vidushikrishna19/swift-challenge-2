////
////  scissors paper stone app.swift
////  testapp3
////
////  Created by Shivanishri on 23/8/25.
////
//
//import SwiftUI
//import RealityKit
//
//struct ContentView: View {
//    @State private var playerChoice: String? = nil
//    @State private var aiChoice: String? = nil
//    @State private var gameResult: String = ""
//    @State private var isCountdownActive = false
//    @State private var countdownText = "Ready?"
//    
//    let moves = [
//        ("Rock", "🪨"),
//        ("Paper", "📄"),
//        ("Scissors", "✂️")
//    ]
//    
//    var body: some View {
//        VStack {
//            Text("✂️📄🪨 Scissors Paper Stone 🪨📄✂️")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .multilineTextAlignment(.center)
//                .padding()
//            
//            // AR Hand Animation
//            ARViewContainer(aiChoice: $aiChoice)
//                .edgesIgnoringSafeArea(.all)
//                .frame(height: 400)
//            
//            Text(countdownText)
//                .font(.title)
//                .padding()
//            
//            if gameResult != "" {
//                Text("Result: \(gameResult)")
//                    .font(.title2)
//                    .padding()
//            }
//            
//            Spacer()
//            
//            // Player choice buttons with emojis
//            HStack(spacing: 30) {
//                ForEach(moves, id: \.0) { move, emoji in
//                    Button(action: {
//                        chooseMove(move)
//                    }) {
//                        VStack {
//                            Text(emoji)
//                                .font(.system(size: 40))
//                            Text(move)
//                                .font(.headline)
//                        }
//                        .padding()
//                        .background(Color.blue.opacity(0.7))
//                        .cornerRadius(12)
//                        .foregroundColor(.white)
//                    }
//                    .disabled(isCountdownActive)
//                }
//            }
//            .padding(.bottom, 50)
//        }
//    }
//    
//    // MARK: - Game Logic
//    func chooseMove(_ move: String) {
//        playerChoice = move
//        gameResult = ""
//        aiChoice = nil
//        startCountdown()
//    }
//    
//    func startCountdown() {
//        isCountdownActive = true
//        countdownText = "3"
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { countdownText = "2" }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { countdownText = "1" }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            let randomMove = moves.map { $0.0 }.randomElement()!
//            aiChoice = randomMove
//            countdownText = "Shoot!"
//            checkWinner()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                isCountdownActive = false
//            }
//        }
//    }
//    
//    func checkWinner() {
//        guard let player = playerChoice, let ai = aiChoice else { return }
//        if player == ai {
//            gameResult = "🤝 It's a Draw!"
//        } else if (player == "Rock" && ai == "Scissors") ||
//                    (player == "Paper" && ai == "Rock") ||
//                    (player == "Scissors" && ai == "Paper") {
//            gameResult = "🎉 You Win! 🎉"
//        } else {
//            gameResult = "🤖 AI Wins!"
//        }
//    }
//}
//
//// MARK: - RealityKit Container
//struct ARViewContainer: UIViewRepresentable {
//    @Binding var aiChoice: String?
//    
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        
//        // Load hand model
//        let handModel = try! Entity.load(named: "HandModel")
//        
//        // Place it in front of the camera
//        let anchor = AnchorEntity(world: [0, 0, -0.5])
//        anchor.addChild(handModel)
//        arView.scene.anchors.append(anchor)
//        
//        context.coordinator.handModel = handModel
//        return arView
//    }
//    
//    func updateUIView(_ uiView: ARView, context: Context) {
//        if let choice = aiChoice {
//            context.coordinator.playAnimation(for: choice)
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//    
//    // MARK: - Coordinator for animations
//    class Coordinator {
//        var handModel: Entity?
//        
//        func playAnimation(for choice: String) {
//            guard let hand = handModel else { return }
//            
//            if let anim = hand.availableAnimations.first(where: { $0.name == choice }) {
//                hand.playAnimation(anim, transitionDuration: 0.25, startsPaused: false)
//            }
//        }
//    }
//}
