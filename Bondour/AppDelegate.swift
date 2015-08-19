//
//  AppDelegate.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-01.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit
import CoreData
import Bolts
import Parse
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------


    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
  
        self.configureParse(launchOptions)
       // self.configurePushNotification(application)
       // self.configureInstallation()
        
       var sgl  = Bondour.sharedInstance
        
        sgl._lmManager.displayNameItemsView()
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var loginNC = storyboard.instantiateViewControllerWithIdentifier("loginNC") as! UINavigationController
        
        
        if(PFUser.currentUser() != nil){
            self.window!.rootViewController = storyboard.instantiateInitialViewController() as! UINavigationController
        }
        else{
            
            self.window!.rootViewController = loginNC
        }
        
        return true
    }
    
    func configureParse(launchOptions: [NSObject: AnyObject]?){
        Parse.enableLocalDatastore()
        
        
        // ****************************************************************************
        // Uncomment this line if you want to enable Crash Reporting
        // ParseCrashReporting.enable()
        //
        // Uncomment and fill in with your Parse credentials:
        Parse.setApplicationId("uNbLHoKkTatsam5x261472JVdEcPQ1oKuAQV8KQ1", clientKey: "egmnSu2cOQzOaeRIe6UBvqiJWYqSSfq9ZHx5ueqA")
        
        
        // loginNC
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)

        var userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(PAWUserDefaultsFilterDistanceKey) == nil){
            userDefaults.setDouble(PAWFeetToMeters(PAWDefaultFilterDistance), forKey: PAWUserDefaultsFilterDistanceKey)
        }
  
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            PFUser.logInWithUsername("Simulator", password: "commeca")
        #endif

        println("curr user \(PFUser.currentUser())")
        
        let defaultACL = PFACL();
        
        UIPageControl.appearance().backgroundColor = UIColor.clearColor()
        // If you would like all objects to be private by default, remove this line.
        defaultACL.setPublicReadAccess(true)
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
        


    }
    
    
    
    func configureInstallation(){
        
        let installation = PFInstallation.currentInstallation()
        //installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
        
        
        if (PFUser.currentUser() != nil){
            let installation = PFInstallation.currentInstallation()
            installation["user"] = PFUser.currentUser()
            installation.saveInBackground()            
        }
        
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    // 1 fois par jour par message
    
    
    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------
    
    func configurePushNotification(application: UIApplication){
        var notificationSettings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound, categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
       application.registerForRemoteNotifications()
    
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()


        installation.setDeviceTokenFromData(deviceToken)

        PFPush.storeDeviceToken(deviceToken)
        installation.saveInBackground()

    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        println("Went to Background");
        // Need to stop regular updates first
        // Only monitor significant changes
    }
    

    func applicationWillEnterForeground(application: UIApplication) {
        
    }
    
    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //     if application.applicationState == UIApplicationState.Inactive {
    //         PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    //     }
    // }
    
    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------
    
    ///////////////////////////////////////////////////////////
    // Uncomment this method if you are using Facebook
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    //     return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, session:PFFacebookUtils.session())
    // }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ingouackaz.Bondour" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Bondour", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Bondour.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

