//
//  EnemyNode.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-26.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import UIKit
import SpriteKit

class Enemy: SKSpriteNode {
    
    static var textureAtlas:SKTextureAtlas?
    var enemyTexture : SKTexture!
    var enemyHeight : CGFloat = 64
    var enemyWidth : CGFloat = 64
     let margin : CGFloat = 50
    
    init(enemyTexture: SKTexture){
        let texture = enemyTexture
        super.init(texture: texture, color: .clear, size: CGSize(width: enemyWidth, height: enemyHeight))
        
        self.zPosition = 20
        self.name = "sprite"
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.none.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue | BitMaskCategory.shot.rawValue
        
        
    }
    /**
    Adding to scene EnemyShot instances with start point at the Enemy instance position every 2 seconds, repeats only 3 times
     
     */
    func enemyShot(){
        
        let waitAction = SKAction.wait(forDuration: 1.0)
        let spawnEnemy = SKAction.run({
            let shot = EnemyShot()
            shot.position = CGPoint(x: self.position.x, y: self.position.y-self.frame.height/2)
            self.scene?.addChild(shot)
            shot.startMovement()
        })
        let spawnAction = SKAction.sequence([waitAction,spawnEnemy])
        let repeatAction = SKAction.repeat(spawnAction, count: 3)
        self.run(repeatAction)
    }

    /**
     EnemyNode's movement to the left or to the right of the UI screen and back (randomly) during 3 seconds and at the same time movement down (5 sec)
     
     - parameter x: lower bound of visible part of the scene width
     */
    func flySpiral(x: CGFloat){
        let screen =  UIScreen.main.bounds
        let time:Double = 3
        let timeVertical:Double = 5
        let moveLeft = SKAction.moveTo(x: x, duration: time)
        moveLeft.timingMode = .easeInEaseOut
        let moveRight = SKAction.moveTo(x: x + screen.width - margin, duration: time)
        moveRight.timingMode = .easeInEaseOut
        let randomnumber = Int(arc4random_uniform(2))
        
        let asideMovementSequence = randomnumber == EnemyDirection.left.rawValue ? SKAction.sequence([moveLeft,moveRight]): SKAction.sequence([moveRight, moveLeft])
        
        let foreverAsideMovement = SKAction.repeatForever(asideMovementSequence)
        
        let forvardMovement = SKAction.moveTo(y: -enemyHeight, duration: timeVertical)
        let groupMovement = SKAction.group([foreverAsideMovement,forvardMovement])
        self.run(groupMovement)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum EnemyDirection: Int{
    case left = 0
    case right = 1
}

