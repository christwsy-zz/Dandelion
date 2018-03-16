//
//  APIService.swift
//  Dandelion
//
//  Created by Kris Wang on 3/15/18.
//  Copyright © 2018 Siyue Wang. All rights reserved.
//

import Foundation
import Moya
import RxSwift

enum APIService {
    case sendViaSms(phoneNumbers: [String], content: String)
    case sendViaEmail(emails: [String], content: String)

    static let provider = RxMoyaProvider<APIService>(requestClosure: { (endpoint: Endpoint<APIService>, done: @escaping MoyaProvider<APIService>.RequestResultClosure) in
        var request = endpoint.urlRequest! as URLRequest
    })
}

extension APIService: TargetType {
    var baseURL: URL {
        return URL(string: ServerURL)!
    }
    
    var path: String {
        switch self {
        case .sendViaSms:
            return "send/sms"
        case .sendViaEmail:
            return "send/email"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .sendViaEmail(let emails, let content):
            return ["emails": emails, "content": content]
        case .sendViaSms(let phoneNumbers, let content):
            return ["phoneNumbers": phoneNumbers, "content": content]
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters!, encoding: JSONEncoding.default)
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
