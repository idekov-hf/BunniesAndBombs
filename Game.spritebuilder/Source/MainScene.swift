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
    
    // Variables
    var screenWidth = CCDirector.sharedDirector().viewSize().width
    var screenHeight = CCDirector.sharedDirector().viewSize().height
    var enemyArray: [Enemy] = []
    var firstEnemyYPos = CGFloat(0.4) * CCDirector.sharedDirector().viewSize().height
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    
    // code is run when the class is loaded
    func didLoadFromCCB(){
        userInteractionEnabled = true
        setupGestures()
        gamePhysicsNode.collisionDelegate = self
        sendWave(6, interval: 1.0)
//        gamePhysicsNode.debugDraw = true
    }
    
    override func onEnter() {
        super.onEnter()
    }
    
    func sendWave(numberOfEnemies: Int, interval: Double){
//        println(height.dynamicType)
        for i in 0..<numberOfEnemies{
            let enemy = CCBReader.load("Enemy") as! Enemy
            enemy.position.y = firstEnemyYPos + (CGFloat(i) * CGFloat(0.4) * screenHeight)
            enemyArray.append(enemy)
            gamePhysicsNode.addChild(enemy)
        }
    }
    
    override func update(delta: CCTime) {
        
    }
    
    // Collisions
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, enemy: CCNode!, ground: CCNode!) -> ObjCBool {
        println("Game Over")
        let gameOver = CCBReader.loadAsScene("GameOver")
        CCDirector.sharedDirector().presentScene(gameOver)
        return true
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
        if enemyYPos < 100 && enemyYPos > 30 && enemyXPos < screenWidth / 2 {
            removeFirstEnemy()
            score += 1
        }
    }
    
    func swipeRight() {
        println("Right swipe!")
        var enemyXPos = enemyArray[0].position.x
        var enemyYPos = enemyArray[0].position.y
        if enemyYPos < 100 && enemyYPos > 30 && enemyXPos > screenWidth / 2 {
            removeFirstEnemy()
            score += 1
        }
        
    }
    
    func removeFirstEnemy() {
        gamePhysicsNode.removeChild(enemyArray[0])
        enemyArray.removeAtIndex(0)
    }
    
    //gameover check function

    
    //gameover function
    
    
}
