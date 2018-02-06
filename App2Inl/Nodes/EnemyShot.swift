//
//  EnemyShot.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-27.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyShot : Shot {
    init(){
        let textureAtlas = Assets.shared.redShotAtlas
        
        /**
         Shot of green color
         */
        super.init(textureAtlas: textureAtlas)
        self.name = "sprite"
        
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.enemyShot.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.none.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue | BitMaskCategory.shot.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     Shot moves  down during 1 second
     
     */
    override func startMovement(){
        
        let moveForvard = SKAction.moveTo(y: -shotSize, duration: 1)
        self.run(moveForvard)
    }
}
