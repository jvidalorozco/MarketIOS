//
//  Category.swift
//  Market
//
//  Created by Administrador on 10/3/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import UIKit

class Category {
    
    var id        : String
    var name      : String
    var image     : UIImage?
    var imageName : String?
    
    init(_name: String, _imageName : String) {
        self.id           = ""
        self.name         = _name
        self.imageName    = _imageName
        self.image        = UIImage(named: _imageName)
    }
    
    init(_dictionary : NSDictionary) {
        self.id           = _dictionary["objectId"] as! String
        self.name         = _dictionary["name"]     as! String
        self.image    = UIImage(named: _dictionary["imageName"] as? String ?? "")
        
    }
    
}
