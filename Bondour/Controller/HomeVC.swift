//
//  HomeVC.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-06.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class HomeVC: UIViewController , UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate, LMManagerDelegate, LMViewDelegate {


    @IBOutlet weak var addGroupButton: UIButton!
    var _lastItem  : LMSpringboardItemView?
    var _selectedItem  : LMSpringboardItemView?

    var _annotationView : AnnotationView?
    
    var _selectedLocation : CGPoint?
    let transition = BubbleTransition()

    var _colorsThemes :[UIColor] = [UIColor(hexString: "52BFFF")!,UIColor(hexString: "FF70EA")!]
    var _selectedTheme : Int = 0
    var _firstAppear  = true
    var _groupSelected  = false
    var manager : LMManager = Bondour.sharedInstance._lmManager

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customView().delegate = self

       // NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDetected", name: UIApplicationDidEnterBackgroundNotification, object: nil)

        self.customView()._respringButton.addTarget(self, action: "LM_respringTapped", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.springboard().alpha = 0
        
        
        self.springboard().centerOnIndex(0, zoomScale: self.springboard().zoomScale, animated: true)

        manager.delegate = self
        println("items \(self.springboard().itemViews.count)")
        
    }
    

    func lmviewDidAppear() {

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
        _groupSelected = false
        
        
    }
    

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    
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
            
            Bondour.sharedInstance._lmManager.updateGroups()
            self.springboard().centerOnIndex(0, zoomScale: 1, animated: false)
            self.springboard().doIntroAnimation()
            self.springboard().alpha = 1
            
            
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
        
        
        var location = sender.locationInView(self.view)
        
        _selectedLocation = location
        _selectedItem = item as? LMSpringboardItemView
        _selectedTheme = Int(arc4random_uniform(2))
        
        manager.lmSelectedGroupObject = _selectedItem?.object
        println(" selected obj \(_selectedItem!.object) ")

        
        self.performSegueWithIdentifier("circleView", sender: nil)
    }
    
    func LM_iconDoubleTapped(sender:UITapGestureRecognizer){
        
        var item = sender.view

        var location = sender.locationInView(self.view)
        println(" tap location \(location) ")

        _selectedLocation = location
        _selectedItem = item as? LMSpringboardItemView
        _selectedTheme = Int(arc4random_uniform(2))

        manager.lmSelectedGroupObject = _selectedItem?.object

        
        self.performSegueWithIdentifier("circleView", sender: nil)
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
        if (_groupSelected == true){
            transition.bubbleColor = UIColor.whiteColor()
            
        }
        else{
            transition.bubbleColor = _colorsThemes[_selectedTheme]
        }
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = _selectedLocation!
        
        if (_groupSelected == true){
            transition.bubbleColor = UIColor.whiteColor()
        }
        else{
            transition.bubbleColor = _colorsThemes[_selectedTheme]
        }
        
        println("did appear")
        
        
        Bondour.sharedInstance._lmManager.updateGroups()
        self.springboard().centerOnIndex(0, zoomScale: 1, animated: false)
        self.springboard().doIntroAnimation()
        self.springboard().alpha = 1
        
        return transition
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let controller = segue.destinationViewController as? CircleVC {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .Custom
            controller.backgroundColor = _colorsThemes[_selectedTheme]
            controller.profilImage = _selectedItem?.icon.image
            transition.bubbleColor = _colorsThemes[_selectedTheme]
        }
        else if (segue.identifier == "NewGroupTVC"){
            var controller = segue.destinationViewController as? UINavigationController
                controller!.transitioningDelegate = self
                controller!.modalPresentationStyle = .Custom
        }
        else if (segue.identifier == "circleView"){
            var controller = segue.destinationViewController as? UINavigationController
            controller!.transitioningDelegate = self
            controller!.modalPresentationStyle = .Custom
        }
    }
    
    @IBAction func settingAction(sender: AnyObject) {
    
        var clipPath : UIBezierPath = UIBezierPath(ovalInRect: CGRectInset(CGRectMake(0, 0, LMSizeIconObjC, LMSizeIconObjC), 0.5, 0.5))

        let image = UIImage(named: "icon7")
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(LMSizeIconObjC, LMSizeIconObjC), false, UIScreen.mainScreen().scale)
        
        clipPath.addClip()
        image!.drawInRect(CGRectMake(0, 0, LMSizeIconObjC, LMSizeIconObjC))
        
        var renderedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        var mascotteItem : LMSpringboardItemView = LMSpringboardItemView()
        mascotteItem.setTitle("New added")
        mascotteItem.icon.image = renderedImage
        
        
        var nArray = [mascotteItem] + self.customView()._springboard!.itemViews
        self.customView()._springboard!.itemViews = nArray
        self.springboard().centerOnIndex(0, zoomScale: 1, animated: false)
        self.springboard().doIntroAnimationSlow()
        self.springboard().alpha = 1
        
    }

    
    @IBAction func addGroupPressed(sender: UIButton) {
    
        _selectedLocation = addGroupButton.center
        _groupSelected = true
        self.performSegueWithIdentifier("NewGroupTVC", sender: nil)
    }
    func userDetected(){

        if (self.customView()._isAppLaunched == false){
            
            self.springboard().centerOnIndex(0, zoomScale: 1, animated: false)
            self.springboard().doIntroAnimation()
            self.springboard().alpha = 1
            
            
        }
    }
    
    // delegate
    func groupsUpdated() {
        
        self.customView()._springboard!.itemViews = Bondour.sharedInstance._lmManager.lmGroupsItems
        
        self.customView()._springboard!.doIntroAnimationSlow()
        self.initItems()
        
    }

    func usersUpdated() {
        
    }
    
}