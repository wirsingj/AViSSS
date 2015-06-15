//
//  GUIManager.swift
//  AViSSS
//
//  Created by Jeff Wirsing on 7/22/14.
//  Copyright (c) 2014 wirsing.app. All rights reserved.
//  iPad2 size - 768x1024

import Foundation
import SceneKit
import AVFoundation

//GUI manager is responsible for recieving and displaying the situation, options, and responses.  It also manages the playback of audio.
class GUIManager : NSObject, AVSpeechSynthesizerDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate{
    
    
    
    //UILabel Versions
    var _option1 = UILabel()
    var _option2 = UILabel()
    var _option3 = UILabel()
    var _option4 = UILabel()
    var _descriptionNode = UILabel()
    var _responseNode = UILabel()
    var _UILabelBeingSpoken = UILabel()
    var _usedLabelNodeArray = [UILabel()]
    var _inactiveLabelNodeArray = [UILabel()]
    var _labelNodeArray = [UILabel()]
    var _audioHasBeenPlayed = false
    var x: Int?
    
    //MenuLabels
    var hallwayButton = UILabel()
    var menuBackground = UILabel()
    
    
    var style = [String:Any]()
    
    //Current States' GUI data
    var _GUIBundle = GUIBundle()
    var scriptManager : ScriptManager?
    var scenarioManager : ScenarioManager?
    var descriptionAudioPlayer : AVAudioPlayer?
    
    let speechSynth = AVSpeechSynthesizer()
    var _usingSynth = true
    var _choice = 0
    
    override init(){
        super.init()
        
        
        let _GUIStyles = GUIStyles()
        style = _GUIStyles.getStyleDictionary(0)
        _labelNodeArray = [_option1, _option2, _option3, _option4, _descriptionNode]
        speechSynth.delegate = self
        
    }

    func setScriptManager(scriptMan: ScriptManager){
        scriptManager = scriptMan
    }
    func setSceneManager(sm: ScenarioManager){
        scenarioManager = sm
    }
    //Recieve and "start" GUI for each state
    func setGUIBundle(bundle: GUIBundle){
        _GUIBundle = bundle
        _audioHasBeenPlayed = false
        //This uses SKLabelNodes
        //setupLabelParentNodes()
        
        //This sets up UILabels...
        setupUILabels()
        
        
        //Play ambient sound if needed
        
        //Maybe a delay before display/read situation text
        presentDescription()
        
        //May be a delay before setting/presenting options
        setChoices()
    }
    
    func setupMenuLabels(){
        hideUILabels()
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
    func hideMenuLabels(){
        
    }
    func hideUILabels(){
        
    }
    func setupUILabels(){
        hideMenuLabels()
        for labelNode in _labelNodeArray{
            labelNode.removeFromSuperview()
        }
        _responseNode.removeFromSuperview()
        for i in 0...3 {
            _labelNodeArray[i] = UILabel() //SKShapeNode(rectOfSize: CGSizeMake(300, 50))
            _labelNodeArray[i].frame = CGRectMake(0, 0, 300, 60)
            _labelNodeArray[i].backgroundColor = style["labelBackgroundColor"] as? UIColor
            _labelNodeArray[i].textColor = style["fontColor"] as! UIColor
            _labelNodeArray[i].tag = i
            _labelNodeArray[i].numberOfLines = 4
            _labelNodeArray[i].hidden = true
            _labelNodeArray[i].userInteractionEnabled = true
            _labelNodeArray[i].preferredMaxLayoutWidth = 300
            let choiceTouchRecognizer = UITapGestureRecognizer(target: self, action: Selector("choice\(i)Touched"))
            _labelNodeArray[i].addGestureRecognizer(choiceTouchRecognizer)
            choiceTouchRecognizer.delegate = self
            
            self.scenarioManager?.view.addSubview(_labelNodeArray[i])
        }
        
        //The node which will present the description of the situation
        _descriptionNode = UILabel()
        _descriptionNode.frame = CGRectMake(0, 0, 300, 200)
        _descriptionNode.backgroundColor = style["labelBackgroundColor"] as? UIColor
        _descriptionNode.textColor = style["fontColor"] as! UIColor
        _descriptionNode.tag = 4
        _descriptionNode.numberOfLines = 20
        _descriptionNode.preferredMaxLayoutWidth = 400
        _descriptionNode.hidden = true
        _descriptionNode.userInteractionEnabled = true
        _descriptionNode.center = self.style["descriptionLocation"]! as! CGPoint
        self.scenarioManager?.view.addSubview(_descriptionNode)
        
        
        //This node holds
        _responseNode = UILabel()
        _responseNode.frame = CGRectMake(0, 0, 300, 200)
        _responseNode.backgroundColor = style["labelBackgroundColor"] as? UIColor
        _responseNode.textColor = style["fontColor"] as! UIColor
        _responseNode.tag = 5
        _responseNode.numberOfLines = 20
        _responseNode.preferredMaxLayoutWidth = 400
        _responseNode.hidden = true
        _responseNode.center = self.style["descriptionLocation"]! as! CGPoint
        self.scenarioManager?.view.addSubview(_responseNode)
    }
    //After a possible delay, present situation text and begin audio playback via speech synth or audioplayer
    func presentDescription(){
        
        let startAudio = {() -> () in
            if self._usingSynth{
                self.startSpeechSynthesizer(self._GUIBundle.situationText)
                self._UILabelBeingSpoken = self._descriptionNode
                
            }else{
                self.updateAudioPlayerSound(self._GUIBundle.soundLocation)
            }
            
        }
        ///var descPosition = self.style["descriptionLocation"]! as CGPoint
        //_descriptionNode.frame.origin = descPosition
        let delayInSeconds = (!_audioHasBeenPlayed) ?  _GUIBundle.descriptionDelay as Double?:0;
        //Add a delay before the setting text and playing audio
        if delayInSeconds > 0 {
            let delay = delayInSeconds! * Double(NSEC_PER_SEC)
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(popTime, dispatch_get_main_queue(), {
                //Do Something after delay
                self.setAttributedText(self._descriptionNode, text: self._GUIBundle.situationText);
                self._descriptionNode.hidden = false;
                if !self._audioHasBeenPlayed {startAudio()}
            })
        }else{
            setAttributedText(_descriptionNode, text: _GUIBundle.situationText)
            _descriptionNode.hidden = false
            if !self._audioHasBeenPlayed {startAudio()}
        }
        
        
        
    }
    
    //Set or present N number of choices- name/text recieved in an array
    //May be a delay before choices are made visible
    //!!Delay should only activate on FIRST setChoice call in per state
    func setChoices(){
        _responseNode.hidden = true
        var delayInSeconds = (!_audioHasBeenPlayed) ? _GUIBundle.optionsDelay as Double?: 0;
        
        //Action that will run code..
        var optionsSetAction = { () -> () in
            //If not an object, so we must set the text, location, and hidden values of the labels
            if self._GUIBundle.object == false {
                
                //Keep original option numbering consistent with
                //LabelNode numbers-  allows us to respond to selection easier
                
                //List of Label nodes to be used-
                self._usedLabelNodeArray = [UILabel]()
                
                
                for (index,option) in enumerate(self._GUIBundle.optionsText){
                    if option != "" {
                        //self.usedLabelNodeArray.append(self.labelNodeArray[index])
                        //self.createMultilineLabel(option, size: CGSizeMake(300, 50), baseNode: &self.labelNodeArray[index])
                        self._usedLabelNodeArray.append(self._labelNodeArray[index])
                        self.setAttributedText(self._labelNodeArray[index], text: option)
                        self._labelNodeArray[index].hidden = false
                    }
                }
                
                //Get x/y locations for labels
                let leftColX = self.style["leftColumnX"]! as! Int
                let rightColX = self.style["rightColumnX"]! as! Int
                let topRowY = self.style["topRowY"]! as! Int
                let botRowY = self.style["bottomRowY"]! as! Int
                
                //Place options based on how many choices
                switch self._usedLabelNodeArray.count {
                case 1:
                    NSLog("Case 1")
                    self._usedLabelNodeArray[0].center = CGPointMake(512, CGFloat(topRowY))
                    //
                    //  self.usedLabelNodeArray[1].position = CGPointMake(CGFloat(rightColX), CGFloat(topRowY))
                    //  self.usedLabelNodeArray[2].position = CGPointMake(CGFloat(leftColX), CGFloat(botRowY))
                    // self.usedLabelNodeArray[3].position = CGPointMake(CGFloat(rightColX), CGFloat(botRowY))
                    
                case 2:
                    NSLog("Case2 ")
                    self._usedLabelNodeArray[0].frame.origin = CGPointMake(CGFloat(leftColX), CGFloat(topRowY))
                    self._usedLabelNodeArray[1].frame.origin = CGPointMake(CGFloat(rightColX), CGFloat(topRowY))
                    //
                    // self.usedLabelNodeArray[2].position = CGPointMake(CGFloat(leftColX), CGFloat(botRowY))
                    //self.usedLabelNodeArray[3].position = CGPointMake(CGFloat(rightColX), CGFloat(botRowY))
                case 3:
                    NSLog("Case3")
                    self._usedLabelNodeArray[0].frame.origin = CGPointMake(CGFloat(leftColX), CGFloat(topRowY))
                    self._usedLabelNodeArray[1].frame.origin = CGPointMake(CGFloat(rightColX), CGFloat(topRowY))
                    self._usedLabelNodeArray[2].frame.origin = CGPointMake(CGFloat(512), CGFloat(botRowY))
                    
                    //self._labelNodeArray[3].position = CGPointMake(CGFloat(rightColX), CGFloat(botRowY))
                    
                case 4:
                    NSLog("Case4")
                    self._usedLabelNodeArray[0].center = CGPointMake(CGFloat(leftColX), CGFloat(topRowY))
                    self._usedLabelNodeArray[1].center = CGPointMake(CGFloat(rightColX), CGFloat(topRowY))
                    self._usedLabelNodeArray[2].center = CGPointMake(CGFloat(leftColX), CGFloat(botRowY))
                    self._usedLabelNodeArray[3].center = CGPointMake(CGFloat(rightColX), CGFloat(botRowY))
                default:
                    break
                }
                
            }else{
                //Tell scenarioManager what objects to listen for
            }
        }
        
        if delayInSeconds > 0 {
            let delay = delayInSeconds! * Double(NSEC_PER_SEC)
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(popTime, dispatch_get_main_queue(), {
                //Do Something after delay
                optionsSetAction()
            })
        }else{
            optionsSetAction()
        }
    }
    //Called (by GUIManager or ScenarioManager for choice/object) when an option has been selected
    //Responsible for hiding options, playing response audio, and presenting response text
    //Driver of logic
    func respondToSelection(choice : Int){
        if(_audioHasBeenPlayed){
        //Hide other label nodes
        NSLog("Responding")
        for label:UILabel in _labelNodeArray{
            label.hidden = true
        }
        _descriptionNode.hidden = true
        _choice = choice
        //Populate response text, and show it
        setAttributedText(_responseNode, text: _GUIBundle.textOnSelect[choice])
        _responseNode.hidden = false
        _responseNode.sizeToFit()
        //_responseNode.center = style["descriptionLocation"]! as CGPoint
        
            
        //Ask scriptManager to parse the actions we recieved earlier
            if let actions = _GUIBundle.actionsOnSelect[safe: choice]{
                scriptManager?.parseActions(_GUIBundle.actionsOnSelect[choice]!)
            }
        //Play audio-  Then, depending on if the answer was correct or not, either re-present choices without selected choice-  or tell state machine to send us to the next state
        if _usingSynth{
            startSpeechSynthesizer(_GUIBundle.textOnSelect[choice])
            
        }else{
            updateAudioPlayerSound(_GUIBundle.soundOnSelect[choice])
        }
        _UILabelBeingSpoken = _responseNode
        }
    }
    
    ////////////////Helper Methods/////////////////////
    //Set new attributed string for a UI label-  can optionaly enlarge a character range
    func setAttributedText(label: UILabel, text: String, enlargedRange: NSRange = NSMakeRange(0, 0)){
        var attributedString = NSMutableAttributedString(string: text)
        
        //Get settings
        let _fontColor = style["fontColor"] as! UIColor
        let _fontSize = style["fontSize"] as! CGFloat
        let _fontName = style["fontName"] as! String
        let _largeFontSize = style["largeFontSize"] as! CGFloat
        var font = UIFont(name: _fontName, size: _fontSize)
        //Apply settings to whole string
        attributedString.setAttributes([NSForegroundColorAttributeName : _fontColor, NSFontAttributeName : font!], range: NSMakeRange(0, attributedString.length ))
        //Enlarge specified range
        var largeFont = UIFont(name: _fontName, size: _largeFontSize)
        attributedString.setAttributes([NSFontAttributeName : largeFont!], range: enlargedRange)
        
        
        label.attributedText = attributedString
        
        label.sizeToFit()
    }
    //Stops previous sound, and begins playing new audio   (Description/response audio)
    func updateAudioPlayerSound(soundLocation: String){
        
        if let soundPath : NSString = NSBundle.mainBundle().pathForResource(soundLocation, ofType: ".mp3"){
            
            descriptionAudioPlayer?.stop()
            descriptionAudioPlayer = nil
            let responseSoundLocation = NSURL(fileURLWithPath: soundPath as! String)
            //NSLog("response sound location\(responseSoundLocation)")
            descriptionAudioPlayer = AVAudioPlayer(contentsOfURL: responseSoundLocation, error: nil)
            descriptionAudioPlayer?.delegate = self
            // NSLog("audioPlayer \(descriptionAudioPlayer)")
            descriptionAudioPlayer!.play()
        }
        
    }
    
    //Stops previous speech synth and begins speaking new text.  Speech rate can optionally be set
    func startSpeechSynthesizer(text :String, speechRate: Float = 0.08){
        NSLog("Start Speech Synth")
        speechSynth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        var words = AVSpeechUtterance(string: text)
        words.rate = speechRate
        
        speechSynth.speakUtterance(words)
    }
    
    
    
    
    
    ///////////Delegate Methods///////////////////////
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        //Used to know when the response audios are done
        NSLog("audioPlayerDidFinishPlaying")
    }
    
    
    
    //This method is responsible for triggering choices after description utterance
    //It also is used to decide when the response utterance is done
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        NSLog("SSD- DidFinishUtterance \(_UILabelBeingSpoken)")
        for index in 0 ... _usedLabelNodeArray.count - 1  {
            if(_usedLabelNodeArray[index] == _UILabelBeingSpoken && _usedLabelNodeArray[index] != _usedLabelNodeArray.last){
                NSLog("SpeechSynthUttENd:  index- \(index)")
                setAttributedText(_UILabelBeingSpoken, text: _UILabelBeingSpoken.text!)
                _UILabelBeingSpoken = _usedLabelNodeArray[index+1]
                startSpeechSynthesizer(_usedLabelNodeArray[index+1].text!)
                return
            }else if(_usedLabelNodeArray[index] == _UILabelBeingSpoken && _usedLabelNodeArray[index] == _usedLabelNodeArray.last){
                _audioHasBeenPlayed = true
                setAttributedText(_UILabelBeingSpoken, text: _UILabelBeingSpoken.text!)
            }
        }
        
        
        
        switch _UILabelBeingSpoken {
        case _descriptionNode:
            NSLog("Description Utterance Ended")
             setAttributedText(_UILabelBeingSpoken, text: _UILabelBeingSpoken.text!)
            _UILabelBeingSpoken = _usedLabelNodeArray[0]
            
            startSpeechSynthesizer(_usedLabelNodeArray[0].text!)
            return
        case _responseNode:
            setAttributedText(_UILabelBeingSpoken, text: _UILabelBeingSpoken.text!)
            if _choice == self._GUIBundle.correctChoiceID{
                NSLog("Correct choice was made!")
                _audioHasBeenPlayed = false
                scriptManager!.goToState(_GUIBundle.nextState)
            }else{
                NSLog("wrong choice!")
                _GUIBundle.optionsText[_choice] = ""
                
                setChoices()
            }
            return
        default:
            return
        }
    }
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didCancelSpeechUtterance utterance: AVSpeechUtterance!) {
        ///////////////Dont Need
        NSLog("SSD CanceledUtterance")
    }
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!) {
        
        //Set the spoken word to a larger font
        setAttributedText(_UILabelBeingSpoken, text: _UILabelBeingSpoken.text!, enlargedRange: characterRange)
    }
    func choice0Touched(){
        NSLog("choice 0 Touched!")
        respondToSelection(0)
    }
    func choice1Touched(){
        NSLog("choice 1 Touched!")
        respondToSelection(1)
    }
    func choice2Touched(){
        NSLog("choice 2 Touched!")
        respondToSelection(2)
    }
    func choice3Touched(){
        NSLog("choice 3 Touched!")
        respondToSelection(3)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}