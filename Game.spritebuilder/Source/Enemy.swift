//
//  Enemy.swift
//  Game
//
//  Created by Iavor Dekov on 7/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Enemy: CCSprite {
    
    var moveSpeed : CGFloat = 80
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
    
    func didLoadFromCCB(){
        scale = 3.0
//        hasBeenSwiped = false
        randomSide = Int(arc4random_uniform(2))
        position.x = xSpawnCoord
    }
    
    
    
    func setInterval(interval: Double){
        schedule("moveDown", interval: interval)
    }
    
    func moveDown(){
        position.y -= 96
//        println(position.y)
    }
}
