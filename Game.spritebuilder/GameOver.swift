//
//  GameOver.swift
//  Game
//
//  Created by Iavor Dekov on 7/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class GameOver: CCNode {
    
    weak var scoreLabel: CCLabelTTF!
    weak var bestScore: CCLabelTTF!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }

    
}