//
//  MUser.swift
//  Market
//
//  Created by jorge on 10/10/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import FirebaseAuth

class MUser{
    
    let objectId          : String
    let email             : String
    var firstName         : String
    var lastName          : String
    var fullName          : String
    var purcharsedItemIds : [String]
    var fullAddress       : String
    var onBoard           : Bool
    
    
    //MARK: - Initializers
    init(_objectId: String, _email: String, _firstName: String, _lastName: String) {
        self.objectId          = _objectId
        self.email             = _email
        self.firstName         = _firstName
        self.lastName          = _lastName
        self.fullName          = _firstName+" "+lastName
        self.fullAddress       = ""
        self.onBoard           = false
        self.purcharsedItemIds = []
    }
    
    init(_dictionary: NSDictionary) {
        self.objectId          = _dictionary[kOBJECTID] as! String
        self.email             = _dictionary[kEMAIL]    as! String
        self.firstName         = _dictionary[kFIRSTNAME] as! String
        self.lastName          = _dictionary[kLASTNAME] as! String
        self.fullName          = _dictionary[kFULLNAME] as! String
        self.fullAddress       = _dictionary[kFULLADDRESS] as! String
        self.onBoard           = _dictionary[kONBOARD] as! Bool
        self.purcharsedItemIds = _dictionary[kPURCHARSEDITEMIDS] as! [String]
      
    }
    
    
    //MARK: - Return current user
    
    class func currentId() -> String{
        return Auth.auth().currentUser?.uid ?? "Not user"
    }
    
    class func currentUser() -> MUser? {
        if Auth.auth().currentUser != nil{
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER){
                return MUser(_dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }

    
    
}
