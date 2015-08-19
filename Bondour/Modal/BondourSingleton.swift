//
//  BondourSingleton.swift
//  Bondour
//
//  Created by Ingouackaz on 2015-07-08.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

private let _BondourSharedInstance = Bondour()


class Bondour  {
    
    var _currentUserItemView : LMSpringboardItemView?
    
    var _lmManager : LMManager = LMManager()
    class var sharedInstance : Bondour {
        return _BondourSharedInstance
    }
    
    
    init(){
        
    }
    //LMSpringboardItemView = LMSpringboardItemView()
    
    
}