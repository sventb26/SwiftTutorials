//
//  GameViewController.swift
//  Project29
//
//  Created by Administrator on 9/19/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

	//MARK: IBOutlets
	@IBOutlet var angleSlider: UISlider!
	@IBOutlet var angleLabel: UILabel!
	@IBOutlet var velocitySlider: UISlider!
	@IBOutlet var velocityLabel: UILabel!
	@IBOutlet var launchButton: UIButton!
	@IBOutlet var playerNumber: UILabel!
	@IBOutlet var scoreP1Label: UILabel!
	@IBOutlet var scoreP2Label: UILabel!
	
	//MARK: IBActions
	@IBAction func angleChanged(_ sender: Any) {
		angleLabel.text = "Angle: \(Int(angleSlider.value))°"
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
	
	
	//MARK: Properties
	var currentGame: GameScene!
	var scoreP1 = 0 {
		didSet {
			scoreP1Label.text = "Score: \(scoreP1)"
		}
	}
	
	var scoreP2 = 0 {
		didSet {
			scoreP2Label.text = "Score: \(scoreP2)"
		}
	}
	
	
	//MARK: Methods
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
	
	//MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
		angleChanged(angleSlider)
		velocityChanged(velocitySlider )
        
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
