//
//  WhackSlot.swift
//  Project14
//
//  Created by Administrator on 5/4/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {

	//MARK: Properties
	var charNode: SKSpriteNode!
	
	//MARK: Methods
	func configure(at position: CGPoint) {
		self.position = position
		
		let sprite = SKSpriteNode(imageNamed: "whackHole")
		addChild(sprite)
		
		let cropNode = SKCropNode()
		cropNode.position = CGPoint(x: 0, y: 15)
		cropNode.zPosition = 1
		cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
		
		charNode = SKSpriteNode(imageNamed: "penguinGood")
		charNode.position = CGPoint(x: 0, y: -90)
		charNode.name = "character"
		cropNode.addChild(charNode)
		
		addChild(cropNode)
	}
}
