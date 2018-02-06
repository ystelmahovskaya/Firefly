//
//  Shot.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-24.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//


import SpriteKit

class Shot: SKSpriteNode {
    let screensize = UIScreen.main.bounds
    let shotSize: CGFloat = 30
    
    let textureAtlas : SKTextureAtlas!
    var animationSpriteArray = [SKTexture]()
    
    init(textureAtlas: SKTextureAtlas){
        let initialSize = CGSize(width: shotSize, height: shotSize)
        self.textureAtlas = textureAtlas
        let textureName = textureAtlas.textureNames.sorted()[0]
        let texture = textureAtlas.textureNamed(textureName)
        
        super.init(texture: texture, color: .clear, size: initialSize)

        self.name = "shotSprite"
        self.zPosition = 30
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
        self.physicsBody?.isDynamic = false
        
    }
    /**
     Shot moves up during 1 seconds
     
     */
    func startMovement(){
        let moveForvard = SKAction.moveTo(y: screensize.height+shotSize, duration: 1)
        self.run(moveForvard)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

