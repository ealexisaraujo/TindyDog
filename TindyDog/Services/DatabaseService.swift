//
//  DatabaseService.swift
//  TindyDog
//
//  Created by Enrique Alexis Lopez Araujo on 08/03/18.
//  Copyright © 2018 alexisaraujo. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE_ROOT = Database.database().reference()

class DatabaseService{
    static let instance = DatabaseService()
    
    private let _Base_Ref = DB_BASE_ROOT
    private let _User_Ref = DB_BASE_ROOT.child("users")
    
    var Base_Ref: DatabaseReference{
        return _Base_Ref
    }
    
    var User_Ref: DatabaseReference{
        return _User_Ref
    }
    
    func observeUserProfile(handler: @escaping(_ userProfileDict: UserModel?) -> Void){
        if let currentUser = Auth.auth().currentUser{
            DatabaseService.instance.User_Ref.child(currentUser.uid).observe(.value, with: { (snapshot) in
                if let userDict = UserModel(snapshot: snapshot){
                    handler(userDict)
                }
            })
        }
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, Any>) {
        User_Ref.child(uid).updateChildValues(userData)
    }
}
