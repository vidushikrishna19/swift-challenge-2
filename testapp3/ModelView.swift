//
//  ModelView.swift
//  idk
//
//  Created by Vidushi Krishna on 22/8/25.
//

import SwiftUI
import RealityKit

struct ModelView : View {
    @State private var model: Entity? = nil // i need to make reference to the model in this view
    
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
        .task {
            
            while true { // if the model exists
                if let model = model {
                    if let cameraTransform = await RealityView.cameraTransform { // ts gives where the user's position acc is in the space
                        let cameraPosition = cameraTransform.translation // where the person is
                        let modelPosition = model.position(relativeTo: nil) // where the camera is
                        
                        var direction = cameraPosition - modelPosition
                        let distance = length(direction)
                        
                        if distance > 0.3 {
                            direction = normalize(direction)
                            let speed: Float = 0.01
                            model.position += direction * speed
                            model.look(at: cameraPosition, from: model.position, relativeTo: nil)
                        }
                    }
                }
            }
        }
        try? await Task.sleep(nanoseconds: 16_000_000)
    }
}

#Preview {
    ModelView()
}

