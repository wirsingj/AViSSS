//
//  StartScene.swift
//  AViSSS
//
//  Created by Jeff Wirsing on 7/22/14.
//  Copyright (c) 2014 wirsing.app. All rights reserved.
//

import SceneKit
import SpriteKit

//This is the scene loaded before script is read...
class StartScene : SCNScene {
    
    override init(){
       super.init()
    }
    required init(coder aDecoder: NSCoder!){
        super.init(coder: aDecoder)
    }
}
