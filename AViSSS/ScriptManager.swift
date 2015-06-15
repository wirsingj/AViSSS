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
    var states : [GDataXMLElement] = [GDataXMLElement]()
    var scenarioManager : ScenarioManager?
    var _GUIManager : GUIManager?
    var scenarioScript: GDataXMLDocument = GDataXMLDocument()
    
    func setSM(sm: ScenarioManager){
        scenarioManager = sm
    }
    func setGM(gm: GUIManager){
        
        _GUIManager = gm
    }
    //Input: xml scenario file name to load as XML document
    //This function is the main parser of our scripts-
    //It first loads environment script if found
    //then it will pull out actions and send them to managers
    //It will then begin to run through the states
    func runScenario(scenarioName: String){
        scenarioScript = getXMLDocument(scenarioName)
        //Check for environment
        if let environment = scenarioScript.rootElement().elementsForName("environment").first as? GDataXMLElement{
            parseEnvironment(getXMLDocument(environment.stringValue()))
        }
        
        //Start scenario at state 0
        goToState(0)
    }
    
    //Process (switch to) given stateID
    func goToState(stateID: Int){
        states = scenarioScript.rootElement().elementsForName("state") as! [GDataXMLElement]
        NSLog("Set States-\(states.count) STATE-\(stateID)")
        //If there is a state with that number, get it and continue..
        if let state: GDataXMLElement = (states.filter{($0 as GDataXMLElement).attributeForName("id").stringValue() == String(stateID)}).first {
            
            //Add Nodes!
            if var nodes = state.elementsForName("nodes"){
                parseNodes((nodes.first as? GDataXMLElement)!)
            }
            
            //Handle actions.
            parseActions(state.elementsForName("actions").first as! GDataXMLElement)
            
            //Menu Options
            buildGUIBundle(state.elementsForName("gui").first as! GDataXMLElement)
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
        for file:GDataXMLElement in environment.rootElement().elementsForName("skybox").first?.elementsForName("file") as! [GDataXMLElement] {
            skyboxArray.append(file.stringValue())
        }
        scenarioManager!.buildSkybox(skyboxArray)
    }
    
    ///////ACTIONS////////////////////////////////////////////////////////////
    //Method for parsing and processing ACTIONS for all TARGETS in a given GDataXMLElement
    //These may be animations (armature, pos/rot/scale, morphers) which effect a target
    //or they may be instructions for playing a sound and displaying text.
    //Function then passes actions to the scenarioManager
    func parseActions(actions: GDataXMLElement){
        //Go through targets, building up a sequence of actions 
        //(some actions can be simultaneously embedded in sequence as a 'batch') for each
        //May be camera or node
        
        //Dictionary of all Target:ActionBatch pairs
        var targetBatches = [String:SCNAction]()
        
        //Variable which is populated by each targets batch of sequences
        var targetSequenceBatch = SCNAction()
        
        //Go through all TARGETS
        for target:GDataXMLElement in actions.elementsForName("target") as! [GDataXMLElement] {
            let name: String = target.attributeForName("name").stringValue()
            
            //First, initialize collection for batch of XMLSequences, and a temp List to hold the SCNAction Sequences
            let batchOfSequences = target.elementsForName("actionSequence") as! [GDataXMLElement]
            var _tempSequenceList = [SCNAction]()
            //Go through all sequences in the batch, adding them to temp list
            for sequence in batchOfSequences {
                let _tempSequence = buildActionSequence(sequence, name: name) as SCNAction
                _tempSequenceList += [_tempSequence]
            }
            //Create a batch of created sequences
            targetSequenceBatch = SCNAction.group(_tempSequenceList)
            //Add batch of action sequences for target to collection of target-action batch pairs
            targetBatches.updateValue(targetSequenceBatch, forKey: name)
        }
        scenarioManager!.addActionsToTargets(targetBatches)
    }
    
    //Build an action sequence  (Used to build overall batches, or nested sequence building
    func buildActionSequence(action: GDataXMLElement, name: NSString)-> SCNAction{
        
        //Get XML action objects to be build into sequence
        let xmlActionsInSequence = action.children() as! [GDataXMLElement]
        var scnActionSequenceArray: [SCNAction] = []
        var repeatCount: Float = 1
        //Go through all actions, adding them to an action sequence list
        //At the end, we will make an ScnAction sequence from the list
        for action in xmlActionsInSequence {
            let type = action.name()
            var buildAction = SCNAction()
            
            switch type {
            case "actionSequence":
                buildAction = buildActionSequence(action, name: name)
            case "position":
                //Move can be either move to or move by
                NSLog("Creating Position action")
                
                let x = ((action.elementsForName("x").first as! GDataXMLElement).stringValue() as NSString).floatValue
                let y = ((action.elementsForName("y").first as! GDataXMLElement).stringValue() as NSString).floatValue
                let z = ((action.elementsForName("z").first as! GDataXMLElement).stringValue() as NSString).floatValue
                let move = SCNVector3Make(x, y, z)
                let duration =  ((action.elementsForName("duration").first as! GDataXMLElement).stringValue() as NSString).floatValue
                //  let count = ((action.elementsForName("count").first as! GDataXMLElement).stringValue() as NSString).integerValue
                // buildAction = SCNAction.repeatAction(SCNAction.moveBy(moveBy, duration: NSTimeInterval(duration)), count: count)
                
                if let type = action.attributeForName("type"){
                    if type.stringValue() == "moveTo"{
                        buildAction = SCNAction.moveTo(move, duration: NSTimeInterval(duration))
                    }else{
                        buildAction = SCNAction.moveBy(move, duration: NSTimeInterval(duration))
                    }
                }
            case "rotation":
                NSLog("Creating Rotation action")
                let x = ((action.elementsForName("x").first as! GDataXMLElement).stringValue() as NSString).floatValue
                let y = ((action.elementsForName("y").first as! GDataXMLElement).stringValue() as NSString).floatValue
                let z = ((action.elementsForName("z").first as! GDataXMLElement).stringValue() as NSString).floatValue
                let angle = ((action.elementsForName("angle").first as! GDataXMLElement).stringValue() as NSString).floatValue
                let duration =  ((action.elementsForName("duration").first as! GDataXMLElement).stringValue() as NSString).doubleValue
                //  let count = ((action.elementsForName("count").first as! GDataXMLElement).stringValue() as NSString).integerValue
                // buildAction = SCNAction.repeatAction(SCNAction.rotateByAngle(CGFloat(degToRad(angle)), aroundAxis: SCNVector3Make(x, y,z), duration: NSTimeInterval(duration)), count: count)
                buildAction = SCNAction.rotateByAngle(CGFloat(degToRad(angle)), aroundAxis: SCNVector3Make(x, y,z), duration: NSTimeInterval(duration))
            case "delay":
                NSLog("Creating Delay action")
                let duration =  (action.stringValue() as NSString).floatValue
                buildAction = SCNAction.waitForDuration(NSTimeInterval(duration))
            case "animation":
                //Create a custom action which has code to start an animationsdf
                //Animation is made outside of closure (variable closure)
                //Get character (armature) animation scene
                var sceneAnimationSourceName = (action.elementsForName("file").first as! GDataXMLElement).stringValue() as NSString
                var sceneAnimationURL = NSBundle.mainBundle().URLForResource(sceneAnimationSourceName as! String, withExtension: "dae")
                var sceneAnimationSource = SCNSceneSource(URL: sceneAnimationURL!, options: nil)
                //let animationName = "\(sceneAnimationSourceName)-1"
                let animationName = (action.elementsForName("name").first as! GDataXMLElement).stringValue() as String
                var animation = sceneAnimationSource?.entryWithIdentifier(animationName, withClass: CAAnimation.self) as! CAAnimation
                let count = ((action.elementsForName("count").first as! GDataXMLElement).stringValue() as NSString).floatValue
                animation.repeatCount = count
                buildAction = SCNAction.runBlock{
                    (node: SCNNode!) in
                    node.addAnimation(animation, forKey: animationName)
                }
            case "morpher":
                //scenarioManager.scene.rootNode.childNodeWithName(name, recursively: true)?.morpher?.targets
                NSLog("buildAction: Morpher case-\(scenarioManager!.runningScene.rootNode.childNodeWithName(name as! String, recursively: true)?.morpher?.targets )")
                //This is how the facial morphers are used as an animation
                var morpherNumber = ((action.elementsForName("id").first as! GDataXMLElement).stringValue() as NSString).floatValue
                var animation = CABasicAnimation(keyPath: "morpher.weights[\(morpherNumber)]")
                animation.fromValue = 0.0;
                animation.toValue = 1.0;
                animation.autoreverses = true;
                let count = ((action.elementsForName("count").first as! GDataXMLElement).stringValue() as NSString).floatValue
                animation.repeatCount = count
                let duration = ((action.elementsForName("duration").first as! GDataXMLElement).stringValue() as NSString).floatValue
                animation.duration = CFTimeInterval(duration );
                buildAction = SCNAction.runBlock{
                    (node: SCNNode!) in
                    node.addAnimation(animation, forKey: "run")
                }
            case "count":
                //The whole sequence may be repeated N times
                repeatCount = (action.stringValue() as NSString).floatValue
                NSLog("count- \(repeatCount)")
            default:
                break
            }
            
            
            scnActionSequenceArray += [buildAction]
        }
        let sequenceAction = SCNAction.sequence(scnActionSequenceArray)
        return SCNAction.repeatAction(sequenceAction, count: Int(repeatCount))
    }
    
    //Method for retrieving nodes (3d object description) from a document and get then processed
    func parseNodes(script: GDataXMLDocument){
        var nodes: [GDataXMLElement] = script.rootElement().elementsForName("node") as! [GDataXMLElement]
        if nodes.count > 0 {
            for node in nodes{
                //NSLog("parsingNode")
                buildSCNNode(node)
            }
        }
    }
    func parseNodes(node: GDataXMLElement){
        var nodes: [GDataXMLElement] = node.elementsForName("node") as! [GDataXMLElement]
        if nodes.count > 0 {
            for node in nodes{
                //NSLog("parsingNode")
                buildSCNNode(node)
            }
        }
    }
    //Method getting an xml document from string location
    func getXMLDocument(location: NSString)->GDataXMLDocument{
        let xmlLocation = NSBundle.mainBundle().pathForResource(location as? String, ofType: ".xml")
        let xmlData = NSData(contentsOfFile: xmlLocation!)
        var error: NSError?
        
        let xmlDocument = GDataXMLDocument(data: xmlData, options: 0, error: &error )
        return xmlDocument
    }
    
    //Build SCNNode that will be passed to ScenarioManager
    //A node may be either a .dae source node, or a primative SK shape (rectangle, sphere, etc)
    //Node can also be a light or camera
    func buildSCNNode(node : GDataXMLElement){
        
        //Declare and name scnNode
        var scnNode = SCNNode()
        
        //Nodes can either be created from a .dae file/object, or they can be a primative shape.
        if node.attributeForName("type").stringValue() == "dae"{
            
            let objectName = (node.elementsForName("objectName").first as! GDataXMLElement).stringValue()
            let sceneName = (node.elementsForName("file").first as! GDataXMLElement).stringValue()
            
            //Get Character model scene
            var sceneURL = NSBundle.mainBundle().URLForResource(sceneName!, withExtension: "dae")
            var sceneSource = SCNSceneSource(URL: sceneURL!, options: nil)
            
            //Get Node containing information about the character mesh
            scnNode = sceneSource?.entryWithIdentifier(objectName, withClass: SCNNode.self) as! SCNNode
            
            //Get scale data
            if let scaleNode:GDataXMLElement = (node.elementsForName("scale")?.first) as? GDataXMLElement{
                let scaleX = ((scaleNode.elementsForName("x").first as! GDataXMLElement).stringValue() as NSString).floatValue
                let scaleY = ((scaleNode.elementsForName("y").first as! GDataXMLElement).stringValue() as NSString).floatValue
                let scaleZ = ((scaleNode.elementsForName("z").first as! GDataXMLElement).stringValue() as NSString).floatValue
                scnNode.scale = SCNVector3Make(scaleX, scaleY, scaleZ)
            }
            
        }else if node.attributeForName("type").stringValue() == "shape"{
            //Get size information
            let sizeNode = node.elementsForName("size").first as! GDataXMLElement
            let height = ((sizeNode.elementsForName("h").first as! GDataXMLElement).stringValue() as NSString).floatValue
            let width = ((sizeNode.elementsForName("w").first as! GDataXMLElement).stringValue() as NSString).floatValue
            
            //Create geometry
            let geometry = SCNPlane(width: CGFloat(width), height: CGFloat(height))
            //Get texture name
            let textureName = (node.elementsForName("texture").first as! GDataXMLElement).stringValue()
            
            geometry.firstMaterial?.diffuse.contents = textureName
            
            geometry.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
            geometry.firstMaterial?.diffuse.wrapT = SCNWrapMode.Clamp
            geometry.firstMaterial?.doubleSided = true
            geometry.firstMaterial?.locksAmbientWithDiffuse = true
            
            scnNode = SCNNode(geometry: geometry)
            
            //Get scale data
            if let scaleNode:GDataXMLElement = (node.elementsForName("scale")?.first) as? GDataXMLElement{
                let scaleX = ((scaleNode.elementsForName("x").first as! GDataXMLElement).stringValue() as NSString).floatValue
                let scaleY = ((scaleNode.elementsForName("y").first as! GDataXMLElement).stringValue() as NSString).floatValue
                let scaleZ = ((scaleNode.elementsForName("z").first as! GDataXMLElement).stringValue() as NSString).floatValue
                scnNode.scale = SCNVector3Make(scaleX, scaleY, scaleZ)

            }
            
        }else if node.attributeForName("type").stringValue() == "camera"{
            scnNode.camera = SCNCamera()
            scnNode.camera?.automaticallyAdjustsZRange = true
            scnNode.name = "camera"
            
            
        }else if node.attributeForName("type").stringValue() == "light"{
            scnNode.light = SCNLight()
            scnNode.light = SCNLight()
            scnNode.light?.type = SCNLightTypeSpot
            scnNode.light?.spotOuterAngle = CGFloat(160)
            
            //Casting shadows
            if(scenarioManager!.castShadows){scnNode.light?.castsShadow = true}
            else{scnNode.light?.castsShadow = false}
        }
    
    
        //Get position data
        let posNode = node.elementsForName("position").first as! GDataXMLElement
        let posX = ((posNode.elementsForName("x").first as! GDataXMLElement).stringValue() as NSString).floatValue
        let posY = ((posNode.elementsForName("y").first as! GDataXMLElement).stringValue() as NSString).floatValue
        let posZ = ((posNode.elementsForName("z").first as! GDataXMLElement).stringValue() as NSString).floatValue
        scnNode.position = SCNVector3Make(posX, posY, posZ)
        
        //Get rotation data
        let rotNode = node.elementsForName("rotation").first as! GDataXMLElement
        let rotX = ((rotNode.elementsForName("x").first as! GDataXMLElement).stringValue() as NSString).floatValue
        let rotY = ((rotNode.elementsForName("y").first as! GDataXMLElement).stringValue() as NSString).floatValue
        let rotZ = ((rotNode.elementsForName("z").first as! GDataXMLElement).stringValue() as NSString).floatValue
        //Build up final rotation transformation
        let xAngle = SCNMatrix4MakeRotation(degToRad(rotX), 1, 0, 0)
        let yAngle = SCNMatrix4MakeRotation(degToRad(rotY), 0, 1, 0)
        let zAngle = SCNMatrix4MakeRotation(degToRad(rotZ), 0, 0, 1)
        var result = SCNMatrix4Mult(SCNMatrix4Mult(xAngle, yAngle), zAngle)
        //Apply rotation transformation to character
        scnNode.transform = SCNMatrix4Mult(result, scnNode.transform)
        
       
        //Set name
        scnNode.name = node.attributeForName("name").stringValue()
        //Add Node to scenario manager
        scenarioManager!.addNode(scnNode)
    }
    
    
    //Set fields of the GUI bundle
    func buildGUIBundle(xmlBundle: GDataXMLElement){
        var guiBundle = GUIBundle()
        
        //Ambient sound
        guiBundle.ambientSound = (xmlBundle.elementsForName("ambient_sound")?.first as! GDataXMLElement).stringValue()
        //Situation sound
        guiBundle.soundLocation = (xmlBundle.elementsForName("situation_sound")?.first as! GDataXMLElement).stringValue()
        //Situation text
        guiBundle.situationText = (xmlBundle.elementsForName("situation_text")?.first as! GDataXMLElement).stringValue()
        //Next State
        guiBundle.nextState = (xmlBundle.elementsForName("next_state")?.first as! GDataXMLElement).stringValue().toInt()!
        //description delay
        guiBundle.descriptionDelay = ((xmlBundle.elementsForName("description_delay")?.first as! GDataXMLElement).stringValue() as NSString).doubleValue
        //options delay
        guiBundle.optionsDelay = ((xmlBundle.elementsForName("options_delay")?.first as! GDataXMLElement).stringValue() as NSString).doubleValue
        //Set object boolean
        guiBundle.object = (xmlBundle.elementsForName("option_type")?.first as! GDataXMLElement).stringValue() == "object" ? true : false
        
        //Set Correct Choice
        guiBundle.correctChoiceID = (xmlBundle.elementsForName("correct_choice")?.first as! GDataXMLElement).stringValue().toInt()!
        //Menu choices   text/text-on-select/sound-on-swift select/actions-on-select
        for menuOption:GDataXMLElement in xmlBundle.elementsForName("menu_option") as! [GDataXMLElement]{
            //
            let index = menuOption.attributeForName("id").stringValue().toInt()
            guiBundle.optionsText[index!] = (menuOption.elementsForName("text")?.first as! GDataXMLElement).stringValue()
            guiBundle.textOnSelect[index!] = (menuOption.elementsForName("text_on_select")?.first as! GDataXMLElement).stringValue()
            guiBundle.soundOnSelect[index!] = (menuOption.elementsForName("sound_on_select")?.first as! GDataXMLElement).stringValue()
            guiBundle.optionsText[index!] = (menuOption.elementsForName("text")?.first as! GDataXMLElement).stringValue()
            
            //TODO-  Build actionsOnSelect
            if let actions = xmlBundle.elementsForName("actions")?.first as? GDataXMLElement{
                guiBundle.actionsOnSelect[index!] = actions
            }
            
        }
        _GUIManager?.setGUIBundle(guiBundle)
    }
    
        
    
    ////Utility Method
    func degToRad(deg: Float)->Float{
        return (deg / 180 * Float(M_PI))
    }
    
}