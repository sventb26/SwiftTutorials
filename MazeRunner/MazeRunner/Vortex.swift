//
//  Vortex.swift
//  MazeRunner
//
//  Created by Administrator on 6/7/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit

class Vortex {
	
	class func createVortex(position: CGPoint) -> SKSpriteNode {
		
		let node = SKSpriteNode(imageNamed: "vortex")
		node.name = "vortex"
		node.position = position
		node.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 1)))
		node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
		node.physicsBody?.isDynamic = false
		
		node.physicsBody?.categoryBitMask = 8
		node.physicsBody?.contactTestBitMask = 8
		node.physicsBody?.collisionBitMask = 0
		
		return node
	}
	

}
