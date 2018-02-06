//
//  GameSettings.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-12.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
import UIKit

class GameSettings: NSObject {
    
    let ud = UserDefaults.standard
    
    var isMusic = true
    var isSound = true
    
    let musicKey = "music"
    let soundKey = "sound"
    let score = "score"
    
    var highScore: [Int] = []
    var highScoreKey = "highscore"
    var currentscore: Int = 0
    
    
    
    override init() {
        super.init()
        loadGameSettings()
        loadScores()
    }
    
    /**
     Save game settings to user defaults:
     - music
     - sound
     - current score
     */
    func saveGameSettings(){
        ud.set(isMusic, forKey: musicKey)
        ud.set(isSound, forKey: soundKey)
        ud.set(currentscore, forKey: score)
        
    }
    /**
     Loading game settings to user defaults:
     - music
     - sound
     - current score
     */
    func loadGameSettings(){
        guard ud.value(forKey: soundKey) != nil && ud.value(forKey: musicKey) != nil  else { return }
        isMusic = ud.bool(forKey: musicKey)
        isSound = ud.bool(forKey: soundKey)
        currentscore = ud.integer(forKey: score)
        
    }
    /**
     Save currentscore to high score array after game's been over, sort, and save 3 higest to user defaults
     */
    func saveScores(){
        highScore.append(currentscore)
        currentscore = 0
        highScore = Array(highScore.sorted { $0 > $1 }.prefix(3))
        ud.set(highScore, forKey: highScoreKey)
        ud.synchronize()
        
    }
    /**
    loading the score array with the specified key from user defaults
     */
    func loadScores(){
        guard ud.value(forKey: highScoreKey) != nil else { return }
        highScore = ud.array(forKey: highScoreKey) as! [Int]
        
    }
    
}
