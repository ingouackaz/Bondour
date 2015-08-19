//
//  PageTutoVC.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-01.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class PageTutoVC: UIViewController {

    
    var pageIndex : Int = 0
    var titleText : String = ""
    var imageFile : String = ""
    
    var currentImage : UIImage = UIImage()
    
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!

   // @IBOutlet var goApplicationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.titleLabel.text = titleText
       //backgroundImage.image = currentImage
    }
    
    @IBAction func goToApplication(sender: AnyObject) {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }

}
