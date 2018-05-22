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
	
	//MARK: Properties
    //The gameTimer property will be a new class called Timer. We'll use this to call the launchFireworks() method every six seconds.
	var gameTimer: Timer!
	
	//The fireworks property will be an array of SKNode objects.
	var fireworks = [SKNode]()
	
	//The leftEdge, bottomEdge, and rightEdge properties are used to define where we launch fireworks from. Each of them will be just off screen to one side.
	let leftEdge = -22
	let bottomEdge = -22
	let rightEdge = 1024 + 22
	
	//The score property will track the player's score.
	var gameScore: SKLabelNode!
	var score = 0 {
		didSet {
			gameScore.text = "Score: \(score)"
		}
	}

	var button: SKNode! = nil
	
	//MARK: Functions
	func createFireworks(xMovement: CGFloat, x: Int, y: Int) {
		
		//Create an SKNode that will act as the firework container, and place it at the position that was specified.
		let node = SKNode()
		node.position = CGPoint(x: x, y: y)
		
		//Create a rocket sprite node, give it the name "firework" so we know that it's the important thing, adjust its colorBledFactor property so that we can color it, then add it to the container.
		let firework = SKSpriteNode(imageNamed: "rocket")
		firework.colorBlendFactor = 1
		firework.name = "firework"
		node.addChild(firework)
		
		//Give the firework sprite node one of three random colors: cyan, green, or red.
		switch GKRandomSource.sharedRandom().nextInt(upperBound: 3) {
		case 0:
			firework.color = .cyan
		
		case 1:
			firework.color = .green
			
		case 2:
			firework.color = .red
			
		default:
			break
		}
		
		//Create a UIBezierPath that will represent the movement of the firework.
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: xMovement, y: 1000))
		
		//Tell the container node to follow that path, turning itself as needed.
		let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
		node.run(move)
		
		//Create particles behind the rocket to make it look like the fireworks are lit.
		let emitter = SKEmitterNode(fileNamed: "fuse.sks")!
		emitter.position = CGPoint(x: 0, y: -22)
		node.addChild(emitter)
		
		//Add the firework to our fireworks array and also to the scene.
		fireworks.append(node)
		addChild(node)
	}
	
	
	@objc func launchFireworks() {
		
		let movementAmount: CGFloat = 1800
		
		switch GKRandomSource.sharedRandom().nextInt(upperBound: 4) {
			
		case 0:
			//fire five, straight up
			createFireworks(xMovement: 0, x: 512, y: bottomEdge)
			createFireworks(xMovement: 0, x: 512 - 200, y: bottomEdge)
			createFireworks(xMovement: 0, x: 512 - 100, y: bottomEdge)
			createFireworks(xMovement: 0, x: 512 + 100, y: bottomEdge)
			createFireworks(xMovement: 0, x: 512 + 200, y: bottomEdge)
			
		case 1:
			//fire five, in a fan
			createFireworks(xMovement: 0, x: 512, y: bottomEdge)
			createFireworks(xMovement: -200, x: 512 - 200, y: bottomEdge)
			createFireworks(xMovement: -100, x: 512 - 100, y: bottomEdge)
			createFireworks(xMovement: 100, x: 512 + 100, y: bottomEdge)
			createFireworks(xMovement: 200, x: 512 + 200, y: bottomEdge)
			
		case 2:
			//fire five, from left to the right
			createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
			createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
			createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
			createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
			createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
			
		case 3:
			//fire five, from right to the left
			createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
			createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
			createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
			createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
			createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
			
		default:
			break
		}
	}
	
	
	func explode(firework: SKNode) {
		
		let emitter = SKEmitterNode(fileNamed: "explode")!
		emitter.position = firework.position
		addChild(emitter)
		
		firework.removeFromParent()
	}
	
	
	func explodeFireworks() {
		
		var numExploded = 0
		
		for (index, fireworkContainer) in fireworks.enumerated().reversed() {
			let firework = fireworkContainer.children[0] as! SKSpriteNode
			
			if firework.name == "selected" {
				//destroy this firework!
				explode(firework: fireworkContainer)
				fireworks.remove(at: index)
				numExploded += 1
			}
		}
		
		switch numExploded {
			
		case 0:
			//nothing - rubbish!
			break
		
		case 1:
			score += 200
			
		case 2:
			score += 500
			
		case 3:
			score += 1500
			
		case 4:
			score += 2500
			
		default:
			score += 4000
		}
	}
	
	
	
	
	
	override func update(_ currentTime: TimeInterval) {
		
		for (index, firework) in fireworks.enumerated().reversed() {
			if firework.position.y > 900 {
				//this uses a posiion high above so that rockets can explode off screen
				fireworks.remove(at: index)
				firework.removeFromParent()
			}
		}
	}
	
	
	func checkTouches(_ touches: Set<UITouch>) {
		guard let touch = touches.first else { return }
		
		let location = touch.location(in: self)
		let nodesAtPoint = nodes(at: location)
		
		for node in nodesAtPoint {
			if node is SKSpriteNode {
				let sprite = node as! SKSpriteNode
				
				if sprite.name == "firework" {
					
					for parent in fireworks {
						let firework = parent.children[0] as! SKSpriteNode
						
						if firework.name == "selected" && firework.color != sprite.color {
							firework.name = "firework"
							firework.colorBlendFactor = 1
						}
					}
					
					sprite.name = "selected"
					sprite.colorBlendFactor = 0
				}
			}
		}
	}
	
	
    override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "background")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
		
		gameScore = SKLabelNode(fontNamed: "Chalkduster")
		gameScore.text = "Score: 0"
		gameScore.position = CGPoint(x: 8, y: 8)
		gameScore.horizontalAlignmentMode = .left
		gameScore.fontSize = 24
		addChild(gameScore)
		
		button = SKSpriteNode(color: SKColor.gray, size: CGSize(width: 100, height: 44))
		button.position = CGPoint(x: 512, y: bottomEdge + 50)
		addChild(button)
		
		gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		
		guard let touch = touches.first else { return }
		
		let location = touch.location(in: self)
			
		if button.contains(location) {
				explodeFireworks()
		}
	}
	
	
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		checkTouches(touches)
	}
	
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		checkTouches(touches)
	}
}
