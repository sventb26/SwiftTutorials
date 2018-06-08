//
//  GameScene.swift
//  MazeRunner
//
//  Created by Administrator on 6/7/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	var bottomBar: BottomBar!
	
	var level = 1
	
	var levelScene: Level!
	
	var player: SKSpriteNode!
	
	var lives = 5
	
	var score = 0 {
		didSet {
			bottomBar.setScore(score: score)
		}
	}
	
	var isGameOver = false
	
	var lastTouchPosition: CGPoint?
	
	var motionManager: CMMotionManager!
	
	
    override func didMove(to view: SKView) {
		
		//Set Background
		let background = SKSpriteNode(imageNamed: "background")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
		
		//Set gravity = no movement.
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		
		//Set Level
		levelScene = Level(level: 1)
		addChild(levelScene)
		
		//Set bottom bar
		bottomBar = BottomBar()
		addChild(bottomBar)
		
		//Set player
		player = Player.createPlayer()
		addChild(player)
		
		
		//Engage motion manager
		motionManager = CMMotionManager()
		motionManager.startAccelerometerUpdates()
		
		physicsWorld.contactDelegate = self
		
    }
	
	
	func didBegin(_ contact: SKPhysicsContact) {
		
		if contact.bodyA.node == player {
			playerCollided(with: contact.bodyB.node!)
		} else if contact.bodyB.node == player {
			playerCollided(with: contact.bodyA.node!)
		}
		
	}
	
	
	func playerCollided(with node: SKNode) {
		
		if node.name == "vortex" {
			
			player.physicsBody?.isDynamic = false
			
			lives -= 1
			
			
			let move = SKAction.move(to: node.position, duration: 0.25)
			let scale = SKAction.scale(by: 0.0001, duration: 0.25)
			let remove = SKAction.removeFromParent()
			let sequence = SKAction.sequence([move, scale, remove])
			
			player.run(sequence) { [unowned self] in
				
				if self.lives >= 0 {
					
					self.bottomBar.lessPlayerLife(lives: self.lives)
					
					if self.lives > 0 {
						self.player = Player.createPlayer()
						self.addChild(self.player)
					}
					
				} else {
					
					self.isGameOver = false
					
				}
			}
		} else if node.name == "star" {
			
			node.removeFromParent()
			score += 1
			
		} else if node.name == "finish" {
			
			//do something
			
		}
	}
	
	
	func getLives() -> Int {
		
		return lives
		
	}
	
	
	override func update(_ currentTime: TimeInterval) {
		
		guard isGameOver == false else { return }
		
		#if targetEnvironment(simulator)
		if let currentTouch = lastTouchPosition {
			let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
			physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
		}
		
		#else
		if let accelerometerData = motionManager.accelerometerData {
			physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
		}
		
		#endif
	}
	
    
    func touchDown(atPoint pos : CGPoint) {
		
		
    }
    
    func touchMoved(toPoint pos : CGPoint) {
		
    }
    
    func touchUp(atPoint pos : CGPoint) {
		
    }
    
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if let touch = touches.first {
			let location = touch.location(in: self)
			lastTouchPosition = location
		}
	}
	
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if let touch = touches.first {
			let location = touch.location(in: self)
			lastTouchPosition = location
		}
	}
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		lastTouchPosition = nil
		
	}
	
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		lastTouchPosition = nil
	}
    
    
}
