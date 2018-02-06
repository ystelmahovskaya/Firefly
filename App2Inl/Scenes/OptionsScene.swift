//
//  OptionsScene.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-12.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import SpriteKit

class OptionsScene: ParentScene {
    
    var isMusic: Bool!
    var isSound: Bool!
    
    /**
    creates ButtonNode with values from user defaults for music and sounds
     */
    override func didMove(to view: SKView) {
        
        isMusic = gameSettings.isMusic
        isSound = gameSettings.isSound
        
        setHeader(withName: "Options", andBackground:"header_background")
        
        let backgroundNameForMusic = isMusic == true ? "music": "nomusic"
        let backgroundNameForSound = isSound == true ? "sound": "nosound"
        
        
        let music = ButtonNode(titled: nil, backgroundName: backgroundNameForMusic)
        music.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY)
        music.name = "music"
        music.label.isHidden = true
        music.setScale(0.7)
        addChild(music)
        
        let sound = ButtonNode(titled: nil, backgroundName: backgroundNameForSound)
        sound.position = CGPoint(x: self.frame.midX + 50, y: self.frame.midY)
        sound.name = "sound"
        sound.label.isHidden = true
        sound.setScale(0.7)
        addChild(sound)
        
        let back = ButtonNode(titled: "back", backgroundName: "button_background")
        back.position = CGPoint(x: self.frame.midX, y: back.frame.height)
        back.name = "back"
        back.label.name = "back"
        back.setScale(0.7)
        addChild(back)
    }
    
    /**
     Check if touch inside the scene is on the node with some name and changing user defaults respectively to the names
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "music"{
            isMusic = !isMusic
            update(node: node as! SKSpriteNode, property: isMusic)
        } else if node.name == "sound"{
            isSound = !isSound
            update(node: node as! SKSpriteNode, property: isSound)
        }
        else if node.name == "back"{
            gameSettings.isMusic = isMusic
            gameSettings.isSound = isSound
            gameSettings.saveGameSettings()
            
            let transition  = SKTransition.crossFade(withDuration: 1.0)
            guard let backScene = backScene else {return}
            backScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(backScene, transition: transition)
        }
    }
    
    /**
     update node image depending on parameter property
     
     - parameter node:  SKSpriteNode
     - parameter property: Bool
     */
    func update(node: SKSpriteNode, property: Bool){
        if let name = node.name {
            node.texture = property ? SKTexture(imageNamed: name) : SKTexture(imageNamed: "no" + name)
            gameSettings.saveGameSettings()
        }
    }
}

