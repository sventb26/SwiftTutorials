//
//  GameScene.swift
//  Project20
//
//  Created by Administrator on 5/21/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //The gameTimer property will be a new class called Timer. We'll use this to call the launchFireworks() method every six seconds.
	var gameTimer: Timer!
	
	//The fireworks property will be an array of SKNode objects.
	var fireworks = [SKNode]()
	
	//The leftEdge, bottomEdge, and rightEdge properties are used to define where we launch fireworks from. Each of them will be just off screen to one side.
	let leftEdge = -22
	let bottomEdge = -22
	let rightEdge = 1024 + 22
	
	//The score property will track the player's score.
	var score = 0 {
		didSet {
			// your code here
		}
	}
	
	
	@objc func launchFireworks() {
		print("launchFireworks")
	}
	
	
    override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "background")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
		
		gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
	}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 
	}
}
