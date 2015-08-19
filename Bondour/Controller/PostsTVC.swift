//
//  PostsTVC.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-01.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit
import Parse
import MapKit

class PostsTVC: UITableViewController, CLLocationManagerDelegate {

    var _feed : Array<PFObject> = []
    var _locationManager : CLLocationManager = CLLocationManager()
    var _currentLocation : CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startStandardUpdates()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    @IBAction func sendPushAction(sender: AnyObject) {
        self.startSendBondour()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return _feed.count
    }

    
    func startSendBondour()  {
        
        println("current user \(PFUser.currentUser())")
        
        if (PFUser.currentUser()!.objectForKey(PAWUserLocationKey) as? PFGeoPoint != nil){
            var currentPoint : PFGeoPoint = PFUser.currentUser()!.objectForKey(PAWUserLocationKey) as! PFGeoPoint
            
            println("current point \(currentPoint)")
            
            // Find users near a given location
            let userQuery = PFUser.query()
            userQuery!.whereKey(PAWUserLocationKey, nearGeoPoint: currentPoint, withinMiles: 1)
            
            // Find devices associated with these users
            let pushQuery = PFInstallation.query()
            pushQuery!.whereKey("user", matchesQuery: userQuery!)
            pushQuery!.whereKey("user", notEqualTo: PFUser.currentUser()!)
            
            // Send push notification to query
            let push = PFPush()
            push.setQuery(pushQuery) // Set our Installation query
            push.setMessage("Bondour HENRI !!!!")
            push.sendPushInBackgroundWithBlock { (succeed, error) -> Void in
                
                println("Error \(error)")
                
                println("Succeed \(succeed)")
            }
        }
    }
    

    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        _currentLocation = newLocation
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        
        let region = MKCoordinateRegion(center: newLocation.coordinate, span: span)
        
        if (PFUser.currentUser() != nil){
            
            var currentPoint : PFGeoPoint = PFGeoPoint(latitude:_currentLocation!.coordinate.latitude, longitude:_currentLocation!.coordinate.longitude)
            PFUser.currentUser()!.setValue(currentPoint, forKey:PAWUserLocationKey)
            PFUser.currentUser()!.saveInBackgroundWithBlock({ (succeed, error) -> Void in
                if (succeed == true){
                    println("location saved")
                    //self.startPostsQuery()
                }
            })
        }
    }
    
    
    func configureLocationManager(){
        // _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // Set a movement threshold for new events.
        
        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
    }
    
    
    func startStandardUpdates(){
        
        _locationManager.startUpdatingLocation()
        
        var currentLocation = _locationManager.location
        if ((currentLocation) != nil){
            println("current location \(currentLocation)")
            _currentLocation = currentLocation
        }
        
    }
}
