import Foundation

enum Side {
    case Left, Right
}

class MainScene: CCNode, CCPhysicsCollisionDelegate {

    // SpriteBuilder code connections
    weak var enemy: Enemy!
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var leftSpawn: CCNode!
    weak var rightSpawn: CCNode!
    
    
    
    // Variables
//    var width = CCDirector.sharedDirector().viewSize().width
    var height = CCDirector.sharedDirector().viewSize().height
    var enemyArray: [CCSprite] = []
//    var xSpawnCoord: CGFloat!
//    var spawnSide: Side! {
//        didSet {
//            if spawnSide == .Left {
//                xSpawnCoord = 0.2 * width
//            }
//            else {
//                xSpawnCoord = 0.8 * width
//            }
//        }
//    }
    
    // code is run when the class is loaded
    func didLoadFromCCB(){
        gamePhysicsNode.collisionDelegate = self
        sendWave(6, interval: 1.0)
    }
    
    override func onEnter() {
        super.onEnter()
    }
    
    func sendWave(numberOfEnemies: Int, interval: Double){
        for i in 0..<numberOfEnemies {
                        
        }
    }
    
    override func update(delta: CCTime) {
        
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, enemy: CCNode!, ground: CCNode!) -> ObjCBool {
        println("Game Over")
        let gameOver = CCBReader.loadAsScene("gameOver")
        CCDirector.sharedDirector().presentScene(gameOver)
        return true
    }
    
    
    //gameover check function

    
    //gameover function
    
    
}
