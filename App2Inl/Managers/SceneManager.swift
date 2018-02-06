//
//  SceneManager.swift
//  App2Inl
//
//  Created by Yuliia Stelmakhovska on 2018-01-12.
//  Copyright © 2018 Yuliia Stelmakhovska. All rights reserved.
//

import Foundation
/**
Saves reference to the scene instance when scene is paused
 */
class SceneManager{
    static let shared = SceneManager()
    
    var gameScene: ParentScene?
    
}

