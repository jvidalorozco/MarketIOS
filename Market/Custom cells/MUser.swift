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

    //MARK: - Login func
    
    class func loginUserWith(email: String, password: String, completion: @escaping(_ error : Error?, _ isEmailVerified: Bool) ->Void){

        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error == nil{
                
                if authDataResult!.user.isEmailVerified {
                    downloadUserFromFirestore(userId: (authDataResult!.user.uid), email: email)
                    completion(error,true)
                }else{
                    print("Email is not verified")
                    completion(error,false)
                }
                
            }else{
                completion(error,false)
            }
        }
        
    }
    
//MARK: - Register user
    class func registerUserWith(email: String, password: String, completion: @escaping(_ error: Error?)-> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            completion(error)
            
            if error == nil {
                authDataResult!.user.sendEmailVerification { (error) in
                    print("auth email verificacion error: ", error?.localizedDescription)
                }
            }
        }
    }
//MARK: - Resend link methods
class func resetPasswordFor(email: String, completion: @escaping(_ error: Error?) -> Void){
    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
        completion(error)
    }
}
    
class func resendVerificationEmail(email: String , completion: @escaping(_ error: Error?) -> Void){
    Auth.auth().currentUser?.reload(completion: { (error) in
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            print("resend email error: ",error?.localizedDescription)
            completion(error)
        })
    })
}
    
}

//MARK: - DownloadUser
func downloadUserFromFirestore(userId: String, email: String){
    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
        
        guard let snapshot = snapshot else{ return}
        if snapshot.exists {
            print("download current user from firestore")
            saveUserLocally(mUserDictionary: snapshot.data()! as NSDictionary)
        }else{
            //there is no user, save new in firestore
            let user = MUser(_objectId: userId, _email: email, _firstName: "", _lastName: "")
            saveUserLocally(mUserDictionary: userDictionaryFrom(user: user))
            saveUserToFirestore(mUser: user)
        }
        
    }
   

}



//MARK: - Save user to firebase
func saveUserToFirestore(mUser: MUser){
    FirebaseReference(.User).document(mUser.objectId).setData(userDictionaryFrom(user: mUser) as! [String: Any]) { (error) in
        if error != nil {
            print("error saving user \(error!.localizedDescription)")
        }
    }
}

func saveUserLocally(mUserDictionary: NSDictionary){
    UserDefaults.standard.set(mUserDictionary, forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}

//MARK: - Helper function
func userDictionaryFrom(user: MUser) -> NSDictionary{
    return NSDictionary(objects: [user.objectId, user.email,user.firstName,user.lastName,user.fullName, user.fullAddress ?? "",user.onBoard], forKeys: [kOBJECTID as NSCopying,kEMAIL as NSCopying, kFIRSTNAME as NSCopying,kLASTNAME as NSCopying,kFULLNAME as NSCopying, kFULLADDRESS as NSCopying,kONBOARD as NSCopying])
}
