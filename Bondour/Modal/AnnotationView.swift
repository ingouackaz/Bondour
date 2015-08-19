//
//  AnnotationView.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-07.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit


var CORNER_RADIUS : CGFloat = 20.0
var PADDING : CGFloat = 10.0
var BG_ALPHA : CGFloat = 0.5


class AnnotationView: UIView {

    
    init(title: String) {
        
        super.init(frame: CGRectZero)
        


    }
    
    override func calculateFrameForString(title:String, forFont font:UIFont)->CGRect{
    
        var size:CGSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)

        var frame : CGRect =  (title as NSString).boundingRectWithSize(size, options: NSStringDrawingOptions.UsesFontLeading | NSStringDrawingOptions.UsesDeviceMetrics, attributes: [NSFontAttributeName:font], context: nil)
        
        frame.origin.y = 0 - frame.size.height - PADDING
        frame.size.height += PADDING
        frame.size.width += PADDING

        println("frame calculated \(frame)")
        
        
        return frame
        

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
