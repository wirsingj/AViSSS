//
//  ScriptManager.swift
//  AViSSS
//
//  Created by Jeff Wirsing on 7/22/14.
//  Copyright (c) 2014 wirsing.app. All rights reserved.
//
// Justin Ehrlich colloberation

import UIKit
import QuartzCore
import SceneKit
//import Foundation

class ScriptManager {
    var states : [GDataXMLElement] = []
    let scenarioManager = ScenarioManager()
    
    //Initialize and get copy of manager
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
            parseEnvironment(getXMLDocument(environment.stringValue()))
        }
        
        //Get states
        states = scenarioScript.rootElement().elementsForName("state") as [GDataXMLElement]
        
        //Start scenario at state 0
        goToState(0)
    }
    
    //Process (switch to) given stateID
    func goToState(stateID: Int){
        
        //If there is a state with that number, get it and continue..
        if let state: GDataXMLElement = (states.filter{($0 as GDataXMLElement).attributeForName("id").stringValue() == String(stateID)}).first {
            
            //Handle actions.
            parseActions(state.elementsForName("actions").first as GDataXMLElement)
            
            //scenarioManager.testStuff("boy1")
            //Menu Options
          //  let menuChoices: [GDataXMLElement] = state.elementsForName("menu_option") as [GDataXMLElement]
           // buildMenuChoices(menuChoices)
        }
        
    
    }
    //Build nodes and skybox for ScenarioManager
    func parseEnvironment(environment :GDataXMLDocument){
        //Add Nodes
        parseNodes(environment)
        
        //Actions
        if let actions = environment.rootElement().elementsForName("actions")?.first as? GDataXMLElement{
             parseActions(actions)
        }
       
        
        //Skybox
        //Right, Left, Top, Bottom, front, back   (last two reversed from apple suggested for first skybox tried..)
        var skyboxArray = [String]()
        for file:GDataXMLElement in environment.rootElement().elementsForName("skybox").first?.elementsForName("file") as [GDataXMLElement] {
            skyboxArray.append(file.stringValue())
        }
        scenarioManager.buildSkybox(skyboxArray)
    }
    
    
    ///////////////////ACTIONS////////////////////////////////////////////////////////////////////////////////////
    //Method for parsing and processing actions in a given GDataXMLElement
    //These may be animations (armature, pos/rot/scale, morphers) which effect a target
    //or they may be instructions for playing a sound and displaying text.
    func parseActions(actions: GDataXMLElement){
        //Go through targets, building up a sequence of actions (some actions can be simultaneously embedded in sequence as a 'batch') for each
        //May be camera, node, display text, or sound file
        var targetSequences = [String:SCNAction]()
        
        //Go through all TARGETS
        for target:GDataXMLElement in actions.elementsForName("target") as [GDataXMLElement] {
            let name: String = target.attributeForName("name").stringValue()
            var targetActionSeq = SCNAction()
            NSLog("ParseActions: Target-\(name)")
            //Go through all sequenced ACTIONS for target
            let seqActions = target.elementsForName("action") as [GDataXMLElement]
            
            //Check for case where we don't need a sequence, just a single action
            if seqActions.count == 1 {
                //Build action (possible batch)
                if let _tempAction = buildAction(seqActions[0], name:name){
                    targetActionSeq = _tempAction
                }
                
             
            //If many actions, build a sequence of all the actions.
            }else{
                NSLog(" \(seqActions.count)")
                var targetActionSeqTempList = [SCNAction]()
                for seqAction in seqActions{
                    if let _ScnAction = buildAction(seqAction, name: name){
                        targetActionSeqTempList += [_ScnAction]
                    }
                }
                targetActionSeq = SCNAction.sequence(targetActionSeqTempList)
            }
            
            
            ///////specialize what we do with the sequence..?
            if target.attributeForName("name").stringValue() == "text"{
                
            }else if target.attributeForName("name").stringValue() == "sound"{
                
            }else{
                //Build action of any other node
                //NSLog("Not text/sound- \(name)")
                
            }
            
            //Add action (possible sequence) to target in scene
            targetSequences.updateValue(targetActionSeq, forKey: name)
            
            
        }
        
        //After all action sequences have been created for all targets, pass the collection to the scene manager
        for(_targetName, _targetAction) in targetSequences{
            scenarioManager.addAction(_targetName, action: _targetAction)
        }
        
        
    }
    
    //Build a single action in a sequence- may be a 'batch' of simultanious action
    func buildAction(action: GDataXMLElement, name: NSString)-> SCNAction?{
        var scnAction = SCNAction()
        //May be a batch
        let coActions = action.children() as [GDataXMLElement]
        var scnCoActionsArray: [SCNAction] = []
        
        //Add coActions to collection
        for coAction in coActions {
            let type = coAction.name()
            var buildAction = SCNAction()
            switch type {
                case "position":
                    NSLog("Creating Position action")
                    let x = ((coAction.elementsForName("x").first as GDataXMLElement).stringValue() as NSString).floatValue
                    let y = ((coAction.elementsForName("y").first as GDataXMLElement).stringValue() as NSString).floatValue
                    let z = ((coAction.elementsForName("z").first as GDataXMLElement).stringValue() as NSString).floatValue
                    let moveBy = SCNVector3Make(x, y, z)
                    let duration =  ((coAction.elementsForName("duration").first as GDataXMLElement).stringValue() as NSString).floatValue
                    let count = ((coAction.elementsForName("count").first as GDataXMLElement).stringValue() as NSString).integerValue
                    buildAction = SCNAction.repeatAction(SCNAction.moveBy(moveBy, duration: NSTimeInterval(duration)), count: count)
                case "rotation":
                    NSLog("Creating Rotation action")
                    let x = ((coAction.elementsForName("x").first as GDataXMLElement).stringValue() as NSString).floatValue
                    let y = ((coAction.elementsForName("y").first as GDataXMLElement).stringValue() as NSString).floatValue
                    let z = ((coAction.elementsForName("z").first as GDataXMLElement).stringValue() as NSString).floatValue
                    let angle = ((coAction.elementsForName("angle").first as GDataXMLElement).stringValue() as NSString).floatValue
                    let duration =  ((coAction.elementsForName("duration").first as GDataXMLElement).stringValue() as NSString).doubleValue
                    buildAction = SCNAction.rotateByAngle(CGFloat(degToRad(angle)), aroundAxis: SCNVector3Make(x, y,z), duration: NSTimeInterval(duration))
                   // scnAction = SCNAction.rotateByAngle(CGFloat(degToRad(90)), aroundAxis: SCNVector3Make(0, 1, 0), duration: NSTimeInterval(3))
                case "delay":
                    NSLog("Creating Delay action")
                    let duration =  (coAction.stringValue() as NSString).floatValue
                    buildAction = SCNAction.waitForDuration(NSTimeInterval(duration))
                case "animation":
                    //Create a custom closure action which has code to start an animation
                    //Animation is made outside of closure (variable closure)
                    //Get character (armature) animation scene
                    var sceneAnimationSourceName = (coAction.elementsForName("file").first as GDataXMLElement).stringValue() as NSString
                    var sceneAnimationURL = NSBundle.mainBundle().URLForResource(sceneAnimationSourceName, withExtension: "dae")
                    var sceneAnimationSource = SCNSceneSource(URL: sceneAnimationURL!, options: nil)
                    let animationName = "\(sceneAnimationSourceName)-1"
                    var animation = sceneAnimationSource?.entryWithIdentifier(animationName, withClass: CAAnimation.self) as CAAnimation
                    buildAction = SCNAction.runBlock{
                        (node: SCNNode!) in
                        node.addAnimation(animation, forKey: animationName)
                    }
                case "morpher":
                   //scenarioManager.scene.rootNode.childNodeWithName(name, recursively: true)?.morpher?.targets
                    NSLog("buildAction: Morpher case-\(scenarioManager.scene.rootNode.childNodeWithName(name, recursively: true)?.morpher?.targets )")
                    //This is how the facial morphers are used as an animation
                    var morpherNumber = ((coAction.elementsForName("id").first as GDataXMLElement).stringValue() as NSString).floatValue
                    var animation = CABasicAnimation(keyPath: "morpher.weights[\(morpherNumber)]")
                    animation.fromValue = 0.0;
                    animation.toValue = 1.0;
                    animation.autoreverses = true;
                    animation.repeatCount = Float.infinity;
                    animation.duration = 2;
                    buildAction = SCNAction.runBlock{
                        (node: SCNNode!) in
                        node.addAnimation(animation, forKey: "run")
                    }
                default:
                    break
            }
            scnCoActionsArray += [buildAction]
        }
        if scnCoActionsArray.count == 1 {
            NSLog("Creating Single Action")
            scnAction = scnCoActionsArray[0]
        }else{
            NSLog("Creating Group. Size- \(scnCoActionsArray.count)")
            scnAction = SCNAction.group(scnCoActionsArray)
            
        }
        return scnAction
    }
    //Pull out sound and pass to SoundManager
    func buildSound(location:String){
        
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
        
        //Declare and name scnNode
        var scnNode = SCNNode()
        
        //Nodes can either be created from a .dae file/object, or they can be a primative shape.
        if node.attributeForName("type").stringValue() == "dae"{
            
            let objectName = (node.elementsForName("objectName").first as GDataXMLElement).stringValue()
            let sceneName = (node.elementsForName("file").first as GDataXMLElement).stringValue()
            
            //Get Character model scene
            var sceneURL = NSBundle.mainBundle().URLForResource(sceneName!, withExtension: "dae")
            var sceneSource = SCNSceneSource(URL: sceneURL!, options: nil)
       
            //Get Node containing information about the character mesh
            scnNode = sceneSource?.entryWithIdentifier(objectName, withClass: SCNNode.self) as SCNNode
            
        }else if node.attributeForName("type").stringValue() == "shape"{
            //Get size information
            let sizeNode = node.elementsForName("size").first as GDataXMLElement
            let height = ((sizeNode.elementsForName("h").first as GDataXMLElement).stringValue() as NSString).floatValue
            let width = ((sizeNode.elementsForName("w").first as GDataXMLElement).stringValue() as NSString).floatValue
            
            //Create geometry
            let geometry = SCNPlane(width: CGFloat(width), height: CGFloat(height))
            //Get texture name
            let textureName = (node.elementsForName("texture").first as GDataXMLElement).stringValue()
            
            geometry.firstMaterial?.diffuse.contents = textureName
        
            geometry.firstMaterial?.diffuse.wrapS = SCNWrapMode.ClampToBorder
            geometry.firstMaterial?.diffuse.wrapT = SCNWrapMode.ClampToBorder
            geometry.firstMaterial?.doubleSided = false
            geometry.firstMaterial?.locksAmbientWithDiffuse = true
            
            scnNode = SCNNode(geometry: geometry)
           
        }
        //NSLog("nodeInfo-\(scnNode)")
         scnNode.castsShadow = false
        //Get position data
        let posNode = node.elementsForName("position").first as GDataXMLElement
        let posX = ((posNode.elementsForName("x").first as GDataXMLElement).stringValue() as NSString).floatValue
        let posY = ((posNode.elementsForName("y").first as GDataXMLElement).stringValue() as NSString).floatValue
        let posZ = ((posNode.elementsForName("z").first as GDataXMLElement).stringValue() as NSString).floatValue
        scnNode.position = SCNVector3Make(posX, posY, posZ)
       
        //Get rotation data
        let rotNode = node.elementsForName("rotation").first as GDataXMLElement
        let rotX = ((rotNode.elementsForName("x").first as GDataXMLElement).stringValue() as NSString).floatValue
        let rotY = ((rotNode.elementsForName("y").first as GDataXMLElement).stringValue() as NSString).floatValue
        let rotZ = ((rotNode.elementsForName("z").first as GDataXMLElement).stringValue() as NSString).floatValue
        //Build up final rotation transformation
        let xAngle = SCNMatrix4MakeRotation(degToRad(rotX), 1, 0, 0)
        let yAngle = SCNMatrix4MakeRotation(degToRad(rotY), 0, 1, 0)
        let zAngle = SCNMatrix4MakeRotation(degToRad(rotZ), 0, 0, 1)
        var result = SCNMatrix4Mult(SCNMatrix4Mult(xAngle, yAngle), zAngle)
        //Apply rotation transformation to character
        scnNode.transform = SCNMatrix4Mult(result, scnNode.transform)

        //Get scale data
        if let scaleNode:GDataXMLElement = (node.elementsForName("scale")?.first) as? GDataXMLElement{
            let scaleX = ((scaleNode.elementsForName("x").first as GDataXMLElement).stringValue() as NSString).floatValue
            let scaleY = ((scaleNode.elementsForName("y").first as GDataXMLElement).stringValue() as NSString).floatValue
            let scaleZ = ((scaleNode.elementsForName("z").first as GDataXMLElement).stringValue() as NSString).floatValue
            scnNode.scale = SCNVector3Make(scaleX, scaleY, scaleZ)
        }
        //Set name
        scnNode.name = node.attributeForName("name").stringValue()
        //Add Node to scenario manager
        scenarioManager.addNode(scnNode)
    }
    
    
    //Make menu choices.  Menu choices will be converted to datastructure which is passed to GUIManager
    func buildMenuChoices(choices: [GDataXMLElement]){
        
    }
    
    //Recieve the chosen menu option
    func menuChoice(choice:Int){
        
    }
    
    
    
    ////Utility Method
    func degToRad(deg: Float)->Float{
        return (deg / 180 * Float(M_PI))
    }
    
}