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
            
            let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2))) // this creates the anchor for the model to be anchored onto
            
            if let model = try? await Entity.init(named: "tired_young_person") {
                model.scale = [0.2, 0.2, 0.2]
                // scale down if too big
                model.position = [0.2, 0, 0]
                // place it slightly beside
                anchor.addChild(model)
            } else {
                print("could not load model")
                
                content.add(anchor) // NEED to add the anchor to the scene otherwise bro will not be anchored
                content.camera = .spatialTracking // this is so that the camera can track the thingy
            }
        }
                .ignoresSafeArea(.all) // otherwise ts aint gonna work
        
    }
}

#Preview {
    ModelView()
}

