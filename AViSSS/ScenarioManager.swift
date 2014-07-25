//
//  ScenarioManager.swift
//  AViSSS
//
//  Created by Jeff Wirsing on 7/22/14.
//  Copyright (c) 2014 wirsing.app. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit

//This class is responsible for managing the different scenes which will represent the Scenarios in the simulation.   It holds a reference to a ScriptManager, a GUIManager, and a SoundManager.    It presents the created scene and GUI to the UIViewController.
class ScenarioManager{
    //Variables
    let _viewController = UIViewController()
    
    //Get reference to the view controller
    init(vc:UIViewController){
        _viewController = vc
    }
}