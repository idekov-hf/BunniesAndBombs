import Foundation

enum Side {
    case Left, Right
}

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    // SpriteBuilder code connections
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var leftSpawn: CCNode!
    weak var rightSpawn: CCNode!
    weak var scoreLabel: CCLabelTTF!
    weak var character: Character!
    
    // Variables
    var screenWidth = CCDirector.sharedDirector().viewSize().width
    var screenHeight = CCDirector.sharedDirector().viewSize().height
    var enemyArray = [Enemy]()
//    var firstEnemyYPos = CGFloat(0.278) * CCDirector.sharedDirector().viewSize().height
    var firstEnemyYPos = CGFloat(192)
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    
    var fallInterval: Double = 0.5
    var fallSpeed: CGFloat = 80
    
    // code is run when the class is loaded
    func didLoadFromCCB(){
        userInteractionEnabled = true
        setupGestures()
        gamePhysicsNode.collisionDelegate = self
        sendWave(5)
        schedule("moveEnemiesDown", interval: fallInterval)
        
//        gamePhysicsNode.debugDraw = true
    }
    
    override func onEnter() {
        super.onEnter()
    }
    
    func sendWave(numberOfEnemies: Int){
        for i in 0..<numberOfEnemies {
            let enemy = CCBReader.load("Enemy") as! Enemy
            enemy.position.y = firstEnemyYPos + (CGFloat(i) * CGFloat(80))
            enemyArray.append(enemy)
            gamePhysicsNode.addChild(enemy)
        }
    }
    
    func moveEnemiesDown() {
        for enemy in enemyArray {
//            enemy.position.y -= fallSpeed
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
        CCDirector.sharedDirector().presentScene(scene)
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
        println("Left swipe!")
        // check to see if the enemy is on the left side of the character
        // if so, remove it from the scene
        var enemyXPos = enemyArray[0].position.x
        var enemyYPos = enemyArray[0].position.y
        character.flipX = true
        if enemyYPos < 160 && enemyYPos >= 96 && enemyXPos < screenWidth / 2 {
            increaseScore()
        }
        
    }
    
    func swipeRight() {
        println("Right swipe!")
        var enemyXPos = enemyArray[0].position.x
        var enemyYPos = enemyArray[0].position.y
        character.flipX = false
        character.animationManager.runAnimationsForSequenceNamed("punch")
        if enemyYPos < 160 && enemyYPos >= 96 && enemyXPos > screenWidth / 2 {
            increaseScore()
        }
        
    }
    
    func increaseScore() {
        removeFirstEnemy()
        score += 1
        if score % 5 == 0 {
            increaseInterval()
        }
    }
    
    func increaseInterval(){
        unschedule("moveEnemiesDown")
        fallInterval = fallInterval * 0.95
        schedule("moveEnemiesDown", interval: fallInterval)
    }
    
    func removeFirstEnemy() {
        gamePhysicsNode.removeChild(enemyArray[0])
        enemyArray.removeAtIndex(0)
        let newEnemy = CCBReader.load("Enemy") as! Enemy
        newEnemy.position.y = CGFloat(528)
        enemyArray.append(newEnemy)
        gamePhysicsNode.addChild(newEnemy)
//        enemyArray[0].position.y = 608
    }
    
    func removeSwipeGestures() {
        var view = CCDirector.sharedDirector().view
        for recognizer in view.gestureRecognizers as! [UIGestureRecognizer] {
            view.removeGestureRecognizer(recognizer)
        }
    }
}
