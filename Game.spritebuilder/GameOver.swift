//
//  GameOver.swift
//  Game
//
//  Created by Iavor Dekov on 7/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class GameOver: CCNode {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    weak var scoreLabel: CCLabelTTF!
    weak var bestScore: CCLabelTTF!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    
    func didLoadFromCCB() {
        var highscore = defaults.integerForKey("highscore")
        if score > highscore {
            defaults.setInteger(score, forKey: "highscore")
        }
    }
    
    func restart () {
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(mainScene)
    }
    
}