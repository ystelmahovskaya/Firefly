//
//  GreenShot.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-24.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import SpriteKit

class GreenShot : Shot {
    
    
    init(){
        let textureAtlas = Assets.shared.greenShotAtlas
        
        
        super.init(textureAtlas: textureAtlas)
        self.physicsBody?.categoryBitMask = BitMaskCategory.shot.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.enemy.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.enemy.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
