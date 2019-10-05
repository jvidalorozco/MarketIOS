//
//  Item.swift
//  Market
//
//  Created by Administrador on 10/4/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import UIKit

class Item {
    
    //MARK: Properties
    var id          :  String!
    var categoryId  :  String!
    var name        :  String!
    var description :  String!
    var price       :  Double!
    var imageLinks  :  [String]!
    
    init() {
        
    }
    //MARK: Init
    init(_ dictionary : NSDictionary) {
        
        id          = dictionary[kOBJECTID]    as?  String
        categoryId  = dictionary[kCATEGOTYID]  as?  String
        name        = dictionary[kName]        as?  String
        description = dictionary[kDESCRIPTION] as?  String
        price       = dictionary[kPRICE]       as?  Double
        imageLinks  = dictionary[kIMAGELINKS]  as? [String]
 
    }
}

//MARK: Save items
func saveItemToFirestore(_ item : Item){
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String : Any])
}

//MARK: Helper functions
func itemDictionaryFrom(_ item: Item) -> NSDictionary{
    return NSDictionary(objects: [
        item.id,item.categoryId,item.name,
        item.description,item.price,item.imageLinks
    ], forKeys: [kOBJECTID as NSCopying,kCATEGOTYID as NSCopying,kName as NSCopying ,kDESCRIPTION as NSCopying,kPRICE as NSCopying,kIMAGELINKS as NSCopying])
}