//
//  BitMaskCategory.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-26.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import SpriteKit


/**
Keeping static values of bit masks
 */
struct BitMaskCategory: OptionSet {
    let  rawValue: UInt32
    
    init(rawValue: UInt32){
        self.rawValue = rawValue
    }
    static let none = BitMaskCategory(rawValue: 0 << 0)
    static let player = BitMaskCategory(rawValue: 1 << 0)
    static let enemy = BitMaskCategory(rawValue: 1 << 1)
    static let enemyShot = BitMaskCategory(rawValue: 1 << 4)
    static let powerUp = BitMaskCategory(rawValue: 1 << 2)
    static let shot = BitMaskCategory(rawValue: 1 << 3)
    static let gate = BitMaskCategory(rawValue: 1 << 5)
    static let all = BitMaskCategory(rawValue: UInt32.max)
    
    
    
}
extension SKPhysicsBody{
    var category: BitMaskCategory {
        get{
            return BitMaskCategory(rawValue: self.categoryBitMask)
        }
        set (newValue){
            self.categoryBitMask = newValue.rawValue
        }
    }    
}

