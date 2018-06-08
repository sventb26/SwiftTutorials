//
//  Player.swift
//  MazeRunner
//
//  Created by Administrator on 6/7/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit

class Player {
	
	class func createPlayer() -> SKSpriteNode {
		
		let node = SKSpriteNode(imageNamed: "player")
		node.position = CGPoint(x: 96, y: 672)
		
		node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
		node.physicsBody?.allowsRotation = false
		node.physicsBody?.linearDamping = 0.5
		
		node.physicsBody?.categoryBitMask = 1
		node.physicsBody?.contactTestBitMask = 4 | 8 | 16
		node.physicsBody?.collisionBitMask = 2
		
		return node
		
	}
}
