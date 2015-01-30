//
//  GUIBundle.swift
//  AViSSS
//
//  Created by Jeff Wirsing on 11/4/14.
//  Copyright (c) 2014 wirsing.app. All rights reserved.
//

import SceneKit

class GUIBundle {
    //Location of ambient sound to be played (Is likely only specified in State 0
    var ambientSound = ""
    //Location of sound and text to be presented for explaination of state situation
    var soundLocation = ""
    var situationText = ""
    
    //1-4 options, can be either a strings or clickable objects
    //Based on object bool variable- either contains text or name clickable node option
    var object = false
    
    //index into each of the following array represents which option it is associated with
    var optionsText  = ["","","",""] //Maybe be object names
    var textOnSelect = ["","","",""]
    var soundOnSelect = ["","","",""]
    var actionsOnSelect = [SCNAction]()
    var correctChoiceID = 0
    var nextState = 0
    var descriptionDelay: Double = 0
    var optionsDelay: Double = 0
    
}
