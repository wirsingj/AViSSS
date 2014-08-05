//
//  GameViewController.swift
//  AViSSS
//
//  Created by Jeff Wirsing on 7/16/14.
//  Copyright (c) 2014 wirsing.app. All rights reserved.
//  GitHub Test 2

import UIKit
import QuartzCore
import SceneKit
import Foundation

class GameViewController: UIViewController {
    let scene = SCNScene()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: -3, y: 4, z: 7)
        cameraNode.eulerAngles = SCNVector3Make(degToRad(-20), degToRad(-25), 0)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light.type = SCNLightTypeAmbient
        ambientLightNode.light.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        buildRoom()
        
        
        
        
        //Get Running boy
      //  var sceneURL = NSBundle.mainBundle().URLForResource("boy2_run", withExtension: "dae")
        var sceneURL = NSBundle.mainBundle().URLForResource("boy2_run_SA", withExtension: "dae")
        var sceneSource = SCNSceneSource(URL: sceneURL, options: nil)
        let armature = sceneSource.entryWithIdentifier("Arnnmature", withClass: SCNNode.self) as SCNNode
        NSLog("\(armature.description)")
        NSLog("\(armature.childNodes)")
        let boy = sceneSource.entryWithIdentifier("boy2", withClass: SCNNode.self) as SCNNode
      //  boy.scale = SCNVector3Make(10, 4, 4)
    //    let runAnimation = loadAnimation("boy2_run_SA", animationIdentifier: "BoyRun")
        boy.geometry.firstMaterial.diffuse.contents = UIImage(named: "CBoy0002.tif")
        
        scene.rootNode.addChildNode(boy)
        scene.rootNode.addChildNode(armature)
      //  scene.rootNode.addAnimation(runAnimation, forKey: "boy2_run-1")
        
        
      //  let boyScene = SCNScene(named: "boy2_run.dae")
      //  boyScene.rootNode.addChildNode(ambientLightNode)
      //  boyScene.rootNode.addChildNode(floorNode)
      //  var boy = boyScene.rootNode.childNodeWithName("boy2", recursively: false)
       // var armature = boyScene.rootNode.childNodeWithName("Arnnmature", recursively: false)

       // var arnmature = boyScene.rootNode.childNodeWithName("Arnnmature", recursively: true)
      //  boy.geometry.firstMaterial.diffuse.contents = UIImage(named: "CBoy0002.tif")
        //NSLog("\(boyScene.rootNode.childNodes.description)")
      // NSLog("\(boy.description)")
      // NSLog("\(armature.description)")
        //armature.addAnimation(runAnimation, forKey: "Run")
        
     //   boy.addChildNode(armature)
     //   boy.rotation = SCNVector4Make(1, 0, 0, 0)
      //  NSLog("\(boy.description)")
      //  scene.rootNode.addChildNode(boy)
        
//        for node in boyScene.rootNode.childNodes{
//          scene.rootNode.addChildNode(node as SCNNode)
//        }
        
        //ShapeKey/Morphing Tests
   //     var sceneURL = NSBundle.mainBundle().URLForResource("boxTest", withExtension: "dae")
   //     var sceneSource = SCNSceneSource(URL: sceneURL, options: nil)
//        var list = sceneSource.identifiersOfEntriesWithClass(SCNMorpher.self)
//        NSLog("\(list.description)")
//        let box: SCNNode = sceneSource.entryWithIdentifier("Cube", withClass: SCNNode.self) as SCNNode
//        let morpher : SCNNode = sceneSource.entryWithIdentifier("Cube-morph", withClass: SCNNode.self) as SCNNode
//        box.position = SCNVector3Make(0, 0, -10)
 //       box.scale = SCNVector3Make(0.5, 1.8, 1)
 //       box.rotation = SCNVector4Make(1, 0, 0, CFloat(-M_PI_2))
        //morpher.setWeight(1, forTargetAtIndex: 0)
     //   boxMorpher.targets[0] = morphedBox.geometry
        //let targetArray:NSMutableArray = boxMorpher.targets //.append(morphedBox.geometry)
     //  targetArray.addObject(morphedBox.geometry)
 //       scene.rootNode.addChildNode(box)
        let scnView = self.view as SCNView
        // set the scene to the view
       // scnView.scene = boyScene
        scnView.scene = scene
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        let gestureRecognizers = NSMutableArray()
        gestureRecognizers.addObject(tapGesture)
        gestureRecognizers.addObjectsFromArray(scnView.gestureRecognizers)
        scnView.gestureRecognizers = gestureRecognizers
    }
    func buildRoom(){
        
        
        
        var floor = SCNFloor()
        floor.reflectionFalloffEnd = 100.0;                                                    // Set a falloff end value for the reflection
        floor.firstMaterial.diffuse.contents = UIImage(named: "floor.jpg")// Set a diffuse texture, here a pavement image
        floor.firstMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(0.2, 0.2, 1)
        //  floor.firstMaterial.diffuse.con = SCNMatrix4(0.4, 0.4, 0.4) // Scale the diffuse texture
        floor.firstMaterial.diffuse.mipFilter = SCNFilterMode.Linear;
        // Create a node to attach the floor to, and add it to the scene
        var floorNode = SCNNode()
        floorNode.geometry = floor
        floorNode.name = "floor"
        floorNode.scale = SCNVector3Make(0.02, 0.02, 0.020)
        
        
        
        scene.rootNode.addChildNode(floorNode)

        
        let wallGeometry = SCNPlane(width: 6, height: 4)
        wallGeometry.firstMaterial.diffuse.contents = "lockerwall.png"
       // wallGeometry.firstMaterial.diffuse.contentsTransform = SCNMatrix4Mult(SCNMatrix4MakeScale(1.0, 1.0, 1.0), SCNMatrix4MakeRotation(CFloat(M_PI_4), 0.0, 0.0, 1.0))
        wallGeometry.firstMaterial.diffuse.wrapS = SCNWrapMode.Repeat
        wallGeometry.firstMaterial.diffuse.wrapT = SCNWrapMode.Repeat
        wallGeometry.firstMaterial.doubleSided = false
        wallGeometry.firstMaterial.locksAmbientWithDiffuse = true
        
         let wallGeometry2 = SCNPlane(width: 6, height: 4)
        wallGeometry2.firstMaterial.diffuse.contents = "lockerwall.png"
        // wallGeometry.firstMaterial.diffuse.contentsTransform = SCNMatrix4Mult(SCNMatrix4MakeScale(1.0, 1.0, 1.0), SCNMatrix4MakeRotation(CFloat(M_PI_4), 0.0, 0.0, 1.0))
        wallGeometry2.firstMaterial.diffuse.wrapS = SCNWrapMode.Repeat
        wallGeometry2.firstMaterial.diffuse.wrapT = SCNWrapMode.Repeat
        wallGeometry2.firstMaterial.doubleSided = false
        wallGeometry2.firstMaterial.locksAmbientWithDiffuse = true
        
        let wall1 = SCNNode(geometry: wallGeometry)
        wall1.position = SCNVector3Make(4, 2, 0)
        wall1.rotation = SCNVector4Make(0, 1, 0, degToRad(-90))
        wall1.castsShadow = false
        
        let wall2 = SCNNode(geometry: wallGeometry2)
        wall2.position = SCNVector3Make(-4, 2, 0)
        wall2.rotation = SCNVector4Make(0, 1, 0, degToRad(90))
        wall2.castsShadow = false
       
        
        scene.rootNode.addChildNode(wall1)
        scene.rootNode.addChildNode(wall2)
    }
    func loadAnimation(sceneName:NSString, animationIdentifier:NSString)-> CAAnimation{
        var sceneURL = NSBundle.mainBundle().URLForResource(sceneName, withExtension: "dae")
        var sceneSource = SCNSceneSource(URL: sceneURL, options: nil)
        return sceneSource.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) as CAAnimation
    }
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            // get its material
            let material = result.node!.geometry.firstMaterial
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.redColor()
            
            SCNTransaction.commit()
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    func degToRad(deg: Float)->Float{
        return (deg / 180 * Float(M_PI))
    }
}
