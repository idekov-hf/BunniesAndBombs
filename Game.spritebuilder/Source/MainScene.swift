import Foundation

enum Side {
    case Left, Right
}

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    // SpriteBuilder code connections
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var enemyNode: CCNode!
    weak var scoreLabel: CCLabelTTF!
    weak var character: Character!
    // game over member variables
    weak var gameOverScoreLabel: CCLabelTTF!
    weak var bestScore: CCLabelTTF!
    weak var tutorialBomb: Bomb!
    weak var hand: CCSprite!
    
    // Variables
    var screenWidth = CCDirector.sharedDirector().viewSize().width
    var screenHeight = CCDirector.sharedDirector().viewSize().height
    var spriteArray: [FallingSprite] = []
    //    var firstEnemyYPos = CGFloat(0.278) * CCDirector.sharedDirector().viewSize().height
    var firstEnemyYPos = CGFloat(352)
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
            if score % 5 == 0 && scrollSpeed < 350 {
                scrollSpeed += 10
            }
        }
    }
    var fallInterval: Double = 0.5
    var scrollSpeed: CGFloat = 140
    var bunnyWasHit: Bool = false
    var tutorial: Bool = true
    var gameOver: Bool = false
    
    // code is run when the class is loaded
    func didLoadFromCCB(){
        gamePhysicsNode.collisionDelegate = self
        animationManager.runAnimationsForSequenceNamed("MainMenu")
//        gamePhysicsNode.debugDraw = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if tutorial == true {
            if touch.locationInWorld().x > CCDirector.sharedDirector().viewSize().width / 2 {
                character.animationManager.runAnimationsForSequenceNamed("PunchRight")
                animationManager.runAnimationsForSequenceNamed("ToGameplayFromTutorial")   
            }
        }
        else {
            if spriteArray.count > 0 {
                if touch.locationInWorld().x < CCDirector.sharedDirector().viewSize().width / 2 {
                    checkForEnemy("Left")
                }
                else {
                    checkForEnemy("Right")
                }
            }
        }
    }
    
    func startGameAfterTutorial() {
        gameStart()
        tutorial = false
    }
    func enableUserInteraction() {
        userInteractionEnabled = true
    }
    
    override func update(delta: CCTime) {
        if tutorial == false && gameOver == false {
            for enemy in spriteArray {
                enemy.position.y = enemy.position.y - scrollSpeed * CGFloat(delta)
            }
        }
    }
    
    // buttons / selectors
    func play() {
        if tutorial == true {
            animationManager.runAnimationsForSequenceNamed("Tutorial")
        } else {
            animationManager.runAnimationsForSequenceNamed("ToGameplay")
        }
    }
    
    func home() {
        character.animationManager.runAnimationsForSequenceNamed("Main")
        animationManager.runAnimationsForSequenceNamed("ToMainMenu")
    }
    
    func restart () {
        character.animationManager.runAnimationsForSequenceNamed("Main")
        animationManager.runAnimationsForSequenceNamed("Restart")
    }
    
    func gameStart() {
        gameOver = false
        scoreLabel.visible = true
        sendWave(5)
    }
    
    func sendWave(numberOfEnemies: Int){
        for i in 0..<numberOfEnemies {
            let bomb = CCBReader.load("Bomb", owner: self) as! Bomb
            bomb.position.y = firstEnemyYPos + (CGFloat(i) * CGFloat(96))
            spriteArray.append(bomb)
            enemyNode.addChild(bomb)
        }
    }
    
    func loadGameOverScene() {
        // highscore code
        let defaults = NSUserDefaults.standardUserDefaults()
        var highscore = defaults.integerForKey("highscore")
        if score > highscore {
            defaults.setInteger(score, forKey: "highscore")
        }
        
        // set high score
        var newHighscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        bestScore.string = "\(newHighscore)"
        gameOverScoreLabel.string = "\(score)"
        
        // reset variabels and remove enemies from the scene
        enemyNode.removeAllChildren()
        spriteArray = []
        scoreLabel.visible = false
        scrollSpeed = 140
        score = 0
        
        // play game over sequence
        if bunnyWasHit == true {
            character.animationManager.runAnimationsForSequenceNamed("GameOver")
            animationManager.runAnimationsForSequenceNamed("GameOver")
        }
        
        bunnyWasHit = false
    }
    
    func checkForEnemy(side: String) {
        character.animationManager.runAnimationsForSequenceNamed("Punch\(side)")
        
        var enemyXPos = spriteArray[0].position.x
        var enemyYPos = spriteArray[0].position.y
        
        if enemyYPos <= 200 && enemyYPos >= 128 && spriteArray[0].spawnSide == side && spriteArray[0].hasBeenSwiped == false {
            if spriteArray[0].spriteType == "Bomb" {
                spriteArray[0].hasBeenSwiped = true
                score += 1
                spriteArray[0].animationManager.runAnimationsForSequenceNamed("Fly\(spriteArray[0].spawnSide)")
            }
            else {
                bunnyWasHit = true
                spriteArray[0].animationManager.runAnimationsForSequenceNamed("Fly\(spriteArray[0].spawnSide)")
            }
        }
    }
    
    func removeThisEnemy() {
        enemyNode.removeChild(spriteArray[0])
        spriteArray.removeAtIndex(0)
        spawnNewEnemy()
    }
    
    func spawnNewEnemy() {
        var randVar  = arc4random_uniform(8)
        if randVar == 5 {
            let newBunny = CCBReader.load("Bunny", owner: self) as! Bunny
            newBunny.position.y = spriteArray.last!.position.y + CGFloat(96)
            spriteArray.append(newBunny)
            enemyNode.addChild(newBunny)
        }
        else {
            let newBomb = CCBReader.load("Bomb", owner: self) as! Bomb
            newBomb.position.y = spriteArray.last!.position.y + CGFloat(96)
            spriteArray.append(newBomb)
            enemyNode.addChild(newBomb)
        }
    }
    
    // Collisions
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, bomb: CCNode!, ground: CCNode!) -> ObjCBool {
        if spriteArray[0].hasBeenSwiped == false {
            gameOver = true
            character.animationManager.runAnimationsForSequenceNamed("GameOver")
            animationManager.runAnimationsForSequenceNamed("\(spriteArray[0].spawnSide)Explosion")
        }
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, bunny: CCNode!, ground: CCNode!) -> ObjCBool {
        score += 1
        enemyNode.removeChild(spriteArray[0])
        spriteArray.removeAtIndex(0)
        spawnNewEnemy()
        return true
    }
}
