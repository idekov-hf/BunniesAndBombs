//
//  MainMenu.swift
//  Game
//
//  Created by Iavor Dekov on 7/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class MainScene: CCNode {
    
    weak var gameNameLabel: CCLabelTTF!
    weak var playButton: CCButton!

    func didLoadFromCCB() {
        
    }
    
    func play() {
        animationManager.runAnimationsForSequenceNamed("ToGameplay")
    }
    
    func switchScene() {
        var gameplay = CCBReader.load("Gameplay") as! Gameplay
        var scene = CCScene()
        scene.addChild(gameplay)
//        var transition = CCTransition(moveInWithDirection: .Down, duration: 0.2)
        CCDirector.sharedDirector().presentScene(scene)
    }
    
}