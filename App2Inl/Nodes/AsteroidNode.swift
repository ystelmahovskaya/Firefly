//
//  StarNode.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-12.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import SpriteKit

class AsteroidNode : RotatingBaseNode {
    /**
    Damages PlayerNode and has the same BitMask and physical properties as the EnemyNode. Atlas chooses ramdomly
     
     */
    init() {
        let randomNumber = Int(arc4random_uniform(4))
        var textureAtlas : SKTextureAtlas!
        
        switch randomNumber {
        case 0:
            textureAtlas = Assets.shared.asteroid_1
        case 1:
            textureAtlas = Assets.shared.asteroid_2
        case 2:
            textureAtlas = Assets.shared.asteroid_3
        case 3:
            textureAtlas = Assets.shared.asteroid_4
        default:
            print("error at asteroidNode")
        }
        
        super.init(textureAtlas:textureAtlas)
        
        name = "asteroid"
        self.physicsBody = SKPhysicsBody(texture: texture!, alphaThreshold: 0.5, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.none.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue | BitMaskCategory.shot.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
