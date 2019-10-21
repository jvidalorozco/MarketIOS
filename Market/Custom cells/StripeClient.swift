//
//  StripeClient.swift
//  Market
//
//  Created by MacBook Pro on 10/20/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class StripeClient {
    
    static let sharedClient  = StripeClient()
    var baseURLString: String? = nil
    
    var baseURL : URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString){
            return url
        }else{
           fatalError()
        }
    }
    
    func createAndConfirmPayment(_ token: STPToken, amount: Int, completion: @escaping(_ error: Error?)->Void){
        let url = self.baseURL.appendingPathComponent("charge")
        let params: [String : Any] = ["stripeToken" : token.tokenId, "amount" : amount, "description" : Constants.defaultDescription, "currency" : Constants.defaultCurrency]
        
        Alamofire.request(url, method: .post, parameters: params).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
            
            switch response.result {
                
            case .success( _) :
                print("Pago exitoso")
                completion(nil)
                
            case .failure(let error):
                print("Error en el pago", error.localizedDescription)
                
            }
            
        })
    }
}

