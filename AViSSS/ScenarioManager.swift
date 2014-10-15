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
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
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
        //addCharacter()
        
        
        
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
        
        //GUI Manager Testing
        let _GUIManager = GUIManager(sm: self)
    }
    
    func addCamera(){
        // create and add a camera to the scene
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 40, z: 80)
         //cameraNode.eulerAngles = SCNVector3Make(degToRad(5), degToRad(0), 0)
        cameraNode.rotation.x = degToRad(-45)
        cameraNode.camera?.automaticallyAdjustsZRange = true
        //cameraNode.camera?.focalBlurRadius = 2.0

    }
    func addLights(){
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 50, z: 10)
        scene.rootNode.addChildNode(lightNode)
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = SCNLightTypeAmbient
        ambientLightNode.light?.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)

    }
    //Expects 6 images: Right, Left, Top, Bottom, front, back
    func buildSkybox(imageNames: [String]){
        scene.background.contents = imageNames
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
    func testStuff(name:NSString){
        
       NSLog("\(scene.rootNode.childNodeWithName(name, recursively: true)?.description)")
//        NSLog("\(scene.rootNode.childNodes)")
//        SCNTransaction.begin()
//        SCNTransaction.setAnimationDuration(20)
//        scene.rootNode.childNodeWithName(name, recursively: true)?.eulerAngles = SCNVector3Make(0, 0, 90)
//        SCNTransaction.commit()
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
        return (deg * 180 / Float(M_PI))
    }
    
    
}
