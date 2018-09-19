//
//  BuildingNode.swift
//  Project29
//
//  Created by Administrator on 9/19/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit

class BuildingNode: SKSpriteNode {

	//MARK: Properties
	var currentImage: UIImage!
	
	
	//MARK: Functions
	func setup() {
		//This function will do the basic work required to make a building, setting its: name, texure, and physics.
		name = "building"
		
		currentImage = drawBuilding(size: size)
		texture = SKTexture(image: currentImage)
		
		configurePhysics()
	}
	
	
	func configurePhysics() {
		//This function will set up per-pixel physics for the sprite's current texture.
		physicsBody = SKPhysicsBody(texture: texture!, size: size)
		physicsBody?.isDynamic = false
		physicsBody?.categoryBitMask = CollissionTypes.building.rawValue
		physicsBody?.contactTestBitMask = CollissionTypes.banana.rawValue
	}
	
	func drawBuilding(size: CGSize) -> UIImage {
		//This function will do the Core Graphics rendering of a building, and return it as a UIImage.
		//Create a new Core Graphics context the size of our building.
		let renderer = UIGraphicsImageRenderer(size: size)
		let img = renderer.image { ctx in
			//Fill it with rectangle that's one of three colors.
			let rectangle = CGRect(x: 0, y:0, width: size.width, height: size.height)
			var color: UIColor
			
			switch GKRandomSource.sharedRandom().nextInt(upperBound: 3) {
			case 0:
				color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
			case 1:
				color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
			default:
				color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
			}
			
			ctx.cgContext.setFillColor(color.cgColor)
			ctx.cgContext.addRect(rectangle)
			ctx.cgContext.drawPath(using: .fill)
			
			//Draw windows all over the building in one of two colors: there's either a light on (yellow) or not (gray).
			let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
			let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
			
			for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
				for col in stride(from: 10, to: Int(size.width - 10), by: 40) {
					if RandomInt(min: 0, max: 1) == 0 {
						ctx.cgContext.setFillColor(lightOnColor.cgColor)
					} else {
						ctx.cgContext.setFillColor(lightOffColor.cgColor)
					}
					
					ctx.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
				}
			}
			
			//Pull out the result as a UIImage and return it for use elsewhere.
			
		}
		
		return img
		
	}
	
	func hitAt(point: CGPoint) {
		let convertedPoint = CGPoint(x: point.x + size.width / 2.0, y: abs(point.y - (size.height / 2.0)))
		
		let renderer = UIGraphicsImageRenderer(size: size)
		let img = renderer.image { ctx in
			currentImage.draw(at: CGPoint(x: 0, y: 0))
			
			ctx.cgContext.addEllipse(in: CGRect(x: convertedPoint.x - 32, y: convertedPoint.y - 32, width: 64, height: 64))
			ctx.cgContext.setBlendMode(.clear)
			ctx.cgContext.drawPath(using: .fill)
		}
		
		texture = SKTexture(image: img)
		currentImage = img
		
		configurePhysics()
	}
}
