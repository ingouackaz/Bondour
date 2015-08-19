//
//  PAWPost.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-01.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit
import MapKit
import Parse

class PAWPost: NSObject {
   
    
    var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title : String = ""
    var subtitle  : String = ""
    var object : PFObject?
    var user : PFUser = PFUser()
    var animatesDrop : Bool = false
    var pinColor: MKPinAnnotationColor = MKPinAnnotationColor(rawValue: 0)!

    override init() {
        super.init()
    }

    convenience init(coordinate:CLLocationCoordinate2D, title:String, subtitle:String){
        self.init()
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
    }
    
    convenience init(object:PFObject){
        
        self.init()
        
        
        var geoPoint: PFGeoPoint = object[PAWParsePostLocationKey] as! PFGeoPoint
        var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude)
        var title: String = object[PAWParsePostTextKey] as! String
        var subtitle =  "toto"
        
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        

    }
    
    override func isEqual(object: AnyObject?) -> Bool {

        /*
        if((!object!.isKindOfClass(PAWPost)) != nil){
            return false
        }

        
        var post = object as! PAWPost
        if(post.object && self.object){
            
            return (post.object.objectId == self.object.objectId)
        }
        
        */
        if (object != nil && object!.isKindOfClass(PAWPost)){
            return false
        }
        
        var post : PAWPost = (object as! PAWPost)

        if(post.object != nil && self.object != nil){
        
            if (post.object?.objectId == self.object?.objectId){
                return true
            }
            else{
                return false
            }
        }
        
        return (post.title == title && post.coordinate.latitude == self.coordinate.latitude && post.coordinate.longitude == post.coordinate.longitude)
    }
    
    
    func setTitleAndSubtitleOutsideDistance(outside:Bool){
    
        if(outside == true){
            self.title =  kPAWWallCantViewPost
            self.subtitle = ""
            self.pinColor = MKPinAnnotationColor.Red
        }
        else{

            self.object!.objectForKey("PAWParsePostUserKey")!.objectForKey("PAWParsePostUsernameKey")
            self.pinColor = MKPinAnnotationColor.Green;
        }
    }
    /*
    @property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;
    
    // @optional
    // Title and subtitle for use by selection UI.
    @property (nonatomic, copy, readonly) NSString *title;
    @property (nonatomic, copy, readonly) NSString *subtitle;
    // @end
    
    // Other properties:
    @property (nonatomic, strong, readonly) PFObject *object;
    @property (nonatomic, strong, readonly) PFUser *user;
    @property (nonatomic, assign) BOOL animatesDrop;
    @property (nonatomic, assign, readonly) MKPinAnnotationColor pinColor;
    */
}
