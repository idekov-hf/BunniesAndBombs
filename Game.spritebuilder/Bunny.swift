//
//  Bunny.swift
//  Game
//
//  Created by Iavor Dekov on 8/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Bunny: FallingSprite {
    
    weak var bunnySprite: Bunny!
    
    override func update(delta: CCTime) {
        bunnySprite.rotation += 5
    }
    
    override func didLoadFromCCB() {
        super.didLoadFromCCB()
        spriteType = "Bunny"
    }
    
}