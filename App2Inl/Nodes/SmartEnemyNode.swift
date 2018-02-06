//
//  SmartEnemyNode.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-29.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import SpriteKit
import GameKit

class SmartEnemyNode: Enemy {
    
    override init(enemyTexture: SKTexture){
        super.init(enemyTexture: enemyTexture)
     
    }
    
    /**
     EnemyNode's movement to the left or to the right of the UI screen and back (randomly) during 3 seconds and at the same time movement down (1 sec)
     
     - parameter x: lower bound of visible part of the scene width
     */
    override func flySpiral(x: CGFloat) {
        let screen =  UIScreen.main.bounds
        let time:Double = 3
        let timeVertical:Double = 1
        let moveLeft = SKAction.moveTo(x: x, duration: time)
        moveLeft.timingMode = .easeInEaseOut
        let moveRight = SKAction.moveTo(x: x + screen.width - margin, duration: time)
        moveRight.timingMode = .easeInEaseOut
        let randomnumber = Int(arc4random_uniform(2))
        
        let asideMovementSequence = randomnumber == EnemyDirection.left.rawValue ? SKAction.sequence([moveLeft,moveRight]): SKAction.sequence([moveRight, moveLeft])
        
        let foreverAsideMovement = SKAction.repeatForever(asideMovementSequence)
        
        let forvardMovement = SKAction.moveTo(y: screen.height-margin, duration: timeVertical)
        let groupMovement = SKAction.group([foreverAsideMovement,forvardMovement])
        self.run(groupMovement)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
