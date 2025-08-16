//
//  trialView.swift
//  testapp3
//
//  Created by Vidushi Krishna on 16/8/25.
//

// GameViewController.swift
import UIKit
import ARKit
import SceneKit
import AVFoundation

class GameViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    // UI Panels
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var questLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    
    // Managers
    var questManager: QuestManager!
    var monster: Monster?
    var exitPortal: ExitPortal?
    
    // Sounds
    var backgroundMusic: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Basic AR setup
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        
        // Hide labels initially
        questLabel.isHidden = true
        winLabel.isHidden = true
        loseLabel.isHidden = true
        
        // Prepare quest manager
        questManager = QuestManager(sceneView: sceneView) { [weak self] in
            // Callback when quests complete
            self?.spawnExitPortal()
        }
        
        // Ambient creepy music
        if let path = Bundle.main.path(forResource: "ambient_loop", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            backgroundMusic = try? AVAudioPlayer(contentsOf: url)
            backgroundMusic?.numberOfLoops = -1
            backgroundMusic?.play()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Run AR world tracking
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        sceneView.session.run(config)
    }
    
    // MARK: Game Flow
    @IBAction func startGame(_ sender: UIButton) {
        startButton.isHidden = true
        questLabel.isHidden = false
        questLabel.text = "Meet your first quest giver..."
        
        // Spawn first NPC
        questManager.spawnFirstNPC()
        
        // Spawn monster slightly later
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.spawnMonster()
        }
    }
    
    func spawnMonster() {
        guard monster == nil else { return }
        monster = Monster(sceneView: sceneView)
        monster?.beginChase(playerNode: sceneView.pointOfView!) {
            // Callback when caught
            self.playerCaught()
        }
    }
    
    func spawnExitPortal() {
        exitPortal = ExitPortal(sceneView: sceneView) {
            self.playerWin()
        }
    }
    
    func playerWin() {
        winLabel.isHidden = false
        monster?.stopChase()
    }
    
    func playerCaught() {
        loseLabel.isHidden = false
        monster?.stopChase()
    }
}
