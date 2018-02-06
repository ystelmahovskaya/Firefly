//
//  RatingScene.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-12.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation

import SpriteKit

class RatingScene: ParentScene {
    
    var places : [Int]!
    
    /**
    Setting header and presenting of the high score list
     
     */
    override func didMove(to view: SKView) {
        gameSettings.loadScores()
        places = gameSettings.highScore
        setHeader(withName: "Best", andBackground:"header_background")
        
        let titles = ["back"]
        
        for  title in titles {
            
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.position = CGPoint(x: self.frame.midX, y: button.frame.height)
            button.name = title
            button.label.name = title
            button.setScale(0.6)
            addChild(button)
        }
        
        for (index, value) in places.enumerated() {
            let l = SKLabelNode(text: value.description)
            l.fontColor = UIColor(red: 219/255, green: 226/255, blue: 215/255, alpha: 1.0)
            l.fontName = "AmericanTypewriter-Bold"
            l.fontSize = 25
            l.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - self.frame.maxY/2.5 - CGFloat(index*25))
            addChild(l)
        }
        
    }
    /**
     Check if touch inside the scene is on the node with name "back" and thansition to the backscene

     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        if node.name == "back"{
            let transition  = SKTransition.crossFade(withDuration: 1.0)
            guard let backScene = backScene else {return}
            backScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(backScene, transition: transition)
        }
        
    }
}

