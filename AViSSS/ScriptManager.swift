//
//  ScriptManager.swift
//  AViSSS
//
//  Created by Jeff Wirsing on 7/22/14.
//  Copyright (c) 2014 wirsing.app. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
//import Foundation

class ScriptManager {
    var currentState = 0
    var states : [GDataXMLElement] = []
    let scenarioManager = ScenarioManager()
    let tom = ""
    
    
    init(sm: ScenarioManager){
        scenarioManager = sm
    }
    
    
    
    
    //Input: xml scenario file name to load as XML document
    //This function is the main parser of our scripts-
    //It first loads environment script if found
    //then it will pull out actions and send them to managers
    //It will then begin to run through the states
    func runScenario(scenarioName: String){
        var scenarioScript = getXMLDocument(scenarioName)
        
        //Check for environment
        if let environment = scenarioScript.rootElement().elementsForName("environment").first as? GDataXMLElement{
            parseEnvironment(getXMLDocument(environment.attributeForName("file").stringValue()))
        }
        
        //Get states
        states = scenarioScript.rootElement().elementsForName("state") as [GDataXMLElement]
        goToState(0)
        
    }
    //Process (switch to) given stateID
    func goToState(stateID: Int){
        
        //If there is a state with that number, get it and continue..
        if let state: GDataXMLElement = (states.filter{($0 as GDataXMLElement).attributeForName("id").stringValue() == String(stateID)}).first {
            
            //Actions
            parseActions(state)
            
            //Menu Options
            let menuChoices: [GDataXMLElement] = state.elementsForName("menu_option") as [GDataXMLElement]
            buildMenuChoices(menuChoices)
        }
        
    
    }
    //Build nodes and skybox for ScenarioManager
    func parseEnvironment(environment :GDataXMLDocument){
        //Add Nodes
        parseNodes(environment)
        scenarioManager.testStuff("")
        //Actions
        
        //Skybox
    }
    
    //Method for parsing and processing actions in a given GDataXMLElement
    //These may be animations (armature, pos/rot/scale, morphers) which effect a target
    //or they may be instructions for playing a sound
    func parseActions(script: GDataXMLElement){
        
    }
    
    
    
    //Method for retrieving nodes (3d object description) from a document and get then processed
    func parseNodes(script: GDataXMLDocument){
        var nodes: [GDataXMLElement] = script.rootElement().elementsForName("node") as [GDataXMLElement]
        if nodes.count > 0 {
            for node in nodes{
                buildSCNNode(node)
            }
            
        }

    }
    //Method getting an xml document from string location
    func getXMLDocument(location: NSString)->GDataXMLDocument{
        let xmlLocation = NSBundle.mainBundle().pathForResource(location, ofType: ".xml")
        let xmlData = NSData(contentsOfFile: xmlLocation!)
        var error: NSError?
        let xmlDocument = GDataXMLDocument(data: xmlData, options: 0, error: &error )
        return xmlDocument
    }
    
    //Build SCNNode that will be passed to ScenarioManager
    //A node may be either a .dae source node, or a primative SK shape (rectangle, sphere, etc)
    func buildSCNNode(node : GDataXMLElement){
        var scnNode = SCNNode()
        
        scnNode.name = node.attributeForName("name").stringValue()
        if node.attributeForName("type").stringValue() == "dae"{
            
            let objectName = (node.elementsForName("objectName").first as GDataXMLElement).stringValue()
            let sceneName = (node.elementsForName("file").first as GDataXMLElement).stringValue()
            
            //Get Character model scene
            var sceneURL = NSBundle.mainBundle().URLForResource(sceneName!, withExtension: "dae")
            var sceneSource = SCNSceneSource(URL: sceneURL!, options: nil)
       
            //Get Node containing information about the character mesh
            scnNode = sceneSource?.entryWithIdentifier(objectName, withClass: SCNNode.self) as SCNNode
            
        }
        //Get position data
        let posNode = node.elementsForName("position").first as GDataXMLElement
        let posX = ((posNode.elementsForName("x").first as GDataXMLElement).stringValue() as NSString).floatValue
        let posY = ((posNode.elementsForName("y").first as GDataXMLElement).stringValue() as NSString).floatValue
        let posZ = ((posNode.elementsForName("z").first as GDataXMLElement).stringValue() as NSString).floatValue
        scnNode.position = SCNVector3Make(posX, posY, posZ)
       
//        //Get rotation data
//        let rotNode = node.elementsForName("rotation").first as GDataXMLElement
//        let rotX = degToRad(((rotNode.elementsForName("x").first as GDataXMLElement).stringValue() as NSString).floatValue)
//        let rotY = ((rotNode.elementsForName("y").first as GDataXMLElement).stringValue() as NSString).floatValue
//        let rotZ = ((rotNode.elementsForName("z").first as GDataXMLElement).stringValue() as NSString).floatValue
        
        //Get scale data
        
        scnNode.scale = SCNVector3Make(5, 5, 5)
        
        
        
        //Build up final rotation transformation
        let xAngle = SCNMatrix4MakeRotation(degToRad(-90), 1, 0, 0)
        let yAngle = SCNMatrix4MakeRotation(degToRad(180), 0, 1, 0)
        let zAngle = SCNMatrix4MakeRotation(0, 0, 0, 1)
        var result = SCNMatrix4Mult(SCNMatrix4Mult(xAngle, yAngle), zAngle)
        
        //Apply rotation transformation to character
        scnNode.transform = SCNMatrix4Mult(result, scnNode.transform)
        
        scenarioManager.addNode(scnNode)
    }
    
    //Build animation and send to ScenarioManager
    //Will need to send target info (name) as well...
    func buildAnimation(node : GDataXMLElement){
        
    }
    func buildMenuChoices(choices: [GDataXMLElement]){
        
    }
    func buildSound(location:String){
        
    }
    
    func degToRad(deg: Float)->Float{
        return (deg / 180 * Float(M_PI))
    }
    
    
    
}