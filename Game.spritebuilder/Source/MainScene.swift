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
    
    // Variables
    var screenWidth = CCDirector.sharedDirector().viewSize().width
    var screenHeight = CCDirector.sharedDirector().viewSize().height
    
    var enemyArray = [Enemy]()
    
    //    var firstEnemyYPos = CGFloat(0.278) * CCDirector.sharedDirector().viewSize().height
    var firstEnemyYPos = CGFloat(352)
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
            if score % 5 == 0 && scrollSpeed < 200 {
                scrollSpeed += 10
            }
        }
    }
    
    var fallInterval: Double = 0.5
    
    var scrollSpeed: CGFloat = 120
    
    override func update(delta: CCTime) {
        for enemy in enemyArray {
            enemy.position.y = enemy.position.y - scrollSpeed * CGFloat(delta)
        }
        
        println(scrollSpeed)
    }
    
    // code is run when the class is loaded
    func didLoadFromCCB(){
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
        animationManager.runAnimationsForSequenceNamed("MainMenu")
        //        gamePhysicsNode.debugDraw = true
    }
    
    func play() {
        animationManager.runAnimationsForSequenceNamed("ToGameplay")
    }
    
    func gameStart() {
        scoreLabel.visible = true
        setupSwipeGestures()
        sendWave(5)
//        schedule("moveEnemiesDown", interval: fallInterval)
    }
    
    func sendWave(numberOfEnemies: Int){
        for i in 0..<numberOfEnemies {
            let enemy = CCBReader.load("Enemy", owner: self) as! Enemy
            enemy.position.y = firstEnemyYPos + (CGFloat(i) * CGFloat(96))
            enemyArray.append(enemy)
            enemyNode.addChild(enemy)
        }
    }
    
    func moveEnemiesDown() {
        println(enemyArray.count)
        for enemy in enemyArray {
            enemy.moveDown()
        }
    }
    
    // Collisions
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, enemy: CCNode!, ground: CCNode!) -> ObjCBool {
        if enemyArray[0].hasBeenSwiped == false {
            println("Game Over")
            removeSwipeGestures()
            loadGameOverScene()
        }
        return true
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
        scoreLabel.visible = false
        enemyNode.removeAllChildren()
        enemyArray = [Enemy]()
        scrollSpeed = 110
        score = 0
        
        // play game over sequence
        animationManager.runAnimationsForSequenceNamed("GameOver")
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        if enemyArray.count > 0 {
        
            if touch.locationInWorld().x < CCDirector.sharedDirector().viewSize().width / 2 {
                checkForEnemy("Left")
            }
            else {
                checkForEnemy("Right")
            }
        }
    }
    
    func setupSwipeGestures() {
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        swipeLeft.direction = .Left
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeLeft)
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        swipeRight.direction = .Right
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeRight)
    }
    
    func removeSwipeGestures() {
        var view = CCDirector.sharedDirector().view
        for recognizer in view.gestureRecognizers as! [UIGestureRecognizer] {
            view.removeGestureRecognizer(recognizer)
        }
    }
    
    func swipeLeft() {
        character.flipX = true
        checkForEnemy("Left")
    }
    
    func swipeRight() {
        character.flipX = false
        checkForEnemy("Right")
    }
    
    func checkForEnemy(side: String) {
        character.animationManager.runAnimationsForSequenceNamed("Punch\(side)")
        
        var enemyXPos = enemyArray[0].position.x
        var enemyYPos = enemyArray[0].position.y
        
        if enemyYPos <= 200 && enemyYPos >= 128 && enemyArray[0].spawnSide == side && enemyArray[0].hasBeenSwiped == false {
            character.rightArm.color = CCColor(red: 0, green: 0, blue: 255)
            enemyArray[0].hasBeenSwiped = true
            score += 1
            enemyArray[0].animationManager.runAnimationsForSequenceNamed("Fly\(enemyArray[0].spawnSide)")
        }
    }
    
    func removeThisEnemy() {
        enemyNode.removeChild(enemyArray[0])
        enemyArray.removeAtIndex(0)
        spawnNewEnemy()
    }
    
    func spawnNewEnemy() {
        var randVar  = arc4random_uniform(10)
        if randVar == 5 {
            let bunny = CCBReader.load("Bunny") as! Bunny
            bunny.position.y = enemyArray.last!.position.y + CGFloat(96)
            enemyArray.append(bunny)
            enemyNode.addChild(bunny)
        }
        else {
            let newEnemy = CCBReader.load("Enemy", owner: self) as! Enemy
            newEnemy.position.y = enemyArray.last!.position.y + CGFloat(96)
            enemyArray.append(newEnemy)
            enemyNode.addChild(newEnemy)
        }
    }
    
    func increaseInterval(){
        unschedule("moveEnemiesDown")
        fallInterval = fallInterval * 0.95
        schedule("moveEnemiesDown", interval: fallInterval)
    }
    
    func restart () {
        animationManager.runAnimationsForSequenceNamed("Restart")
    }
}
