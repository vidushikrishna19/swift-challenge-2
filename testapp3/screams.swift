//
//  screams.swift
//  testapp3
//
//  Created by Shivanishri on 8/9/25.
//

import SwiftUI
import RealityKit

struct ScreamView: View {
    var body: some View {
        RealityView { content in
            // Create a scene anchor (not AR)
            let sceneAnchor = AnchorEntity()

            // Load your character
            if let character = try? Entity.load(named: "Baldi_usdz") {
                character.scale = [0.5, 1.8, 0.5]  // Tall & slender
                character.position = [0, 0, -2]
                sceneAnchor.addChild(character)

                // Load scream sound
                if let audioURL = Bundle.main.url(forResource: "608752__soundburst__scream-1", withExtension: "mp3"),
                   let scream = try? AudioFileResource.load(contentsOf: audioURL) {

                    // Repeat every 5 seconds
                    Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                        // Make it move forward slightly
                        let newTransform = Transform(translation: SIMD3(x: 0, y: 0, z: -1.5))
                        character.move(to: newTransform, relativeTo: sceneAnchor, duration: 1.0)

                        // Play scream sound
                        character.playAudio(scream)
                    }
                }
            }

            content.add(sceneAnchor)
        }
        .ignoresSafeArea()
    }
}


        
