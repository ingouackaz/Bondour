//
//  NewGroupTVC.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-09.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class NewGroupTVC: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var _usersFounded : Array<PFUser> = []

    
    var _titleGroupTextField : UITextField?
    var _selectedImage : UIImage = UIImage(named: "icon7")!
    var _addImageButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if (section == 0){
            return 1

        }
        
        else{
            return 1 + _usersFounded.count
        }
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!

        if (cell.accessoryType == UITableViewCellAccessoryType.Checkmark){
            cell.accessoryType =  UITableViewCellAccessoryType.None

        }
        else{
            cell.accessoryType =  UITableViewCellAccessoryType.Checkmark

        }
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("NewGroupName", forIndexPath: indexPath) as! NewGroupNameCell
            
           _titleGroupTextField =  cell.titleGroupTextField
            _addImageButton = cell.addCoverImageButton
            cell.addCoverImageButton.addTarget(self, action: "addImage", forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        }
        
        if (indexPath.section == 1 && indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("NewGroupSearch", forIndexPath: indexPath) as! NewGroupSearchCell
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("NewGroupDetail", forIndexPath: indexPath) as! NewGroupDetailCell
            
            var object = _usersFounded[indexPath.row-1]
            cell.configureCellWith(object)
            return cell
        }

    }
    
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    @IBAction func leaveAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    
    func addImage(){
        let imageController = UIImagePickerController()
        //imageController.editing = false
        imageController.delegate = self;
        
        let alert = UIAlertController(title: "Lets get a picture", message: "Simple Message", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.Default) { (alert) -> Void in
 
            self.openGallary()
        }
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (alert) -> Void in
                println("Take Photo")
                self.openGallary()

            }
            
            alert.addAction(cameraButton)
        } else {
            println("Camera not available")
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
            println("Cancel Pressed")
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)

        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    @IBAction func doneAction(sender: AnyObject) {
        
        if (_titleGroupTextField!.text != ""){
            self.startCreateGroupRequest()
        }
        else{
            
            self.displayAlertWithText("Veuillez le nom de votre nouveau groupe")
        }
    }


    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField.tag == 0){
            textField.resignFirstResponder()
            textField.text = textField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            if(textField.text != ""){
                var query : PFQuery = PFUser.query()!
               
                query.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)
                query.whereKey("name", matchesRegex: textField.text, modifiers: "i")
                println("search [\(textField.text)]")
                query.findObjectsInBackgroundWithBlock ({(objects:[AnyObject]?, error: NSError?) in
                    if(error == nil){
                        self._usersFounded.removeAll(keepCapacity: false)
                        println("count research \(objects!.count)")
                        for object in objects! {
                            
                            self._usersFounded.append(object as! PFUser)
                        }
                        self.tableView.reloadData()
                    }
                    else{
                        println("Error in retrieving \(error)")
                    }
                    println("ended")
                })
            }
            
            return true
        }
        else {
         //   _titleGroupTextField = textField.text
            
            return true
        }
    }

    
    func openGallary()
    {
        var picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        
        var img = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        _selectedImage = img!.resizedImageToFitInSize(CGSize(width: 300, height: 300), scaleIfSmaller: true)
        
        _addImageButton?.setImage(_selectedImage, forState: UIControlState.Normal)
        
        _addImageButton?.layer.masksToBounds = true
        _addImageButton?.layer.cornerRadius = 10
        picker.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func startCreateGroupRequest(){
    

        var imageData =  UIImageJPEGRepresentation(_selectedImage, 0.7)
        
        
        var pictureFile = PFFile(data:imageData)
        
        
        var newGroup : PFObject = PFObject(className: kBGroupClassNameKey)
        newGroup.setObject(PFUser.currentUser()!, forKey: kBGroupOwnerKey)
        newGroup.setObject(pictureFile, forKey: kBGroupIconKey)
        newGroup.setObject(_titleGroupTextField!.text, forKey: kBGroupNameKey)

        newGroup.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            
            if(succeeded == true){
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
            else{
                self.displayAlertWithText("Erreur lors de la création du groupe.")
            }
        }
    }
    
    
    
    func displayAlertWithText(text:String){
        let myAlert: UIAlertController = UIAlertController(title: "Erreur", message:text,
            preferredStyle: .Alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

}
