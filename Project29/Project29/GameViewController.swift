//
//  GameViewController.swift
//  Project29
//
//  Created by Administrator on 6/15/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
	
	//MARK: Properties
	var currentGame: GameScene!

	
	//MARK: Outlets
	@IBOutlet var angleSlider: UISlider!
	@IBOutlet var angleLabel: UILabel!
	@IBOutlet var velocitySlider: UISlider!
	@IBOutlet var velocityLabel: UILabel!
	@IBOutlet var launchButton: UIButton!
	@IBOutlet var playerNumber: UILabel!
	
	//MARK: Actions
	@IBAction func angleChanged(_ sender: Any) {
		angleLabel.text = "Angle: \(Int(angleSlider.value))º"
	}
	
	
	@IBAction func velocityChanged(_ sender: Any) {
		velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
	}
	
	
	
	@IBAction func launch(_ sender: Any) {
		
		angleSlider.isHidden = true
		angleLabel.isHidden = true
		
		velocitySlider.isHidden = true
		velocityLabel.isHidden = true
		
		launchButton.isHidden = true
		
		currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
		
	}
	
	
	func activatePlayer(number: Int) {
		
		if number == 1 {
			playerNumber.text = "<<< PLAYER ONE"
		} else {
			playerNumber.text = "PLAYER TWO >>>"
		}
		
		angleSlider.isHidden = false
		angleLabel.isHidden = false
		
		velocitySlider.isHidden = false
		velocityLabel.isHidden = false
		
		launchButton.isHidden = false
		
		
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		angleChanged(angleSlider)
		velocityChanged(velocitySlider)
		
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
				currentGame = scene as! GameScene
				currentGame.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false	
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
