//
//  exit the game .swift
//  testapp3
//
//  Created by Shivanishri on 23/8/25.
//

import SwiftUI
import RealityKit

struct GlowingExitContentView: View {
    var body: some View {
        NavigationView {
            GlowingDoorView()
        }
    }
}

struct GlowingDoorView: View {
    var body: some View {
        RealityView { content in
            // Create the main scene
            let anchor = AnchorEntity(.plane(.horizontal, classification: .floor, minimumBounds: [2, 2]))
            
            // Create the exit structure
            createExitStructure(anchor: anchor)
            
            // Add atmospheric lighting
            setupLighting(anchor: anchor)
            
            content.add(anchor)
        }
        .navigationTitle("Glowing Exit")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Scene Creation Functions

func createExitStructure(anchor: AnchorEntity) {
    // Create door frame
    let frameWidth: Float = 2.0
    let frameHeight: Float = 3.0
    
    // Door frame posts (left and right)
    let leftPost = createPost(height: frameHeight, position: [-frameWidth/2, frameHeight/2, 0])
    let rightPost = createPost(height: frameHeight, position: [frameWidth/2, frameHeight/2, 0])
    
    // Door frame top
    let topFrame = createFrameTop(width: frameWidth, position: [0, frameHeight, 0])
    
    // The glowing door itself
    let door = createGlowingDoor(width: frameWidth - 0.2, height: frameHeight - 0.1, position: [0, frameHeight/2, -0.05])
    
    // Floor platform
    let platform = createPlatform(width: frameWidth + 1, depth: 1, position: [0, -0.05, 0])
    
    // Add all components to anchor
    anchor.addChild(leftPost)
    anchor.addChild(rightPost)
    anchor.addChild(topFrame)
    anchor.addChild(door)
    anchor.addChild(platform)
    
    // Add some atmospheric elements
    addAtmosphericElements(anchor: anchor, doorPosition: [0, frameHeight/2, -0.05])
}

func createPost(height: Float, position: SIMD3<Float>) -> ModelEntity {
    let mesh = MeshResource.generateBox(width: 0.2, height: height, depth: 0.2)
    var material = SimpleMaterial()
    material.color = .init(tint: UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0))
    material.roughness = .init(floatLiteral: 0.9)
    
    let post = ModelEntity(mesh: mesh, materials: [material])
    post.position = position
    return post
}

func createFrameTop(width: Float, position: SIMD3<Float>) -> ModelEntity {
    let mesh = MeshResource.generateBox(width: width, height: 0.2, depth: 0.2)
    var material = SimpleMaterial()
    material.color = .init(tint: UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0))
    material.roughness = .init(floatLiteral: 0.9)
    
    let frame = ModelEntity(mesh: mesh, materials: [material])
    frame.position = position
    return frame
}

func createGlowingDoor(width: Float, height: Float, position: SIMD3<Float>) -> ModelEntity {
    let mesh = MeshResource.generateBox(width: width, height: height, depth: 0.1)
    
    // Create bright neon white glowing material
    var material = UnlitMaterial()
    material.color = .init(tint: UIColor.white)
    
    let door = ModelEntity(mesh: mesh, materials: [material])
    door.position = position
    
    // Animation removed for now to fix compilation
    
    return door
}

func createPlatform(width: Float, depth: Float, position: SIMD3<Float>) -> ModelEntity {
    let mesh = MeshResource.generateBox(width: width, height: 0.1, depth: depth)
    var material = SimpleMaterial()
    material.color = .init(tint: UIColor(red: 0.02, green: 0.02, blue: 0.02, alpha: 1.0))
    material.roughness = .init(floatLiteral: 0.95)
    
    let platform = ModelEntity(mesh: mesh, materials: [material])
    platform.position = position
    return platform
}

func addAtmosphericElements(anchor: AnchorEntity, doorPosition: SIMD3<Float>) {
    // Add some floating particles around the door
    for _ in 0..<8 {
        let particle = createGlowParticle(
            position: [
                doorPosition.x + Float.random(in: -1.5...1.5),
                doorPosition.y + Float.random(in: -1.0...1.0),
                doorPosition.z + Float.random(in: -0.5...0.5)
            ]
        )
        anchor.addChild(particle)
    }
}

func createGlowParticle(position: SIMD3<Float>) -> ModelEntity {
    let mesh = MeshResource.generateSphere(radius: 0.05)
    var material = UnlitMaterial()
    material.color = .init(tint: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8))
    
    let particle = ModelEntity(mesh: mesh, materials: [material])
    particle.position = position
    
    // Animation removed for now to fix compilation
    
    return particle
}

func setupLighting(anchor: AnchorEntity) {
    // Minimal directional light for very subtle scene definition
    let directionalLight = DirectionalLight()
    directionalLight.light.color = UIColor.white
    directionalLight.light.intensity = 100 // Much lower intensity
    directionalLight.orientation = simd_quatf(angle: -Float.pi/4, axis: [1, 1, 0])
    anchor.addChild(directionalLight)
    
    // Bright white point light near the door for intense glow effect
    let glowLight = PointLight()
    glowLight.light.color = UIColor.white
    glowLight.light.intensity = 3000 // Higher intensity for bright white glow
    glowLight.light.attenuationRadius = 4.0
    glowLight.position = [0, 1.5, 0.5]
    anchor.addChild(glowLight)
    
    // Very dim ambient light to keep background dark
    let ambientLight = PointLight()
    ambientLight.light.color = UIColor.white
    ambientLight.light.intensity = 50 // Very low intensity
    ambientLight.light.attenuationRadius = 10.0
    ambientLight.position = [0, 2, 2]
    anchor.addChild(ambientLight)
}

#Preview {
    GlowingExitContentView()
}
