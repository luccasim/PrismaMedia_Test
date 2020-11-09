//
//  UserView.swift
//  PrismaMedia_SwiftUI
//
//  Created by owee on 09/11/2020.
//

import SwiftUI

struct UserView: View {
    
    @EnvironmentObject var userRequest : UserRequest
    
    var body: some View {
        
        NavigationView {
            VStack {
                Image(uiImage: userRequest.avatar)
                    .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.top, 40)
                Spacer()
                VStack(spacing:5) {
                    Text(userRequest.fullName)
                    Text(userRequest.email)
                    SettingButton
                }
                .padding(.bottom, 200)
            }
        }.onAppear() {
            self.userRequest.fetchUser()
        }
    }
    
    @State var showSettings = false
    
    // MARK : - Navigation
    var SettingButton : some View {
        NavigationLink(
            destination: UserSettingView(),
            isActive: $showSettings,
            label: {
                Text("Modifier")
                    .frame(width: 200, alignment: .center)
                    .foregroundColor(.white)
                    .background(Rectangle().fill(Color.black))
            })
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserView().environmentObject(UserRequest())
            UserSettingView().environmentObject(UserRequest())
        }
    }
}
