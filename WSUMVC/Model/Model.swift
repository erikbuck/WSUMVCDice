import SceneKit

class Model {
   public var numberOfRolls : Int = 0
   public var shakerScene : SCNScene?
   var diePrototype : SCNNode?
   var dice = [SCNNode]()
   var diceFaces = [Int8]()
   var isResting = false
   
   static let shared = Model()
   
   func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
      
      if !isResting {
         isResting = true
         for die in dice {
            let v = die.physicsBody!.velocity
            let av = die.physicsBody!.angularVelocity
            
            isResting = isResting && abs(av.x) < 0.1 &&
            abs(av.y) < 0.1 && abs(av.z) < 0.1 &&
            abs(v.x) < 0.1 && abs(v.y) < 0.1 &&
            abs(v.z) < 0.1
         }
         
         if isResting {
            for die in dice {
               let upFace = calculateFaceThatsUp(die)
               diceFaces.append(upFace)
               //print("\(upFace)", terminator: " ")
            }
            //print("")
         }
      }
   }
   
   func setNumberOfDice(_ numberOfDice : UInt8) {
      for die in dice {
         die.removeFromParentNode()
      }
      dice = [SCNNode]()
      for _ in 0..<numberOfDice {
         let newDie = diePrototype!.clone()
         dice.append(newDie)
         shakerScene?.rootNode.addChildNode(newDie)
      }
   }
   
   init(numberOfDice : UInt8 = 2 ) {
      shakerScene = SCNScene(named: "Shaker.scn")
      let dieScene = SCNScene(named: "die.scn")!
      diePrototype = dieScene.rootNode.childNode(withName: "Die", recursively: true)!
      setNumberOfDice(numberOfDice)
   }
   
   func calculateFaceThatsUp(_ node : SCNNode) -> Int8 {
      let transformedUp = node.presentation.convertVector(SCNVector3(0,1,0), to: nil)
      let transformedRight = node.presentation.convertVector(SCNVector3(1,0,0), to: nil)
      let transformedFront = node.presentation.convertVector(SCNVector3(0,0,1), to: nil)
      var result = Int8(-1)
      
      if(transformedUp.y > 0.9) {
         result = 1
      } else if(transformedUp.y < -0.9) {
         result = 6
      } else if(transformedRight.y < -0.9) {
         result = 2
      } else if(transformedRight.y > 0.9) {
         result = 5
      } else if(transformedFront.y > 0.9) {
         result = 3
      } else if(transformedFront.y < -0.9) {
         result = 4
      }
      return result
   }
   
   func roll() {
      diceFaces = [Int8]()
      isResting = false
      self.numberOfRolls += 1
      for die in dice {
         let impulse = SCNVector3(Float.random(in: 0.0 ..< 14.0),
                                  Float.random(in: 0.0 ..< 30.0),
                                  Float.random(in: 0.0 ..< 14.0))
         die.physicsBody?.applyForce(impulse, asImpulse: true)
      }
   }
}
