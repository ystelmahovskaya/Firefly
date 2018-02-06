//
//  GateNode.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-02-01.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import SpriteKit

class GateNode : SKSpriteNode {
    
    static var textureAtlas:SKTextureAtlas?
    var gateTexture : SKTexture!
    let gateHeight : CGFloat = 150
    let gateWigth : CGFloat = 150

    
    init(texture: SKTexture){
        let texture = texture
        super.init(texture: texture, color: .clear, size: CGSize(width: gateHeight, height: gateWigth))
        self.zPosition = 20
        self.name = "gate"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.gate.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.none.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue
        self.addChild(gateShine(fileNamed: "GateParticles"))
        
        
    }
    /**
     creates shining background under GateNode image
     
     - parameter fileNamed: the name of the SpriteKit Particle Editor file
     - returns: SKEmitterNode
     */
    
    func gateShine(fileNamed: String) -> SKEmitterNode{
        let shine : SKEmitterNode = SKEmitterNode(fileNamed: fileNamed)!
        let point = self.position
        shine.position = point
        shine.zPosition = 25
        let shineAction = SKAction.wait(forDuration: 2)
        self.run(shineAction)
        return shine
    }
    /**
     performs GateNode movement trought the scene
     
     - parameter duration: TimeInterval duration of the movement
     */
    func startMovement(duration: TimeInterval){
        let moveForvard = SKAction.moveTo(y: -gateHeight, duration: duration)
        self.run(moveForvard)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
