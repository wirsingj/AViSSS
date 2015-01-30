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
import AVFoundation
//This class manages the menu scene and the running scenarios.
//It first builds the menu scene, and then builds and runs scenarios.
//It is is responsible for adding nodes to the scenes, and removing/refreshing/switching between scenes when needed.
class ScenarioManager: UIViewController {
    var runningScene = SCNScene()
    var menuScene = SCNScene()
    let cameraNode = SCNNode()
    var targets = [String]()
    var currentSceneIsMenu: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get view
        let scnView = self.view as SCNView
        scnView.layer.anchorPoint = CGPointMake(512, 384)
        scnView.center = CGPointMake(512, 384)
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        /////////////////////
        //Will have section here for 'intro' scene to be used before scripting scenes
         ////////////////////
        
        
        
        ////////////////////////////////////////
        //Begin script reading process
        /////////////////////////////////////
        
        //GUI Manager
        let _GUIManager = GUIManager(sm: self)
       // scnView.overlaySKScene = _GUIManager
        let scriptManager = ScriptManager(sm: self, gm:_GUIManager)
        _GUIManager.setScriptManager(scriptManager)
        //Set new working scene
        //May have some loading screen/transition in future
        scnView.scene = runningScene
        
        //Add lights and camera
        addLights()
        addCamera()
        
        //Will get scenario name from first scene/GUIManager
        //var scenarioName = "testScenario"
        var scenarioName = "action_test2"
        
        
        //Ask sciptManager to begin running script
        scriptManager.runScenario(scenarioName)
        
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
        func buildMenuScene(){
        currentSceneIsMenu = true
        menuScene = SCNScene(named: "StartScene")!
    }
    func rebuildRunningScene(){
        
    }
    func addCamera(){
        // create and add a camera to the scene
        cameraNode.camera = SCNCamera()
        runningScene.rootNode.addChildNode(cameraNode)
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 20)
         //cameraNode.eulerAngles = SCNVector3Make(degToRad(5), degToRad(0), 0)
        cameraNode.rotation.x = degToRad(-45)
        cameraNode.camera?.automaticallyAdjustsZRange = true
        //cameraNode.camera?.focalBlurRadius = 0.005   //looks terrrible..?
        cameraNode.name = "camera"
    }
    func addLights(){
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLightTypeSpot
        lightNode.light?.spotOuterAngle = CGFloat(160)
        lightNode.position = SCNVector3(x: 0, y: 20, z: 0)
        lightNode.eulerAngles = SCNVector3Make(degToRad(90), degToRad(0), degToRad(0))
        //lightNode.light?.shadowColor = UIColor.blackColor()
        lightNode.light?.castsShadow = true
        runningScene.rootNode.addChildNode(lightNode)
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = SCNLightTypeAmbient
        ambientLightNode.light?.color = UIColor.darkGrayColor()
        runningScene.rootNode.addChildNode(ambientLightNode)

    }
    //Expects 6 images: Right, Left, Top, Bottom, front, back
    func buildSkybox(imageNames: [String]){
        runningScene.background.contents = imageNames
    }
    //Add prepared node to scene
    func addNode(node: SCNNode){
        runningScene.rootNode.addChildNode(node)
    }
    func addActionsToTargets(targetActions : [String:SCNAction]){
        for (target, action) in targetActions{
            runningScene.rootNode.childNodeWithName(target, recursively: true)?.runAction(action)
        }
    }
    func setSelectableTargets(targets:[String]){
        self.targets = targets
    }
    //Used to detect touches to clickable objects in scene
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
