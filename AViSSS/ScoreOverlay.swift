//
//  ScoreOverlay.swift
//  AViSSS
//
//  Created by Jeff Wirsing on 6/23/15.
//  Copyright (c) 2015 wirsing.app. All rights reserved.
//

import SpriteKit



class ScoreOverlay: SKScene{
    
    var menuLabel = SKLabelNode()
    var scenarioManager : ScenarioManager?
    
    init(size: CGSize, totalStates: Int, incorrectChoices: Int, sm: ScenarioManager) {
        NSLog("Score Overlay")
        
        super.init(size: size)
        self.size = size
        anchorPoint = CGPointMake(0.5, 0.5)
        var background = SKSpriteNode(imageNamed: "chalkboard.tif")
        background.size = size
        background.zPosition = -5
        background.name = "background"
        self.addChild(background)
        self.backgroundColor = SKColor.brownColor()
        NSLog("Size \(self.frame.size)")
        
        var textLabel = SKLabelNode(fontNamed:"Chalkduster")
        textLabel.text = "Congratulations!  Your score was: ";
        textLabel.fontSize = 40;
        textLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 50);
        self.addChild(textLabel)
        
        var scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
        scoreLabel.text = "States encountered: \(totalStates), incorrect choices: \(incorrectChoices) ";
        scoreLabel.fontSize = 40;
        scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 50);
        self.addChild(scoreLabel)
        
        
        menuLabel = SKLabelNode(fontNamed:"Chalkduster")
        menuLabel.text = "Main Menu";
        menuLabel.fontSize = 25;
        menuLabel.position = CGPoint(x:400, y: -300);
        self.addChild(menuLabel)
        
        scenarioManager = sm
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touchLocation = (touches as! Set<UITouch>).first!.locationInNode(self)
        
        
        if CGRectContainsPoint(menuLabel.frame, touchLocation){
            NSLog("Menu Label Touched!")
            scenarioManager!.buildMenuScene()
            NSLog("returned from menu to score")
        }
        
        
        
    }
    
    
}
