import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {

    // SpriteBuilder code connections
    weak var enemy: Enemy!
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var gameOver: CCNode!
    
    // Variables
//    var enemyArray: Array!
    
    func didLoadFromCCB(){
        gamePhysicsNode.collisionDelegate = self
    }
    
    func sendWave(numberOfEnemies: Int, interval: Double, enemySpeed: Double){
        for i in 0..<numberOfEnemies{
            
        }
    }
    
    override func update(delta: CCTime) {
        
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, enemy: CCNode!, ground: CCNode!) -> ObjCBool {
        println("Game Over")
        gameOver.visible = true
        return true
    }
    
    //gameover check function

    
    //gameover function
    
    
}
