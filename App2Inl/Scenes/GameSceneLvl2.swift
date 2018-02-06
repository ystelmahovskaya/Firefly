//
//  GameSceneLvl2.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-29.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import SpriteKit

class GameSceneLvl2: GameScene {
    
    
    
    
    override init(size: CGSize) {
        super.init(size: size)
        score  = gameSettings.currentscore
        hud.score = gameSettings.currentscore
        currentLvl = 2
    }
    
    override func didMove(to view: SKView) {
        self.scene?.isPaused = false
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        sceneManager.gameScene = self
        super.didMove(to: view)
        
        spawnAsteroid(duration: 5)
    }
    
    /**
     Add AsteroidNode every 2 srconds to the scene and start it's movement
     
     - parameter duration: duration of the movement in sec
     
     */
    func spawnAsteroid(duration: TimeInterval){
        let spawnAction = SKAction.run { [unowned self] in
            let asteroid = AsteroidNode()
            let randomX = arc4random_uniform( UInt32(self.frame.width) )
            
            asteroid.position =  CGPoint(x: CGFloat((self.frame.width * self.increment) + CGFloat(randomX)), y: self.size.height + self.smallNodeSpawnDistance)
            asteroid.startMovement(duration: duration)
            asteroid.setScale(0.5)
            self.addChild(asteroid)
            
        }
        
        let waitAction = SKAction.wait(forDuration: 2)
        self.run(SKAction.repeatForever( SKAction.sequence([spawnAction,waitAction])))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
    }
    
}
