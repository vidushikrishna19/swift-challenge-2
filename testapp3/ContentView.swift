////
////  ContentView.swift
////  testapp3
////
////  Created by Vidushi Krishna on 2/8/25.
////
//
//import SwiftUI
//import RealityKit
//
//struct ContentView : View {
//    @State private var showQuestDialog = false // controls whether the quest thingy alert is shown
//    @State private var ghostSpawned = false // prevents/lets multiple ghosts from spawning
//
//    var body: some View {
//        RealityView { content in
//            // creates the quest-giver cube
//            
//            let cube = Entity()
//            cube.name = "questGiver" // creates the entity which acts as the quest giver cube
//            let mesh = MeshResource.generateBox(size: 0.1)
//            let material = SimpleMaterial(color: .blue, isMetallic: true)
//            cube.components.set(ModelComponent(mesh: mesh, materials: [material]))
//            cube.position = [0, 0.05, 0]
//            
//            // puts the cube onto a horizontal surface
//            let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
//            anchor.addChild(cube)
//            content.add(anchor)
//            content.camera = .spatialTracking
//            
//        } update: { content, attachments in
//                   // makes the ghost chase the camera
//                   guard let ghost = content.entities.first(where: { $0.name == "ghost" }),
//                         let cameraTransform = content.cameraTransform else { return }
//
//                   let cameraPosition = cameraTransform.translation
//                   let ghostPosition = ghost.position(relativeTo: nil)
//
//                   let direction = normalize(cameraPosition - ghostPosition) * 0.01 // Speed
//                   ghost.position += direction
//
//        } gesture: { event in
//            if case let .tap(location) = event {
//                if let ray = event.ray(in: .world),
//                   let result = ray.entityHit(from: location),
//                   result.entity.name == "questGiver" {
//                    // Show quest dialog
//                    showQuestDialog = true
//                }
//            }
//            
//        } attachments: {
//                   // Spawn ghost once when cube is tapped
//                   if showQuestDialog && !ghostSpawned {
//                       Attachment(id: "ghost") { _ in
//                           let ghost = Entity()
//                           ghost.name = "ghost"
//                           ghost.components.set(ModelComponent(
//                               mesh: MeshResource.generateSphere(radius: 0.05),
//                               materials: [SimpleMaterial(color: .white, roughness: 0.2, isMetallic: false)]
//                           ))
//                           ghost.position = [0, 0.05, -0.5] // In front of user
//                           return ghost
//                       }
//                   }
//               }
//               .alert("started AHHHH!", isPresented: $showQuestDialog) {
//                   Button("yes sigma kimg") {}
//               } message: {
//                   Text("lets not die today...")
//               }
//           }
//       }
//#Preview {
//    ContentView()
//}
