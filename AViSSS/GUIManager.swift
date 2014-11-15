//
//  GUIManager.swift
//  AViSSS
//
//  Created by Jeff Wirsing on 7/22/14.
//  Copyright (c) 2014 wirsing.app. All rights reserved.
//  iPad2 size - 768x1024

import Foundation
import Spritekit
import SceneKit

//GUI manager is responsible for recieving
class GUIManager : SKScene{
    
    
    //Labels used during scenarios
    var option1 = SKLabelNode()
    var option2 = SKLabelNode()
    var option3 = SKLabelNode()
    var option4 = SKLabelNode()
    var descriptionNode = SKLabelNode()
    var style = [String:Any]()
    
    var labelNodeArray = [SKLabelNode()]
    var actionNode = SKNode()
    //Current States' GUI data
    var _GUIBundle = GUIBundle()
    
    init(sm: ScenarioManager){
        super.init(size: sm.view.frame.size)
        self.anchorPoint = CGPointMake(0.5, 0.5)
        self.addChild(actionNode)
        let _GUIStyles = GUIStyles()
        style = _GUIStyles.getStyleDictionary(0)
        labelNodeArray = [option1, option2, option3, option4, descriptionNode]
        //Needs parameter for style from GUIStyles
        setupChoiceLabels()
    }
    
    
    //Recieve and "start" GUI for each state
    func setGUIBundle(bundle: GUIBundle){
        _GUIBundle = bundle
        
        //Play ambient sound if needed
        
        //Maybe a delay before display/read situation text
        presentDescription()
        
        //May be a delay before setting/presenting options
        setChoices()
    }
    
    //Set or present N number of choices- name/text recieved in an array
    //May be a delay before choices are made visible
    func setChoices(){
        
        var delay = _GUIBundle.optionsDelay as Int?
        //Action that will run code..
        var optionsSetAction = SKAction.runBlock{  () in
            //If not an object, so we must set the text, location, and hidden values of the labels
            if self._GUIBundle.object == false {
                //Make array for non-empty choices text (from bundle)
                let usedOptions = self._GUIBundle.optionsText.filter{($0) != ""}
                //Make array to hold
                for (index, choice) in enumerate(usedOptions){
                    var labelNode = self.labelNodeArray[index]
                    labelNode.text = choice
                    labelNode.hidden = false
                }
                //Get x/y locations for labels
                let leftColX = self.style["leftColumnX"]! as Int
                let rightColX = self.style["rightColumnX"]! as Int
                let topRowY = self.style["topRowY"]! as Int
                let botRowY = self.style["bottomRowY"]! as Int
                    //Place options based on
                switch usedOptions.count {
                case 1:
                    self.labelNodeArray[0].position = CGPointMake(0, CGFloat(topRowY))
                case 2:
                    self.labelNodeArray[0].position = CGPointMake(CGFloat(leftColX), CGFloat(topRowY))
                    self.labelNodeArray[1].position = CGPointMake(CGFloat(rightColX), CGFloat(topRowY))
                case 3:
                    self.labelNodeArray[0].position = CGPointMake(CGFloat(leftColX), CGFloat(topRowY))
                    self.labelNodeArray[1].position = CGPointMake(CGFloat(rightColX), CGFloat(topRowY))
                    self.labelNodeArray[2].position = CGPointMake(CGFloat(0), CGFloat(botRowY))
                    
                case 4:
                    self.labelNodeArray[0].position = CGPointMake(CGFloat(leftColX), CGFloat(topRowY))
                    self.labelNodeArray[1].position = CGPointMake(CGFloat(rightColX), CGFloat(topRowY))
                    self.labelNodeArray[2].position = CGPointMake(CGFloat(leftColX), CGFloat(botRowY))
                    self.labelNodeArray[3].position = CGPointMake(CGFloat(rightColX), CGFloat(botRowY))
                default:
                    break
                }
                
            }else{
                //Tell scenarioManager what objects to listen for
            }
        }
        
        if delay > 0 {
            let delayAction = SKAction.waitForDuration(NSTimeInterval(delay!))
            let descriptionSequence = SKAction.sequence([delayAction, optionsSetAction])
            actionNode.runAction(descriptionSequence)
        }else{
            actionNode.runAction(optionsSetAction)
        }
    }
    //After a possible delay, present situation text and begin audio playback
    func presentDescription(){
        var delay = _GUIBundle.descriptionDelay as Int?
        
        var descPosition = self.style["descriptionLocation"]! as CGPoint
         self.labelNodeArray[4].position = descPosition
        var textSetAction = SKAction.runBlock{  () in
            self.descriptionNode.text = self._GUIBundle.situationText
            self.descriptionNode.hidden = false
        }
        
        if delay > 0 {
            let delayAction = SKAction.waitForDuration(NSTimeInterval(delay!))
            let descriptionSequence = SKAction.sequence([delayAction, textSetAction, SKAction.playSoundFileNamed(_GUIBundle.soundLocation, waitForCompletion: false)])
            actionNode.runAction(descriptionSequence)
        }else{
            let descriptionSequence = SKAction.sequence([textSetAction, SKAction.playSoundFileNamed(_GUIBundle.soundLocation, waitForCompletion: false)])
            actionNode.runAction(descriptionSequence)
        }
        
    }
    //Called (by GUIManager or ScenarioManager for choice/object) when an option has been selected
    //Responsible for hiding options, playing response audio, and presenting response text
    //Driver of logic
    func respondToSelection(choice : Int){
        //Play response audio and show text
        //If correct send ScriptManager into next state
        
        //If incorrect remove selected choice from the bundle the incorrect choice and re-call presentChoices
    }
    
    
    //Set up formatting of labels based on supplied style Dictionary, does not present, place, or supply text to labels
    func setupChoiceLabels(){
        
        option1.name = "option1"
        option2.name = "option2"
        option3.name = "option3"
        option4.name = "option4"
        descriptionNode.name = "description"
        for label in labelNodeArray{
            //label = SKLabelNode(fontNamed:"Copperplate")
          // label.fontName = style["fontName"] as String
            label.text = ""
            label.color = style["fontColor"] as? UIColor
            
            //label.colorBlendFactor = 1
            var _fontSize = style["fontSize"]! as Int
            label.fontSize = CGFloat(_fontSize)
            label.hidden = true
            self.addChild(label)
        }
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}