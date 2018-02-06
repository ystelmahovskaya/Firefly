//
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-15.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import SpriteKit

class RotatingBaseNode :  SKSpriteNode {
    let rotatingNodeSize : CGFloat = 72
      let scale : CGFloat = 2.5
    let initialSize : CGSize!
    let textureAtlas : SKTextureAtlas!
    var textureNameBeginsWith = ""
    var animationSpriteArray = [SKTexture]()
    
    
    init(textureAtlas: SKTextureAtlas){
        self.textureAtlas = textureAtlas
        initialSize = CGSize(width: rotatingNodeSize, height: rotatingNodeSize)
        let textureName = textureAtlas.textureNames.sorted()[0]
        let texture = textureAtlas.textureNamed(textureName)
        textureNameBeginsWith = String(textureName.characters.dropLast(6))
        super.init(texture: texture, color: .clear, size: initialSize)
        self.setScale(scale)
        self.name = "sprite"
        self.zPosition = 20
        
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
        self.physicsBody?.isDynamic = true
    }
    
    /**
     performs RotatingBaseNode movement trought the scene
     
     - parameter duration:  duration of the movement in sec
     */
    
    func startMovement(duration: TimeInterval){
        performRotation(imageNamed: textureNameBeginsWith)
        let moveForvard = SKAction.moveTo(y: -scale * rotatingNodeSize, duration: duration)
        self.run(moveForvard)
    }
    
    /**
     Animate sprites to create effect of rotation used SKAction
     
     - parameter imageNamed:  substring of the texture name
     - important: numbers in the files names should be sequentiell
     */
      func performRotation(imageNamed: String){
        for i in 1...18{
            let number = String(format: "%02d", i)
            animationSpriteArray.append(SKTexture(imageNamed: imageNamed + number.description))
            
        }
        SKTexture.preload(animationSpriteArray){
            let rotation = SKAction.animate(with: self.animationSpriteArray, timePerFrame: 0.1, resize: true, restore: false)
            let rotationForever = SKAction.repeatForever(rotation)
            self.run(rotationForever)
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

