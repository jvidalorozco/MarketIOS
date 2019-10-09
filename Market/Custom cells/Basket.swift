//
//  Basket.swift
//  Market
//
//  Created by jorge on 7/10/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation

class Basket {
    
    var id       : String!
    var ownerId  : String!
    var itemIds  : [String]!
    
    init() {
        
    }
    
    
    init(_dictionary : NSDictionary) {
        id      = _dictionary[kOBJECTID] as? String
        ownerId = _dictionary[kOWNERID]  as? String
        itemIds = _dictionary[kITEMSIDS] as? [String]
        
    }
}

//MARK: Download items
func downloadBasketFromFirestore(_ ownerId: String, completion: @escaping(_ basket: Basket?)-> Void){
    FirebaseReference(.Basket).whereField(kOWNERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else{
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        }else{
            completion(nil)
        }
    }
}


//MARK: Save to firebase
func saveBasketToFirestore(_ basket: Basket){
    FirebaseReference(.Basket).document(basket.id).setData(basketDictionaryFrom(basket) as! [String: Any])
}

//MARK: Helpers functions
func basketDictionaryFrom(_ basket : Basket) -> NSDictionary{
    return NSDictionary(objects: [basket.id, basket.ownerId, basket.itemIds],
                        forKeys: [kOBJECTID as NSCopying, kOWNERID as NSCopying, kITEMSIDS as NSCopying])
}

//MARK: -Update basket
func updateBasketInFirestore(_ basket: Basket, withValues: [String: Any], completion: @escaping(_ error: Error?)->Void){
    FirebaseReference(.Basket).document(basket.id).updateData(withValues) { (error) in
        if let error = error {
            completion(error)
        }
        
    }
    
}
