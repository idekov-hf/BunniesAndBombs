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
    
    func restart () {
        var gameplay = CCBReader.load("Gameplay") as! Gameplay
        var scene = CCScene()
        scene.addChild(gameplay)
        var transition = CCTransition(revealWithDirection: .Up, duration: 0.25)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
}