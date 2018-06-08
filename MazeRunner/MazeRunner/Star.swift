//
//  Star.swift
//  MazeRunner
//
//  Created by Administrator on 6/7/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit

class Star {
	
	class func createStar(position: CGPoint) -> SKSpriteNode {
		
		let node = SKSpriteNode(imageNamed: "star")
		node.name = "star"
		node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
		node.physicsBody?.isDynamic = false
		
		node.physicsBody?.categoryBitMask = 4
		node.physicsBody?.contactTestBitMask = 4
		node.physicsBody?.collisionBitMask = 0
		node.position = position
		
		return node
		
	}

}
