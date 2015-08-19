//
//  CircleVC.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-09.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class CircleVC: UIViewController,  UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate, LMViewDelegate {

    let transition = BubbleTransition()
    var backgroundColor : UIColor?
    var profilImage : UIImage?
    var _lastItem  : LMSpringboardItemView?
    var _selectedItem  : LMSpringboardItemView?
    
    var _annotationView : AnnotationView?
    
    var _selectedLocation : CGPoint?
    
    var _colorsThemes :[UIColor] = [UIColor(hexString: "52BFFF")!,UIColor(hexString: "FF70EA")!]
    
    var _selectedTheme : Int = 0
    
    var _firstAppear  = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.customView().delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func lmviewDidAppear() {
        
        Bondour.sharedInstance._lmManager.updateUsersFromCurrentGroup()
        self.springboard().centerOnIndex(0, zoomScale: 1, animated: false)
        self.springboard().doIntroAnimation()
        self.springboard().alpha = 1
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "LM_didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "LM_didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        self.springboard().centerOnIndex(0, zoomScale: self.springboard().zoomScale, animated: true)
        
        if (_firstAppear == true){
            _firstAppear = false
            self.springboard().centerOnIndex(0, zoomScale: 1, animated: false)
            self.springboard().doIntroAnimation()
            self.springboard().alpha = 1
        }
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func initItems(){
        for (index, item) in enumerate(self.springboard().itemViews){
            
            var tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:"LM_iconTapped:")
            tap.numberOfTapsRequired = 1
            tap.delegate = self
            
            
            var doubletap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:"LM_iconDoubleTapped:")
            doubletap.numberOfTapsRequired = 2
            doubletap.delegate = self
            
            tap.requireGestureRecognizerToFail(doubletap)
            
            item.addGestureRecognizer(tap)
            item.addGestureRecognizer(doubletap)
            
        }
    }
    
    
    func customView()->LMView{
        return self.view as! LMView
    }
    
    
    func springboard()->LMSpringboardView{
        return (self.view as! LMView)._springboard!
    }
    
    
    func LM_didBecomeActive(){
        
        if (self.customView()._isAppLaunched == false){
            
            Bondour.sharedInstance._lmManager.updateUsersFromCurrentGroup()
            self.springboard().centerOnIndex(0, zoomScale: 1, animated: false)
            self.springboard().doIntroAnimation()
            self.springboard().alpha = 1
            //
            
        }
    }
    
    func LM_didEnterBackground(){
        if (self.customView()._isAppLaunched == false){
            self.springboard().alpha = 0
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if (CGFloat(self.springboard().zoomScale) < CGFloat(self.springboard().minimumZoomLevelToLaunchApp)){
            return false
        }
        
        
        return true
    }
    
    func LM_respringTapped(){
        
        if (self.customView()._isAppLaunched == true){
            
            self.customView().quitApp()
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
                }, completion: nil)
        }
        else{
            
            var springboard : LMSpringboardView = self.springboard()
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.springboard().alpha = 0
                }, completion: { (finished) -> Void in
                    self.springboard().doIntroAnimation()
                    self.springboard().alpha = 1
            })
        }
    }
    
    
    
    func LM_iconTapped(sender:UITapGestureRecognizer){
        
        var item = sender.view
        
        
        while(item != nil && item?.isKindOfClass(LMSpringboardItemView) == false){
            item = item?.superview
        }
        
    }
    
    func LM_iconDoubleTapped(sender:UITapGestureRecognizer){
        
        var item = sender.view
        
        var location = sender.locationInView(self.view)
        println(" tap location \(location) ")
        
        _selectedLocation = location
        _selectedItem = item as? LMSpringboardItemView
        _selectedTheme = Int(arc4random_uniform(2))
        
        
        self.performSegueWithIdentifier("networkView", sender: nil)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if (self.isViewLoaded() == true && self.customView()._isAppLaunched == true){
            return UIStatusBarStyle.Default
        }
        else{
            return UIStatusBarStyle.LightContent
        }
    }
    
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = _selectedLocation!
        
        
        transition.bubbleColor = _colorsThemes[_selectedTheme]
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = _selectedLocation!
        transition.bubbleColor = _colorsThemes[_selectedTheme]
        
        return transition
    }
    
    
    @IBAction func leaveRoom(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let controller = segue.destinationViewController as? UIViewController {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .Custom
            //  controller.backgroundColor = _colorsThemes[_selectedTheme]
            // controller.profilImage = _selectedItem?.icon.image
            transition.bubbleColor = _colorsThemes[_selectedTheme]
        }
    }
    
    func groupsUpdated() {
        

        
    }
    
    func usersUpdated() {
        self.customView()._springboard!.itemViews = Bondour.sharedInstance._lmManager.lmSelectedGroupUsersItems
        println("count here \(Bondour.sharedInstance._lmManager.lmSelectedGroupUsersItems.count)")
        self.customView()._springboard!.doIntroAnimationSlow()
        self.initItems()
    }
}
