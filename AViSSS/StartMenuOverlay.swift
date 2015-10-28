//
//  StartMenuOverlay.swift
//  AViSSS
//
//  Created by Jeff Wirsing on 5/20/15.
//  Copyright (c) 2015 wirsing.app. All rights reserved.
//

import SpriteKit


class StartMenuOverlay: SKScene{
    
    var scenarioManager = ScenarioManager()
    var buttons = [SKShapeNode]()
    var scenarioList = [String]()
    
    override init(size: CGSize) {
        super.init(size: size)
        self.size = size
        anchorPoint = CGPointMake(0.5, 0.5)
        let background = SKSpriteNode(imageNamed: "locker_image.jpg")
        background.size = size
        background.zPosition = -5
        background.name = "background"
        self.addChild(background)
        self.backgroundColor = SKColor.brownColor()
        NSLog("Size \(self.frame.size)")
        
        let logo = SKSpriteNode(imageNamed: "logo2.png")
        logo.zPosition = 1
        logo.position = CGPointMake(250, 250)
        logo.name = "logo"
        self.addChild(logo)
        
        
        setupButtons()
        NSLog("menu init finished")
    }
    func setupButtons(){
        
        //get list of scenarios
        scenarioList = scenarioManager.scriptManager.getScenarioList()
        NSLog("ScenarioList- \(scenarioList)")
        var x:CGFloat = -500
        var y:CGFloat = 200
        
        for scenario in scenarioList{
            NSLog("buildingButton")
           // var button = SKShapeNode(path: CGPathCreateWithRoundedRect(CGRectMake(x, y,  193, 135), 8, 8, nil))
            let button = SKShapeNode()
            button.position=CGPointMake(x, y)
            let pathPos = CGPathCreateMutable()
            CGPathAddRoundedRect(pathPos, nil, CGRectMake(0, 0, 193, 135),8,8)
            button.path = pathPos

            button.fillColor = UIColor(white: 1, alpha: 1)
            //button.fillTexture = SKTexture(imageNamed: "\(scenario).png")
            button.fillTexture = SKTexture(imageNamed: "hallwayScenario.png")
            button.strokeColor = SKColor.blackColor()
            button.lineWidth = 2
            button.zPosition = 1
            button.name = "scenario"
            NSLog("button created- frame \(button.frame)")
            self.addChild(button)
            
            buttons.append(button)
            
            //Move coordinates down the column, and over a row if needed
            y -= 145
            if (y < -300) {
                y = 200
                x += 210
            }
            
        }
        
        NSLog("buttonsListMade- \(buttons)")
        
    }
    
    func setTheScenarioManager(sm: ScenarioManager){
        scenarioManager = sm
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSLog("Start Menu Touched!")
        let touchLocation = (touches ).first!.locationInNode(self)
        var index = 0
        
        for button in buttons{
            NSLog("testing button touch \(button.frame, touchLocation)")
            if CGRectContainsPoint(button.frame, touchLocation){
                NSLog("\(scenarioList[index]) Touched")
                scenarioManager.refreshRunningScene("\(scenarioList[index])")
                scenarioManager.scenarioNames = scenarioList
                scenarioManager.currentScenarioIndex = index
            }
            index++
        }
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
