//
//  Item.swift
//  Market
//
//  Created by Administrador on 10/4/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchClient

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


//MARK: Download Func
func downloadItemsFromFirebase(_ withCategoryId : String, completion: @escaping(_ itemsArray: [Item])->Void){
    var itemArray: [Item] = []
    FirebaseReference(.Items).whereField(kCATEGOTYID, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
      
        if error != nil {
            completion(itemArray)
            print("Error ha ocurrido", error?.localizedDescription ?? "Error")
            return
        }
        
        guard let snapshot = snapshot else { completion(itemArray);  return }
       
        if !snapshot.isEmpty{
            for itemDict in snapshot.documents {
                itemArray.append(Item(itemDict.data() as NSDictionary))
            }
        }
        completion(itemArray)
    }
}


func downloadItems(_ withIds: [String], completion: @escaping(_ itemArray: [Item])->Void){
    
    var count = 0
    var itemArray: [Item] = []
    
    if withIds.count > 0 {
        for itemId in withIds {
            FirebaseReference(.Items).document(itemId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else{
                    completion(itemArray)
                    return
                }
                if snapshot.exists {
                    itemArray.append(Item(snapshot.data()! as NSDictionary))
                    count += 1
                }else{
                    completion(itemArray)
                }
                
                if count == withIds.count {
                               completion(itemArray)
                }
            }
           
        }
    }else{
        completion(itemArray)
    }
   
}

//MARK: -Algolia funcs
  func saveItemToAlgolia(item: Item){
      
      let index = AlgoliaService.shared.index
      let itemToSave = itemDictionaryFrom(item) as! [String: Any]
      
      index.addObject(itemToSave, withID: item.id, requestOptions: nil) { (content, error) in
          
          if error != nil {
              print("error saving to algolia",error!.localizedDescription)
          }else{
              print("added to algolia")
          }
          
      }
  }
  

func searchAlgolia(searchString: String, completion: @escaping(_ itemarray: [String])->Void){
    
    let index = AlgoliaService.shared.index
    var resultIds: [String] = []
    let query = Query(query: searchString)
    query.attributesToRetrieve = ["name","description"]
    
    index.search(query) { (content, error) in
        if error == nil {
            let cont = content!["hits"] as! [[String: Any]]
            resultIds = []
            
            for result in cont {
                resultIds.append(result["objectID"] as! String)
            }
            
            completion(resultIds)
        }else{
            print("Error algolia search", error!.localizedDescription)
            completion(resultIds)
        }
    }
}

