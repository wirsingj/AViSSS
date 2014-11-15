//
//  GUIStyles.swift
//  AViSSS
//
//  Created by Jeff Wirsing on 11/11/14.
//  Copyright (c) 2014 wirsing.app. All rights reserved.
//
import SpriteKit

class GUIStyles{
    var styleDictionaries = [[String:Any]]()
    
    init(){
        var styleDictionary_1 = [String:Any]()
        styleDictionary_1["fontSize"] = 22
        styleDictionary_1["fontName"] = "Copperplate"
        styleDictionary_1["fontcolor"] = SKColor.blackColor()
        styleDictionary_1["labelForegroundColor"] = SKColor.grayColor()
        styleDictionary_1["labelBackgroundColor"] = SKColor.blackColor()
        styleDictionary_1["descriptionLocation"] = CGPointMake(0, 200.0)
        styleDictionary_1["leftColumnX"] = -275
        styleDictionary_1["rightColumnX"] = 275
        styleDictionary_1["topRowY"] = -200
        styleDictionary_1["bottomRowY"] = -300
        styleDictionaries.append(styleDictionary_1)
        
        //Add more style dictionaries as needed
    }
    func getStyleDictionary(index:Int)->[String:Any]{
        return styleDictionaries[index]
    }
}
