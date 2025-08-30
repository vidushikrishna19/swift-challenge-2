//
//  ContentView.swift
//  idoewjkd43e
//
//  Created by Vidushi Krishna on 23/8/25.
//

import SwiftUI
import RealityKit

struct ChasingModelView : View {

    var body: some View {
        RealityView { content in
                    let model = try! await ModelEntity.init(named: "low_poly_person")
                    model.scale = [0.01, 0.01, 0.01]
                    model.position = [0, 0.05, 0]
                    
                    // Create horizontal plane anchor for the content
                    let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
                    anchor.addChild(model)
                    // Add the horizontal plane anchor to the scene
                    content.add(anchor)
                    
                    content.camera = .spatialTracking
                }
        .edgesIgnoringSafeArea(.all)
            }
        }


#Preview {
    ChasingModelView()
}


