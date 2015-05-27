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
    var hallwayButton = UILabel()
    
    override init(size: CGSize) {
        super.init(size: size)
        self.size = size
        anchorPoint = CGPointMake(0.5, 0.5)
        var background = SKSpriteNode(imageNamed: "locker_image.jpg")
        background.size = size
        background.zPosition = -5
        self.addChild(background)
        self.backgroundColor = SKColor.brownColor()
        NSLog("Size \(self.frame.size)")
        
        
        //The node which will present the description of the situation
        hallwayButton = UILabel()
        hallwayButton.text = "Hallway"
        hallwayButton.frame = CGRectMake(0, 0, 300, 200)
        hallwayButton.backgroundColor = UIColor.blackColor()
        hallwayButton.textColor = UIColor.whiteColor()
        hallwayButton.tag = 1
        hallwayButton.numberOfLines = 1
        hallwayButton.preferredMaxLayoutWidth = 200
        hallwayButton.hidden = false
        hallwayButton.userInteractionEnabled = true
        NSLog("adding hallwaybutton")
        hallwayButton.sizeToFit()
        self.scenarioManager?.view.addSubview(hallwayButton)
        
    }
    func hideButtons(){
        hallwayButton.hidden = true
    }
    func setTheScenarioManager(sm: ScenarioManager){
        scenarioManager = sm
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touchLocation = (touches as! Set<UITouch>).first!.locationInNode(self)
        
        var touchedNode = self.nodeAtPoint(touchLocation) as? SKSpriteNode
        //Get Node that was touched
        if let touchedNodeTemp = touchedNode {
            //Handle case where it is GUI Node
            NSLog("TouchNodeTemp- \(touchedNodeTemp.name)")
            
            let name:String = touchedNodeTemp.name!
            
            switch name {
                
            case "hallway":
                NSLog("hallway touched")
                scenarioManager?.refreshRunningScene("hallwayScenario")
                break
            default:
                break
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
