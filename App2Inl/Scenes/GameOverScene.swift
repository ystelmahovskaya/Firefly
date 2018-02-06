//
//  GameOverScene.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-12.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: ParentScene {
 
    /**
     Setting header and creating navigation menu
     
     */
    override func didMove(to view: SKView) {
        
        setHeader(withName: "Game Over", andBackground:"header_background")
        let titles = ["restart", "options", "best"]
        
        for (index, title) in titles.enumerated() {
            
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(index * 60))
            button.name = title
            button.label.name = title
            button.setScale(0.7)
            addChild(button)
        }
    }
    
    /**
    Check if touch inside the scene is on the node with some name and navigating to scene depending on this name
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "restart"{
            sceneManager.gameScene = nil
            let transition  = SKTransition.crossFade(withDuration: 1.0)
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
        else if node.name == "options"{
            
            let transition  = SKTransition.crossFade(withDuration: 1.0)
            let optionsScene = OptionsScene(size: self.size)
            optionsScene.backScene = self
            optionsScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(optionsScene, transition: transition)
            
        }
        else if node.name == "best"{
            
            let transition  = SKTransition.crossFade(withDuration: 1.0)
            let bestScene = RatingScene(size: self.size)
            bestScene.backScene = self
            bestScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(bestScene, transition: transition)
        }
        
    }
}
