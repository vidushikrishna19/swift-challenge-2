//
//  ContentView.swift
//  idoewjkd43e
//
//  Created by Vidushi Krishna on 23/8/25.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State private var model: ModelEntity?
    @State private var cameraAnchor: AnchorEntity?
    
    var body: some View {
        RealityView { content in
            // Load model
            let model = try! await ModelEntity(named: "Baldi_usdz")
            model.scale = [0.001, 0.001, 0.001]
            model.position = [0, 0.01, -0.5]
            
            let model1 = try! await ModelEntity(named: "low_poly_person")
            model1.scale = [0.01, 0.01, 0.01]
            model1.position = [1, 0.01, 0.5]
            
            // Anchor on a horizontal plane
            let anchor = AnchorEntity(.plane(.horizontal,
                                             classification: .any,
                                             minimumBounds: [0.2, 0.2]))
            let anchor1 = AnchorEntity(.plane(.horizontal,
                                             classification: .any,
                                             minimumBounds: [0.1, 0.1]))
            anchor.addChild(model)
            anchor.addChild(model1)
            content.add(anchor)
            content.add(anchor1)
            
            self.model = model
            self.model = model1
            
            // Add camera anchor (follows the headset automatically)
            let cameraAnchor = AnchorEntity(.camera)
            content.add(cameraAnchor)
            
            content.camera = .spatialTracking
            startHorrorGame(entity: model)
            
            func float() async {
                while true {
                    let cameraPos = cameraAnchor.position(relativeTo: nil)
                    
                    await model.move(
                        to: Transform(translation: cameraPos),
                        relativeTo: nil,
                        duration: 140.5,
                        timingFunction: .easeOut
                    )
                }
            }
            
           
            Task {
                await float()
            }
            
        }
        .ignoresSafeArea(edges: .all)
        
        
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
                
                
                // Start scream sounds
                startScreaming(entity: entity, audio: screamAudio)
                
            } catch {
                print("Audio error: \(error)")
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



