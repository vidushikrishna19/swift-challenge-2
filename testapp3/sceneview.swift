//
//  sceneview.swift
//  testapp3
//
//  Created by Vidushi Krishna on 16/8/25.
//

//import SwiftUI
//import UIKit
//import SceneKit
//import ARKit
//import AVFoundation
//
//// Controller class to handle cube movement
//class SceneController {
//    var cubeNode: SCNNode?
//
//    // Called by CADisplayLink every frame
//    @objc func runUpdate() {
//        guard let cubeNode = cubeNode else { return }
//
//        // Camera at origin
//        let cameraPos = SCNVector3(0, 0, 0)
//        var direction = SCNVector3(
//            cameraPos.x - cubeNode.position.x,
//            cameraPos.y - cubeNode.position.y,
//            cameraPos.z - cubeNode.position.z
//        )
//
//        let distance = sqrt(direction.x*direction.x + direction.y*direction.y + direction.z*direction.z)
//
//        if distance > 0.05 {
//            // Normalize direction
//            direction.x /= distance
//            direction.y /= distance
//            direction.z /= distance
//
//            // Move cube toward camera
//            cubeNode.position.x += direction.x * 0.01
//            cubeNode.position.y += direction.y * 0.01
//            cubeNode.position.z += direction.z * 0.01
//
//            // Rotate cube to face camera
//            cubeNode.look(at: cameraPos)
//        }
//    }
//}
//
//struct sceneview: View {
//    let scene = SCNScene()
//    let controller = SceneController()
//    @State private var displayLink: CADisplayLink?
//       var cameraNode = SCNNode()
//
//    var body: some View {
//        SceneView(
//            scene: scene,
//            pointOfView: cameraNode,
//            options: [.allowsCameraControl, .autoenablesDefaultLighting]
//        )
//        .onAppear {
//            setupScene()
//            startChase()
//        }
//        .ignoresSafeArea()
//    }
//
//    func setupScene() {
//        // Add camera at origin
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3(0, 0, 0)
//        scene.rootNode.addChildNode(cameraNode)
//
//        // Add cube in front of camera
//        let cube = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
//        let cubeNode = SCNNode(geometry: cube)
//        cubeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        cubeNode.position = SCNVector3(0, 0, -1)
//        scene.rootNode.addChildNode(cubeNode)
//
//        controller.cubeNode = cubeNode
//    }
//
//    func startChase() {
//        let link = CADisplayLink(target: controller, selector: #selector(SceneController.runUpdate))
//        link.add(to: .main, forMode: .default)
//        displayLink = link
//    }
//}
//
//#Preview {
//    sceneview()
//}
