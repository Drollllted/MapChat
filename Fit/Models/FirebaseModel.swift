//
//  SignInModel.swift
//  Fit
//
//  Created by Drolllted on 28.08.2025.
//

import Foundation
import FirebaseAuth

struct FirebaseModel: Codable {
    var uid: String
    var email: String?
    var fullName: String?
    var nameTag: String?
    var imageURL: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.fullName = user.displayName ?? ""
        //self.nameTag = user.
        self.imageURL = user.photoURL?.description
    }
}
