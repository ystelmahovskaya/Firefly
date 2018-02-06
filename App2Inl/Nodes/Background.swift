//
//  Background.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-23.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation

import SpriteKit

class Background: SKSpriteNode {
    
    /**
     Create image background
     
     - parameter imageNamed: File name
     - parameter point:  position
     - returns: Background
     */
    static func populateBackground(at point: CGPoint, imageNamed: String)-> Background {
        let background = Background(imageNamed: imageNamed)
        background.position = point  
        return background
    }
}

