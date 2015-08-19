//
//  LMManager.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-10.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

protocol LMManagerDelegate{
    func groupsUpdated()
    func usersUpdated()
}


class LMManager {
   
    var _names : [String] = ["Lucas", "Marie", "Henry", "Jean", "Lea","Celine", "Karima", "Mohamed", "Karim", "Latifa", "Esmiralda"]
    var clipPath : UIBezierPath = UIBezierPath(ovalInRect: CGRectInset(CGRectMake(0, 0, LMSizeIconObjC, LMSizeIconObjC), 0.5, 0.5))
    var images : [UIImage] = [UIImage(named: "icon7")!, UIImage(named: "icon8")!, UIImage(named: "icon8")!, UIImage(named: "icon8")!]
    var titles : [String] = ["","","", ""]
    var lmGroupsItems : [LMSpringboardItemView] = []
    var lmSelectedGroupObject : PFObject?
    var lmSelectedGroupUsersItems : [LMSpringboardItemView] = []

    
    
    var delegate:LMManagerDelegate? = nil

     init() {

        var itemsArray : [LMSpringboardItemView] = []

        itemsArray = self.fixWithNativeItems(itemsArray)
        self.lmSelectedGroupUsersItems  = itemsArray
        self.lmGroupsItems = itemsArray
        //self.displayNameItemsView(itemsArray)
    }
    
    func updateGroups(){
    
        self.updateGroupsCurrentUser()
    }
    
    
    func addNewItem(){
    
        
    }
    
    func didDeletetBat(){

    }
    
    func fixWithNativeItems(items : [LMSpringboardItemView]) ->  [LMSpringboardItemView] {
    
        
        var itemsArray : [LMSpringboardItemView] = items
        // clean array
        var indexToRemove : [Int] = []
        
        
        itemsArray = itemsArray.filter( { m in m.tag != 2})
        
        // check if added needed
        var min : Int = 4 - itemsArray.count
        if (min > 0){
            var nativeItems = self.loadNativeItems(min)
            
            println(" items : \(itemsArray.count)  need : \(min) native )")
            itemsArray = nativeItems + itemsArray
            println("after added native : \(itemsArray.count) ")
        }
        
        return itemsArray
        
    }
    
    

    
    func createItemForGroup(group:PFObject)->LMSpringboardItemView{
        
        println("group info \(group)")
        
        var file =  group.objectForKey("icon") as! PFFile
        var name = group.objectForKey("name") as! String
        var groupItem : LMSpringboardItemView = LMSpringboardItemView()
        groupItem.setTitle(name)
        groupItem.objectId = group.objectId
        groupItem.object = group
        
        // user
        file.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if (data != nil){
                let image = UIImage(data:data!)
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(LMSizeIconObjC, LMSizeIconObjC), false, UIScreen.mainScreen().scale)
                
                self.clipPath.addClip()
                image!.drawInRect(CGRectMake(0, 0, LMSizeIconObjC, LMSizeIconObjC))
                
                var renderedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                groupItem.icon.image = renderedImage
            }
            else{
                let image = UIImage(named: "icon7")!
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(LMSizeIconObjC, LMSizeIconObjC), false, UIScreen.mainScreen().scale)
                
                self.clipPath.addClip()
                image.drawInRect(CGRectMake(0, 0, LMSizeIconObjC, LMSizeIconObjC))
                
                var renderedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                groupItem.icon.image = renderedImage
            }        }, progressBlock: nil)
        
        return groupItem
        
        
    }
    
    func createItemFromUser(user:PFUser)->LMSpringboardItemView{
        
        var name = user.objectForKey("name") as! String
        var userItem : LMSpringboardItemView = LMSpringboardItemView()
        userItem.setTitle(name)
        let image = UIImage(named: "icon7")!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(LMSizeIconObjC, LMSizeIconObjC), false, UIScreen.mainScreen().scale)
        
        self.clipPath.addClip()
        image.drawInRect(CGRectMake(0, 0, LMSizeIconObjC, LMSizeIconObjC))
        
        var renderedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        userItem.icon.image = renderedImage
        
        /*
        user.fetchIfNeededInBackgroundWithBlock { (object, error) -> Void in
            var file =  object!.objectForKey("profileImage") as! PFFile
            // user
            file.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if (data != nil){
                    let image = UIImage(data:data!)
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(LMSizeIconObjC, LMSizeIconObjC), false, UIScreen.mainScreen().scale)
                    
                    self.clipPath.addClip()
                    image!.drawInRect(CGRectMake(0, 0, LMSizeIconObjC, LMSizeIconObjC))
                    
                    var renderedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
                    
                    UIGraphicsEndImageContext()
                    userItem.icon.image = renderedImage
                    
                }
                else{
                    let image = UIImage(named: "icon7")!
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(LMSizeIconObjC, LMSizeIconObjC), false, UIScreen.mainScreen().scale)
                    
                    self.clipPath.addClip()
                    image.drawInRect(CGRectMake(0, 0, LMSizeIconObjC, LMSizeIconObjC))
                    
                    var renderedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
                    
                    UIGraphicsEndImageContext()
                    userItem.icon.image = renderedImage
                }
                // #notification userAdded
                
                }
                , progressBlock: nil)
        }*/

        
        return userItem
    }
    
    
    
    func loadNativeItems(count:Int)->[LMSpringboardItemView]{
        var nativeItems : [LMSpringboardItemView] = []
        for i in 0 ..< count  {
            
            let image = images[i]
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(LMSizeIconObjC, LMSizeIconObjC), false, UIScreen.mainScreen().scale)
            
            clipPath.addClip()
            image.drawInRect(CGRectMake(0, 0, LMSizeIconObjC, LMSizeIconObjC))
            
            var renderedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            var mascotteItem : LMSpringboardItemView = LMSpringboardItemView()
            mascotteItem.setTitle(titles[i])
            mascotteItem.icon.image = renderedImage
            mascotteItem.tag = 2
            mascotteItem.hidden = true
            nativeItems.append(mascotteItem)
        }
        
        nativeItems.last?.hidden = true
        return nativeItems
    }
    
    
    func groupsUpdateIfNeeded() {

        var newGroupQuery : PFQuery = PFQuery(className: kBGroupClassNameKey)
        newGroupQuery.whereKey(kBGroupOwnerKey, equalTo: PFUser.currentUser()!)
        newGroupQuery.orderByDescending("createdAt")
        newGroupQuery.limit = 1
        newGroupQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil){
                var object = objects?.first
                
                // same lastUpdate
                println("last local obj id \(self.lmGroupsItems.last!.objectId) && last up obj \(object!.objectId!)")
                // cache
                if (self.lmGroupsItems.last?.objectId != nil && object!.objectId! != self.lmGroupsItems.last!.objectId || self.lmGroupsItems.last?.objectId == nil){
                    
                    self.updateGroupsCurrentUser()
                }
            }
        }
        
    }
    
    
    func updateGroupsCurrentUser(){
        
        var itemsArray : [LMSpringboardItemView] = []
        var newGroupQuery : PFQuery = PFQuery(className: kBGroupClassNameKey)
        println("afarray count \(itemsArray.count)")
 
        var currentUserItem : LMSpringboardItemView = self.createItemFromUser(PFUser.currentUser()!)
        itemsArray.append(currentUserItem)
        println("bfarray count \(itemsArray.count)")

        newGroupQuery.whereKey(kBGroupOwnerKey, equalTo: PFUser.currentUser()!)
        newGroupQuery.orderByDescending("createdAt")
        newGroupQuery.findObjectsInBackgroundWithBlock { (groups, error) -> Void in
            if (error == nil){
                for group in groups! {
                    var newGroup = self.createItemForGroup(group as! PFObject)
                    itemsArray.append(newGroup)
                }
                
                // a la fin on update le manager et on notifie
                
                itemsArray = self.fixWithNativeItems(itemsArray)
                self.lmGroupsItems = itemsArray
                println("after update gorups")
                if (self.delegate != nil){
                    
                    self.delegate!.groupsUpdated()
                }
                // #notification groupsAdded
            }
        }
    }
    
    func updateUsersFromCurrentGroup(){
        
        
        if (lmSelectedGroupObject != nil){
        
            lmSelectedGroupObject!.fetchIfNeededInBackgroundWithBlock({ (object, error) -> Void in
                
                println("error \(error) obj \(object)")
                if (error == nil){
                    var itemsArray : [LMSpringboardItemView] = []
                    
                    if (object!.objectForKey("users") as? [PFObject] != nil){
                        var users : [PFUser] = object!.objectForKey("users") as! [PFUser]
                        println("count users \(users.count)")
                        for user in users {
                            var newUser = self.createItemFromUser(user)
                            itemsArray.append(newUser)
                            println("toto!!!!")

                        }
                        
                        
                        
                        itemsArray = self.fixWithNativeItems(itemsArray)
                        
                        self.lmSelectedGroupUsersItems = itemsArray
                        println("after update gorups")
                        
                        if (self.delegate != nil){
                            
                            self.delegate!.usersUpdated()
                        }
                    }
                }
               
               
            })
        }
        
    }
    
    
    func displayNameItemsArray(array:[LMSpringboardItemView]){
        
        for (index, view) in enumerate(array){
            
            println("view name \((view as LMSpringboardItemView).objectId)")
        }
    }
    
    func displayNameItemsView(){
        
        for (index, view) in enumerate(self.lmGroupsItems){
            
            println("view name \((view as LMSpringboardItemView).label.text)")
        }
    }
    
}
