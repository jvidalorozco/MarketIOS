//
//  AlgoliaService.swift
//  Market
//
//  Created by Administrador on 10/15/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import InstantSearchClient

class AlgoliaService {
    
    static let shared = AlgoliaService()
    let client = Client(appID: kALGOLIA_APP_ID, apiKey: kALGOLIA_SEARCH_KEY)
    let index  = Client(appID: kALGOLIA_APP_ID, apiKey: kALGOLIA_ADMIN_KEY).index(withName: "Dev_Market")
    
    private init (){
        
    }
    
}


