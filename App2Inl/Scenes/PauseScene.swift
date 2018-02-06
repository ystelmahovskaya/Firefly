//
//  PauseScene.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-24.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import SpriteKit

class PauseScene: ParentScene, BackgroundHelper {
    /**
     Setting header and creating navigation menu
     */
    override func didMove(to view: SKView) {
        createStarLayers(index: 0, scene: self)
        createStarLayers(index: 1, scene: self)
        setHeader(withName: "pause", andBackground:"header_background")
        
        
        let titles = ["restart", "options", "resume"]
        
        for (index, title) in titles.enumerated() {
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(index * 60))
            button.name = title
            button.label.name = title
            button.setScale(0.6)
            addChild(button)
        }
    }
    /**
     pause scene saved in game setting during pause
     */
    override func update(_ currentTime: TimeInterval) {
        if let gameScene = sceneManager.gameScene{
            if gameScene.isPaused == false{
                gameScene.isPaused = true
                print("!!!!CHANGED TO PAUSED")
            }
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
        else if node.name == "resume"{
            let transition  = SKTransition.crossFade(withDuration: 1.0)
            guard let gameScene = sceneManager.gameScene else { return }
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
        
    }
}
