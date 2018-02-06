//
//  MenuScene.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-12.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: ParentScene {
    /**
     Setting header and creating navigation menu, preloading of Assets     
     */
    override func didMove(to view: SKView) {
        if !Assets.shared.isLoaded{
            Assets.shared.preloadAssets()
            Assets.shared.isLoaded = true
        }
        let screenCenterPoint =  CGPoint(x: self.size.width/2 , y: self.size.height/2 )
        let background = Background.populateBackground(at: screenCenterPoint, imageNamed: "b1")
        background.size = self.size
        self.addChild(background)
        background.zPosition = 0
        
        setHeader(withName: nil, andBackground:"logo")
        
        
        let titles = ["play", "options", "best"]
        
        for (index, title) in titles.enumerated() {
            
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.setScale(0.7)
            button.position = CGPoint(x: self.frame.width-self.frame.width/5, y: self.frame.height-self.frame.height/3 - CGFloat(index * 70))
            button.name = title
            button.zPosition = 1
            button.label.name = title
            addChild(button)
            
        }
        
    }
    /**
     Check if touch inside the scene is on the node with some name and navigating to scene depending on this name
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "play"{
            let transition  = SKTransition.crossFade(withDuration: 1.0)
            let gameScene = GameScene(size: CGSize(width: self.size.width, height: self.size.height))
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
    
    /**
     Add header to the scene
     
     - parameter name:  optional header text
     - parameter backgroundName:  file name
     */
    override func setHeader(withName name:String?, andBackground backgroundName: String ){
        let header = ButtonNode(titled: name, backgroundName: backgroundName)
        header.position = CGPoint(x: self.frame.width/3, y: self.frame.height-self.frame.height/4)
        header.setScale(0.3)
        let colorize = SKAction.colorize(with: .white, colorBlendFactor: 6, duration: 5)
        header.run(colorize)
        header.zPosition=1
        self.addChild(header)
        let image = ButtonNode(titled: nil, backgroundName: "lightfighter0001")
        image.position = CGPoint(x: self.frame.width/3, y: self.frame.height/2.5)
        image.setScale(0.5)
        image.zRotation=30
        image.zPosition=1
        self.addChild(image)
    }
}
