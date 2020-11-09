//
//  ReqResWS_Tests.swift
//  PrismaMedia_TestTests
//
//  Created by owee on 09/11/2020.
//

import XCTest
@testable import PrismaMedia_Test


/// Here the tests for ReqResWs
/// We only test local Data here,
/// Because we wont test URLSession its native
class ReqResWS_Tests: XCTestCase {

    /// Test and debug on Codable struct
    func testUsersReponse() throws {
        
        let bundle = Bundle.init(identifier: "fr.devios.PrismaMedia-Test")
        let url = bundle?.url(forResource: "ReqResWSReponse.json", withExtension: nil)!
        let data = try Data(contentsOf: url!)
        
        let reponse = try JSONDecoder().decode(ReqResWS.UsersReponse.self, from: data)
        
        print(reponse.data)
    }
    
}
