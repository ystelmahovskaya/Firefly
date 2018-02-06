//
//  BackgroundHelper.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-29.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol BackgroundHelper {
    
    func createStarLayers(index: CGFloat, scene: SKScene)
    
}

extension BackgroundHelper {
    /**
     Create a layer of stars using SKLabelNode and SKEmitterNode
     
     - parameter speed: The average initial speed of a new particle in points per second.
     - parameter lifetime:  The average lifetime of a particle, in seconds
     - parameter scale:  The average initial scale factor of a particle.
     - parameter birthRate:  The rate at which new particles are created.
     - parameter color:  The average initial color for a particle.
     - parameter index:  Shows how many times player crossed distanse equals to UI screen bounds
     
     - returns: SKEmitterNode
     */
    func starfieldEmitterNode(speed : CGFloat, lifetime: CGFloat, scale: CGFloat, birthRate: CGFloat, color: SKColor, index: CGFloat) -> SKEmitterNode {
        let star = SKLabelNode(fontNamed: "Helvetica")
        star.fontSize = 40.0
        star.text = "✦"
        let textureView = SKView()
        let texture = textureView.texture(from: star)
        texture!.filteringMode = .nearest
        
        let emitterNode = SKEmitterNode()
        emitterNode.particleTexture = texture
        emitterNode.particleBirthRate = birthRate
        emitterNode.particleColor = color
        emitterNode.particleLifetime = lifetime
        emitterNode.particleSpeed = speed
        emitterNode.particleScale = scale
        emitterNode.particleColorBlendFactor = 1
        
        emitterNode.particlePositionRange = CGVector(dx: UIScreen.main.bounds.maxX , dy: 0)
        emitterNode.particleSpeedRange = 16.0
        
        emitterNode.particleAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.rotate(byAngle: CGFloat(-Double.pi/4), duration: 1),
            SKAction.rotate(byAngle: CGFloat(Double.pi/4), duration: 1)]))
        
        
        let twinkles = 20
        let colorSequence = SKKeyframeSequence(capacity: twinkles*2)
        let twinkleTime = 1.0 / CGFloat(twinkles)
        for i in 0..<twinkles {
            colorSequence.addKeyframeValue(SKColor.white,time: CGFloat(i) * 2 * twinkleTime / 2)
            colorSequence.addKeyframeValue(SKColor.yellow, time: (CGFloat(i) * 2 + 1) * twinkleTime / 2)
        }
        emitterNode.particleColorSequence = colorSequence
        emitterNode.advanceSimulationTime(TimeInterval(lifetime))
        return emitterNode
    }
    /**
     Creates 3 layers of stars using 3 instances of SKEmitterNode with different properties
     
     - parameter index:  shows how many tomes player crossed distanse equals to UI screen bounds
     - parameter scene:  SKScene where node is supposed to be plased as child
     */
    func createStarLayers(index: CGFloat, scene: SKScene) {
        let starfieldNode = SKNode()
        starfieldNode.position = CGPoint(x: UIScreen.main.bounds.maxX * index , y:UIScreen.main.bounds.maxY)
        
        starfieldNode.name = "starfieldNode"
        starfieldNode.addChild(starfieldEmitterNode(speed: -48, lifetime: UIScreen.main.bounds.size.height / 23, scale: 0.2, birthRate: 1, color: SKColor.lightGray, index: starfieldNode.position.x))
        scene.addChild(starfieldNode)
        
        var emitterNode = starfieldEmitterNode(speed: -32, lifetime:  UIScreen.main.bounds.size.height / 10, scale: 0.14, birthRate: 2, color: SKColor.gray, index: starfieldNode.position.x)
        emitterNode.zPosition = -10
        starfieldNode.addChild(emitterNode)
        
        emitterNode = starfieldEmitterNode(speed: -20, lifetime:  UIScreen.main.bounds.size.height / 5, scale: 0.1, birthRate: 5, color: SKColor.darkGray, index: starfieldNode.position.x )
        starfieldNode.addChild(emitterNode)
    }
}
