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
    var targets = [String]()
    var currentSceneIsMenu: Bool = true
    var scriptManager = ScriptManager()
    var _GUIManager = GUIManager()
    var castShadows = false
    
    var scnView : SCNView = SCNView()
    var statesEncountered = 0
    var incorrectChoices = 0
    var lastState = false
    
    var scenarioNames = [String]()
    var currentScenarioIndex = 0
    
    var scoreOverlay : ScoreOverlay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("ViewDidLoad")
        
        
        //Get view
        scnView = self.view as! SCNView
        //scnView.layer.anchorPoint = CGPointMake(512, 384)
        scnView.layer.anchorPoint = CGPointMake(0.5,0.5)
        scnView.center = CGPointMake(512, 384)
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        
        //Create GUI and Script managers and link them together
        _GUIManager = GUIManager()
        scriptManager = ScriptManager()
        scriptManager.setSM(self)
        scriptManager.setGM(_GUIManager)
        _GUIManager.setScriptManager(scriptManager)
        _GUIManager.setSceneManager(self)
        
        
        //Sprite kit menu is presented-  no scene is made yet
        
        buildMenuScene()
        
        //refreshRunningScene("hallwayScenario")
        
        
        
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
        scnView.gestureRecognizers = gestureRecognizers as [AnyObject]
    }
    func buildMenuScene(){
        statesEncountered = 0
        incorrectChoices = 0
        
        NSLog("building Menu")
        currentSceneIsMenu = true
        menuScene = SCNScene()
        scnView.scene = menuScene
        //        NSLog("scnView size- \(scnView.frame.size)")
        var overlay = StartMenuOverlay(size: scnView.frame.size)
        // scnView.overlaySKScene  = ScoreOverlay(size: scnView.frame.size, totalStates: statesEncountered, incorrectChoices: incorrectChoices, sm: self)
        overlay.setTheScenarioManager(self)
        scnView.overlaySKScene = overlay
        
        NSLog("Test")
    }
    func refreshRunningScene(sceneName: String?){
        
        NSLog("refreshingScene")
        if let _sceneName = sceneName{
            scnView.overlaySKScene = nil
            runningScene = SCNScene()
            
            //Add Ambient Light
            addLights()
            
            lastState = false
            scnView.scene = runningScene
            scriptManager.runScenario(_sceneName)
            
        }else{
            //If scene name was nil, it means we finished last scenario
            //scnView.scene = nil
            _GUIManager.removeUI()
            
            scoreOverlay = ScoreOverlay(size: scnView.frame.size, totalStates: statesEncountered, incorrectChoices: incorrectChoices, sm: self)
            
            scnView.overlaySKScene  = scoreOverlay
        }
        
    }
    func addLights(){
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
    //Add scnAction or animation
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
        let scnView = self.view as! SCNView
        
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
