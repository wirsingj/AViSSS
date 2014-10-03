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

class ScenarioManager: UIViewController {
    var scene = SCNScene()
    let cameraNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get view
        let scnView = self.view as SCNView
        
        
        /////////////////////
        //Will have section here for 'intro' scene to be used before scripting scenes
        ////////////////////
        
        ////////////////////////////////////////
        //Begin script reading process
        /////////////////////////////////////
        let scriptManager = ScriptManager(sm: self)
        
        //Set new working scene
        //May have some loading screen/transition in future
        scnView.scene = scene
        
        //Add lights and camera
        addLights()
        addCamera()
        
        //Will get scenario name from first scene/GUIManager
        var scenarioName = "testScenario"
        
        //Ask sciptManager to begin running script
        scriptManager.runScenario(scenarioName)
        
        //Old testing method
        addCharacter()
        
        
        
        ////////////Other settings....///////////////////
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        // configure the view
        scnView.backgroundColor = UIColor.blueColor()
     
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        let gestureRecognizers = NSMutableArray()
        gestureRecognizers.addObject(tapGesture)
        if let existingGestureRecognizers = scnView.gestureRecognizers {
            gestureRecognizers.addObjectsFromArray(existingGestureRecognizers)
        }
        scnView.gestureRecognizers = gestureRecognizers

    }
    
    func addCamera(){
        // create and add a camera to the scene
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 5)
        // cameraNode.eulerAngles = SCNVector3Make(degToRad(-20), degToRad(-25), 0)
        cameraNode.camera?.automaticallyAdjustsZRange = true

    }
    func addLights(){
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = SCNLightTypeAmbient
        ambientLightNode.light?.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)

    }
    //Add prepared node to scene
    func addNode(node: SCNNode){
        scene.rootNode.addChildNode(node)
    }
    //Add animation to a node-  This can be loc/rot/scale animations, or armature animations
    func addAnimation(target: String, animation: CAAnimation, key: String){
        scene.rootNode.childNodeWithName(target, recursively: true)?.addAnimation(animation, forKey: key)
    }
    //Add CABasicAnimation to a node-  This can be the Morphers (facial animation)
    func addAnimation(target: String, animation: CABasicAnimation, key: String){
        scene.rootNode.childNodeWithName(target, recursively: true)?.addAnimation(animation, forKey: key)
    }

    
    func addCharacter(){
        //Set name variables
//        let characterName = "CWom0016"
//        let sceneName = "woman16_Character"
//        let sceneAnimationSourceName = "woman16_Run"
        let characterName = "CBoy0001"
        let sceneName = "boy1_Character"
        let sceneAnimationSourceName = "boy1_Talk"
//        let characterName = "CBoy0002"
//        let sceneName = "boy2_Character"
////        let sceneAnimationSourceName = "boy2_Grab"
//        let characterName = "CBoy0003"
//        let sceneName = "boy3_Character"
//        let sceneAnimationSourceName = "boy3_Run"
//        let characterName = "CBoy0004"
//        let sceneName = "boy4_Character"
//        let sceneAnimationSourceName = "boy3_Run"
        
        
        let animationName = "\(sceneAnimationSourceName)-1"
        
        /////Get the scene/////
        //Get Character model scene
        var sceneURL = NSBundle.mainBundle().URLForResource(sceneName, withExtension: "dae")
        var sceneSource = SCNSceneSource(URL: sceneURL!, options: nil)
        
       //Get character (armature) animation scene
        var sceneAnimationURL = NSBundle.mainBundle().URLForResource(sceneAnimationSourceName, withExtension: "dae")
        var sceneAnimationSource = SCNSceneSource(URL: sceneAnimationURL!, options: nil)
        
        //Log nodes found in scene sources
        NSLog("Character- \(sceneSource?.identifiersOfEntriesWithClass(SCNNode.self))")
        NSLog("Animation- \(sceneAnimationSource?.identifiersOfEntriesWithClass(SCNNode.self)?.description)")
        
        

        
        //Get Node containing information about the character mesh
        let character = sceneSource?.entryWithIdentifier(characterName, withClass: SCNNode.self) as SCNNode
        //Get the armature from the scene source and add it to character
        //(may be able to set this in the .dae/blender in the future)
        //Update-  Reordering the armature as a childnode of character in the .dea works
        //let armature = sceneSource.entryWithIdentifier(armatureName, withClass: SCNNode.self) as SCNNode
       // character.addChildNode(armature)
        
        //Build up final rotation transformation
        let xAngle = SCNMatrix4MakeRotation(degToRad(-90), 1, 0, 0)
        let yAngle = SCNMatrix4MakeRotation(degToRad(180), 0, 1, 0)
        let zAngle = SCNMatrix4MakeRotation(0, 0, 0, 1)
        var result = SCNMatrix4Mult(SCNMatrix4Mult(xAngle, yAngle), zAngle)
        
        //Apply rotation transformation to character
        character.transform = SCNMatrix4Mult(result, character.transform)
        
        //NSLog("Morpher Stuff-\(character.morpher?.targets?)")
       // NSLog("SceneSource Morpher Targets- \(sceneSource?.identifiersOfEntriesWithClass(SCNGeometry.self))")
        character.scale = SCNVector3Make(5, 5, 5)
        //Get the animation associated with the armature from the scene
        var animation = sceneAnimationSource?.entryWithIdentifier(animationName, withClass: CAAnimation.self) as CAAnimation
        //This is how the facial morphers are used as an animation
        let animation2 = CABasicAnimation(keyPath: "morpher.weights[6]")
        animation2.fromValue = 0.0;
        animation2.toValue = 1.0;
        animation2.autoreverses = true;
        animation2.repeatCount = Float.infinity;
        animation2.duration = 2;
        
        //Adding body animation to character's skinner skeleton object
        character.addAnimation(animation, forKey: "run")
        //Adding morpher (face) animation(s) to character
        character.addAnimation(animation2, forKey: "smile")
        
       NSLog("animation keys- \(character.animationKeys())")
        //character.removeAnimationForKey("run")
        //Add character to scene
        scene.rootNode.addChildNode(character)
    }
    
    func buildRoom(){
        
        var floor = SCNFloor()
        // Set a falloff end value for the reflection
        floor.reflectionFalloffEnd = 100.0;
        // Set a diffuse texture, here a pavement image
        floor.firstMaterial?.diffuse.contents = UIImage(named: "floor.jpg")
        floor.firstMaterial?.diffuse.mipFilter = SCNFilterMode.Linear
        // Create a node to attach the floor to, and add it to the scene
        var floorNode = SCNNode()
        floorNode.geometry = floor
        floorNode.name = "floor"
        // floorNode.scale = SCNVector3Make(0.02, 0.02, 0.020)
        
        
        
        scene.rootNode.addChildNode(floorNode)
        
        
        let wallGeometry = SCNPlane(width: 60, height: 40)
        wallGeometry.firstMaterial?.diffuse.contents = "lockerwall.png"
        wallGeometry.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        wallGeometry.firstMaterial?.diffuse.wrapT = SCNWrapMode.Repeat
        wallGeometry.firstMaterial?.doubleSided = false
        wallGeometry.firstMaterial?.locksAmbientWithDiffuse = true
        
        let wallGeometry2 = SCNPlane(width: 60, height: 40)
        wallGeometry2.firstMaterial?.diffuse.contents = "lockerwall.png"
        wallGeometry2.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        wallGeometry2.firstMaterial?.diffuse.wrapT = SCNWrapMode.Repeat
        wallGeometry2.firstMaterial?.doubleSided = false
        wallGeometry2.firstMaterial?.locksAmbientWithDiffuse = true
        
        let wall1 = SCNNode(geometry: wallGeometry)
        wall1.position = SCNVector3Make(40, 20, 0)
        wall1.rotation = SCNVector4Make(0, 1, 0, degToRad(-90))
        wall1.castsShadow = false
        
        let wall2 = SCNNode(geometry: wallGeometry2)
        wall2.position = SCNVector3Make(-40, 20, 0)
        wall2.rotation = SCNVector4Make(0, 1, 0, degToRad(90))
        wall2.castsShadow = false
        
        
        scene.rootNode.addChildNode(wall1)
        scene.rootNode.addChildNode(wall2)
    }
    
    
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        if let hitResults = scnView.hitTest(p, options: nil) {
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                // retrieved the first clicked object
                let result: AnyObject! = hitResults[0]
                
                // get its material
                let material = result.node!.geometry!.firstMaterial!
                
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
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
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
