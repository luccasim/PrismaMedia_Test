//
//  UserView.swift
//  PrismaMedia_SwiftUI
//
//  Created by owee on 09/11/2020.
//

import SwiftUI

struct UserView: View {
    
    @ObservedObject var userRequest : UserRequest
    
    var body: some View {
        HStack {
            Image(uiImage: userRequest.avatar)
            Text(userRequest.fullName)
            Text(userRequest.email)
            Text("Modifier")
        }.onAppear() {
            self.userRequest.fetchUser()
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(userRequest: UserRequest())
    }
}
