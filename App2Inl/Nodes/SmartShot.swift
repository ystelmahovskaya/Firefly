//
//  SmartShot.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-29.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation

import GameplayKit
import SpriteKit

class SmartShot : SKNode, GKAgentDelegate {
    var agent = GKAgent2D()
    
    /**
     SmartShot implements GKAgentDelegate and can use GKAgent's behaviour, has the same physical properties as the EnemyNode
     
     - parameter scene: parent to place SKSpriteNode
    - parameter radius: Float used to agent circular movement
      - parameter position: point on the scene where node places
     */
    init(scene:SKScene, radius:Float, position:CGPoint) {
        super.init()
        
        self.position = position
        self.zPosition = 10;
        self.name = "sprite"
        
        agent.radius = radius
        agent.position = vector_float2(Float(position.x), Float(position.y))
        agent.delegate = self
        agent.maxSpeed = 100 * 4
        agent.maxAcceleration = 50 * 4
        
        let bomb = SKSpriteNode(imageNamed:"bomb")
        bomb.physicsBody = SKPhysicsBody(texture: bomb.texture!, alphaThreshold: 0.5, size: bomb.size)
        bomb.physicsBody?.isDynamic = true
        bomb.physicsBody?.categoryBitMask = BitMaskCategory.enemy.rawValue
        bomb.physicsBody?.collisionBitMask = BitMaskCategory.none.rawValue
        bomb.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue | BitMaskCategory.shot.rawValue
        bomb.zRotation = CGFloat(-.pi / 2.0)
        self.addChild(bomb)
        scene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func agentDidUpdate(_ agent: GKAgent) {
        guard let agent2D = agent as? GKAgent2D else {
            return
        }
        
        self.position = CGPoint(x: CGFloat(agent2D.position.x), y: CGFloat(agent2D.position.y))
        self.zRotation = CGFloat(agent2D.rotation)
    }
}
