//
//  NewGroupDetailCell.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-09.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class NewGroupDetailCell: UITableViewCell {

    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var photoImage: UIImageView!
    
    
    
    func configureCellWith(object:PFObject){
    
        //var fname  = (object.objectForKey("firstname") as? String)
        var lname  = (object.objectForKey("name") as? String)
        
        
        self.nameLabel.text = lname
        
        if (object.objectForKey("profileImage") != nil){
            var file = object.objectForKey("profileImage") as! PFFile
            
            file.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.photoImage.image = UIImage(data:imageData!)
                }
                
            })
        }
        else{
            self.photoImage.image = UIImage(named: "icon7")
            
        }
    }
}
