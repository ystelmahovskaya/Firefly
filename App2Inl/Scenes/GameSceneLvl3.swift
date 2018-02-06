//
//  TestScene.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-29.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneLvl3: GameScene {
    
    let trackingAgent = GKAgent2D()
    var seekGoal : GKGoal = GKGoal()
    let stopGoal = GKGoal(toReachTargetSpeed: 0)
    var agentSystem = GKComponentSystem()
    var lastUpdateTime : TimeInterval = 0
    
    override init(size: CGSize) {
        super.init(size: size)
        hud.score = gameSettings.currentscore
        score  = gameSettings.currentscore
        currentLvl = 3
        spawnSmartEnemy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        self.scene?.isPaused = false
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        sceneManager.gameScene = self
        super.didMove(to: view)
        self.trackingAgent.position = vector_float2(Float(player.position.x), Float(player.position.y))
        self.agentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
        self.seekGoal = GKGoal(toSeekAgent: self.trackingAgent)
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        super.update(currentTime)
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        
        let delta = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        self.agentSystem.update(deltaTime: delta)
        self.trackingAgent.position = vector_float2(Float(player.position.x), Float(player.position.y))
    }
    
    /**
     creating background and spawn SmartEnemy if player moves to non populated area
     
     - parameter player:  PlayerNode
     - parameter increment: Shows how many times player crossed distanse equals to UI screen bounds
     */
    override func updateLayers(player: PlayerNode, increment: CGFloat) {
        let position =  player.position.x
        let boundsUp = UIScreen.main.bounds.size.width * (self.increment+1)
        let boundsLow = UIScreen.main.bounds.size.width * self.increment
        
        
        switch position {
            
        case let x where x > boundsUp:
            self.increment+=1
            createStarLayers(index:increment+2, scene: self)
            spawnSmartEnemy()
            break
        case let x where x < boundsLow:
            self.increment-=1
            createStarLayers(index:increment-2, scene: self)
            spawnSmartEnemy()
            break
        default:
            break
        }
    }
    
    /**
     Add SmartEnemyNode to the scene and start it's movement
     */
    func spawnSmartEnemy(){
        let smartEnemyTexture = Assets.shared.enemysmart_Atlas
        
        SKTextureAtlas.preloadTextureAtlases([smartEnemyTexture]) { [unowned self] in
            
            let spawnEnemy = SKAction.run({
                let enemy = SmartEnemyNode(enemyTexture: self.getTextureFrom(atlas: smartEnemyTexture))
                let randomX = arc4random_uniform( UInt32(self.frame.width) )
                enemy.position = CGPoint(x: CGFloat((self.frame.width * self.increment) + CGFloat(randomX)), y: self.size.height + self.smallNodeSpawnDistance)
                self.addChild(enemy)
                
                enemy.flySpiral(x: CGFloat(self.frame.width * self.increment))
                
                
                let waitAction = SKAction.wait(forDuration: 1.0)
                let spawnShot = SKAction.run({
                    let shot : SmartShot = SmartShot(scene: self, radius: Float(40.0), position: CGPoint(x: enemy.position.x, y: enemy.position.y))
                    
                    shot.agent.behavior = GKBehavior()
                    shot.agent.behavior?.setWeight(1, for: self.seekGoal)
                    shot.agent.behavior?.setWeight(0, for: self.stopGoal)
                    self.agentSystem.addComponent(shot.agent)
                    
                })
                let spawnShotAction = SKAction.sequence([waitAction,spawnShot])
                let repeatAction = SKAction.repeat(spawnShotAction, count: 2)
                self.run(repeatAction)
            })
            self.run(spawnEnemy)
            
        }
    }
}
