//
//  TransitionScene.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-02-02.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation

import SpriteKit
import GameplayKit

class TransitionScene: ParentScene, BackgroundHelper {
    
    var gate: SKSpriteNode?
    var image: ButtonNode?
    var level = 1
    
    init(size: CGSize, level: Int) {
        super.init(size: size)
        self.level = level
        if(level != 4){
            self.setHeader(withName: "Level \(level) ", andBackground: "header_background")
            self.gate = SKSpriteNode(texture: getTextureFrom(atlas: Assets.shared.portal))
            self.gate?.setScale(0.8)
            self.gate?.zPosition = 25
            self.gate?.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 30)
            self.addChild(gate!)
            
            self.image = ButtonNode(titled: nil, backgroundName: "lightfighter0006")
            image?.position = CGPoint(x: -20, y: -20)
            image?.setScale(0.15)
            image?.zRotation=30
            image?.zPosition=30
        } else {
            self.setHeader(withName: "You win", andBackground: "header_background")
            self.image = ButtonNode(titled: nil, backgroundName: "lightfighter0006")
            image?.position = CGPoint(x:self.size.width/2, y: self.size.height/2 - 30)
            image?.setScale(0.15)
            image?.zPosition=30
        }
        self.addChild(image!)
    }
    
    override func didMove(to view: SKView) {
        let shine : SKEmitterNode = SKEmitterNode(fileNamed: "BackgroundParticles")!
        let point = CGPoint(x: self.size.width/2, y: self.size.height/2)
        shine.position = point
        shine.zPosition = 0
        self.addChild(shine)
        createStarLayers(index: 0, scene: self)
        createStarLayers(index: 1, scene: self)
        
        animateShip(level: level)
        
    }
    
    /**
    Changes z position of ship to dreate visual effect
     */
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if ((image?.position.x)! > self.size.width/2){
            image?.zPosition = 24
        }
    }
    /**
    Animate ship image and call thansition function when animation is finished
     
     - parameter level:  number of the level
     */
    func animateShip(level:Int){
        let move:SKAction?
        if (level != 4){
            playMusic(filename: "airstrike")
            move = SKAction.moveBy(x: self.frame.width + 100, y: self.frame.height - 20, duration: 3)
        } else {
            playMusic(filename: "ywwowoo")
            move = SKAction.wait(forDuration: 5)
        }
        
        image?.run(move!, completion: { [unowned self]  in
            self.run(self.transitionToLvl(lvlnr: level))
        })
    }
    
    /**
     Creates action which loads the new scene depending on the level number
     
     - parameter lvlnr:  number of the level
     - returns: SKAction
     */
    func transitionToLvl (lvlnr:Int) -> SKAction {
        
        let transitionAction = SKAction.run { [unowned self] in
            
            let transition  = SKTransition.crossFade(withDuration: 1.0)
            var lvl:ParentScene!
            switch lvlnr {
            case 2:
                lvl = GameSceneLvl2(size: CGSize(width: self.size.width, height: self.size.height))
            case 3:
                lvl = GameSceneLvl3(size: CGSize(width: self.size.width, height: self.size.height))
            default:
                
                self.gameSettings.saveScores()
                lvl = GameOverScene(size: self.size)
                
            }
            lvl?.scaleMode = .aspectFill
            self.sceneManager.gameScene = lvl
            self.scene!.view?.presentScene(lvl, transition: transition)
        }
        return transitionAction
        
    }
    /**
     Play background music if music is on
     
     - parameter filename:  name of music file
     */
    func playMusic(filename: String){
        if gameSettings.isMusic == true{
            self.run(SKAction.playSoundFileNamed("filename", waitForCompletion: false))
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
