//
//  Pokal.swift
//  MazeRunner
//
//  Created by Administrator on 6/7/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit

class Pokal {
	
	class func createPokal(position: CGPoint) -> SKSpriteNode {
		
		let node = SKSpriteNode(imageNamed: "finish")
		node.name = "finish"
		node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
		node.physicsBody?.isDynamic = false
		
		node.physicsBody?.categoryBitMask = 16
		node.physicsBody?.contactTestBitMask = 16
		node.physicsBody?.collisionBitMask = 0
		node.position = position
		
		return node
		
	}

}
