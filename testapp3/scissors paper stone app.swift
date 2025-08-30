//
//  scissors paper stone app.swift
//  testapp3
//
//  Created by Shivanishri on 23/8/25.
//

import SwiftUI
import RealityKit
import ARKit
import Foundation

struct ContentView: View {
    var body: some View {
        RockPaperScissorsView()
    }
}

struct RockPaperScissorsView: View {
    @State private var arView = ARView(frame: .zero)
    @State private var playerChoice: GameChoice? = nil
    @State private var aiChoice: GameChoice? = nil
    @State private var gameResult: GameResult? = nil
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            ARViewContainer(arView: arView)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                if let result = gameResult {
                    Text(result.message)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                }
                
                HStack(spacing: 20) {
                    Button(action: { playGame(.rock) }) {
                        Text("🪨 Rock")
                            .font(.title2)
                            .padding()
                            .background(Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: { playGame(.paper) }) {
                        Text("📄 Paper")
                            .font(.title2)
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: { playGame(.scissors) }) {
                        Text("✂️ Scissors")
                            .font(.title2)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(isAnimating)
                .opacity(isAnimating ? 0.5 : 1.0)
                .padding(.bottom, 50)
            }
        }
    }
    
    private func playGame(_ choice: GameChoice) {
        guard !isAnimating else { return }
        
        playerChoice = choice
        aiChoice = GameChoice.allCases.randomElement()!
        isAnimating = true
        
        // Start countdown animation
        startGameAnimation()
        
        // Determine winner after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            gameResult = determineWinner(player: choice, ai: aiChoice!)
            isAnimating = false
            
            // Reset after showing result
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                resetGame()
            }
        }
    }
    
    private func startGameAnimation() {
        guard let handModel = arView.scene.findEntity(named: "HandModel") as? ModelEntity else {
            print("Could not find HandModel entity")
            return
        }
        
        // Countdown animation (rock-rock-rock-choice)
        animateCountdown(entity: handModel) { [self] in
            // Show final choices
            if let playerChoice = self.playerChoice {
                animateToChoice(entity: handModel, choice: playerChoice, isPlayer: true)
            }
        }
    }
    
    private func resetGame() {
        gameResult = nil
        playerChoice = nil
        aiChoice = nil
        
        // Reset hand to neutral position
        if let handModel = arView.scene.findEntity(named: "HandModel") as? ModelEntity {
            animateToChoice(entity: handModel, choice: .rock, isPlayer: false)
        }
    }
    
    private func determineWinner(player: GameChoice, ai: GameChoice) -> GameResult {
        if player == ai {
            return GameResult(message: "It's a tie!", winner: nil)
        }
        
        let playerWins = (player == .rock && ai == .scissors) ||
                        (player == .paper && ai == .rock) ||
                        (player == .scissors && ai == .paper)
        
        return GameResult(
            message: playerWins ? "You win!" : "AI wins!",
            winner: playerWins ? .player : .ai
        )
    }
}

struct ARViewContainer: UIViewRepresentable {
    let arView: ARView
    
    func makeUIView(context: Context) -> ARView {
        setupARView()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    private func setupARView() {
        // Configure AR session
        let config = ARWorldTrackingConfiguration()
        arView.session.run(config)
        
        // Create anchor and scene
        let anchor = AnchorEntity(plane: .horizontal)
        
        // Create hand model (you can replace this with your actual 3D model)
        let handModel = createHandModel()
        handModel.name = "HandModel"
        
        // Position the hand model
        handModel.position = [0, 0, -0.5]
        handModel.scale = [0.1, 0.1, 0.1]
        
        anchor.addChild(handModel)
        arView.scene.addAnchor(anchor)
        
        // Add lighting
        let lightEntity = Entity()
        lightEntity.components[DirectionalLightComponent.self] = DirectionalLightComponent(
            color: .white,
            intensity: 1000,
            isRealWorldProxy: false
        )
        lightEntity.orientation = simd_quatf(angle: -.pi/4, axis: [1, 0, 0])
        anchor.addChild(lightEntity)
    }
    
    private func createHandModel() -> ModelEntity {
        // Create a simple hand representation using basic shapes
        // Replace this with your actual 3D model loading code
        
        let mesh = MeshResource.generateBox(size: [0.3, 0.4, 0.1])
        let material = SimpleMaterial(color: .systemPink, isMetallic: false)
        let handEntity = ModelEntity(mesh: mesh, materials: [material])
        
        // Add fingers as separate entities for animation
        createFingers(parent: handEntity)
        
        return handEntity
    }
    
    private func createFingers(parent: ModelEntity) {
        let fingerMesh = MeshResource.generateBox(size: [0.03, 0.15, 0.03])
        let fingerMaterial = SimpleMaterial(color: .systemPink, isMetallic: false)
        
        // Create 5 fingers
        for i in 0..<5 {
            let finger = ModelEntity(mesh: fingerMesh, materials: [fingerMaterial])
            finger.name = "finger_\(i)"
            
            let xOffset = Float(i - 2) * 0.04
            finger.position = [xOffset, 0.15, 0]
            
            parent.addChild(finger)
        }
        
        // Create thumb
        let thumb = ModelEntity(mesh: fingerMesh, materials: [fingerMaterial])
        thumb.name = "thumb"
        thumb.position = [-0.12, 0.05, 0.05]
        thumb.orientation = simd_quatf(angle: .pi/4, axis: [0, 0, 1])
        parent.addChild(thumb)
    }
}

// Animation functions
extension RockPaperScissorsView {
    private func animateCountdown(entity: ModelEntity, completion: @escaping () -> Void) {
        // Create bouncing animation for countdown
        let originalScale = entity.scale
        let bounceScale = SIMD3<Float>(1.2, 1.2, 1.2)
        
        // Create bounce animation
        entity.scale = bounceScale
        
        // Animate back to original scale multiple times
        var bounceCount = 0
        let maxBounces = 6
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            bounceCount += 1
            
            if bounceCount % 2 == 0 {
                entity.scale = bounceScale
            } else {
                entity.scale = originalScale
            }
            
            if bounceCount >= maxBounces {
                timer.invalidate()
                entity.scale = originalScale
                completion()
            }
        }
    }
    
    private func animateToChoice(entity: ModelEntity, choice: GameChoice, isPlayer: Bool) {
        switch choice {
        case .rock:
            animateToRock(entity: entity)
        case .paper:
            animateToPaper(entity: entity)
        case .scissors:
            animateToScissors(entity: entity)
        }
    }
    
    private func animateToRock(entity: ModelEntity) {
        // Close all fingers into fist
        for i in 0..<5 {
            if let finger = entity.findEntity(named: "finger_\(i)") {
                let closedRotation = simd_quatf(angle: .pi/2, axis: [1, 0, 0])
                finger.orientation = closedRotation
            }
        }
        
        if let thumb = entity.findEntity(named: "thumb") {
            thumb.orientation = simd_quatf(angle: .pi/3, axis: [0, 1, 0])
        }
    }
    
    private func animateToPaper(entity: ModelEntity) {
        // Open all fingers
        for i in 0..<5 {
            if let finger = entity.findEntity(named: "finger_\(i)") {
                finger.orientation = simd_quatf(angle: 0, axis: [1, 0, 0])
            }
        }
        
        if let thumb = entity.findEntity(named: "thumb") {
            thumb.orientation = simd_quatf(angle: .pi/6, axis: [0, 0, 1])
        }
    }
    
    private func animateToScissors(entity: ModelEntity) {
        // Show only index and middle finger
        for i in 0..<5 {
            if let finger = entity.findEntity(named: "finger_\(i)") {
                if i == 1 || i == 2 { // Index and middle finger
                    finger.orientation = simd_quatf(angle: 0, axis: [1, 0, 0])
                } else {
                    finger.orientation = simd_quatf(angle: .pi/2, axis: [1, 0, 0])
                }
            }
        }
        
        if let thumb = entity.findEntity(named: "thumb") {
            thumb.orientation = simd_quatf(angle: .pi/3, axis: [0, 1, 0])
        }
    }
}

// Game logic structures
enum GameChoice: CaseIterable {
    case rock, paper, scissors
    
    var emoji: String {
        switch self {
        case .rock: return "🪨"
        case .paper: return "📄"
        case .scissors: return "✂️"
        }
    }
}

struct GameResult {
    let message: String
    let winner: Winner?
}

enum Winner {
    case player, ai
}
struct RockPaperScissorsApp: App {
    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
        }
    }
}
