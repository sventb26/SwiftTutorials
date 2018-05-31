//
//  GameScene.swift
//  Project23
//
//  Created by Administrator on 5/29/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
	//MARK: Properties
	var starfield: SKEmitterNode!
	var player: SKSpriteNode!
	
	var scoreLabel: SKLabelNode!
	var gameOverLabel: SKLabelNode!
	var playAgainBtn: SKNode! = nil
	var playAgainBtnLabel: SKLabelNode!
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	var possibleEnemies = ["ball", "hammer", "tv"]
	var gameTimer: Timer!
	var isGameOver = false
	
	var rocketTimer: Timer!
	var rockets = [SKNode]()
	
	
	//MARK: Methods
	@objc func createEnemy() {
		
		possibleEnemies = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleEnemies) as! [String]
		let randomDistribution = GKRandomDistribution(lowestValue: 50, highestValue: 736)
		
		let enemy = SKSpriteNode(imageNamed: possibleEnemies[0])
		enemy.position = CGPoint(x: 1200, y: randomDistribution.nextInt())
		enemy.name = "enemy"
		addChild(enemy)
		
		enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
		enemy.physicsBody?.categoryBitMask = 1
		enemy.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
		enemy.physicsBody?.angularVelocity = 5
		enemy.physicsBody?.linearDamping = 0
		enemy.physicsBody?.angularDamping = 0
		
	}
	
	
	@objc func launchRockets() {
		
		let movementAmount: CGFloat = 1400
		
		createRocket(xMovement: movementAmount, x: Int(player.position.x), y: Int(player.position.y))
	
	}
	
	
	func createRocket(xMovement: CGFloat, x: Int, y: Int) {
		
		let rocket = SKSpriteNode(imageNamed: "rocket")
		rocket.position = CGPoint(x: x + 75, y: y)
		rocket.zPosition = 1
		rocket.colorBlendFactor = 1
		rocket.name = "rocket"
		rocket.color = .red
		
		let emitter = SKEmitterNode(fileNamed: "fuse")!
		emitter.position = CGPoint(x: -22 , y: 0)
		rocket.addChild(emitter)
		
		rocket.physicsBody = SKPhysicsBody(texture: rocket.texture!, size: rocket.size)
		rocket.physicsBody?.contactTestBitMask = 1
		rocket.physicsBody?.linearDamping = 0
		rocket.physicsBody?.angularDamping = 0
		
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: xMovement, y: 0))
		
		let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 400)
		rocket.run(move)
		
		addChild(rocket)
	}
	
	
	override func update(_ curentTime: TimeInterval) {
		
		for node in children {
			if node.position.x < -300 || node.position.x > 1205 {
				node.removeFromParent()
			}
		}
	}
	
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		var location = touch.location(in: self)
		
		if location.y < 100 {
			location.y = 100
		} else if location.y > 668 {
			location.y = 668
		}
	
		player.position = CGPoint(x: location.x + 40, y: location.y)
		
	}
	
	
	func didBegin(_ contact: SKPhysicsContact) {
		
		if contact.bodyA.node?.name == "enemy" && contact.bodyB.node?.name == "rocket" {
			destroy(object: contact.bodyA.node! as! SKSpriteNode)
			removeObject(object: contact.bodyB.node! as! SKSpriteNode)
			score += 1
		}
		
		if contact.bodyB.node?.name == "enemy" && contact.bodyA.node?.name == "rocket"{
			destroy(object: contact.bodyB.node! as! SKSpriteNode)
			removeObject(object: contact.bodyA.node! as! SKSpriteNode)
			score += 1
		}
		
		if contact.bodyA.node?.name == "enemy" && contact.bodyB.node?.name == "player" {
			
			destroy(object: contact.bodyA.node! as! SKSpriteNode)
			destroy(object: contact.bodyB.node! as! SKSpriteNode)
			gameOver()
		}
		
		if contact.bodyB.node?.name == "enemy" && contact.bodyA.node?.name == "player" {
			
			destroy(object: contact.bodyA.node! as! SKSpriteNode)
			destroy(object: contact.bodyB.node! as! SKSpriteNode)
			gameOver()
		}
	}
	
	
	func gameOver() {
		
		isGameOver = true
		if rocketTimer != nil {
			rocketTimer.invalidate()
		}
		gameTimer.invalidate()
		gameOverLabel.isHidden = false
		playAgainBtn.isHidden = false
		playAgainBtnLabel.isHidden = false
		
	}
	
	func destroy(object: SKSpriteNode) {
		
		let explosion = SKEmitterNode(fileNamed: "explosion")!
		explosion.position = object.position
		addChild(explosion)
		
		object.isHidden = true
		object.removeFromParent()
		object.removeAllActions()
		camera?.removeAllActions()
		
	}
	
	func playAgain() {
		
		let newScene = GameScene(size: self.size)
		newScene.scaleMode = self.scaleMode
		let animation = SKTransition.fade(withDuration: 1.0)
		self.view?.presentScene(newScene, transition: animation)
		
	}
	
	
	func removeObject(object: SKSpriteNode) {
		
		object.isHidden = true
		object.removeFromParent()
		object.removeAllActions()
		camera?.removeAllActions()
	}
	
	
	//MARK: Functions
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if let touch = touches.first {
			let location = touch.location(in: self)
			let tappedNodes = nodes(at: location)
			
			for node in tappedNodes {
				if node.name == "player" {
					player.position = CGPoint(x: player.position.x + 40, y: player.position.y)
					rocketTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(launchRockets), userInfo: nil, repeats: true)
				} else if node == playAgainBtn {
					
					playAgain()
				}
			}
		}
	}
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if let touch = touches.first {
			let location = touch.location(in: self)
			let tappedNodes = nodes(at: location)
			
			for node in tappedNodes {
				if node.name == "player" {
					
					player.position = CGPoint(x: player.position.x - 40, y: player.position.y)
					
					if rocketTimer != nil {
						rocketTimer.invalidate()
					}
				}
			}
		}
	}
	
	
	override func didMove(to view: SKView) {
		backgroundColor = UIColor.black
		
		starfield = SKEmitterNode(fileNamed: "Starfield")!
		starfield.position = CGPoint(x: 1024, y: 384)
		starfield.advanceSimulationTime(10)
		addChild(starfield)
		starfield.zPosition = -1
		
		player = SKSpriteNode(imageNamed: "player")
		player.position = CGPoint(x: 100, y: 384)
		player.name = "player"
		player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
		player.physicsBody?.contactTestBitMask = 1
		addChild(player)
		
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.position = CGPoint(x: 16, y: 16)
		scoreLabel.horizontalAlignmentMode = .left
		addChild(scoreLabel)
		
		gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
		gameOverLabel.text = "GAME OVER"
		gameOverLabel.position = CGPoint(x: 512, y: 404)
		gameOverLabel.horizontalAlignmentMode = .center
		gameOverLabel.isHidden = true
		addChild(gameOverLabel)
		
		playAgainBtn = SKSpriteNode(color: .green, size: CGSize(width: 160, height: 44))
		playAgainBtn.position = CGPoint(x: 512, y: 364)
		playAgainBtn.isHidden = true
		
		playAgainBtnLabel = SKLabelNode(fontNamed: "EuphemiaUCAS")
		playAgainBtnLabel.fontColor = .blue
		playAgainBtnLabel.fontSize = 24
		playAgainBtnLabel.text = "Play Again"
		playAgainBtnLabel.position = CGPoint(x: 0, y: -8)
		playAgainBtnLabel.horizontalAlignmentMode = .center
		playAgainBtnLabel.isHidden = true
		playAgainBtn.addChild(playAgainBtnLabel)
		addChild(playAgainBtn)
		
		score = 0
		isGameOver = false
		
		gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
		
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		physicsWorld.contactDelegate = self
		
	}
}
