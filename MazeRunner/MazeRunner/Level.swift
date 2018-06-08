//
//  Level.swift
//  MazeRunner
//
//  Created by Administrator on 6/7/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit

class Level: SKNode {
	
	init(level: Int) {
		super.init()
		
		self.setLevel(level: level)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setLevel(level: Int) {
		
		
		if let levelPath = Bundle.main.path(forResource: "level\(level)", ofType: "txt") {
			if let levelString = try? String(contentsOfFile: levelPath) {
				let lines = levelString.components(separatedBy: "\n")
				
				for (row, line) in lines.reversed().enumerated() {
					
					for (column, letter) in line.enumerated() {
					
						let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
						
						if letter == "x" {
							
							let block = Block.createBlock(position: position)
							self.addChild(block)
							
						} else if letter == "v" {
							
							let vortex = Vortex.createVortex(position: position)
							self.addChild(vortex)
							
						} else if letter == "s" {
							
							let star = Star.createStar(position: position)
							self.addChild(star)
							
						} else if letter == "f" {
							
							let pokal = Pokal.createPokal(position: position)
							self.addChild(pokal)
						}
					}
				}
			}
		}
	}
	

}
