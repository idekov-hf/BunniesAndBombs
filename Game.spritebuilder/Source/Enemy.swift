//
//  Enemy.swift
//  Game
//
//  Created by Iavor Dekov on 7/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Enemy: CCSprite {
    
    var moveSpeed : CGFloat = 50
    var width = CCDirector.sharedDirector().viewSize().width
    var xSpawnCoord: CGFloat!
    var randomSide: Int! {
        didSet {
            if randomSide == 0 {
                xSpawnCoord = 0.2 * width
            }
            else {
                xSpawnCoord = 0.8 * width
            }
        }
    }
    
    func didLoadFromCCB(){
        scale = 3.0
        schedule("moveDown", interval: 0.8)
        randomSide = Int(arc4random_uniform(2))
        position.x = xSpawnCoord
    }
    
    
    
    func setInterval(interval: Double){
        schedule("moveDown", interval: interval)
    }
    
    func moveDown(){
        positionInPoints = ccp(positionInPoints.x, positionInPoints.y - moveSpeed)
    }
}
