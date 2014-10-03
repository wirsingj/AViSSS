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
    var currentState: Int = 0
    let scenarioManager = ScenarioManager()
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
        if let environment: GDataXMLElement = scenarioScript.rootElement().elementsForName("environment").first as? GDataXMLElement{
            parseEnvironment(getXMLDocument(environment.attributeForName("file").stringValue()))
        }
        
        //Get states
        var states = scenarioScript.rootElement().elementsForName("state")
    }
    
    //Build nodes and skybox for ScenarioManager
    func parseEnvironment(environment :GDataXMLDocument){
        //Get the nodes to add
        var nodes: [GDataXMLElement] = environment.rootElement().elementsForName("node") as [GDataXMLElement]
        if nodes.count > 0 {
            for node in nodes{
                buildSCNNode(node)
            }
            
        }
        
    }
    
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
        
        if node.attributeForName("type").stringValue() == "dae"{
            
            let nodeName = node.attributeForName("name").stringValue()
            let sceneName = (node.elementsForName("file").first as GDataXMLElement).stringValue()
            
            //Get Character model scene
            var sceneURL = NSBundle.mainBundle().URLForResource(sceneName!, withExtension: "dae")
            var sceneSource = SCNSceneSource(URL: sceneURL!, options: nil)
       
            //Get Node containing information about the character mesh
            scnNode = sceneSource?.entryWithIdentifier(nodeName, withClass: SCNNode.self) as SCNNode
            scnNode.scale = SCNVector3Make(5, 5, 5)
            NSLog("Test2 \(scnNode.description)")
        }
        
        
        
        
        //Build up final rotation transformation
        let xAngle = SCNMatrix4MakeRotation(degToRad(-90), 1, 0, 0)
        let yAngle = SCNMatrix4MakeRotation(degToRad(180), 0, 1, 0)
        let zAngle = SCNMatrix4MakeRotation(0, 0, 0, 1)
        var result = SCNMatrix4Mult(SCNMatrix4Mult(xAngle, yAngle), zAngle)
        
        //Apply rotation transformation to character
        scnNode.transform = SCNMatrix4Mult(result, scnNode.transform)
        NSLog("Test")
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