//
//  LMView.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-06.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit


protocol LMViewDelegate{
    func lmviewDidAppear()
}



class LMView: UIView {

    var _appLaunchMaskView:UIImageView?
    var _lastLaunchedItem:LMSpringboardItemView?
    var _springboard:LMSpringboardView?
    var _appView:UIView = UIImageView(image: UIImage(named: "App.png"))
    var _respringButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var _isAppLaunched : Bool = false
    var _names : [String] = ["Lucas", "Marie", "Henry", "Jean", "Lea","Celine", "Karima", "Mohamed", "Karim", "Latifa", "Esmiralda"]
    var clipPath : UIBezierPath = UIBezierPath(ovalInRect: CGRectInset(CGRectMake(0, 0, LMSizeIconObjC, LMSizeIconObjC), 0.5, 0.5))
    var images : [UIImage] = [UIImage(named: "icon7")!, UIImage(named: "icon8")!, UIImage(named: "icon8")!]
    var titles : [String] = ["Loan","Léo",""]
    
    
    var delegate:LMViewDelegate? = nil

    
    
    func displayMessageItem(item:LMSpringboardItemView){
    
        if (_isAppLaunched == false){
            
            
            println("Lancement de l'application !")
        }
    }
    
    func quitApp(){
    
        if (_isAppLaunched == true){
        }
    }
    
    

     init() {
        super.init(frame: CGRectZero)
        
    }
    

    
    
    override func didMoveToWindow() {
        
        if (self.window == nil) {
            println("Disappear ")

        }
        else {
            println("Appear ")

            if (self.delegate != nil){
                
                self.delegate!.lmviewDidAppear()
            }
        }
        
        
        
    }
    
    
    override func canBecomeFirstResponder() -> Bool {
        
        return true
    }
    
    func initLMItem(tag:Int){

        if (tag == 0){
            self._springboard!.itemViews = Bondour.sharedInstance._lmManager.lmGroupsItems
        }
        else{
        
            self._springboard!.itemViews = Bondour.sharedInstance._lmManager.lmSelectedGroupUsersItems
        }
    }

    
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
                
        var fullFrame : CGRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        
        var mask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        
        var bg : UIImageView = UIImageView(frame: fullFrame)
        
        bg.image = UIImage(named: "Wallpaper.png")
        
        bg.contentMode = UIViewContentMode.ScaleAspectFill
        bg.autoresizingMask = mask
        
        self.addSubview(bg)
        
        _springboard = LMSpringboardView(frame: fullFrame)
        _springboard?.autoresizingMask = mask
        
        println("tag \(self.tag)")
        
        
        self.initLMItem(self.tag)
        self.addSubview(_springboard!)
        
        _appView = UIImageView(image: UIImage(named: "App.png"))
        _appView.transform = CGAffineTransformMakeScale(0, 0)
        _appView.backgroundColor = UIColor.whiteColor()
        self.addSubview(_appView)
        
        _appLaunchMaskView = UIImageView(image: UIImage(named: "Icon.png"))
        _respringButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        self.addSubview(_respringButton)
    }

    
    
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var statusFrame : CGRect = CGRectZero
        
        if(self.window != nil)
        {
            var statusFrame : CGRect  = UIApplication.sharedApplication().statusBarFrame
            
            
            var insets : UIEdgeInsets = _springboard!.contentInset
            
            statusFrame = self.window!.convertRect(statusFrame, toView: self)
            
            insets.top = statusFrame.size.height
            
            _springboard!.contentInset = insets;
        }
        
        var size : CGSize  = self.bounds.size;
        
        
        _appView.bounds = CGRectMake(0, 0, size.width, size.height);
        _appView.center = CGPointMake(size.width*0.5, size.height*0.5);
        
        
        _appLaunchMaskView!.center  = CGPointMake(size.width*0.5, size.height*0.5+statusFrame.size.height);
        
        _respringButton.bounds = CGRectMake(0, 0, LMSizeIconObjC, LMSizeIconObjC);
        _respringButton.center = CGPointMake(size.width*0.5, size.height-LMSizeIconObjC*0.5);
    }
}
