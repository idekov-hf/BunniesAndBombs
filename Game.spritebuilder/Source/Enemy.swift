//
//  Enemy.swift
//  Game
//
//  Created by Iavor Dekov on 7/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Enemy: CCSprite {
    
    private var moveSpeed : CGFloat = 50
    
    func didLoadFromCCB(){
        schedule("moveDown", interval: 1)
    }
    
    func setInterval(interval: Double){
        schedule("moveDown", interval: interval)
    }
    
    func moveDown(){
        positionInPoints = ccp(positionInPoints.x, positionInPoints.y - moveSpeed)
    }
}
