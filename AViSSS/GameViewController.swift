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
    var scene = SCNScene()
    let cameraNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        
        // create and add a camera to the scene
        
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 1, z: 4)
       // cameraNode.eulerAngles = SCNVector3Make(degToRad(-20), degToRad(-25), 0)
        cameraNode.camera.automaticallyAdjustsZRange = true
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
        
        
        //scene.rootNode.addChildNode(SCNNode(geometry: SCNBox(width: 1, height: 2, length: 1, chamferRadius: 0.4)))
        //buildRoom()
        addCharacter()
        
        //Get view
        let scnView = self.view as SCNView
        
        // set the scene to the view
        scnView.scene = scene
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        
        // add a tap gesture recognizer
       // let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
      //  let gestureRecognizers = NSMutableArray()
       // gestureRecognizers.addObject(tapGesture)
        //gestureRecognizers.addObjectsFromArray(scnView.gestureRecognizers)
        //scnView.gestureRecognizers = gestureRecognizers
    }
    
    
    
    func addCharacter(){
        let sceneName = "boy2_kneel"
        
        let characterName = "CBoy0002"
        let textureName = "CBoy0002.tif"
        let armatureName = "Arnnmature"
        let animationName = "\(sceneName)-1"
        
        var sceneURL = NSBundle.mainBundle().URLForResource(sceneName, withExtension: "dae")
        var sceneSource = SCNSceneSource(URL: sceneURL, options: nil)
        
        NSLog("\(sceneSource.identifiersOfEntriesWithClass(SCNNode.self).description)")
        let armature = sceneSource.entryWithIdentifier(armatureName, withClass: SCNNode.self) as SCNNode
        //Assign CharacterName
        
        //Get Node containing information about the character mesh
        let character = sceneSource.entryWithIdentifier(characterName, withClass: SCNNode.self) as SCNNode
        //add the Character's armature
        character.addChildNode(armature)
        //Add the characters skin
        
        character.geometry.firstMaterial.diffuse.contents = UIImage(named: textureName)
        
        //Rotation tests
        let xAngle = SCNMatrix4MakeRotation(degToRad(-90), 1, 0, 0)
        let yAngle = SCNMatrix4MakeRotation(degToRad(180), 0, 1, 0)
        let zAngle = SCNMatrix4MakeRotation(0, 0, 0, 1)
        var result = SCNMatrix4Mult(SCNMatrix4Mult(xAngle, yAngle), zAngle)
        
        character.transform = result
        //character.rotation = SCNVector4Make(1, 0, 0, degToRad(-90))
        //character.scale = SCNVector3Make(2, 2, 2)
        
        //Get the animation associated with the armature from the scene
        var animation = sceneSource.entryWithIdentifier(animationName, withClass: CAAnimation.self) as CAAnimation
        //animation.duration = 10
        animation.repeatCount = Float.infinity
        
        //This is how the facial morphers are used as an animation
        let animation2 = CABasicAnimation(keyPath: "morpher.weights[6]")
        animation2.fromValue = 0.0;
        animation2.toValue = 1.0;
        animation2.autoreverses = true;
        animation2.repeatCount = Float.infinity;
        animation2.duration = 2;
        
        //Adding animations to character
        character.addAnimation(animation, forKey: "run")
        character.addAnimation(animation2, forKey: "smile")
        
        scene.rootNode.addChildNode(character)
    }
    
    func morpherTesting(){
        
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        cameraNode.eulerAngles = SCNVector3Make(0, 0, 0)
        
        var boxURL = NSBundle.mainBundle().URLForResource("boxTest", withExtension: "dae")
        var mapURL = NSBundle.mainBundle().URLForResource("foldingMap", withExtension: "dae")
        var exampleURL = NSBundle.mainBundle().URLForResource("morphExample", withExtension: "dae")
        var boyURL = NSBundle.mainBundle().URLForResource("boy3_Talk", withExtension: "dae")
        var walkURL = NSBundle.mainBundle().URLForResource("walk", withExtension: "dae")
        var attackURL = NSBundle.mainBundle().URLForResource("attack", withExtension: "dae")
        
        var boxSource = SCNSceneSource(URL: boxURL, options: nil)
        var mapSource =  SCNSceneSource(URL: mapURL, options: nil)
        var exampleSource =  SCNSceneSource(URL: exampleURL, options: nil)
        var boySource =  SCNSceneSource(URL: boyURL, options: nil)
        var walkSource =  SCNSceneSource(URL: walkURL, options: nil)
        var attackSource =  SCNSceneSource(URL: attackURL, options: nil)
        
        var boxlist = boxSource.identifiersOfEntriesWithClass(SCNNode.self)
        var maplist = mapSource.identifiersOfEntriesWithClass(SCNNode.self)
        var examplelist = exampleSource.identifiersOfEntriesWithClass(SCNNode.self)
        var boyList = boySource.identifiersOfEntriesWithClass(SCNNode.self)
        var walkList :[String] = walkSource.identifiersOfEntriesWithClass(SCNNode.self) as [String]
        
        
       // NSLog("BoxScene- \(boxlist.description)")
       // NSLog("MapScene- \(maplist.description)")
       // NSLog("ExampleScene- \(examplelist.description)")
      //  NSLog("BoyScene- \(boyList.description)")
      //  NSLog("walkScene- \(walkList.description)")
        
        
        // var box: SCNNode = boxSource.entryWithIdentifier("Cube", withClass: SCNNode.self) as SCNNode
        // var map: SCNNode = mapSource.entryWithIdentifier("node-Map", withClass: SCNNode.self) as SCNNode
        //   var cylinder: SCNNode = exampleSource.entryWithIdentifier("pCylinder1", withClass: SCNNode.self) as SCNNode
        var boy: SCNNode = boySource.entryWithIdentifier("boy3", withClass: SCNNode.self) as SCNNode
        //var walk: SCNNode = walkSource.entryWithIdentifier("node-Box01", withClass: SCNNode.self) as SCNNode
        var attackScene = SCNScene(named: "attack")
        var walkScene = SCNScene(named: "walk")
        var walk = SCNNode()
       // addChildrenToNodeFromScene(walkScene, node: scene.rootNode)
        ///////////////// //Get Scene directly////////////////////////
        let boyScene = SCNScene(named: "boy3_Talk.dae")
        //  var boy = boyScene.rootNode.childNodeWithName("boy3", recursively: true)
        
        //NSLog("boy deets- \(boy)")
        
        
        
        //boy.rotation = SCNVector4Make(0, 1, 0, degToRad(90))
        // face.transform = SCNMatrix4MakeRotation(degToRad(190), 1, 0, 0)
        //  face.transform = SCNMatrix4MakeScale(5, 5, 5)
        //  boy.position = SCNVector3Make(0, 4, -10)
        
        // boy.scale = SCNVector3Make(100, 100, 100)
        //    boy.transform = SCNMatrix4MakeTranslation(0, 50, 0)
        
        // boy.geometry.firstMaterial.diffuse.contents = UIImage(named: "CBoy0002.tif")
        // boy.geometry.firstMaterial.diffuse.contents = UIImage(named: "CBoy0003.tif.001.tif")
        // boy.geometry.firstMaterial.lightingModelName = "litPerPixel"
        
        
        
        
        //   NSLog("Box- \(box.description)")
        //   NSLog("Cylinder- \(cylinder.description)")
        //NSLog("boy- \(boy.description)")
        
        //  cylinder.morpher.setWeight(1, forTargetAtIndex: 0)
        //  map.morpher.setWeight(1, forTargetAtIndex: 0)
        //  face.morpher.setWeight(1, forTargetAtIndex: 0)
        //  box.morpher.setWeight(0.4, forTargetAtIndex: 0)
        //face.morpher.setWeight(1, forTargetAtIndex: 0)
        // box.rotation = SCNVector4Make(1, 0, 0, degToRad(90))n
        
        
        //   let animation = CABasicAnimation(keyPath: "morpher.weights[4]")
        //let animation: CAAnimation = attackSource.entryWithIdentifier("attackID", withClass: CAAnimation.self) as CAAnimation
        //animation.fromValue = 0.0;
        // animation.toValue = 1.0;
        //  animation.autoreverses = true;
        //  animation.repeatCount = Float.infinity;
        //  animation.duration = 2;
        //scene.rootNode.addAnimation(animation, forKey: "smile")
        
        //walk.rotation = SCNVector4Make(0, 1, 0, degToRad(90))
        scene.rootNode.addChildNode(walk)

     
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
    //Add all children of scene to given node
    func addChildrenToNodeFromScene(scene: SCNScene, node: SCNNode)->SCNNode{
        
        for child in scene.rootNode.childNodes{
            node.addChildNode(child as SCNNode)
        }
        
        return node
    }

}
