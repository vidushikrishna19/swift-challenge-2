//
//  ContentView.swift
//  idoewjkd43e
//
//  Created by Vidushi Krishna on 23/8/25.
//

import SwiftUI
import RealityKit

struct ModelView1 : View {
    @State private var model: ModelEntity?
    @State private var cameraAnchor: AnchorEntity?

    var body: some View {
        RealityView { content in
            // Load model
            let model = try! await ModelEntity(named: "tired_young_person")
            model.scale = [0.01, 0.01, 0.01]
            model.position = [0, 0.05, -0.5]
            
            // Anchor on a horizontal plane
            let anchor = AnchorEntity(.plane(.horizontal,
                                             classification: .any,
                                             minimumBounds: [0.2, 0.2]))
            anchor.addChild(model)
            content.add(anchor)
            self.model = model
            
            // Add camera anchor (follows the headset automatically)
            let cameraAnchor = AnchorEntity(.camera)
            content.add(cameraAnchor)
            self.cameraAnchor = cameraAnchor
            
        } update: { content in
            guard let model = model, let cameraAnchor = cameraAnchor else { return }
            
            let cameraPos = cameraAnchor.position(relativeTo: nil)
            let modelPos = model.position(relativeTo: nil)
            let distance = simd_distance(cameraPos, modelPos)
            
            if distance > 0.15 {
                // Keep moving toward camera until 15 cm away
                let targetPos = SIMD3<Float>(
                    cameraPos.x,
                    modelPos.y,
                    cameraPos.z - 0.1
                )
                
                model.move(
                    to: Transform(translation: targetPos),
                    relativeTo: nil,
                    duration: 0.3,
                    timingFunction: .easeInOut
                )
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ModelView1()
}
