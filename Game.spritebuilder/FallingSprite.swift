//
//  GameSprites.swift
//  Game
//
//  Created by Iavor Dekov on 8/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class FallingSprite: CCSprite {
    
    var spriteType: String!
    var width = CCDirector.sharedDirector().viewSize().width
    var xSpawnCoord: CGFloat!
    var spawnSide: String!
    var hasBeenSwiped: Bool = false
    var randomSide: Int! {  
        didSet {
            if randomSide == 0 {
                xSpawnCoord = 0.2 * width
                spawnSide = "Left"
            }
            else {
                xSpawnCoord = 0.8 * width
                spawnSide = "Right"
            }
        }
    }
    
    func didLoadFromCCB() {
        randomSide = Int(arc4random_uniform(2))
        position.x = xSpawnCoord
    }
    
    func moveDown(){
        position.y -= 96
    }
    
}