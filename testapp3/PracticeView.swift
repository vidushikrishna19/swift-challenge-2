//
//  ContentView.swift
//  practice1
//
//  Created by Vidushi Krishna on 31/8/25.
//

import SwiftUI
import RealityKit

struct PracticeView : View {

    var body: some View {
        RealityView { content in

            // Create a cube model
            let model = Entity()
            let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
            let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
            model.components.set(ModelComponent(mesh: mesh, materials: [material]))
            model.position = [0, 0.05, 0]
            
            let model1 = Entity()
            let mesh1 = MeshResource.generateBox(size: 0.5, cornerRadius: 0.009)
            let material1 = SimpleMaterial(color: .blue, roughness: 0.15, isMetallic: true)
            model1.components.set(ModelComponent(mesh: mesh1, materials: [material1 ]))
            model1.position = [0, 1, 0]

            // Create horizontal plane anchor for the content
            let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
            
            let anchor1 = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.3, 0.3)))
            
            anchor.addChild(model)
            anchor1.addChild(model1)

            // Add the horizontal plane anchor to the scene
            content.add(anchor)
            content.add(anchor1)

            content.camera = .spatialTracking

        }
        .edgesIgnoringSafeArea(.all)
    }

}

