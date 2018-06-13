//
//  BottomBar.swift
//  
//
//  Created by Administrator on 6/7/18.
//

import SpriteKit

class BottomBar: SKNode {
	
	let scoreLabel: SKLabelNode

	
	override init() {
		
		scoreLabel = SKLabelNode(fontNamed: "EuphemiaUCAS")
		super.init()
		
		let bottomBarBackground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 1024, height: 64))
		bottomBarBackground.fillColor = .black
		bottomBarBackground.alpha = 0.5
		self.addChild(bottomBarBackground)
		
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .left
		scoreLabel.position = CGPoint(x: 50, y: 16)
		self.addChild(scoreLabel)
		
		let starIcon = SKSpriteNode(imageNamed: "star")
		starIcon.scale(to: CGSize(width: starIcon.size.width / 2, height: starIcon.size.height / 2))
		starIcon.position = CGPoint(x: 26, y: 32)
		self.addChild(starIcon)
		
		for i in 1...5 {
			
			let playerIcon = SKSpriteNode(imageNamed: "player")
			playerIcon.name = "playerIcon\(i)"
			playerIcon.scale(to: CGSize(width: playerIcon.size.width * 0.80, height: playerIcon.size.height * 0.80))
			playerIcon.position = CGPoint(x: 680 + (60 * i), y: 32)
			self.addChild(playerIcon)
			
		}
		
	}
	
	func setScore(score: Int) {
		
		scoreLabel.text = "Score: \(score)"
		
	}
	
	
	func lessPlayerLife (lives: Int) {
		
		if (self.childNode(withName: "playerIcon\(lives + 1)")) != nil {
			
			let explosion = SKEmitterNode(fileNamed: "explosion")!
			explosion.position = (self.childNode(withName: "playerIcon\(lives + 1)")?.position)!
			addChild(explosion)
			
			self.childNode(withName: "playerIcon\(lives + 1)")?.removeFromParent()
			
			
		} else {
			
			print("Couldn't remove playerIcon.")
			
		}
	}
	
	
	func addPlayerLife(lives: Int) {
		
		if lives <= 5 {
		
			let playerIcon = SKSpriteNode(imageNamed: "player")
			playerIcon.name = "playerIcon\(lives)"
			playerIcon.scale(to: CGSize(width: playerIcon.size.width * 0.80, height: playerIcon.size.height * 0.80))
			playerIcon.position = CGPoint(x: 680 + (60 * lives), y: 32)
			self.addChild(playerIcon)

		} else {
			print("Max of 5 allowed!")
		}
	}
	
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
