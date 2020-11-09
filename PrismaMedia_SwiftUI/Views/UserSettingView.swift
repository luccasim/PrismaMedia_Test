//
//  UserSettingView.swift
//  PrismaMedia_SwiftUI
//
//  Created by owee on 09/11/2020.
//

import SwiftUI

struct UserSettingView: View {
    
    @EnvironmentObject var userRequest : UserRequest
    @Environment(\.presentationMode) var presentation
    
    @State var fullName : String = ""
    @State var email : String = ""
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Change Name", text: $fullName)
            TextField("Change Mail", text: $email)
            validButton
        }
        .multilineTextAlignment(.center)
        .padding(.bottom, 200)
    }
    
    var validButton : some View {
        Text("Valider")
            .frame(width: 200)
            .foregroundColor(.white)
            .background(
                Rectangle().fill(Color.black)
            )
            .onTapGesture(count: 1, perform: {
                self.userRequest.email = email
                self.userRequest.fullName = fullName
                self.presentation.wrappedValue.dismiss()
            })
    }
    
}

struct UserSettingView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingView()
    }
}
