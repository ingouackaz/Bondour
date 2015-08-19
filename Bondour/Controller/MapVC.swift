//
//  MapVC.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-01.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, CLLocationManagerDelegate {

    var _locationManager : CLLocationManager = CLLocationManager()
    var _currentLocation : CLLocation?
    
    
    var _circleOverlay : MKCircle?
    var _annotations = []
    var _mapPinsPlaced : Bool = false
    var _mapPannedSinceLocationUpdate : Bool = false
    var _allPosts : Array <PAWPost> = []

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        _locationManager.delegate = self

        
        self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.332495, -122.029095),
            MKCoordinateSpanMake(0.008516, 0.021801) )
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "distanceFilterDidChange:", name: PAWFilterDistanceDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "postWasCreated:", name: PAWPostCreatedNotification, object: nil)
        
        _mapPannedSinceLocationUpdate = false
        self.startStandardUpdates()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _locationManager.startUpdatingLocation()
    }

    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        _locationManager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        _currentLocation = newLocation
        
        let span = MKCoordinateSpanMake(0.05, 0.05)

        let region = MKCoordinateRegion(center: newLocation.coordinate, span: span)

        
        self.mapView.setRegion(region, animated: true)

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

    
    func initMapView(){
        
        // here
        let location = CLLocationCoordinate2D(
            latitude: 50.52373,
            longitude: 2.88157
        )
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    func distanceFilterDidChange(notification:NSNotification){
        
        if let info = notification.userInfo as? Dictionary<String,String> {
            var filterDistance = Double(info[kPAWFilterDistanceKey]!.toInt()!)

            if (_circleOverlay != nil){
                self.mapView.removeOverlay(_circleOverlay)
                _circleOverlay = nil
            }
            
            _circleOverlay = MKCircle(centerCoordinate: _currentLocation!.coordinate, radius: filterDistance)
            self.mapView.addOverlay(_circleOverlay)
            
            // Update our pins for the new filter distance:
            
            self.updatePostsForLocation(_currentLocation!, nearbyDistance: filterDistance)

            
            if (_mapPannedSinceLocationUpdate == true){
                var newRegion:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(_currentLocation!.coordinate,  filterDistance *
                    2.0,  filterDistance * 2.0)
                self.mapView.region = newRegion
                
                _mapPannedSinceLocationUpdate = false
            }
            else{
            
                 var currentRegion:MKCoordinateRegion = self.mapView.region
                var newRegion:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(currentRegion.center,  filterDistance *
                    2.0,  filterDistance * 2.0)
                
                
                
                var oldMapPannedValue : Bool = _mapPannedSinceLocationUpdate
                self.mapView.setRegion(newRegion, animated: true)
                _mapPannedSinceLocationUpdate = oldMapPannedValue
            }
        }
        
    /*
        CLLocationAccuracy filterDistance = [[note userInfo][kPAWFilterDistanceKey] doubleValue];
        
        if (self.circleOverlay != nil) {
        [self.mapView removeOverlay:self.circleOverlay];
        self.circleOverlay = nil;
        }
        self.circleOverlay = [MKCircle circleWithCenterCoordinate:self.currentLocation.coordinate radius:filterDistance];
        [self.mapView addOverlay:self.circleOverlay];
        
        // Update our pins for the new filter distance:
        [self updatePostsForLocation:self.currentLocation withNearbyDistance:filterDistance];
        
        // If they panned the map since our last location update, don't recenter it.
        if (!self.mapPannedSinceLocationUpdate) {
        // Set the map's region centered on their location at 2x filterDistance
        MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, filterDistance * 2.0f, filterDistance * 2.0f);
        
        [self.mapView setRegion:newRegion animated:YES];
        self.mapPannedSinceLocationUpdate = NO;
        } else {
        // Just zoom to the new search radius (or maybe don't even do that?)
        MKCoordinateRegion currentRegion = self.mapView.region;
        MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(currentRegion.center, filterDistance * 2.0f, filterDistance * 2.0f);
        
        BOOL oldMapPannedValue = self.mapPannedSinceLocationUpdate;
        [self.mapView setRegion:newRegion animated:YES];
        
*/
    }
    
    func updatePostsForLocation(currentLocation:CLLocation, nearbyDistance:CLLocationAccuracy){
    
        
        
        for(index, post) in enumerate(_allPosts){
        
            
            var objectLocation : CLLocation = CLLocation(latitude: post.coordinate.latitude, longitude: post.coordinate.longitude)
            
            var distanceFromCurrent : CLLocationDistance = currentLocation.distanceFromLocation(objectLocation)
            
            if (distanceFromCurrent > nearbyDistance){
                post.setTitleAndSubtitleOutsideDistance(true)
                
                //(self.mapView.viewForAnnotation(post) as MKPinAnnotationView).pinColor = post.pinColor
            }
            else{
                post.setTitleAndSubtitleOutsideDistance(false)
                //(self.mapView.viewForAnnotation(post) as MKPinAnnotationView).pinColor = post.pinColor
            }
        
            /*
            CLLocationDistance distanceFromCurrent = [currentLocation distanceFromLocation:objectLocation];
            if (distanceFromCurrent > nearbyDistance) { // Outside search radius
            [post setTitleAndSubtitleOutsideDistance:YES];
            [(MKPinAnnotationView *)[self.mapView viewForAnnotation:post] setPinColor:post.pinColor];
            } else {
            [post setTitleAndSubtitleOutsideDistance:NO]; // Inside search radius
            [(MKPinAnnotationView *)[self.mapView viewForAnnotation:post] setPinColor:post.pinColor];
            }
            */
        }
    }
    /*
    // When we update the search filter distance, we need to update our pins' titles to match.
    - (void)updatePostsForLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy) nearbyDistance {
    for (PAWPost *post in _allPosts) {
    CLLocation *objectLocation = [[CLLocation alloc] initWithLatitude:post.coordinate.latitude
    longitude:post.coordinate.longitude];
    
    // if this post is outside the filter distance, don't show the regular callout.
    CLLocationDistance distanceFromCurrent = [currentLocation distanceFromLocation:objectLocation];
    if (distanceFromCurrent > nearbyDistance) { // Outside search radius
    [post setTitleAndSubtitleOutsideDistance:YES];
    [(MKPinAnnotationView *)[self.mapView viewForAnnotation:post] setPinColor:post.pinColor];
    } else {
    [post setTitleAndSubtitleOutsideDistance:NO]; // Inside search radius
    [(MKPinAnnotationView *)[self.mapView viewForAnnotation:post] setPinColor:post.pinColor];
    }
    }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
