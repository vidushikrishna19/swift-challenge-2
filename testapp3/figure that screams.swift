//
//  figure that screams.swift
//  testapp3
//
//  Created by Shivanishri on 6/9/25.
//

import SwiftUI
import RealityKit

struct SlenderManView: View {
    var body: some View {
        
        RealityView { content in
            // Create the Slender Man entity
            let tallFigure = createSlenderMan()
            tallFigure.position = [0, 0, -5]
            content.add(tallFigure)
            
            // Start horror behaviors
            startHorrorGame(entity: tallFigure)
        }
    }
    
    func createSlenderMan() -> Entity {
        let tallFigure = Entity()
        
        // Black material for the entity
        let blackMaterial = UnlitMaterial(color: .black)
        
        // Body (tall and thin like Slender Man)
        let body = ModelEntity(
            mesh: .generateCylinder(height: 3.5, radius: 0.2),
            materials: [blackMaterial]
        )
        
        // Head
        let head = ModelEntity(
            mesh: .generateSphere(radius: 0.25),
            materials: [blackMaterial]
        )
        head.position = [0, 1.9, 0]
        
        // Arms (long and thin)
        let leftArm = ModelEntity(
            mesh: .generateCylinder(height: 1.8, radius: 0.05),
            materials: [blackMaterial]
        )
        leftArm.position = [-0.4, 0.8, 0]
        leftArm.orientation = simd_quatf(angle: Float.pi/6, axis: [0, 0, 1])
        
        let rightArm = ModelEntity(
            mesh: .generateCylinder(height: 1.8, radius: 0.05),
            materials: [blackMaterial]
        )
        rightArm.position = [0.4, 0.8, 0]
        rightArm.orientation = simd_quatf(angle: -Float.pi/6, axis: [0, 0, 1])
        
        // Glowing white eyes
        let eyeMaterial = UnlitMaterial(color: .white)
        let eyeMesh = MeshResource.generateSphere(radius: 0.04)
        
        let leftEye = ModelEntity(mesh: eyeMesh, materials: [eyeMaterial])
        leftEye.position = [-0.07, 2.0, 0.22]
        
        let rightEye = ModelEntity(mesh: eyeMesh, materials: [eyeMaterial])
        rightEye.position = [0.07, 2.0, 0.22]
        
        // Add all parts to the main entity
        tallFigure.addChild(body)
        tallFigure.addChild(head)
        tallFigure.addChild(leftArm)
        tallFigure.addChild(rightArm)
        tallFigure.addChild(leftEye)
        tallFigure.addChild(rightEye)
        
        return tallFigure
    }
    
    func startHorrorGame(entity: Entity) {
        // Load scream audio
        Task {
            do {
                guard let audioURL = Bundle.main.url(
                    forResource: "608752__soundburst__scream-1",
                    withExtension: "mp3"
                ) else {
                    print("Scream file missing")
                    return
                }
                
                let screamAudio = try await AudioFileResource.load(
                    contentsOf: audioURL,
                    inputMode: .spatial,
                    loadingStrategy: .preload
                )
                
                // Start chasing behavior
                startChasing(entity: entity)
                
                // Start scream sounds
                startScreaming(entity: entity, audio: screamAudio)
                
            } catch {
                print("Audio error: \(error)")
            }
        }
    }
    
    func startChasing(entity: Entity) {
        Task {
            while true {
                try? await Task.sleep(for: .milliseconds(500))
                
                // Move closer to player (toward origin)
                let currentPos = entity.position
                let targetPos = SIMD3<Float>(0, 0, 0)
                let direction = normalize(targetPos - currentPos)
                let newPos = currentPos + direction * 0.1 // Move 0.1 units closer
                
                entity.move(
                    to: Transform(translation: newPos),
                    relativeTo: nil,
                    duration: 0.5,
                    timingFunction: .linear
                )
            }
        }
    }
    
    func startScreaming(entity: Entity, audio: AudioFileResource) {
        Task {
            while true {
                entity.playAudio(audio)
                try? await Task.sleep(for: .seconds(3))
            }
        }
    }
}
