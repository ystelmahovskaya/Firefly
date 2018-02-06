//
//  BluePowerUp.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-30.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import SpriteKit

class BluePowerUp: PowerUp {
    /**
    Power up of blue color adds 1 life
     
     */
    init(){
        let textureAtlas = Assets.shared.bluePowerUp
        super.init(textureAtlas: textureAtlas)
        name = "bluePowerUp"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
