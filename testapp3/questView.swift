//
//  questView.swift
//  testapp3
//
//  Created by Vidushi Krishna on 16/8/25.
//

import ARKit
import SceneKit

class QuestManager {
    var sceneView: ARSCNView
    var onAllQuestsComplete: (() -> Void)?
    
    var quests: [String] = ["Play Rock-Paper-Scissors", "Find 3 cursed objects"]
    var currentQuestIndex = 0
    
    init(sceneView: ARSCNView, onComplete: (() -> Void)?) {
        self.sceneView = sceneView
        self.onAllQuestsComplete = onComplete
    }
    
    func spawnFirstNPC() {
        let npc = SCNSphere(radius: 0.1)
        npc.firstMaterial?.diffuse.contents = UIColor.green
        let node = SCNNode(geometry: npc)
        node.position = SCNVector3(0, 0, -1.5) // 1.5m in front of camera
        sceneView.scene.rootNode.addChildNode(node)
        
        // After a short delay, start quest
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.startQuest()
        }
    }
    
    func startQuest() {
        if currentQuestIndex < quests.count {
            print("Quest: \(quests[currentQuestIndex])")
            completeQuest()
        } else {
            // All quests done
            onAllQuestsComplete?()
        }
    }
    
    func completeQuest() {
        currentQuestIndex += 1
        if currentQuestIndex < quests.count {
            startQuest()
        } else {
            onAllQuestsComplete?()
        }
    }
}
