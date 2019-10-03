//
//  FirebaseCollectionReference.swift
//  Market
//
//  Created by Administrador on 10/3/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference : String {
    case User
    case Category
    case Items
    case Basket
}

func FirebaseReference(_ collectionReference : FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}
