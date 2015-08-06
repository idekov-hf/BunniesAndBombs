//
//  Bunny.swift
//  Game
//
//  Created by Iavor Dekov on 8/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Bunny: FallingSprite {
    
    
    override func update(delta: CCTime) {
        rotation += 5
    }
    
    override func didLoadFromCCB() {
        scale = 0.2
        super.didLoadFromCCB()
        spriteType = "Bunny"
    }
    
}