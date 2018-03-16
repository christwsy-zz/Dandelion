//
//  ComposeMessegeViewModel.swift
//  Dandelion
//
//  Created by Kris Wang on 3/15/18.
//  Copyright © 2018 Siyue Wang. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftUtilities
import SwiftyJSON

// Binding the control/content inputs
struct ComposeMessageInput {
    var phoneNumber: Observable<String>
    var email: Observable<String>
    var content: Observable<String>
    var sendButtonTap: Observable<Void>
}

// View model for the compose message view controller
class ComposeMessageViewModel {
    let bag = DisposeBag()
    let canSendSms: Observable<Bool>
    let canSendEmail: Observable<Bool>
    
    init(input: ComposeMessageInput) {
        canSendSms = Observable.combineLatest(input.phoneNumber, input.content, resultSelector: { (phoneNumber, content) -> Bool in
            let phoneRegex = "(\\+)?[0-9]{10,11}"
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phonePredicate.evaluate(with: phoneNumber) && content.count > 0
        })
        
        canSendEmail = Observable.combineLatest(input.email, input.content, resultSelector: { (email, content) -> Bool in
            let emailRegex = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email) && content.count > 0
        })
    }
}
