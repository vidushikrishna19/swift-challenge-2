//
//  sceneview.swift
//  testapp3
//
//  Created by Vidushi Krishna on 16/8/25.
//

import SwiftUI
import RealityKit

struct sceneview: View {
    var body: some View {
        RealityView { content in
            // Create a cube entity
            let cube = ModelEntity(
                mesh: .generateBox(size: 0.2),
                materials: [SimpleMaterial(color: .blue, isMetallic: false)]
            )
            
            // Place cube in front of camera
            cube.position = [0, 0, -0.5]
            
            // Add to scene
            content.add(cube)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    sceneview()
}
