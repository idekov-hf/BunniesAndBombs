//
//  Enemy.swift
//  Game
//
//  Created by Iavor Dekov on 7/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Bomb: FallingSprite {
    
    override func didLoadFromCCB(){
        scale = 3.0
        super.didLoadFromCCB()
        spriteType = "Bomb"
    }

}
