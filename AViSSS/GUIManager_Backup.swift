////
////  GUIManager.swift
////  AViSSS
////
////  Created by Jeff Wirsing on 7/22/14.
////  Copyright (c) 2014 wirsing.app. All rights reserved.
////  iPad2 size - 768x1024
//
//import Foundation
//import Spritekit
//import SceneKit
//import AVFoundation
//
////GUI manager is responsible for recieving and displaying the situation, options, and responses.  It also manages the playback of audio.
//class GUIManagerBackup : SKScene, AVSpeechSynthesizerDelegate, AVAudioPlayerDelegate{
//    
//    
//    //Labels used during scenarios
//    var option1 = SKShapeNode()
//    var option2 = SKShapeNode()
//    var option3 = SKShapeNode()
//    var option4 = SKShapeNode()
//    var descriptionNode = SKShapeNode()
//    var responseNode = SKShapeNode()
//    var nodeBeingSpoken = SKShapeNode()
//    var _UILabelBeingSpoken = UILabel()
//    var usedLabelNodeArray = [SKNode()]
//    var labelNodeArray = [SKShapeNode()]
//    
//    //UILabel Versions
//    var _option1 = UILabel()
//    var _option2 = UILabel()
//    var _option3 = UILabel()
//    var _option4 = UILabel()
//    var _descriptionNode = UILabel()
//    var _responseNode = UILabel()
//    var _nodeBeingSpoken = UILabel()
//    var _usedLabelNodeArray = [UILabel()]
//    var _labelNodeArray = [UILabel()]
//    
//    
//    
//    
//    var style = [String:Any]()
//    
//    var actionNode = SKNode()
//    var soundActionNode = SKNode()
//    //Current States' GUI data
//    var _GUIBundle = GUIBundle()
//    var scriptManager : ScriptManager?
//    var scenarioManager : ScenarioManager?
//    var descriptionAudioPlayer : AVAudioPlayer?
//    
//    let speechSynth = AVSpeechSynthesizer()
//    var _usingSynth = true
//    var _choice = 0
//    
//    init(sm: ScenarioManager){
//        super.init(size: sm.view.frame.size)
//        scenarioManager = sm
//        self.anchorPoint = CGPointMake(0.5, 0.5)
//        // scenarioManager?.view.layer.anchorPoint = CGPointMake(512, 384)
//        self.addChild(actionNode)
//        let _GUIStyles = GUIStyles()
//        style = _GUIStyles.getStyleDictionary(0)
//        labelNodeArray = [option1, option2, option3, option4, descriptionNode]
//        _labelNodeArray = [_option1, _option2, _option3, _option4, _descriptionNode]
//        
//        actionNode.name = "ActionNode"
//        speechSynth.delegate = self
//        
//    }
//    func setScriptManager(scriptMan: ScriptManager){
//        scriptManager = scriptMan
//    }
//    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
//        //Used to know when the response audios are done
//        NSLog("audioPlayerDidFinishPlaying")
//    }
//    
//    
//    
//    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didStartSpeechUtterance utterance: AVSpeechUtterance!) {
//        //Dont need..?
//        NSLog("SSD DidStart- \(utterance.speechString)")
//    }
//    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
//        NSLog("SSD- DidFinishUtterance")
//    }
//    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didCancelSpeechUtterance utterance: AVSpeechUtterance!) {
//        //Dont Need
//        NSLog("SSD CanceledUtterance")
//    }
//    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!) {
//        //Testing for each word...
//        
//        setAttributedText(_UILabelBeingSpoken, text: _UILabelBeingSpoken.text!, enlargedRange: characterRange)
//        //We need to make the font of the word being spoken larger
//        //First, restore the string to its original size, then enlarge the given character-range
//        
//        
//        //var textNode = nodeBeingSpoken.childNodeWithName("textNode") as ASAttributedLabelNode
//        // nodeBeingSpoken.removeAllChildren()
//        //createMultilineLabel(utterance.speechString, size: CGSizeMake(500,200), baseNode: &nodeBeingSpoken)
//        //Get settings
//        //let _fontSize = style["fontSize"] as CGFloat
//        //let _fontName = style["fontName"] as String
//        
//        //var font = UIFont(name: _fontName, size: _fontSize)
//        //var newAttributedString = NSMutableAttributedString(string: "Testing")//utterance.speechString)
//        
//        // NSLog("SSD WillSpeakRange... currentNode- \(textNode.parent?.position)")
//        //NSLog("RangeSpoken- \(characterRange)")
//        //Apply settings to entire string
//        // newAttributedString.setAttributes([NSFontAttributeName : font!], range: NSMakeRange(0, newAttributedString.length ))
//        //Apply large font to range being spoken
//        //   var largeFont = UIFont(name: _fontName, size: 20)
//        // newAttributedString.setAttributes([NSFontAttributeName : largeFont!], range: characterRange)
//        //textNode.attributedString  = newAttributedString
//        //nodeBeingSpoken.addChild(textNode)
//    }
//    
//    func startSpeechSynthesizer(text :String, speechRate: Float = 0.08){
//        NSLog("Start Speech Synth")
//        speechSynth.stopSpeakingAtBoundary(AVSpeechBoundary.Word)
//        //var text = "I'm walking down the hallway, and someone bumps into me and says \"excuse me\""
//        var words = AVSpeechUtterance(string: text)
//        words.rate = speechRate
//        
//        speechSynth.speakUtterance(words)
//    }
//    
//    
//    //Recieve and "start" GUI for each state
//    func setGUIBundle(bundle: GUIBundle){
//        _GUIBundle = bundle
//        
//        //This uses SKLabelNodes
//        //setupLabelParentNodes()
//        
//        //This sets up UILabels...
//        setupUILabels()
//        
//        
//        //Play ambient sound if needed
//        
//        //Maybe a delay before display/read situation text
//        presentDescription()
//        
//        //May be a delay before setting/presenting options
//        setChoices()
//    }
//    func setupUILabels(){
//        
//        for i in 0...3 {
//            _labelNodeArray[i] = UILabel() //SKShapeNode(rectOfSize: CGSizeMake(300, 50))
//            _labelNodeArray[i].frame = CGRectMake(0, 0, 300, 50)
//            _labelNodeArray[i].backgroundColor = style["labelBackgroundColor"] as? UIColor
//            _labelNodeArray[i].textColor = style["fontColor"] as UIColor
//            _labelNodeArray[i].tag = i
//            _labelNodeArray[i].numberOfLines = 4
//            _labelNodeArray[i].hidden = true
//            self.scenarioManager?.view.addSubview(_labelNodeArray[i])
//            
//        }
//        
//        _descriptionNode = UILabel()
//        _descriptionNode.frame = CGRectMake(20, 20, 100, 100)
//        _descriptionNode.backgroundColor = style["labelBackgroundColor"] as? UIColor
//        _descriptionNode.textColor = style["fontColor"] as UIColor
//        _descriptionNode.tag = 4
//        _descriptionNode.numberOfLines = 8
//        _descriptionNode.hidden = true
//        self.scenarioManager?.view.addSubview(_descriptionNode)
//        NSLog("setupUILabels- \(scenarioManager?.view.frame)")
//        
//        _responseNode = UILabel()
//        _responseNode.frame = CGRectMake(0, 0, 5, 5)
//        _responseNode.backgroundColor = style["labelBackgroundColor"] as? UIColor
//        _responseNode.textColor = style["fontColor"] as UIColor
//        _responseNode.tag = 4
//        _responseNode.numberOfLines = 8
//        _responseNode.hidden = true
//        self.scenarioManager?.view.addSubview(_responseNode)
//    }
//    //Set or present N number of choices- name/text recieved in an array
//    //May be a delay before choices are made visible
//    //!!Delay should only activate on FIRST setChoice call in per state
//    func setChoices(){
//        NSLog("Setting Choices  \(self._GUIBundle.optionsText)")
//        responseNode.hidden = true
//        var delay = _GUIBundle.optionsDelay as Int?
//        //Action that will run code..
//        var optionsSetAction = SKAction.runBlock{  () in
//            //If not an object, so we must set the text, location, and hidden values of the labels
//            if self._GUIBundle.object == false {
//                
//                //Keep original option numbering consistent with
//                //LabelNode numbers-  allows us to respond to selection easier
//                
//                //List of Label nodes to be used-
//                self.usedLabelNodeArray = [SKNode]()
//                self._usedLabelNodeArray = [UILabel]()
//                
//                
//                for (index,option) in enumerate(self._GUIBundle.optionsText){
//                    if option != "" {
//                        //self.usedLabelNodeArray.append(self.labelNodeArray[index])
//                        //self.createMultilineLabel(option, size: CGSizeMake(300, 50), baseNode: &self.labelNodeArray[index])
//                        self._usedLabelNodeArray.append(self._labelNodeArray[index])
//                        self.setAttributedText(self._labelNodeArray[index], text: option)
//                        self.labelNodeArray[index].hidden = false
//                    }
//                }
//                
//                //Get x/y locations for labels
//                let leftColX = self.style["leftColumnX"]! as Int
//                let rightColX = self.style["rightColumnX"]! as Int
//                let topRowY = self.style["topRowY"]! as Int
//                let botRowY = self.style["bottomRowY"]! as Int
//                
//                //Place options based on how many choices
//                switch self.usedLabelNodeArray.count {
//                case 1:
//                    self.usedLabelNodeArray[0].position = CGPointMake(0, CGFloat(topRowY))
//                    //
//                    //  self.usedLabelNodeArray[1].position = CGPointMake(CGFloat(rightColX), CGFloat(topRowY))
//                    //  self.usedLabelNodeArray[2].position = CGPointMake(CGFloat(leftColX), CGFloat(botRowY))
//                    // self.usedLabelNodeArray[3].position = CGPointMake(CGFloat(rightColX), CGFloat(botRowY))
//                    
//                case 2:
//                    self.usedLabelNodeArray[0].position = CGPointMake(CGFloat(leftColX), CGFloat(topRowY))
//                    self.usedLabelNodeArray[1].position = CGPointMake(CGFloat(rightColX), CGFloat(topRowY))
//                    //
//                    // self.usedLabelNodeArray[2].position = CGPointMake(CGFloat(leftColX), CGFloat(botRowY))
//                    //self.usedLabelNodeArray[3].position = CGPointMake(CGFloat(rightColX), CGFloat(botRowY))
//                case 3:
//                    self.usedLabelNodeArray[0].position = CGPointMake(CGFloat(leftColX), CGFloat(topRowY))
//                    self.usedLabelNodeArray[1].position = CGPointMake(CGFloat(rightColX), CGFloat(topRowY))
//                    self.usedLabelNodeArray[2].position = CGPointMake(CGFloat(0), CGFloat(botRowY))
//                    //
//                    // self.labelNodeArray[3].position = CGPointMake(CGFloat(rightColX), CGFloat(botRowY))
//                    
//                case 4:
//                    self.usedLabelNodeArray[0].position = CGPointMake(CGFloat(leftColX), CGFloat(topRowY))
//                    self.usedLabelNodeArray[1].position = CGPointMake(CGFloat(rightColX), CGFloat(topRowY))
//                    self.usedLabelNodeArray[2].position = CGPointMake(CGFloat(leftColX), CGFloat(botRowY))
//                    self.usedLabelNodeArray[3].position = CGPointMake(CGFloat(rightColX), CGFloat(botRowY))
//                default:
//                    break
//                }
//                
//            }else{
//                //Tell scenarioManager what objects to listen for
//            }
//        }
//        
//        if delay > 0 {
//            let delayAction = SKAction.waitForDuration(NSTimeInterval(delay!))
//            let presentChoiceSequence = SKAction.sequence([delayAction, optionsSetAction])
//            actionNode.runAction(presentChoiceSequence)
//        }else{
//            actionNode.runAction(optionsSetAction)
//        }
//    }
//    
//    func setAttributedText(label: UILabel, text: String, enlargedRange: NSRange = NSMakeRange(0, 0)){
//        var attributedString = NSMutableAttributedString(string: text)
//        
//        //Get settings
//        let _fontColor = style["fontColor"] as UIColor
//        let _fontSize = style["fontSize"] as CGFloat
//        let _fontName = style["fontName"] as String
//        var font = UIFont(name: _fontName, size: _fontSize)
//        //Apply settings to whole string
//        attributedString.setAttributes([NSForegroundColorAttributeName : _fontColor, NSFontAttributeName : font!], range: NSMakeRange(0, attributedString.length ))
//        //Enlarge specified range
//        var largeFont = UIFont(name: _fontName, size: 20)
//        attributedString.setAttributes([NSFontAttributeName : largeFont!], range: enlargedRange)
//        
//        
//        label.attributedText = attributedString
//    }
//    //After a possible delay, present situation text and begin audio playback via speech synth or audioplayer
//    func presentDescription(){
//        var delay = _GUIBundle.descriptionDelay as Int?
//        
//        var descPosition = self.style["descriptionLocation"]! as CGPoint
//        // self._descriptionNode.f = descPosition
//        //Action for setting the text of the description
//        var textSetAction = SKAction.runBlock{  () in
//            
//            self.setAttributedText(self._descriptionNode, text: self._GUIBundle.situationText); self._descriptionNode.hidden = false
//        }
//        
//        nodeBeingSpoken = descriptionNode
//        var soundAction = SKAction()
//        //Create sound action-  either with speechSynth or audioplayer
//        if _usingSynth{
//            soundAction = SKAction.runBlock{
//                () in self.startSpeechSynthesizer(self._GUIBundle.situationText); self._UILabelBeingSpoken = self._descriptionNode}
//            
//        }else{
//            //Create audio player
//            soundAction = SKAction.runBlock{
//                () in self.updateAudioPlayerSound(self._GUIBundle.soundLocation)
//            }
//            
//        }
//        //Add a delay before the text action if needed
//        if delay > 0 {
//            let delayAction = SKAction.waitForDuration(NSTimeInterval(delay!))
//            
//            let descriptionSequence = SKAction.sequence([delayAction, textSetAction, soundAction])
//            // descriptionAudioPlayer.
//            actionNode.runAction(descriptionSequence)
//        }else{
//            let descriptionSequence = SKAction.sequence([textSetAction, soundAction])
//            actionNode.runAction(descriptionSequence, withKey: "descriptionAction")
//        }
//        
//    }
//    
//    //Called (by GUIManager or ScenarioManager for choice/object) when an option has been selected
//    //Responsible for hiding options, playing response audio, and presenting response text
//    //Driver of logic
//    func respondToSelection(choice : Int){
//        
//        //Hide other label nodes
//        NSLog("Responding")
//        for label:SKShapeNode in labelNodeArray{
//            label.hidden = true
//        }
//        descriptionNode.hidden = true
//        _choice = choice
//        //Populate response text, and show it
//        createMultilineLabel(_GUIBundle.textOnSelect[choice], size: CGSizeMake(300, 200), baseNode: &responseNode)
//        responseNode.hidden = false
//        responseNode.position = style["descriptionLocation"]! as CGPoint
//        nodeBeingSpoken = responseNode
//        
//        //Play audio-  Then, depending on if the answer was correct or not, either re-present choices without selected choice-  or tell state machine to send us to the next state
//        if _usingSynth{
//            startSpeechSynthesizer(_GUIBundle.textOnSelect[choice])
//        }else{
//            self.updateAudioPlayerSound(self._GUIBundle.soundOnSelect[choice])
//        }
//        //If choice was correct, we must now go to next state, if incorrect, remove that choice and re-present choices
//        if choice == self._GUIBundle.correctChoiceID{
//            NSLog("Correct choice was made!")
//            self.scriptManager!.goToState(self._GUIBundle.nextState)
//        }else{
//            NSLog("wrong choice!")
//            self._GUIBundle.optionsText[choice] = ""
//            
//            self.setChoices()
//        }
//        
//    }
//    func updateAudioPlayerSound(soundLocation: String){
//        
//        NSLog("UpdateAudioPlayerSound- \(soundLocation)")
//        if let soundPath : NSString = NSBundle.mainBundle().pathForResource(soundLocation, ofType: ".mp3"){
//            
//            descriptionAudioPlayer?.stop()
//            descriptionAudioPlayer = nil
//            let responseSoundLocation = NSURL(fileURLWithPath: soundPath)
//            //NSLog("response sound location\(responseSoundLocation)")
//            descriptionAudioPlayer = AVAudioPlayer(contentsOfURL: responseSoundLocation, error: nil)
//            descriptionAudioPlayer?.delegate = self
//            // NSLog("audioPlayer \(descriptionAudioPlayer)")
//            descriptionAudioPlayer!.play()
//        }
//        
//    }
//    func createMultilineLabel(text: String, size: CGSize, inout baseNode: SKShapeNode){
//        
//        baseNode.removeAllChildren()
//        
//        let textNode = ASAttributedLabelNode(size: size)
//        
//        var attributeString = NSMutableAttributedString(string: text)
//        
//        //Get settings
//        let _fontColor = style["fontColor"] as UIColor
//        let _fontSize = style["fontSize"] as CGFloat
//        let _fontName = style["fontName"] as String
//        textNode.userInteractionEnabled = false
//        var font = UIFont(name: _fontName, size: _fontSize)
//        //Apply settings to string
//        attributeString.setAttributes([NSForegroundColorAttributeName : _fontColor, NSFontAttributeName : font!], range: NSMakeRange(0, attributeString.length ))
//        textNode.attributedString = attributeString
//        textNode.name = "textNode"
//        baseNode.addChild(textNode)
//        
//        
//    }
//    
//    //Set up formatting of labels based on supplied style Dictionary, does not present, place, or supply text to labels
//    func setupLabelParentNodes(){
//        
//        
//        NSLog("Just named- \(option1.name)")
//        for i in 0...3 {
//            labelNodeArray[i] = SKShapeNode(rectOfSize: CGSizeMake(300, 50))
//            labelNodeArray[i].fillColor = UIColor.blackColor()
//            labelNodeArray[i].name = "option\(i+1)"
//            self.addChild(labelNodeArray[i])
//        }
//        
//        descriptionNode = SKShapeNode(rectOfSize: CGSizeMake(500, 200))
//        descriptionNode.name = "description"
//        descriptionNode.fillColor = UIColor.blackColor()
//        self.addChild(descriptionNode)
//        
//        responseNode = SKShapeNode(rectOfSize: CGSizeMake(500, 200))
//        responseNode.name = "response"
//        responseNode.fillColor = UIColor.blackColor()
//        self.addChild(responseNode)
//        
//        
//        
//        
//    }
//    
//    //////////////////Touch///////////////////
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        
//        //var touchedNode = self.nodeAtPoint(touches.anyObject()!.locationInNode(self)) as? SKSpriteNode
//        var touched = touches.anyObject() as UITouch
//        //Get Node that was touched
//        let touchedNodes = self.nodesAtPoint(touched.locationInNode(self))
//        NSLog("Touched! \(touchedNodes)")
//        // NSLog("\(touched.locationInNode(self))")
//        let touchedNode = touchedNodes.first as SKNode?
//        //Figure out which option was selected
//        if let node :SKNode = touchedNode {
//            let name :String = node.name!
//            NSLog("Touched node- \(name)")
//            switch name {
//                
//            case "option1":
//                respondToSelection(0)
//            case "option2":
//                respondToSelection(1)
//            case "option3":
//                respondToSelection(2)
//            case "option4":
//                respondToSelection(3)
//            default:
//                break
//            }
//        }
//        
//        
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}