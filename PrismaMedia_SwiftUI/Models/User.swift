//
//  User.swift
//  PrismaMedia_SwiftUI
//
//  Created by owee on 09/11/2020.
//

import Foundation

// This Model is not used (Because no presence of Persistance or Collection)
struct User : Identifiable {
    let id : Int
    let fullname : String
    let email : String
    let avatar : String
}
