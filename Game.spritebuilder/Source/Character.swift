//
//  Character.swift
//  Game
//
//  Created by Iavor Dekov on 7/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Character: CCSprite {
    
    weak var leftArm: CCNode!
    weak var rightArm: CCNode!
    
    func didLoadFromCCB() {
        leftArm.zOrder = -1
        rightArm.zOrder = -1
    }
    
}
