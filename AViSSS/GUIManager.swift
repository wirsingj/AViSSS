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

class GUIManager {
    var option1 = SKLabelNode()
    var option2 = SKLabelNode()
    var option3 = SKLabelNode()
    var option4 = SKLabelNode()
    var descriptionNode = SKLabelNode()
    var skScene = SKScene()
    var soundNode = SKNode()
    var _GUIBundle = GUIBundle()
    init(sm: ScenarioManager){
        skScene = SKScene(size: sm.view.frame.size)
        skScene.anchorPoint = CGPointMake(0.5, 0.5)
        NSLog("GUI/ size \(sm.view.frame.size)")
        skScene.addChild(soundNode)
        setupLabelNodes()
        (sm.view as SCNView).overlaySKScene = skScene
    }
    func setupLabelNodes(){
        
        option1 = SKLabelNode(fontNamed:"Copperplate")
        option1.text = "Option1";
        option1.color = SKColor.blueColor()
        option1.colorBlendFactor = 1
        option1.fontSize = 35;
        option1.position = CGPoint(x:-275, y:-200);
        option1.name = "option1"
        skScene.addChild(option1)
        
        
        option2 = SKLabelNode(fontNamed:"Copperplate")
        option2.text = "Option2";
        option2.color = SKColor.blueColor()
        option2.colorBlendFactor = 1
        option2.fontSize = 35;
        option2.position = CGPoint(x:275, y:-200);
        option2.name = "option2"
        skScene.addChild(option2)
        
        option3 = SKLabelNode(fontNamed:"Copperplate")
        option3.text = "Option3";
        option3.color = SKColor.blueColor()
        option3.colorBlendFactor = 1
        option3.fontSize = 35;
        option3.position = CGPoint(x:-275, y:-300);
        option3.name = "option3"
        skScene.addChild(option3)
        
        option4 = SKLabelNode(fontNamed:"Copperplate")
        option4.text = "Option4";
        option4.color = SKColor.blueColor()
        option4.colorBlendFactor = 1
        option4.fontSize = 35;
        option4.position = CGPoint(x:275, y:-300);
        option4.name = "option2"
        skScene.addChild(option4)
        
        descriptionNode = SKLabelNode(fontNamed:"Copperplate")
        descriptionNode.text = "Desc";
        descriptionNode.color = SKColor.blueColor()
        descriptionNode.colorBlendFactor = 1
        descriptionNode.fontSize = 25;
        descriptionNode.position = CGPoint(x:0, y:100);
        descriptionNode.name = "option2"
        skScene.addChild(descriptionNode)


    }
    func setGUIBundle(bundle: GUIBundle){
        _GUIBundle = bundle
        setChoices()
        playDescriptionSound()
    }
    func setChoices(){
        option1.text = _GUIBundle.optionsText[0]
        option2.text = _GUIBundle.optionsText[1]
        option3.text = _GUIBundle.optionsText[2]
        option4.text = _GUIBundle.optionsText[3]
    }
    func setDescription(){
        descriptionNode.text = _GUIBundle.situationText
    }
    func playDescriptionSound(){
        soundNode.runAction(SKAction.playSoundFileNamed(_GUIBundle.soundLocation, waitForCompletion: true))
    }
}