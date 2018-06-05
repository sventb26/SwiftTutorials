//
//  GameScene.swift
//  Project26
//
//  Created by Administrator on 6/5/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum CollisionTypes: UInt32 {
	case player = 1
	case wall = 2
	case star = 4
	case vortex = 8
	case finish = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {

	//MARK: Properties
	var player: SKSpriteNode!
	var lastTouchPosition: CGPoint?
	var motionManager: CMMotionManager!
	
	var scoreLabel: SKLabelNode!
	
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	var isGameOver = false
	
	
	//MARK: Functions
    override func didMove(to view: SKView) {
		
		let background = SKSpriteNode(imageNamed: "background")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
		
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		
		loadLevel()
		
		scoreLabel = SKLabelNode(fontNamed: "EuphemiaUCAS")
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .left
		scoreLabel.position = CGPoint(x: 16, y: 16)
		addChild(scoreLabel)
		
		createPlayer()
		
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
			isGameOver = true
			score -= 1
			
			let move = SKAction.move(to: node.position, duration: 0.25)
			let scale = SKAction.scale(by: 0.0001, duration: 0.25)
			let remove = SKAction.removeFromParent()
			let sequence = SKAction.sequence([move, scale, remove])
			
			player.run(sequence) { [unowned self] in
				
				self.createPlayer()
				self.isGameOver = false
				
			}
		} else if node.name == "star" {
			
			node.removeFromParent()
			score += 1
			
		} else if node.name == "finish" {
		
			print("GAME OVER!")
			
		}
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
	
	
	func createPlayer() {
		
		player = SKSpriteNode(imageNamed: "player")
		player.position = CGPoint(x: 96, y: 672)
		player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
		player.physicsBody?.allowsRotation = false
		player.physicsBody?.linearDamping = 0.5
		
		player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
		player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
		player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
		addChild(player)
		
	}
	
	
	func loadLevel() {
		
		if let levelPath = Bundle.main.path(forResource: "level1", ofType: "txt") {
			if let levelString = try? String(contentsOfFile: levelPath) {
				let lines = levelString.components(separatedBy: "\n")
				
				for (row, line) in lines.reversed().enumerated() {
					for (column, letter) in line.enumerated() {
						let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
						
						if letter == "x" {
							
							let node = SKSpriteNode(imageNamed: "block")
							node.position = position
							
							node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
							node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
							node.physicsBody?.isDynamic = false
							addChild(node)
							
							
						} else if letter == "v" {
							
							let node = SKSpriteNode(imageNamed: "vortex")
							node.name = "vortex"
							node.position = position
							node.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 1)))
							node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
							node.physicsBody?.isDynamic = false
							
							node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
							node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
							node.physicsBody?.collisionBitMask = 0
							addChild(node)
							
						} else if letter == "s" {
							
							let node = SKSpriteNode(imageNamed: "star")
							node.name = "star"
							node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
							node.physicsBody?.isDynamic = false
							
							node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
							node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
							node.physicsBody?.collisionBitMask = 0
							node.position = position
							addChild(node)
							
						} else if letter == "f" {
							
							let node = SKSpriteNode(imageNamed: "finish")
							node.name = "finish"
							node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
							node.physicsBody?.isDynamic = false
							
							node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
							node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
							node.physicsBody?.collisionBitMask = 0
							node.position = position
							addChild(node)
						}
					}
				}
			}
		}
	}
	
	
}
