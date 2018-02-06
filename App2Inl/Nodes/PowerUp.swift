//
//  PowerUp.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-30.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import SpriteKit



class PowerUp: SKSpriteNode {
    let powerUpSize: CGFloat = 52
    let textureAtlas : SKTextureAtlas!
    var textureNameBeginsWith = ""
    var animationSpriteArray = [SKTexture]()
    
    init(textureAtlas: SKTextureAtlas){
        let initialSize = CGSize(width: powerUpSize, height: powerUpSize)
        self.textureAtlas = textureAtlas
        let textureName = textureAtlas.textureNames.sorted()[0]
        let texture = textureAtlas.textureNamed(textureName)
        textureNameBeginsWith = String(textureName.characters.dropLast(6))
        super.init(texture: texture, color: .clear, size: initialSize)
        self.setScale(0.7)
        self.name = "sprite"
        self.zPosition = 20
        
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.powerUp.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.player.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue
    }
    
    /**
     performs PowerUp's movement trought the scene during 5 sec
     */
    func startMovement(){
        performRotation()
        let moveForvard = SKAction.moveTo(y: -powerUpSize, duration: 5)
        self.run(moveForvard)
        
    }
    /**
     Animate sprites to create effect of rotation used SKAction
     
    
     - important: numbers in the files names should be sequentiell
     */
    func performRotation(){
        for i in 1...15{
            let number = String(format: "%02d", i)
            animationSpriteArray.append(SKTexture(imageNamed: textureNameBeginsWith+number.description))
            
        }
        SKTexture.preload(animationSpriteArray){
            let rotation = SKAction.animate(with: self.animationSpriteArray, timePerFrame: 0.05, resize: true, restore: false)
            
            let rotationForever = SKAction.repeatForever(rotation)
            self.run(rotationForever)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

