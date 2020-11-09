//
//  RepResWS.swift
//  PrismaMedia_test
//
//  Created by owee on 09/11/2020.
//

import Foundation

protocol ReqResAPI {
    
    func taskGetUser(Id:Int, Callback: @escaping((Result<ReqResWS.UsersReponse, Error>) -> Void))
    
}

final class ReqResWS {
    
    private let session : URLSession
    
    // Possible singleton
    public static let shared = ReqResWS(Session: .shared)
    
    // Possible inject session
    public init(Session:URLSession?=nil) {
        self.session = Session ?? URLSession.shared
    }
    
    // Webservices endpoint
    public enum Endpoint {
        
        case users(id:Int)
        
        var url : URL? {
            
            switch self {
            case .users(let id): return URLComponents(string: "https://reqres.in/api/users/\(id)")?.url
            }
        }
    }
    
    // Class errors
    public enum WSError : Error {
        case unvalidRequestParameter
        case unvalidReponseJSONFormat
    }
    
    
    /// Make URLRequest
    /// - Parameter Endpoint: The desired Endpoint
    /// - Returns: A request if the endpoint is valid
    public func request(Endpoint:Endpoint) -> URLRequest? {
        guard let url = Endpoint.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    /// Basic task as a generic
    /// - Parameters:
    ///   - Request: The request
    ///   - Completion: The callback result
    fileprivate func task<Reponse:Codable>(Request:URLRequest, Completion:@escaping (Result<Reponse,Error>) -> Void) {
        
        self.session.dataTask(with: Request) { (Data, Rep, Err) in
            
            if let error = Err {
                return Completion(.failure(error))
            }
            
            else if let data = Data {
                
                do {
                    
                    let reponse = try JSONDecoder().decode(Reponse.self, from: data)
                    Completion(.success(reponse))
                    
                } catch {
                    Completion(.failure(WSError.unvalidReponseJSONFormat))
                }
            }

        }.resume()
    }
}

extension ReqResWS : ReqResAPI {
    
    /// Task for an user ID
    /// - Parameters:
    ///   - Id: user ID
    ///   - Callback: The callback result
    func taskGetUser(Id:Int, Callback: @escaping((Result<ReqResWS.UsersReponse, Error>) -> Void)) {
        
        guard let request = self.request(Endpoint: .users(id: Id)) else {
            return Callback(.failure(WSError.unvalidRequestParameter))
        }
        
        self.task(Request: request, Completion: Callback)
    }
    
    /// User endpoint reponse
    struct UsersReponse : Codable {
        
        let data : Datas
        
        struct Datas : Codable {
            
            let id : Int
            let email, firstName, lastName, avatar : String
            
            enum CodingKeys : String, CodingKey {
                case id, email, avatar
                case firstName = "first_name"
                case lastName = "last_name"
            }
        }
    }
    
}
