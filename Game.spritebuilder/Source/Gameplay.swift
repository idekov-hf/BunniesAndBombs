import Foundation

enum Side {
    case Left, Right
}

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    // SpriteBuilder code connections
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var leftSpawn: CCNode!
    weak var rightSpawn: CCNode!
    weak var scoreLabel: CCLabelTTF!
    weak var character: Character!
    weak var mainMenu: CCNode!
    
    // Variables
    var screenWidth = CCDirector.sharedDirector().viewSize().width
    var screenHeight = CCDirector.sharedDirector().viewSize().height
    var enemyArray = [Enemy]()
    //    var firstEnemyYPos = CGFloat(0.278) * CCDirector.sharedDirector().viewSize().height
    var firstEnemyYPos = CGFloat(352)
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    
    var fallInterval: Double = 0.5

    
    // code is run when the class is loaded
    func didLoadFromCCB(){
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
        gameStart()
        
        //        gamePhysicsNode.debugDraw = true
    }
    
    func gameStart() {
        setupGestures()
        sendWave(5)
        schedule("moveEnemiesDown", interval: fallInterval)
    }
    
    func playButton() {
//        println("Play button was pressed")
        animationManager.runAnimationsForSequenceNamed("GamePlay")
    }
    
    func sendWave(numberOfEnemies: Int){
        for i in 0..<numberOfEnemies {
            let enemy = CCBReader.load("Enemy", owner: self) as! Enemy
            enemy.position.y = firstEnemyYPos + (CGFloat(i) * CGFloat(96))
            enemyArray.append(enemy)
            gamePhysicsNode.addChild(enemy)
        }
    }
    
    func moveEnemiesDown() {
        for enemy in enemyArray {
            enemy.moveDown()
        }
    }
    
    override func update(delta: CCTime) {
        
    }
    
    // Collisions
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, enemy: CCNode!, ground: CCNode!) -> ObjCBool {
        println("Game Over")
        removeSwipeGestures()
        loadGameOverScene()
        return true
    }
    
    func loadGameOverScene() {
        
        // highscore code
        let defaults = NSUserDefaults.standardUserDefaults()
        var highscore = defaults.integerForKey("highscore")
        if score > highscore {
            defaults.setInteger(score, forKey: "highscore")
        }
        
        // load game over scene
        var gameOverScene = CCBReader.load("GameOver") as! GameOver
        
        // set current score
        gameOverScene.score = score
        
        // set high score
        var newHighscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        gameOverScene.bestScore.string = "\(newHighscore)"
        
        // load game over scene with correct score information
        var scene = CCScene()
        scene.addChild(gameOverScene)
        var transition = CCTransition(moveInWithDirection: .Down, duration: 0.25)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func setupGestures() {
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        swipeLeft.direction = .Left
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeLeft)
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        swipeRight.direction = .Right
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeRight)
    }
    
    func swipeLeft() {
//        println("Left swipe!")
        // check to see if the enemy is on the left side of the character
        // if so, remove it from the scene
        var enemyXPos = enemyArray[0].position.x
        var enemyYPos = enemyArray[0].position.y
        character.flipX = true
        character.animationManager.runAnimationsForSequenceNamed("Punch")
        if enemyYPos < 170 && enemyYPos >= 150 && enemyXPos < screenWidth / 2 {
            
            increaseScore()
        }
        
    }
    
    func swipeRight() {
//        println("Right swipe!")
        var enemyXPos = enemyArray[0].position.x
        var enemyYPos = enemyArray[0].position.y
        character.flipX = false
        character.animationManager.runAnimationsForSequenceNamed("Punch")
        if enemyYPos < 170 && enemyYPos >= 150 && enemyXPos > screenWidth / 2 {
            increaseScore()
        }
        
    }
    
    func increaseScore() {
        //        removeFirstEnemy()
        score += 1
        if score % 5 == 0 {
            increaseInterval()
        }
        
        enemyArray[0].animationManager.runAnimationsForSequenceNamed("Fly\(enemyArray[0].spawnSide)")
//        var removedEnemy = self.enemyArray.removeAtIndex(0)
//        var remove = CCActionCallBlock(block: {self.removeThisEnemy(removedEnemy)})
//        runAction(CCActionSequence(array: [CCActionDelay(duration: 0.5),remove]))
    }
    
//    func removeThisEnemy(enemy:Enemy) {
    func removeThisEnemy() {
//        gamePhysicsNode.removeChild(enemy)
        enemyArray[0].physicsBody.collisionMask = []
        gamePhysicsNode.removeChild(enemyArray[0])
        enemyArray.removeAtIndex(0)
        spawnNewEnemy()
    }
    
    func spawnNewEnemy() {
        let newEnemy = CCBReader.load("Enemy", owner: self) as! Enemy
        newEnemy.position.y = CGFloat(640)
        enemyArray.append(newEnemy)
        gamePhysicsNode.addChild(newEnemy)
        //        enemyArray[0].position.y = 608
    }
    
    func increaseInterval(){
        unschedule("moveEnemiesDown")
        fallInterval = fallInterval * 0.95
        schedule("moveEnemiesDown", interval: fallInterval)
    }
    
    func removeSwipeGestures() {
        var view = CCDirector.sharedDirector().view
        for recognizer in view.gestureRecognizers as! [UIGestureRecognizer] {
            view.removeGestureRecognizer(recognizer)
        }
    }
}
