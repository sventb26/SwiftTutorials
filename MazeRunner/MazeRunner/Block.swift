//
//  Block.swift
//  MazeRunner
//
//  Created by Administrator on 6/7/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit

class Block {
	
	
	class func createBlock(position: CGPoint) -> SKSpriteNode {
		
		let node = SKSpriteNode(imageNamed: "block")
		node.position = position
		
		node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
		node.physicsBody?.categoryBitMask = 2
		node.physicsBody?.isDynamic = false
		
		return node
		
	}
}
