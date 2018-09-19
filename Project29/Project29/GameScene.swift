//
//  GameScene.swift
//  Project29
//
//  Created by Administrator on 9/19/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit
import GameplayKit

enum CollissionTypes: UInt32 {
	case banana = 1
	case building = 2
	case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	//MARK: Properties
	var buildings = [BuildingNode]()
	weak var viewController: GameViewController!
	
	var player1: SKSpriteNode!
	var player2: SKSpriteNode!
	var banana: SKSpriteNode!
	
	var currentPlayer = 1
	
	//MARK: Game Methods
	func launch(angle: Int, velocity: Int) {
		//Figure out how hard to throw the banana.  We accept a velocity parameter, but we'll need to divide that by 10.
		let speed = Double(velocity) / 10.0
		
		//Convert the input angle to radians.  Most people don't think in radians, so the input will come in as degrees that we will convert to radians.
		let radians = deg2rad(degrees: angle)
		
		//If somehow there's a banana already, we'll remove it, then create a new one using circle physics.
		if banana != nil {
			banana.removeFromParent()
			banana = nil
		}
		
		banana = SKSpriteNode(imageNamed: "banana")
		banana.name = "banana"
		banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
		banana.physicsBody?.categoryBitMask = CollissionTypes.banana.rawValue
		banana.physicsBody?.collisionBitMask = CollissionTypes.building.rawValue | CollissionTypes.player.rawValue
		banana.physicsBody?.contactTestBitMask = CollissionTypes.building.rawValue | CollissionTypes.player.rawValue
		banana.physicsBody?.usesPreciseCollisionDetection = true
		addChild(banana)
		
		if currentPlayer == 1 {
			//If player 1 was throwing the banana, we position the banana up and to the left of the player and give it some spin.
			banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
			banana.physicsBody?.angularVelocity = -20
			
			// 5
			let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
			let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
			let pause = SKAction.wait(forDuration: 0.15)
			let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
			player1.run(sequence)
			
			// 6
			let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
			banana.physicsBody?.applyImpulse(impulse)
		} else {
			// 7
			banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
			banana.physicsBody?.angularVelocity = 20
			
			let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
			let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
			let pause = SKAction.wait(forDuration: 0.15)
			let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
			player2.run(sequence)
			
			let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
			banana.physicsBody?.applyImpulse(impulse)
			
		}
	}
	
	func deg2rad(degrees: Int) -> Double {
		return Double(degrees) * Double.pi / 180.0
	}
	
	
	func createBuildings() {
		var currentX: CGFloat = -15
		
		while currentX < 1024 {
			let size = CGSize(width: RandomInt(min: 2, max: 4) * 40, height: RandomInt(min: 300, max: 600))
			currentX += size.width + 2
			
			let building = BuildingNode(color: UIColor.red, size: size)
			building.position = CGPoint(x: currentX - (size.width/2), y: size.height/2)
			building.setup()
			addChild(building)
			
			buildings.append(building)
		}
	}
	
	func createPlayers() {
		player1 = SKSpriteNode(imageNamed: "player")
		player1.name = "player1"
		player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width/2)
		player1.physicsBody?.categoryBitMask = CollissionTypes.player.rawValue
		player1.physicsBody?.collisionBitMask = CollissionTypes.banana.rawValue
		player1.physicsBody?.contactTestBitMask = CollissionTypes.banana.rawValue
		player1.physicsBody?.isDynamic = false
		
		let player1Building = buildings[1]
		player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
		addChild(player1)
		
		player2 = SKSpriteNode(imageNamed: "player")
		player2.name = "player2"
		player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
		player2.physicsBody?.categoryBitMask = CollissionTypes.player.rawValue
		player2.physicsBody?.collisionBitMask = CollissionTypes.banana.rawValue
		player2.physicsBody?.contactTestBitMask = CollissionTypes.banana.rawValue
		player2.physicsBody?.isDynamic = false
		
		let player2Building = buildings[buildings.count - 2]
		player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
		addChild(player2)
	}
	
	func destroy(player: SKSpriteNode) {
		let explosion = SKEmitterNode(fileNamed: "hitPlayer")!
		explosion.position = player.position
		addChild(explosion)
		
		player.removeFromParent()
		banana?.removeFromParent()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
			let newGame = GameScene(size: self.size)
			newGame.viewController = self.viewController
			self.viewController.currentGame = newGame
			
			self.changePlayer()
			newGame.currentPlayer = self.currentPlayer
			
			let transition = SKTransition.doorway(withDuration: 1.5)
			self.view?.presentScene(newGame, transition: transition)
			
		}
	}
	
	func changePlayer() {
		if currentPlayer == 1 {
			currentPlayer = 2
		} else {
			currentPlayer = 1
		}
		
		viewController.activatePlayer(number: currentPlayer)
	}
	
	func bananaHit(building: BuildingNode, atPoint contactPoint: CGPoint) {
		let buildingLocation = convert(contactPoint, to: building)
		building.hitAt(point: buildingLocation)
		
		let explosion = SKEmitterNode(fileNamed: "hitBuilding")!
		explosion.position = contactPoint
		addChild(explosion)
		
		banana.name = ""
		banana?.removeFromParent()
		banana = nil
		
		changePlayer()
	}
	
	//MARK: Game Scene Methods
	func didBegin(_ contact: SKPhysicsContact) {
		var firstBody: SKPhysicsBody
		var secondBody: SKPhysicsBody
		
		if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
			firstBody = contact.bodyA
			secondBody = contact.bodyB
		} else {
			firstBody = contact.bodyB
			secondBody = contact.bodyA
		}
		
		if let firstNode = firstBody.node {
			if let secondNode = secondBody.node {
				if firstNode.name == "banana" && secondNode.name == "building" {
					bananaHit(building: secondNode as! BuildingNode, atPoint: contact.contactPoint)
				}
				
				if firstNode.name == "banana" && secondNode.name == "player1" {
					destroy(player: player1)
					viewController.scoreP2 += 1
				}
				
				if firstNode.name == "banana" && secondNode.name == "player2" {
					destroy(player: player2)
					viewController.scoreP1 += 1
				}
			}
		}
	}
	
	override func didMove(to view: SKView) {
		backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
		
		physicsWorld.contactDelegate = self
		
		createBuildings()
		createPlayers()
	}
	
	
    func touchDown(atPoint pos : CGPoint) {
		
    }
    
    func touchMoved(toPoint pos : CGPoint) {
		
    }
    
    func touchUp(atPoint pos : CGPoint) {
		
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
		if banana != nil {
			if banana.position.y < -1000 {
				banana.removeFromParent()
				banana = nil
				
				changePlayer()
			}
		}
    }
}
