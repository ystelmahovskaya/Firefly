//
//  ParentScene.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-11.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class ParentScene: SKScene {
    let gameSettings = GameSettings()
    let sceneManager = SceneManager.shared
    var backScene:SKScene?
    
    /**
     Add header to the scene
     
     - parameter name:  optional header text
      - parameter backgroundName:  file name
     */
    func setHeader(withName name:String?, andBackground backgroundName: String ){
        let header = ButtonNode(titled: name, backgroundName: backgroundName)
        header.position = CGPoint(x: self.frame.midX, y: self.frame.height - 40)
        header.zPosition=1
        self.addChild(header)
    }
    
    /**
     Returns first texture from the atlas
     
     - parameter atlas:  SKTextureAtlas
     - returns: SKTexture
     */
    func getTextureFrom(atlas : SKTextureAtlas ) -> SKTexture{
        let atlas = atlas
        let textureNames = atlas.textureNames.sorted()
        let texture = atlas.textureNamed(textureNames[0])
        return texture
    }
    
    override init(size: CGSize) {
        super .init(size: size)
        backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

