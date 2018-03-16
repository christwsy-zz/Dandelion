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

// Wrapper for sending messege service
class MessageService {
    static let sharedInstance = MessageService()
    
    let bag = DisposeBag()
    
    func sendViaSms(phoneNumber: String, content: String, completion: @escaping (Bool) -> Void) {
        APIService.provider.request(.sendViaSms(phoneNumber: phoneNumber, content: content)).subscribe(onSuccess: { response in
            debugPrint(response)
            completion(true)
        }, onError: { error in
            debugPrint(error)
            completion(false)
        }).disposed(by: bag)
    }
    
    func sendViaEmail(email: String, content: String, completion: @escaping (Bool) -> Void) {
        APIService.provider.request(.sendViaEmail(email: email, content: content)).subscribe(onSuccess: { response in
            debugPrint(response)
            completion(true)
        }, onError: { error in
            debugPrint(error)
            completion(false)
        }).disposed(by: bag)
    }
}
