//
//  HUD.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-12.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import SpriteKit

class HUD: SKNode {
    
    let scoreBackground = SKSpriteNode(imageNamed: "scores")
    let scoreLabel = SKLabelNode(text: "0")
    let margin : CGFloat = 20
    let hudZPosition : CGFloat = 100
    var score: Int = 0 {
        didSet{
            scoreLabel.text = score.description
        }
    }
    let menuButton = SKSpriteNode(imageNamed: "menu")
    let life1 = SKSpriteNode(imageNamed: "life")
    let life2 = SKSpriteNode(imageNamed: "life")
    let life3 = SKSpriteNode(imageNamed: "life")
    
    /**
     places HUD elements on the screen
     
     - parameter screenSize: the size of the scene
     */
    
    func configureUI(screenSize: CGRect){
    
        scoreBackground.position = CGPoint(x: -screenSize.width/2+scoreBackground.size.width/2+margin, y: screenSize.height/2 - scoreBackground.size.height/2 )
        scoreBackground.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        scoreBackground.zPosition = hudZPosition-1
        scoreBackground.setScale(0.5)
        addChild(scoreBackground)
        
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: -10, y: 3)
        scoreLabel.zPosition = hudZPosition
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 30
        scoreBackground.addChild(scoreLabel)
        
        menuButton.position = CGPoint(x: -screenSize.width/2+margin, y: -screenSize.height/2+margin)
        menuButton.anchorPoint = CGPoint(x: 0, y: 0)
        menuButton.zPosition = hudZPosition
        menuButton.setScale(0.7)
        menuButton.name = "pause"
        addChild(menuButton)

        let lifes = [life1, life2, life3]
        
        for (index, life) in lifes.enumerated() {
            life.position = CGPoint(x: screenSize.width/2 - CGFloat (index + 1) * ((life.size.width)+3), y: -screenSize.height/2+margin)
            life.zPosition = hudZPosition
            life.anchorPoint = CGPoint(x: 0, y: 0)
            addChild((life))
        }
    }
    
}

