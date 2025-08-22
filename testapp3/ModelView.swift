//
//  ModelView.swift
//  idk
//
//  Created by Vidushi Krishna on 22/8/25.
//

import SwiftUI
import RealityKit

struct ModelView : View {
    
    var body: some View {
        RealityView { content in
            
            let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
            
            if let model = try? await Entity.init(named: "tired_young_person") {
                model.scale = [0.2, 0.2, 0.2]    // scale down if too big
                model.position = [0.2, 0, 0]     // place it slightly beside the cube
                anchor.addChild(model)
            } else {
                print("could not load model")
                
                // Add the horizontal plane anchor to the scene
                content.add(anchor)
                content.camera = .spatialTracking
            }
        }
                .ignoresSafeArea(.all)
        
    }
}

#Preview {
    ModelView()
}

