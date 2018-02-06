//
//  PlayerNode.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-17.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation

import SpriteKit
import GameKit
import CoreMotion

class PlayerNode: SKSpriteNode {
    
    
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    var yAcceleration: CGFloat = 0
    let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    
    var leftTextureArrayAnimation = [SKTexture]()
    var rightTextureArrayAnimation = [SKTexture]()
    var forwardTextureArrayAnimation = [SKTexture]()
    var moveDirection: TurnDirection = .none
    var stillTurning = false
    let animationSpriteStrides = [(6,1,-1), (6,11,1), (6,6,1)]
    
    /**
     placing and configuration of default properties of the player node
     
     - parameter point: point on the scene where player is supposed to be placed
     - returns: PlayerNode
     */
    static func populate (at point: CGPoint) -> PlayerNode {
        
        let playerShipTexture = Assets.shared.playerAtlas.textureNamed("lightfighter0006")
        let playerShip = PlayerNode(texture: playerShipTexture)
        playerShip.setScale(0.2)
        playerShip.position = point
        playerShip.zPosition = 40
        playerShip.physicsBody = SKPhysicsBody(texture: playerShipTexture, alphaThreshold: 0.5, size: playerShip.size)
        
        playerShip.physicsBody?.isDynamic = false
        playerShip.physicsBody?.categoryBitMask = BitMaskCategory.player.rawValue
        playerShip.physicsBody?.collisionBitMask = BitMaskCategory.enemy.rawValue | BitMaskCategory.powerUp.rawValue
        playerShip.physicsBody?.contactTestBitMask = BitMaskCategory.enemy.rawValue | BitMaskCategory.powerUp.rawValue
        
        return playerShip
    }
    
    /**
     - Configurating movement of the player dependen on accelerometer value.
     - Adjusting of players y position to prevent movement out of UI screen's bounds
     
     */
    func checkPosition(){
        
        self.position.x += xAcceleration * 20
        self.position.y += yAcceleration * 15
        
        if (self.position.y < 50){
            self.position.y = 50
        } else if (self.position.y > 200){
            self.position.y = 200
        }
        
        
    }
    
    /**
     PlayerNode's movement on the scene (x,y axis) using data from accelerometer CMMotionManager is used
     
     */
    func performFly() {
        shipAnimationFillArray()
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in //[unowned self] 
            if let data = data {
                let acceleration = data.acceleration
                self.xAcceleration = CGFloat(acceleration.y) * 0.7 + self.xAcceleration * 0.3
                self.yAcceleration = -CGFloat(acceleration.x) * 0.7 - self.yAcceleration * 0.3
                
            }
        }
        
        let shipWaitAction = SKAction.wait(forDuration: 1.0)
        let shipDirectionCheckAction = SKAction.run { [unowned self] in
            self.movementDirectionCheck()
        }
        
        let shipSequence = SKAction.sequence([shipWaitAction, shipDirectionCheckAction ])
        let shipSequenceForever = SKAction.repeatForever(shipSequence)
        self.run(shipSequenceForever)
    }
    
    /**
     Configurating movement of the player dependen on accelerometer value.
     
    - parameter _stride:  stride (Int,Int,Int) stride.0 start image number in file name
     _stride.1 is the last image number in file name
     _stride.2 is a step to iterate through the images
     
     - Parameter callback: The callback called after preloading of textures.
     - Parameter array: SKTextures Array.
     */
    func preloadArray(_stride: (Int,Int,Int), callback: @escaping(_ array: [SKTexture])-> ()){
        var array = [SKTexture]()
        for i in stride(from: _stride.0, to: _stride.1, by: _stride.2){
            let number = String(format: "%02d", i)
            let texture = SKTexture(imageNamed: "lightfighter00\(number)")
            array.append(texture)
        }
        SKTexture.preload(array){
            callback(array)
        }
    }
    
    /**
      Configurating movement of the player dependen on accelerometer value. Preloading arrays of textures for turning and forvard movement
     */
    func shipAnimationFillArray(){
        SKTextureAtlas.preloadTextureAtlases([SKTextureAtlas(named: "SpaceFighterImages")]) {
            self.preloadArray(_stride: self.animationSpriteStrides[0], callback: { (array) in
                self.leftTextureArrayAnimation = array
            })
            self.preloadArray(_stride: self.animationSpriteStrides[1], callback: { (array) in
                self.rightTextureArrayAnimation = array
            })
            
            self.forwardTextureArrayAnimation = {
                var array = [SKTexture]()
                
                let texture = SKTexture(imageNamed: "lightfighter0006")
                array.append(texture)
                
                SKTexture.preload(array, withCompletionHandler: {
                    print("done")
                })
                return array
            }()
            
            
        }
        
    }
    
    /**
     Checks changing of turn direction based on accelerometer's data uses for animation of ship's turns
     */
    func movementDirectionCheck(){
        
        if xAcceleration > 0.02, moveDirection != .right , stillTurning==false { //turn right
            stillTurning = true
            moveDirection = .right
            turnShip(direction: .right)
        } else if xAcceleration < -0.02, moveDirection != .left , stillTurning==false {
            stillTurning = true
            moveDirection = .left
            turnShip(direction: .left)
        } else if stillTurning == false{
            turnShip(direction: .none)
        }
    }
    
    /**
     Animating players turns based on direction with SKAction class functions
     
      - parameter direction: TurnDirection: enum value of possible players movements
     
     */
    
     func turnShip(direction: TurnDirection){
        var array = [SKTexture]()
        if direction == .right{
            array = rightTextureArrayAnimation
        } else if direction == .left{
            array = leftTextureArrayAnimation
        } else {
            array = forwardTextureArrayAnimation
        }
        
        let forwardAction = SKAction.animate(with: array, timePerFrame: 0.1, resize: true, restore: false)
        let backwardAction = SKAction.animate(with: array.reversed(), timePerFrame: 0.1, resize: true, restore: false)
        
        let sequenceAction = SKAction.sequence([forwardAction,backwardAction])
        self.run(sequenceAction){[unowned self] in
            self.stillTurning = false
        }
    }
    /**
    Players responce to collision with powerUp, changed color to green 5 times
     
     */
    func greenPowerUp(){
        let colorAction = SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.2)
        let unColorAction = SKAction.colorize(with: .green, colorBlendFactor: 0.0, duration: 0.2)
        let sequenceAction = SKAction.sequence([colorAction, unColorAction])
        let repeatAcrion = SKAction.repeat(sequenceAction, count: 5)
        self.run(repeatAcrion)
    }
    /**
     Players responce to collision with powerUp, changed color to blue 5 times
     
     */
    func bluePowerUp(){
        let colorAction = SKAction.colorize(with: .blue, colorBlendFactor: 1.0, duration: 0.2)
        let unColorAction = SKAction.colorize(with: .blue, colorBlendFactor: 0.0, duration: 0.2)
        let sequenceAction = SKAction.sequence([colorAction, unColorAction])
        let repeatAcrion = SKAction.repeat(sequenceAction, count: 5)
        self.run(repeatAcrion)
    }
}
enum TurnDirection {
    case left
    case right
    case none
    
}
