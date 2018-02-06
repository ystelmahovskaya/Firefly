//
//  PlanetWhite.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-15.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import SpriteKit

class PlanetNode: RotatingBaseNode {
    /**
     Class uses as an animated background part, does not communicate with some other objects
     
     */
    init(){
        let randomNumber = Int(arc4random_uniform(2))
        let textureAtlas = randomNumber == 1 ?  Assets.shared.planetWhiteAtlas: Assets.shared.planetBlueAtlas
        super.init(textureAtlas: textureAtlas)
        
        name = randomNumber == 1 ? "PlanetWhite" : "PlanetBlue"
        self.physicsBody?.categoryBitMask = BitMaskCategory.none.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.none.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.none.rawValue
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
