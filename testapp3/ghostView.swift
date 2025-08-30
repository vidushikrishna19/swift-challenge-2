////
////  ghostView.swift
////  testapp3
////
////  Created by Vidushi Krishna on 16/8/25.
////
//// Monster.swift
//
//import ARKit
//import SceneKit
//import AVFoundation
//
//class Monster {
//    var sceneView: ARSCNView
//    var node: SCNNode
//    var chaseTimer: Timer?
//    var playerNode: SCNNode?
//    var onCaught: (() -> Void)?
//    
//    var soundPlayer: AVAudioPlayer?
//    
//    init(sceneView: ARSCNView) {
//        self.sceneView = sceneView
//        
//        // Simple red sphere monster
//        let sphere = SCNSphere(radius: 0.15)
//        sphere.firstMaterial?.diffuse.contents = UIColor.red
//        node = SCNNode(geometry: sphere)
//        node.position = SCNVector3(0, 0, -2)
//        sceneView.scene.rootNode.addChildNode(node)
//        
//        // Load growl/footstep audio
//        if let path = Bundle.main.path(forResource: "monster_growl", ofType: "mp3") {
//            let url = URL(fileURLWithPath: path)
//            soundPlayer = try? AVAudioPlayer(contentsOf: url)
//            soundPlayer?.numberOfLoops = -1
//            soundPlayer?.play()
//        }
//    }
//    
//    func beginChase(playerNode: SCNNode, onCaught: @escaping () -> Void) {
//        self.playerNode = playerNode
//        self.onCaught = onCaught
//        
//        chaseTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
//            self.updateChase()
//        }
//    }
//    
//    func stopChase() {
//        chaseTimer?.invalidate()
//        soundPlayer?.stop()
//    }
//    
//    func updateChase() {
//        guard let player = playerNode else { return }
//        
//        // Move monster slightly closer each tick
//        let playerPos = player.worldPosition
//        let monsterPos = node.worldPosition
//        let direction = SCNVector3(playerPos.x - monsterPos.x,
//                                   playerPos.y - monsterPos.y,
//                                   playerPos.z - monsterPos.z)
//        node.position = SCNVector3(monsterPos.x + direction.x * 0.1,
//                                   monsterPos.y + direction.y * 0.1,
//                                   monsterPos.z + direction.z * 0.1)
//        
//        // Update sound volume (closer = louder)
//        let dist = distance(a: playerPos, b: node.worldPosition)
//        soundPlayer?.volume = max(0.1, min(1.0, 1.0 / Float(dist)))
//        
//        // If very close, catch player
//        if dist < 0.3 {
//            onCaught?()
//            stopChase()
//        }
//    }
//    
//    func distance(a: SCNVector3, b: SCNVector3) -> Float {
//        let dx = a.x - b.x
//        let dy = a.y - b.y
//        let dz = a.z - b.z
//        return sqrt(dx*dx + dy*dy + dz*dz)
//    }
//}
//
