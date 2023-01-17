//
//  ViewController.swift
//  WSUMVC
//
//  Created by Erik Buck on 9/9/19.
//  Copyright © 2019 WSU. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController, SCNSceneRendererDelegate {
   @IBOutlet var numberOfRollsLabel : UILabel?
   @IBOutlet var facesLabel : UILabel?
   @IBOutlet var sceneView : SCNView?

   override func viewDidLoad() {
      super.viewDidLoad()
      sceneView?.scene = Model.shared.shakerScene
      sceneView?.delegate = self
   }
   
   func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
      Model.shared.renderer(renderer, didRenderScene: scene, atTime: time)
      DispatchQueue.main.async {
         let diceFaces = Model.shared.diceFaces.sorted()
         var facesString = ""
         for face in diceFaces {
            if 0 < face {
               facesString.append("\(face) ")
            } else {
               facesString.append("-- ")
            }
         }
         self.facesLabel?.text = facesString
      }
   }
   
   @IBAction func takeNumberOfDiceFrom(slider : UISlider) {
      Model.shared.setNumberOfDice(UInt8(slider.value))
   }
   
   @IBAction func roll(sender : UIButton) {
      Model.shared.roll()
      numberOfRollsLabel?.text = String(Model.shared.numberOfRolls)
   }
}

