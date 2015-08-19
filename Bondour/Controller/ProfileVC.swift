//
//  ProfileVC.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-08.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!

    var backgroundColor : UIColor?
    var profilImage : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))

        self.profileImageView.image = profilImage
        self.view.backgroundColor = backgroundColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
}
