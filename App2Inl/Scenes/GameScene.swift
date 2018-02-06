//
//  GameScene.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-11.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: ParentScene, BackgroundHelper {
    
    
    var player: PlayerNode!
    
    var cameraNode: SKCameraNode?
    var backgroundMusik: SKAudioNode!
    var currentLvl:Int = 1
    var increment : CGFloat = 0
    var hud: HUD = HUD()
    var score : Int = 0
    let bigNodeSpawnDistance: CGFloat = 100
    let smallNodeSpawnDistance: CGFloat = 50
    
    var lives = 3 {
        didSet{
            switch lives {
            case 3:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = false
            case 2:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = true
            case 1:
                hud.life1.isHidden = false
                hud.life2.isHidden = true
                hud.life3.isHidden = true
            default:
                break
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        checkMusic()
        
        self.scene?.isPaused = false
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        sceneManager.gameScene = self
        self.player.performFly()
    }
    /**
     Move camera to follow player, creating stars background
     */
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        updateLayers(player: player, increment: increment)
        if let camera = cameraNode, let pl = player {
            camera.position.x = pl.position.x
        }
    }
    /**
     Checking user defaults and adding backgroung music if needed
     */
    func checkMusic(){
        gameSettings.loadGameSettings()
        if gameSettings.isMusic {
            if let musicURL = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3"){
                backgroundMusik = SKAudioNode(url: musicURL)
                addChild(backgroundMusik)
            }
        }
    }
    
    /**
     creating background if player moves to non populated area
     
     - parameter player:  PlayerNode
     - parameter increment: Shows how many times player crossed distanse equals to UI screen bounds
     */
    func updateLayers(player:PlayerNode, increment: CGFloat ){
        let position =  player.position.x
        let boundsUp = UIScreen.main.bounds.size.width * (self.increment+1)
        let boundsLow = UIScreen.main.bounds.size.width * self.increment
        
        
        switch position {
            
        case let x where x > boundsUp:
            self.increment+=1
            createStarLayers(index:increment+2, scene: self)
            break
        case let x where x < boundsLow:
            self.increment-=1
            createStarLayers(index:increment-2, scene: self)
            break
        default:
            break
        }
    }
    /**
     Check if touch inside the scene is on the node with name "pause" and thansition to the PauseScene otherwise call playerFire() function
     
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "pause"{
            let transition  = SKTransition.crossFade(withDuration: 1.0)
            let pauseScene = PauseScene(size: CGSize(width: size.width, height: size.height))
            pauseScene.scaleMode = .aspectFill
            self.scene?.isPaused = true
            backgroundMusik?.removeFromParent()
            sceneManager.gameScene = self
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        }else{
            playerFire()
        }
        
    }
    
    
    
    
    
    override init(size: CGSize) {
        super.init(size: CGSize(width: size.width, height: size.height))
        
        cameraNode = SKCameraNode()
        cameraNode?.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        //cameraNode?.setScale(10)
        self.camera = cameraNode
        addChild(cameraNode!)
        player = PlayerNode.populate(at: CGPoint(x: self.frame.width/2, y: 50))
        self.addChild(player)
        cameraNode?.addChild(hud)
        hud.configureUI(screenSize: self.frame)
        
        for index in -2...2 {
            createStarLayers(index: CGFloat(index), scene: self)
        }
        spawnEnemies()
        spawnPlanet(duration: 25)
        spawnPowerUp()
        spawnGate(duration: 20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Remove useless nodes from scene
     */
    override func didSimulatePhysics() {
        let removePointLow: CGFloat = -50
        let removePointHigh: CGFloat = 20
        player.checkPosition()
        
        enumerateChildNodes(withName: "shotSprite") { (node, stop) in
            if node.position.y >= self.size.height+removePointHigh {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "enemyShotSprite") { (node, stop) in
            if node.position.y <= removePointLow {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "greenPowerUp") { (node, stop) in
            if node.position.y <= removePointLow {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "bluePowerUp") { (node, stop) in
            if node.position.y <= removePointLow {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "sprite") { (node, stop) in
            if node.position.y <= removePointLow {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "asteroid") { (node, stop) in
            if node.position.y <= removePointLow {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "starfieldNode") { (node, stop) in
            
            if  (node.position.x < UIScreen.main.bounds.size.width * (self.increment-2) ||  node.position.x > UIScreen.main.bounds.size.width * (self.increment+2)) {
                node.removeFromParent()
            }
        }
    }
    /**
     Add PlanetNode to the scene and start it's movement
     
     - parameter duration: duration of the movement in sec

     */
    func spawnPlanet(duration: TimeInterval){
        let spawnAction = SKAction.run { [unowned self] in
            let planet = PlanetNode()
            let randomX = arc4random_uniform( UInt32(self.frame.width) )
            planet.position = CGPoint(x: CGFloat((self.frame.width * self.increment) + CGFloat(randomX)), y: self.size.height+self.bigNodeSpawnDistance)
            planet.startMovement(duration: duration)
            self.addChild(planet)
        }
        let randomTimeSpawn = Double(arc4random_uniform(11) + 10)
        
        let waitAction = SKAction.wait(forDuration: randomTimeSpawn)
        self.run(SKAction.repeatForever( SKAction.sequence([spawnAction,waitAction])))
        
    }
    
    /**
     Add GateNode to the scene and start it's movement
     
     - parameter duration: duration of the movement in sec
     
     */
    func spawnGate(duration: TimeInterval){
        let spawnAction = SKAction.run { [unowned self] in
            let randomX = arc4random_uniform( UInt32(self.frame.width) )
            let gate = GateNode(texture: self.getTextureFrom(atlas: Assets.shared.portal))
            gate.position = CGPoint(x: CGFloat((self.frame.width * self.increment) + CGFloat(randomX)), y: self.size.height + self.bigNodeSpawnDistance)
            gate.startMovement(duration: duration)
            self.addChild(gate)
        }
        let randomTimeSpawn = Double(arc4random_uniform(20) + 10)
        
        let waitAction = SKAction.wait(forDuration: randomTimeSpawn)
        self.run(SKAction.repeatForever( SKAction.sequence([waitAction,spawnAction])))
        
    }
    /**
     Add BluePowerUp or GreenPowerUp (randomly chooses) to the scene and start it's movement
     */
    func spawnPowerUp(){
        let spawnAction = SKAction.run { [unowned self] in
            let randomNumber = Int(arc4random_uniform(2))
            let powerUp = randomNumber == 1 ? BluePowerUp() : GreenPowerUp()
            let randomX = arc4random_uniform( UInt32(self.frame.width) )
            powerUp.position = CGPoint(x: CGFloat((self.frame.width * self.increment) + CGFloat(randomX)), y: self.size.height + self.smallNodeSpawnDistance)
            powerUp.startMovement()
            self.addChild(powerUp)
        }
        let randomTimeSpawn = Double(arc4random_uniform(5) + 10)
        let waitAction = SKAction.wait(forDuration: randomTimeSpawn)
        self.run(SKAction.repeatForever( SKAction.sequence([spawnAction,waitAction])))
        
    }
    
    /**
    Forever runs sequence spawnGroupOfEnemies and waiting (3 seconds) functions
     */
    func spawnEnemies(){
        let waitAction = SKAction.wait(forDuration: 3.0)
        let spawnSpiralAction = SKAction.run { [unowned self] in
            self.spawnGroupOfEnemies()
        }
        self.run(SKAction.repeatForever(SKAction.sequence([waitAction,spawnSpiralAction])))
        
    }
    
    
    /**
     Add groups of 3 Enemies (randomly chooses atlas) with 1 sec interval between each to the scene and start theirs's movement and shooting
     */
    func spawnGroupOfEnemies(){
        let enemyTextureAtlas1 = Assets.shared.enemy_1Atlas
        let enemyTextureAtlas2 = Assets.shared.enemy_2Atlas
        SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1,enemyTextureAtlas2]) { [unowned self] in
            
            let randomNumber = Int(arc4random_uniform(2))
            let arrayOfAtlases = [enemyTextureAtlas1, enemyTextureAtlas2]
            let textureAtlas = arrayOfAtlases[randomNumber]
            
            let waitAction = SKAction.wait(forDuration: 1.0)
            let spawnEnemy = SKAction.run({
                let enemy = Enemy(enemyTexture: self.getTextureFrom(atlas: textureAtlas))
                let randomX = arc4random_uniform( UInt32(self.frame.width) )
                enemy.position = CGPoint(x: CGFloat((self.frame.width * self.increment) + CGFloat(randomX)), y: self.size.height + self.smallNodeSpawnDistance)
                self.addChild(enemy)
                enemy.enemyShot()
                enemy.flySpiral(x: CGFloat((self.frame.width * self.increment)))
            })
            let spawnAction = SKAction.sequence([waitAction,spawnEnemy])
            let repeatAction = SKAction.repeat(spawnAction, count: 1)
            self.run(repeatAction)
        }
    }
    
    /**
     Add GreenShot instance to scene and animate it's movement
     */
    func playerFire(){
        let shot = GreenShot()
        shot.position = self.player.position
        shot.startMovement()
        self.addChild(shot)
    }
   
    /**
    Transition to Transition Scene
     
     - parameter lvlnr:  number of the level
     */
    func transitionToLvl(lvlnr:Int){
        
        let transitionAction = SKAction.run { [unowned self] in
            
            self.gameSettings.currentscore = self.hud.score
            self.gameSettings.saveGameSettings()
            let transition  = SKTransition.crossFade(withDuration: 0.3)
            let lvl:ParentScene = TransitionScene (size: CGSize(width: self.size.width, height: self.size.height), level: lvlnr)
            lvl.scaleMode = .aspectFill
            self.sceneManager.gameScene = lvl
            self.scene!.view?.presentScene(lvl, transition: transition)
        }
        self.run(transitionAction)
    }
}


extension GameScene: SKPhysicsContactDelegate{
    /**
     Collisions handles
     */
    func didBegin(_ contact: SKPhysicsContact) {
        
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion")
        let contactPoint = contact.contactPoint
        explosion?.position = contactPoint
        explosion?.zPosition = 25
        let waitForExplosionAction = SKAction.wait(forDuration: 2)
        
        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        
        switch contactCategory {
        case [.enemyShot, .player] :print ("player vs enemyshot")
            fallthrough
        case [.enemy,.player]:print("player vs enemy")
        if contact.bodyA.node?.name=="sprite"{
            if  contact.bodyA.node?.parent != nil {
                contact.bodyA.node?.removeFromParent()
                lives-=1
            }
        } else {
            if  contact.bodyB.node?.parent != nil {
                contact.bodyB.node?.removeFromParent()
                lives-=1
            }
        }
        addChild(explosion!)
        self.run(waitForExplosionAction, completion: {
            explosion?.removeFromParent()
        })
        
        if lives == 0 {
            gameSettings.currentscore = hud.score
            gameSettings.saveScores()
            let gameOverScene = GameOverScene(size: self.size)
            gameOverScene.scaleMode = .aspectFill
            
            let transition = SKTransition.doorsCloseVertical(withDuration: 1.0)
            self.scene!.view?.presentScene(gameOverScene, transition: transition)
            
            }
            
        case [.enemyShot, .shot] :print ("player vs enemyshot")
            fallthrough
        case [.enemy,.shot]:print("shot vs enemy")
        if  contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
            if gameSettings.isSound == true{
                self.run(SKAction.playSoundFileNamed("laser4", waitForCompletion: false))
            }
            score+=5
            hud.score=score
            gameSettings.currentscore = score
            gameSettings.saveGameSettings()
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            addChild(explosion!)
            self.run(waitForExplosionAction, completion: {
                explosion?.removeFromParent()
            })
            }
            
            
        case [.powerUp,.player]:print("player vs powerUp")
        if  contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil  {
            if contact.bodyA.node?.name == "bluePowerUp" {
                contact.bodyA.node?.removeFromParent()
                if lives < 3 {
                    lives += 1
                }
                player.bluePowerUp()
                
            } else if contact.bodyB.node?.name == "bluePowerUp" {
                contact.bodyB.node?.removeFromParent()
                if lives < 3 {
                    lives += 1
                }
                player.bluePowerUp()
                
            }
            if contact.bodyA.node?.name == "greenPowerUp" {
                contact.bodyA.node?.removeFromParent()
                lives=3
                player.greenPowerUp()
                
            } else if contact.bodyB.node?.name == "greenPowerUp" {
                contact.bodyB.node?.removeFromParent()
                lives=3
                player.greenPowerUp()
            }
            }
        case [.gate, .player] :print ("player vs gate")
        transitionToLvl(lvlnr: currentLvl + 1)
            
        default:
            preconditionFailure("unable to detect collision category")
        }
    }
}


