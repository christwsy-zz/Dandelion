//
//  MessageService.swift
//  Dandelion
//
//  Created by Kris Wang on 3/15/18.
//  Copyright © 2018 Siyue Wang. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class MessageService {
    static let sharedInstance = MessageService()
    
    let bag = DisposeBag()
    
    func sendViaSms(phoneNumbers: [String], content: String, completion: @escaping (Bool) -> Void) {
        APIService.provider.request(.sendViaSms(phoneNumbers: phoneNumbers, content: content)).subscribe(onSuccess: { response in
            debugPrint(response)
            completion(true)
        }, onError: { error in
            debugPrint(error)
            completion(false)
        }).disposed(by: bag)
    }
    
    func sendViaEmail(emails: [String], content: String, completion: @escaping (Bool) -> Void) {
        APIService.provider.request(.sendViaEmail(emails: emails, content: content)).subscribe(onSuccess: { response in
            debugPrint(response)
            completion(true)
        }, onError: { error in
            debugPrint(error)
            completion(false)
        }).disposed(by: bag)
    }
}
