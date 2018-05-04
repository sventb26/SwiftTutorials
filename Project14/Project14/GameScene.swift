//
//  GameScene.swift
//  Project14
//
//  Created by Administrator on 5/4/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	
	//MARK: Properties
	var slots = [WhackSlot]()
	var gameScore: SKLabelNode!
	var score = 0 {
		didSet {
			gameScore.text = "score: \(score)"
		}
	}
	
	
	//MARK: Functions
	func createSlot(at position: CGPoint) {
		let slot = WhackSlot()
		slot.configure(at: position)
		addChild(slot)
		slots.append(slot)
	}
	
	
	//MARK: Default Functions
    override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "whackBackground")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
		
		gameScore = SKLabelNode(fontNamed: "Chalkduster")
		gameScore.text = "Score: 0"
		gameScore.position = CGPoint(x: 8, y:8)
		gameScore.horizontalAlignmentMode = .left
		gameScore.fontSize = 48
		addChild(gameScore)
		
		for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
		for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
		for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
		for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
	}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
	
	}
}
