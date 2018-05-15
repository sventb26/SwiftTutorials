//
//  GameScene.swift
//  Project17
//
//  Created by Administrator on 5/15/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	
	//MARK: Properties
	var gameScore: SKLabelNode!
	var score = 0 {
		didSet {
			gameScore.text = "Score: \(score)"
		}
	}
	
	var livesImages = [SKSpriteNode]()
	var lives = 3
	var activeSliceBG: SKShapeNode!
	var activeSliceFG: SKShapeNode!
	var activeSlicePoints = [CGPoint]()
	var isSwooshSoundActive = false

	
	//MARK: Functions
	func createScore() {
		gameScore = SKLabelNode(fontNamed: "Chalkduster")
		gameScore.text = "Score: 0"
		gameScore.horizontalAlignmentMode = .left
		gameScore.fontSize = 48
		
		addChild(gameScore)
		
		gameScore.position = CGPoint(x: 8, y: 8)
	}
	
	func createLives() {
		for i in 0 ..< 3 {
			let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
			spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
			addChild(spriteNode)
			
			livesImages.append(spriteNode)
		}
	}
	
	func createSlices() {
		
		activeSliceBG = SKShapeNode()
		activeSliceBG.zPosition = 2
		
		activeSliceFG = SKShapeNode()
		activeSliceFG.zPosition = 2
		
		activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
		activeSliceBG.lineWidth = 9
		
		activeSliceFG.strokeColor = UIColor.white
		activeSliceFG.lineWidth = 5
		
		addChild(activeSliceBG)
		addChild(activeSliceFG)
	}
	
	
	func redrawActiveSlice() {
		//If we have fewer than two points in our array, we don't have enough data to draw a line so it needs to clear the shapes and exit the method.and
		if activeSlicePoints.count < 2 {
			activeSliceBG.path = nil
			activeSliceFG.path = nil
			return
		}
		
		//If we have more than 12 slice points in our array, we need to remove the oldest ones until we have at most 12 - this stops the swipe shapes from becoming too long.12
		while activeSlicePoints.count > 12 {
			activeSlicePoints.remove(at: 0)
		}
		
		//It needs to start its line at the position of the first swipe point, then go through each of the others drawing lines to each point.at
		let path = UIBezierPath()
		path.move(to: activeSlicePoints[0])
		
		for i in 1 ..< activeSlicePoints.count {
			path.addLine(to: activeSlicePoints[i])
		}
		
		//It needs to update the slice shape paths so they get drawn using their designs - i.e. line width and color.
		activeSliceBG.path = path.cgPath
		activeSliceFG.path = path.cgPath
	}
	
	
	func playSwooshSound() {
		isSwooshSoundActive = true
		
		let randomNumber = RandomInt(min: 1, max: 3)
		
		let soundName = "swoosh\(randomNumber).caf"
		
		let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
		
		run(swooshSound) { [unowned self] in
			self.isSwooshSoundActive = false
		}
	}

	
	override func didMove(to view: SKView) {
		
		let background = SKSpriteNode(imageNamed: "sliceBackground")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
		
		physicsWorld.gravity = CGVector(dx: 0, dy: -6)
		physicsWorld.speed = 0.85
		
		createScore()
		createLives()
		createSlices()
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		
		//Remove all existing points in the activeSlicePoints array, becase we're starting fresh.
		activeSlicePoints.removeAll(keepingCapacity: true)
		
		//Get the touch location and add it to the activeSlicePoints array.activeSlicePoints
		if let touch = touches.first {
			let location = touch.location(in: self)
			activeSlicePoints.append(location)
			
			//Call the redrawActiveSlice() method to clear the slice shapes.activeSlicePoints
			redrawActiveSlice()
			
			//Remove any actions that are currently attached to the slice shapes.  This is important if they are in the middle of the fadeOut(withDuration:) action.action
			activeSliceBG.removeAllActions()
			activeSliceFG.removeAllActions()
			
			//Set both slice shapes to have an alpha value of 1 so they are fully visible.activeSliceBG
			activeSliceBG.alpha = 1
			activeSliceFG.alpha = 1
		}
	}
	
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		
		let location = touch.location(in: self)
		
		activeSlicePoints.append(location)
		redrawActiveSlice()
		
		if !isSwooshSoundActive	{
			playSwooshSound()
		}
	}
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
		activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
	}
	
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
	touchesEnded(touches, with: event)
	}
}
