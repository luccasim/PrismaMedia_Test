//
//  UserRequest.swift
//  PrismaMedia_SwiftUI
//
//  Created by owee on 09/11/2020.
//

import Foundation
import Combine
import UIKit

protocol UserRequestAPI {
    func fetchUser()
}

final class UserRequest : ObservableObject {
    
    @Published var avatar : UIImage
    @Published var fullName : String
    @Published var email : String
    
    let webService : ReqResWS
    
    private var cancellable = Set<AnyCancellable>()
    
    init(WebService:ReqResWS?=nil, Model:User?=nil) {
        
        self.webService = WebService ?? ReqResWS.shared
        self.avatar = UIImage()
        self.fullName = Model.flatMap({"\($0.firstName) \($0.lastName)"}) ?? ""
        self.email = Model?.email ?? ""
        
    }
    
    enum UIError : Error {
        case unavailableFetchingResult
        case unavailableFetchingAvatarImage
    }
    
}

extension UserRequest : UserRequestAPI {
    
    typealias fetchResult = (Avatar:UIImage, FullName:String, Email:String)
    
    func fetchUser() {
        
        self.userFuture(Id: 1)
            .flatMap({self.avatarFuture(UserReponse: $0)})
            .receive(on: RunLoop.main)
            .sink { (comp) in
                switch comp {
                case .finished: print("Finish")
                case .failure(let error): print("Error \(error.localizedDescription)")
                }
            } receiveValue: { (reponse) in
                self.avatar = reponse.Avatar
                self.email = reponse.Email
                self.fullName = reponse.FullName
            }
            .store(in: &cancellable)
    }
    
    private func userFuture(Id:Int) -> Future<ReqResWS.UsersReponse, Error> {
        return Future<ReqResWS.UsersReponse, Error> { [weak self] promise in
            
            guard let self = self else { return promise(.failure(UIError.unavailableFetchingResult))}
            
            self.webService.taskGetUser(Id: Id, Callback: { (result) in
                switch result {
                case .success(let reponse): promise(.success(reponse))
                case .failure(let error) : promise(.failure(error))
                }
            })
            
        }
    }
    
    private func avatarFuture(UserReponse:ReqResWS.UsersReponse) -> Future<fetchResult, Error> {
        return Future<fetchResult, Error> { promise in
            
            guard let avatarURL = URLComponents(string: UserReponse.data.avatar)?.url else {
                return promise(.failure(UIError.unavailableFetchingResult))
            }
            
            URLSession.shared.dataTask(with: avatarURL) { (data, rep, err) in
                if let image = data.flatMap({UIImage(data: $0)}) {
                    let result = fetchResult(Avatar: image,
                                             FullName:"\(UserReponse.data.firstName) \(UserReponse.data.lastName)",
                                             Email:"String")
                    promise(.success(result))
                } else {
                    promise(.failure(UIError.unavailableFetchingAvatarImage))
                }
            }.resume()
        }
    }
    
}
