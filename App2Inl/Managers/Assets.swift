//
//  Assets.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-15.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import SpriteKit
/**
Keeping static values atlases
 */
class Assets {

    static let shared = Assets()
    var isLoaded = false
    
    let planetWhiteAtlas = SKTextureAtlas(named: "PlanetWhite")
    let planetBlueAtlas = SKTextureAtlas(named: "PlanetBlue")
    let playerAtlas = SKTextureAtlas(named: "SpaceFighterImages")
    let greenShotAtlas = SKTextureAtlas(named: "GreenShot")
    let redShotAtlas = SKTextureAtlas(named: "RedShot")
    let enemy_1Atlas = SKTextureAtlas(named: "Enemy1")
    let enemy_2Atlas = SKTextureAtlas(named: "Enemy2")
    let enemysmart_Atlas = SKTextureAtlas(named: "SmartEnemy")
    let bluePowerUp = SKTextureAtlas(named: "BluePowerUp")
    let greenPowerUp = SKTextureAtlas(named: "GreenPowerUp")
    let asteroid_1 = SKTextureAtlas(named: "Asteroid1")
    let asteroid_2 = SKTextureAtlas(named: "Asteroid2")
    let asteroid_3 = SKTextureAtlas(named: "Asteroid3")
    let asteroid_4 = SKTextureAtlas(named: "Asteroid4")
    let portal = SKTextureAtlas(named: "Portal")
    let smartShot = SKTextureAtlas(named: "SmartShot")
    
    
    /**
     Load the atlas objects' textures into memory
     */
    func preloadAssets(){
        planetWhiteAtlas.preload {
            
        }
        planetBlueAtlas.preload {
            
        }
        greenShotAtlas.preload {
            
        }
        redShotAtlas.preload {
            
        }
        playerAtlas.preload {
            print("Player")
        }
        enemy_1Atlas.preload {
            print("enemy_1Atlas")
        }
        enemy_2Atlas.preload {
            print("enemy_2Atlas")
        }
        enemysmart_Atlas.preload {
            print("enemysmart_Atlas")
        }
        bluePowerUp.preload {
            print("bluePowerUp")
        }
        greenPowerUp.preload {
            print("GreenPowerUp")
        }
        asteroid_1.preload {
            print("asteroid_1")
        }
        asteroid_2.preload {
            print("asteroid_2")
        }
        asteroid_3.preload {
            print("asteroid_3")
        }
        asteroid_4.preload {
            
        }
        portal.preload {
            
        }
        smartShot.preload {
            
        }
        
    }
}

