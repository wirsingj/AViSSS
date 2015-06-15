//
//  StartMenuOverlay.swift
//  AViSSS
//
//  Created by Jeff Wirsing on 5/20/15.
//  Copyright (c) 2015 wirsing.app. All rights reserved.
//

import SpriteKit


class StartMenuOverlay: SKScene{
    var scenarioManager : ScenarioManager?
    var hallwayButton = SKShapeNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        self.size = size
        anchorPoint = CGPointMake(0.5, 0.5)
        var background = SKSpriteNode(imageNamed: "locker_image.jpg")
        background.size = size
        background.zPosition = -5
        background.name = "background"
        self.addChild(background)
        self.backgroundColor = SKColor.brownColor()
        NSLog("Size \(self.frame.size)")
        
        var logo = SKSpriteNode(imageNamed: "logo2.png")
        logo.zPosition = 1
        logo.position = CGPointMake(250, 250)
        logo.name = "logo"
        self.addChild(logo)
        
        hallwayButton = SKShapeNode(path: CGPathCreateWithRoundedRect(CGRectMake(-350,100,  193, 135), 8, 8, nil))
        hallwayButton.fillColor = UIColor(white: 1, alpha: 1)
        hallwayButton.fillTexture = SKTexture(imageNamed: "lockerButton.png")
        hallwayButton.strokeColor = SKColor.blackColor()
        hallwayButton.lineWidth = 2
        //  var hallwayButton = SKSpriteNode(imageNamed: "lockerButton.png")
        hallwayButton.zPosition = 1
        // hallwayButton.position = CGPointMake(-350, 100)
        hallwayButton.name = "hallway"
        self.addChild(hallwayButton)
        //The node which will present the description of the situation
//        hallwayButton = UILabel()
//        hallwayButton.text = "Hallway"
//        hallwayButton.frame = CGRectMake(0, 0, 300, 200)
//        hallwayButton.backgroundColor = UIColor.blackColor()
//        hallwayButton.textColor = UIColor.whiteColor()
//        hallwayButton.tag = 1
//        hallwayButton.numberOfLines = 1
//        hallwayButton.preferredMaxLayoutWidth = 200
//        hallwayButton.hidden = false
//        hallwayButton.userInteractionEnabled = true
//        NSLog("adding hallwaybutton")
//        hallwayButton.sizeToFit()
//        self.view!.addSubview(hallwayButton)
        
//        var hallwayLabel = SKLabelNode(fontNamed:"Chalkduster")
//        hallwayLabel.text = "Hallway";
//        hallwayLabel.fontSize = 200;
//        hallwayLabel.position = CGPointMake(0, 0)
//        hallwayLabel.name = "hallway"
//        hallwayLabel.zPosition = 4
//        hallwayLabel.
//        self.addChild(hallwayLabel)
        
    }
    func hideButtons(){
        hallwayButton.hidden = true
    }
    func setTheScenarioManager(sm: ScenarioManager){
        scenarioManager = sm
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touchLocation = (touches as! Set<UITouch>).first!.locationInNode(self)
        
        if CGRectContainsPoint(hallwayButton.frame, touchLocation){
            NSLog("Hallway Touched")
            scenarioManager?.refreshRunningScene("hallwayScenario")
            
        }
        
        
//        var touchedNode = self.nodeAtPoint(touchLocation) as? SKSpriteNode
//        
//        //Get Node that was touched
//        if let touchedNodeTemp = touchedNode {
//            NSLog("TouchNodeTemp- \(touchedNodeTemp.position, touchedNodeTemp.name)")
//            
//            let name:String = touchedNodeTemp.name!
//            
//            switch name {
//                
//            case "hallway":
//                NSLog("hallway touched")
//                scenarioManager?.refreshRunningScene("hallwayScenario")
//                break
//            default:
//                break
//            }
//        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
