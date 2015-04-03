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
        styleDictionary_1["fontSize"] = 18 as CGFloat
        styleDictionary_1["largeFontSize"] = 22 as CGFloat
        styleDictionary_1["fontName"] = "ArialMT"
        styleDictionary_1["fontColor"] = UIColor.whiteColor()
        styleDictionary_1["labelForegroundColor"] = SKColor.grayColor()
        styleDictionary_1["labelBackgroundColor"] = UIColor.blackColor().colorWithAlphaComponent(0.5)
        styleDictionary_1["descriptionLocation"] = CGPointMake(700, 150)
        styleDictionary_1["leftColumnX"] = 341
        styleDictionary_1["rightColumnX"] = 682
        styleDictionary_1["topRowY"] = 600
        styleDictionary_1["bottomRowY"] = 700
        styleDictionaries.append(styleDictionary_1)
        
        //Add more style dictionaries as needed
    }
    func getStyleDictionary(index:Int)->[String:Any]{
        return styleDictionaries[index]
    }
}
