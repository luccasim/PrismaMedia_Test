//
//  PrismaMedia_SwiftUIApp.swift
//  PrismaMedia_SwiftUI
//
//  Created by owee on 09/11/2020.
//

import SwiftUI

@main
struct PrismaMedia_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            UserView().environmentObject(UserRequest())
        }
    }
}
