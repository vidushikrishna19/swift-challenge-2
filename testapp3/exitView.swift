//
//  exitView.swift
//  testapp3
//
//  Created by Vidushi Krishna on 16/8/25.
//

import SwiftUI
import ARKit
import SceneKit

class ExitPortal {
    var sceneView: ARSCNView
    var node: SCNNode
    var onPlayerEntered: (() -> Void)?
    
    init(sceneView: ARSCNView, onEntered: @escaping () -> Void) {
        self.sceneView = sceneView
        self.onPlayerEntered = onEntered
        
        // Simple glowing portal (blue torus)
        let torus = SCNTorus(ringRadius: 0.3, pipeRadius: 0.05)
        torus.firstMaterial?.diffuse.contents = UIColor.cyan
        node = SCNNode(geometry: torus)
        node.position = SCNVector3(0, 0, -2)
        sceneView.scene.rootNode.addChildNode(node)
        
        // Spin animation
        let spin = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 3))
        node.runAction(spin)
        
        // Poll player distance
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.checkPlayerEntered()
        }
    }
    
    func checkPlayerEntered() {
        guard let player = sceneView.pointOfView else { return }
        let dist = distance(a: player.worldPosition, b: node.worldPosition)
        if dist < 0.5 {
            onPlayerEntered?()
        }
    }
    
    func distance(a: SCNVector3, b: SCNVector3) -> Float {
        let dx = a.x - b.x
        let dy = a.y - b.y
        let dz = a.z - b.z
        return sqrt(dx*dx + dy*dy + dz*dz)
    }
}

