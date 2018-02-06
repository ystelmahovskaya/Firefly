//
//  BaseGameScene.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-29.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import SpriteKit
class BaseGameScene: ParentScene {
    
    
    fileprivate  var player: PlayerNode!
    internal var cameraNode: SKCameraNode?
    var backgroundMusik: SKAudioNode!
    
    var increment : CGFloat = 0
    fileprivate  let hud = HUD()
    fileprivate  var score : Int = 0 {
        didSet{
            if(score > 5){
//                print("lvl2")
//                let transition  = SKTransition.crossFade(withDuration: 1.0)
//                let lvl2 = GameSceneLvl2(size: CGSize(width: size.width, height: size.height))
//                lvl2.scaleMode = .aspectFill
//                self.scene?.isPaused = true
//                sceneManager.gameScene = lvl2
//                self.scene!.view?.presentScene(lvl2, transition: transition)
            }
        }
    }
    fileprivate var lives = 3 {
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
        
        gameSettings.loadGameSettings()
        if gameSettings.isMusic && backgroundMusik == nil{
            //        to play music need to check if file exists
            if let musicURL = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3"){
                backgroundMusik = SKAudioNode(url: musicURL)
                addChild(backgroundMusik)
            }
        }
        
        self.scene?.isPaused = false
        
        
        //        checking if scene was created and saved to manager
        guard sceneManager.gameScene == nil else { return }
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        //saving current scene to scene manager to call it from pause
        sceneManager.gameScene = self
        
        
        
        
        self.player.performFly()
        // let starNode = createStarLayers()
        
        //   starNode.removeFromParent()
        cameraNode = SKCameraNode()
        cameraNode?.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        // cameraNode?.addChild(starNode)
        // addChild(starNode)
        //   cameraNode?.setScale(10)
        self.camera = cameraNode
        addChild(cameraNode!)
        hud.removeFromParent()
        
        cameraNode?.addChild(hud)
        hud.configureUI(screenSize: self.frame)
        
        
        
        //    spawnPlanet()
        createStarLayers(index: 0)
        createStarLayers(index: 1)
        createStarLayers(index: 2)
        createStarLayers(index: -1)
        createStarLayers(index: -2)
        spawnEnemies()
        
    }
    override func update(_ currentTime: TimeInterval) {
//        super.update(currentTime)
//        let position =  player.position.x
//        let boundsUp = UIScreen.main.bounds.size.width * (self.increment+1)
//        let boundsLow = UIScreen.main.bounds.size.width * self.increment
//
//
//        switch position {
//
//        case let x where x > boundsUp:
//            self.increment+=1
//            print(self.increment)
//            createStarLayers(index:increment+1)
//            break
//        case let x where x < boundsLow:
//            self.increment-=1
//            print(self.increment)
//            createStarLayers(index:increment-1)
//            break
//
//        default:
//            break
//        }
//
//
//
//        if let camera = cameraNode, let pl = player {
//
//            camera.position.x = pl.position.x
//
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "pause"{
            let transition  = SKTransition.crossFade(withDuration: 1.0)
            let pauseScene = PauseScene(size: CGSize(width: size.width, height: size.height))
            pauseScene.scaleMode = .aspectFill
            self.scene?.isPaused = true
            sceneManager.gameScene = self
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        }else{
            playerFire()
        }
        
    }
    
    
    
    
    override init(size: CGSize) {
        super.init(size: CGSize(width: size.width, height: size.height))
        player = PlayerNode.populate(at: CGPoint(x: self.frame.width/2, y: 50))
        self.addChild(player)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didSimulatePhysics() {
        
        player.checkPosition()
        //<#UnsafeMutablePointer<ObjCBool>#> flag true or false (kursor)
        //cleening nodes out of scene
        //        enumerateChildNodes(withName: "sprite") { (node, stop) in
        //            if node.position.y <= -100 {
        //                node.removeFromParent()
        //                //                if node .isKind(of: PowerUp.self){
        //                //                print("pa removed")
        //                //                }
        //            }
        //        }
        enumerateChildNodes(withName: "shotSprite") { (node, stop) in
            if node.position.y >= self.size.height+20 {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "enemyShotSprite") { (node, stop) in
            if node.position.y <= -50 {
                node.removeFromParent()
            }
        }
        //        enumerateChildNodes(withName: "greenPowerUp") { (node, stop) in
        //            if node.position.y <= -100 {
        //                node.removeFromParent()
        //            }
        //        }
        enumerateChildNodes(withName: "sprite") { (node, stop) in
            if node.position.y <= -50 {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "starfieldNode") { (node, stop) in
            
            //            if  node.position.x < UIScreen.main.bounds.size.width * self.increment-3 {
            //                print("starfieldNode removed\(node.position.x)")
            //                node.removeFromParent()
            //            }
        }
    }
    
    fileprivate func spawnPlanet(){
        let spawnAction = SKAction.run { [unowned self] in
            let planet = PlanetWhite()
            let randomX = arc4random_uniform( UInt32(self.frame.width) )
            
            
            planet.position = CGPoint(x: CGFloat((self.frame.width * self.increment) + CGFloat(randomX)), y: self.size.height+100)
            planet.startMovement()
            self.addChild(planet)
        }
        let randomTimeSpawn = Double(arc4random_uniform(11) + 10)
        
        let waitAction = SKAction.wait(forDuration: randomTimeSpawn)
        self.run(SKAction.repeatForever( SKAction.sequence([spawnAction,waitAction])))
        
    }
    
    
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
        // let correctedIndex = index != 0 ? index: 1
        // emitterNode.position = CGPoint(x: UIScreen.main.bounds.minX * index , y: self.frame.maxY)
        
        print("starfieldEmitterNode created at position \(emitterNode.position.x)")
        emitterNode.particlePositionRange = CGVector(dx: frame.maxX , dy: 0)
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
    
    func createStarLayers(index: CGFloat) {
        //A layer of a star field
        let starfieldNode = SKNode()
        starfieldNode.position = CGPoint(x: self.frame.maxX * index , y: self.frame.maxY)
        print("starfieldNode created at position \(starfieldNode.position.x)")
        starfieldNode.name = "starfieldNode"
        starfieldNode.addChild(starfieldEmitterNode(speed: -48, lifetime: size.height / 23, scale: 0.2, birthRate: 1, color: SKColor.lightGray, index: starfieldNode.position.x))
        addChild(starfieldNode)
        
        //A second layer of stars
        var emitterNode = starfieldEmitterNode(speed: -32, lifetime: size.height / 10, scale: 0.14, birthRate: 2, color: SKColor.gray, index: starfieldNode.position.x)
        emitterNode.zPosition = -10
        starfieldNode.addChild(emitterNode)
        
        //A third layer
        emitterNode = starfieldEmitterNode(speed: -20, lifetime: size.height / 5, scale: 0.1, birthRate: 5, color: SKColor.darkGray, index: starfieldNode.position.x )
        starfieldNode.addChild(emitterNode)
        
    }
    
    fileprivate func playerFire(){
        let shot = GreenShot()
        shot.position = self.player.position
        shot.startMovement()
        self.addChild(shot)
    }
    
    fileprivate func spawnEnemies(){
        let waitAction = SKAction.wait(forDuration: 3.0)
        let spawnSpiralAction = SKAction.run { [unowned self] in
            self.spawnGroupOfEnemies()
        }
        self.run(SKAction.repeatForever(SKAction.sequence([waitAction,spawnSpiralAction])))
        
    }
    
    fileprivate func spawnGroupOfEnemies(){
        let enemyTextureAtlas1 = Assets.shared.enemy_1Atlas
        let enemyTextureAtlas2 = Assets.shared.enemy_2Atlas
        SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1,enemyTextureAtlas2]) { [unowned self] in
            
            let randomNumber = Int(arc4random_uniform(2))
            let arrayOfAtlases = [enemyTextureAtlas1, enemyTextureAtlas2]
            let textureAtlas = arrayOfAtlases[randomNumber]
            
            let waitAction = SKAction.wait(forDuration: 1.0)
            let spawnEnemy = SKAction.run({
                let textureNames = textureAtlas.textureNames.sorted()
                let texture = textureAtlas.textureNamed(textureNames[0])
                let enemy = Enemy(enemyTexture: texture)
                enemy.position = CGPoint(x: self.size.width/2, y: self.size.height+50)
                enemy.setScale(0.3)
                self.addChild(enemy)
                enemy.flySpiral()
            })
            let spawnAction = SKAction.sequence([waitAction,spawnEnemy])
            let repeatAction = SKAction.repeat(spawnAction, count: 3)
            self.run(repeatAction)
        }
        
    }
}


extension BaseGameScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion")
        let contactPoint = contact.contactPoint
        explosion?.position = contactPoint
        explosion?.zPosition = 25
        let waitForExplosionAction = SKAction.wait(forDuration: 2)
        
        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        
        switch contactCategory {
        case [.enemy,.player]:print("player vs enemy")
        if contact.bodyA.node?.name=="sprite"{
            //            check if colision had happened
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
            
        case [.enemy,.shot]:print("shot vs enemy")
        if  contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
            if gameSettings.isSound == true{
                self.run(SKAction.playSoundFileNamed("laser4", waitForCompletion: false))
            }
            score+=5
            hud.score=score
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            addChild(explosion!)
            self.run(waitForExplosionAction, completion: {
                explosion?.removeFromParent()
            })
            }
            
        default:
            preconditionFailure("unable to detect collision category")
        }
    }
    
    
    
}


