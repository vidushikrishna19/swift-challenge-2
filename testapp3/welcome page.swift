//
//  welcome page.swift
//  testapp3
//
//  Created by Shivanishri on 24/8/25.
//

import SwiftUI
import RealityKit
import ARKit
import Foundation

// MARK: - Welcome View
struct ContentView1: View {
    var body: some View {
        WelcomeView()
    }
}

struct WelcomeView: View {
    @State private var showGame = false
    @State private var animateTitle = false
    @State private var animateButton = false
    @State private var animateRules = false
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.black]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // 3D AR Background
            ARBackgroundView()
                .ignoresSafeArea()
                .opacity(0.3)
            
            // Main Content
            VStack(spacing: 30) {
                Spacer()
                
                // Game Title
                VStack(spacing: 10) {
                    Text("👹")
                        .font(.system(size: 80))
                        .scaleEffect(animateTitle ? 1.2 : 1.0)
                        .rotationEffect(.degrees(animateTitle ? 10 : -10))
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateTitle)
                    
                    Text("MONSTER")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.black, .gray],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .white, radius: 2, x: 2, y: 2)
                    
                    Text("ESCAPE")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.gray, .black],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .white, radius: 2, x: 2, y: 2)
                }
                .offset(y: animateTitle ? -10 : 10)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateTitle)
                
                // Game Rules Card
                RulesCardView()
                    .scaleEffect(animateRules ? 1.0 : 0.8)
                    .opacity(animateRules ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.5), value: animateRules)
                
                Spacer()
                
                // Start Game Button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showGame = true
                    }
                }) {
                    HStack(spacing: 15) {
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                        
                        Text("START ESCAPE")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        LinearGradient(
                            colors: [.black, .gray],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .scaleEffect(animateButton ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateButton)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            animateTitle = true
            animateButton = true
            animateRules = true
        }
        .fullScreenCover(isPresented: $showGame) {
            MonsterEscapeGameView()
        }
    }
}

// MARK: - Rules Card View
struct RulesCardView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Rules Title
            HStack {
                Image(systemName: "book.fill")
                    .font(.title2)
                    .foregroundColor(.black)
                
                Text("HOW TO SURVIVE")
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.black)
                
                Image(systemName: "book.fill")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            
            // Rules List
            VStack(spacing: 15) {
                RuleItemView(
                    icon: "figure.run",
                    title: "RUN AWAY",
                    description: "Keep moving to avoid the monster",
                    color: .red
                )
                
                RuleItemView(
                    icon: "target",
                    title: "COMPLETE TASKS",
                    description: "Finish objectives to progress",
                    color: .blue
                )
                
                RuleItemView(
                    icon: "eye.fill",
                    title: "STAY ALERT",
                    description: "Monster is always hunting you",
                    color: .orange
                )
                
                RuleItemView(
                    icon: "flag.checkered",
                    title: "ESCAPE",
                    description: "Reach the exit to win",
                    color: .green
                )
            }
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.9))
                .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Rule Item View
struct RuleItemView: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
            }
            
            // Text
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

// MARK: - AR Background View
struct ARBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Setup AR scene
        setupARScene(arView: arView)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    private func setupARScene(arView: ARView) {
        // Create anchor
        let anchor = AnchorEntity(world: [0, 0, -2])
        
        // Create spooky floating objects
        createFloatingElements(anchor: anchor)
        
        // Add lighting
        addLighting(anchor: anchor)
        
        arView.scene.addAnchor(anchor)
        
        // Start camera session - simplified without error handling
        let config = ARWorldTrackingConfiguration()
        arView.session.run(config)
    }
    
    private func createFloatingElements(anchor: AnchorEntity) {
        // Create floating monster eyes
        for i in 0..<5 {
            let eyeEntity = ModelEntity(
                mesh: MeshResource.generateSphere(radius: 0.05),
                materials: [SimpleMaterial(color: .red, isMetallic: false)]
            )
            
            // Random positions
            let x = Float.random(in: -1.5...1.5)
            let y = Float.random(in: -0.5...1.5)
            let z = Float.random(in: -1.0...0.5)
            
            eyeEntity.position = [x, y, z]
            
            // Add simple floating animation using Timer
            let originalY = y
            let floatOffset = Float(i) * 0.5 // Use i to create variation
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                let time = Float(Date().timeIntervalSince1970) + floatOffset
                let newY = originalY + sin(time) * 0.1
                eyeEntity.position.y = newY
            }
            
            anchor.addChild(eyeEntity)
        }
        
        // Create floating geometric shapes
        for i in 0..<3 {
            let shapeEntity = ModelEntity(
                mesh: MeshResource.generateBox(size: [0.1, 0.1, 0.1]),
                materials: [SimpleMaterial(color: .black.withAlphaComponent(0.7), isMetallic: true)]
            )
            
            let x = Float.random(in: -2.0...2.0)
            let y = Float.random(in: 0.5...2.0)
            let z = Float.random(in: -1.5...0.0)
            
            shapeEntity.position = [x, y, z]
            
            // Add simple rotation using Timer
            let rotationSpeed = Float(i + 1) * 0.5 // Use i for different speeds
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                let time = Float(Date().timeIntervalSince1970) * rotationSpeed
                let rotation = simd_quatf(angle: time, axis: [1, 1, 0])
                shapeEntity.orientation = rotation
            }
            
            anchor.addChild(shapeEntity)
        }
    }
    
    private func addLighting(anchor: AnchorEntity) {
        // Add dramatic lighting
        let lightEntity = Entity()
        lightEntity.components[DirectionalLightComponent.self] = DirectionalLightComponent(
            color: .white,
            intensity: 500,
            isRealWorldProxy: false
        )
        lightEntity.orientation = simd_quatf(angle: -.pi/4, axis: [1, 0, 0])
        
        anchor.addChild(lightEntity)
        
        // Add ambient light
        let ambientEntity = Entity()
        ambientEntity.components[DirectionalLightComponent.self] = DirectionalLightComponent(
            color: .red,
            intensity: 200,
            isRealWorldProxy: false
        )
        
        anchor.addChild(ambientEntity)
    }
}

// MARK: - Game View (Placeholder)
struct MonsterEscapeGameView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("🎮 GAME STARTING...")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("Monster Escape Game")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Button("Back to Menu") {
                    dismiss()
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
            }
        }
    }
}

// MARK: - Main App
@main
struct WelcomeApp: App {
    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Preview
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

