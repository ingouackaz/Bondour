//
//  Constant.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-01.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class Constant: NSObject {
   
}

 func PAWFeetToMeters(feet:Double)->Double{
    return feet * 0.3048
}

func PAWMetersToFeet(meters:Double)->Double{
    return meters * 3.281
}

func PAWMetersToKilometers(meters:Double)->Double{
    return meters * 1000.0
}


let PAWDefaultFilterDistance = 1000.0
let PAWWallPostMaximumSearchDistance = 100.0
let PAWWallPostsSearchDefaultLimit = 20

// Parse API key constants:


let PAWParsePostsClassName = "Posts"
let PAWParsePostUserKey = "user"
let PAWParsePostUsernameKey = "username"
let PAWParsePostTextKey = "text"
let PAWParsePostLocationKey = "location"
let PAWParsePostNameKey = "name"

// NSNotification userInfo keys:

let kPAWFilterDistanceKey = "filterDistance"
let kPAWLocationKey = "location"

// Notification names:

let PAWFilterDistanceDidChangeNotification = "PAWFilterDistanceDidChangeNotification"
let PAWCurrentLocationDidChangeNotification = "PAWCurrentLocationDidChangeNotification"
let PAWPostCreatedNotification = "PAWPostCreatedNotification"

// UI strings:
let kPAWWallCantViewPost = "Can’t view post! Get closer."

// NSUserDefaults
let PAWUserDefaultsFilterDistanceKey = "filterDistance"

typealias PAWLocationAccuracy = Double



let   PAWUserLocationKey = "location"

// Groupe

let  kBGroupClassNameKey = "Group"

let  kBGroupNameKey = "name"

let  kBGroupOwnerKey = "owner"
let  kBGroupIconKey = "icon"
let  kBGroupUserKey = "users"

/*
static double PAWFeetToMeters(double feet) {
return feet * 0.3048;
}

static double PAWMetersToFeet(double meters) {
return meters * 3.281;
}

static double PAWMetersToKilometers(double meters) {
return meters / 1000.0;
}

static double const PAWDefaultFilterDistance = 1000.0;
static double const PAWWallPostMaximumSearchDistance = 100.0; // Value in kilometers

static NSUInteger const PAWWallPostsSearchDefaultLimit = 20; // Query limit for pins and tableviewcells

// Parse API key constants:
static NSString * const PAWParsePostsClassName = @"Posts";
static NSString * const PAWParsePostUserKey = @"user";
static NSString * const PAWParsePostUsernameKey = @"username";
static NSString * const PAWParsePostTextKey = @"text";
static NSString * const PAWParsePostLocationKey = @"location";
static NSString * const PAWParsePostNameKey = @"name";

// NSNotification userInfo keys:
static NSString * const kPAWFilterDistanceKey = @"filterDistance";
static NSString * const kPAWLocationKey = @"location";

// Notification names:
static NSString * const PAWFilterDistanceDidChangeNotification = @"PAWFilterDistanceDidChangeNotification";
static NSString * const PAWCurrentLocationDidChangeNotification = @"PAWCurrentLocationDidChangeNotification";
static NSString * const PAWPostCreatedNotification = @"PAWPostCreatedNotification";

// UI strings:
static NSString * const kPAWWallCantViewPost = @"Can’t view post! Get closer.";

// NSUserDefaults
static NSString * const PAWUserDefaultsFilterDistanceKey = @"filterDistance";

typedef double PAWLocationAccuracy;

#endif // Anywall_PAWConstants_h
*/