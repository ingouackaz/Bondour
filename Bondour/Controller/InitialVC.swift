//
//  InitialVC.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-01.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit
import Parse

class InitialVC: UIViewController {

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
        self.navigationController!.navigationBar.hidden = true


    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController!.navigationBar.hidden = false
    }

    @IBAction func fcbConnectAction(sender: AnyObject) {
       
        var permissions = [ "public_profile", "email", "user_friends" ]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: { (user, error) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    //self.exitLoginMode()

                    self.getFcbInformation()
                    
                } else {
                    println("User logged in through Facebook!")
                    self.getFcbInformation()
                   // self.exitLoginMode()

                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        })
    }
    
    func getFcbInformation(){
        
        var request : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        request.startWithCompletionHandler({ (connection, result, error) -> Void in
            if (error == nil) {
                var userData : NSDictionary  = result as! NSDictionary
                println("User FCB data \(result)")
                var name : String = userData["name"] as! String
                name = name.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                PFUser.currentUser()!.setValue(name, forKey: "name")
                PFUser.currentUser()!.save()
                
                var faceBookId : String = userData["id"] as! String
                var url : String =  "https://graph.facebook.com/\(faceBookId)/picture?type=large&return_ssl_resources=1"
                
                var urlRequest : NSURLRequest = NSURLRequest(URL: NSURL(string:url)!)
                
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                    
                    if (error == nil){
                        PFUser.currentUser()!.setValue(PFFile(data: data), forKey: "profileImage")
                        PFUser.currentUser()!.save()                        
                    }
                    
                    self.exitLoginMode()
                    
                })
                // NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                
            }
            else{
                               
                var  file : PFFile = PFFile(data: UIImagePNGRepresentation( UIImage(named: "icon_mascotte")))
            }
        })
    }
    
    func exitLoginMode(){
        
        
        var appD = UIApplication.sharedApplication().delegate as! AppDelegate
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        appD.window!.rootViewController = storyboard.instantiateInitialViewController() as! UINavigationController
        
        //self.dismissViewControllerAnimated(true, completion: nil)
    }

}
