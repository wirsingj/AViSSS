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
    
    var speechText = SKLabelNode()
    var option1 = SKLabelNode()
    var option2 = SKLabelNode()
    var option3 = SKLabelNode()
    var option4 = SKLabelNode()
    var skScene = SKScene()
    
    init(sm: ScenarioManager){
        skScene = SKScene(size: sm.view.frame.size)
        skScene.anchorPoint = CGPointMake(0.5, 0.5)
        NSLog("GUI/ size \(sm.view.frame.size)")
        setupLabelNodes()
        (sm.view as SCNView).overlaySKScene = skScene
    }
    func setupLabelNodes(){
        
        option1 = SKLabelNode(fontNamed:"Copperplate")
        option1.text = "Option1";
        option1.color = SKColor.blueColor()
        option1.colorBlendFactor = 1
        option1.fontSize = 55;
        option1.position = CGPoint(x:-100, y:-50);
        option1.name = "option1"
        skScene.addChild(option1)
        
        
        option2 = SKLabelNode(fontNamed:"Copperplate")
        option2.text = "Option2";
        option2.color = SKColor.blueColor()
        option2.colorBlendFactor = 1
        option2.fontSize = 55;
        option2.position = CGPoint(x:100, y:-50);
        option2.name = "option2"
        skScene.addChild(option2)

    }
    func setChoices(choices:[String]){
        option1.text = choices[0]
        
    }
}