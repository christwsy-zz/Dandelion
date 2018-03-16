//
//  ComposeMessegeViewController.swift
//  Dandelion
//
//  Created by Kris Wang on 3/15/18.
//  Copyright © 2018 Siyue Wang. All rights reserved.
//

import UIKit
import RxSwift

class ComposeMessegeViewController: UIViewController {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    var viewModel: ComposeMessageViewModel!
    let bag = DisposeBag()
    var hasSentSms = false
    var hasSentEmail = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init with controls and UI
        bindControls()
        self.statusLabel.alpha = 0
        
        let _ = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        // If the user already sent a text message/mail, it will prevent from sending again by the trigger
        hasSentSms = false
        hasSentEmail = false
        viewModel.canSendEmail.distinctUntilChanged().debounce(0.5, scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] canSendEmail in
            if canSendEmail && !self.hasSentEmail {
                self.hasSentEmail = true
                MessageService.sharedInstance.sendViaEmail(email: self.emailTextField.text!, content: self.contentTextView.text) { sent in
                    print("sendViaEmail=\(sent)")
                    self.showMessageSendStatus(sent)
                }
            }
        }).disposed(by: bag)
        
        viewModel.canSendSms.distinctUntilChanged().debounce(0.5, scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] canSendSms in
            if canSendSms && !self.hasSentSms {
                self.hasSentSms = true
                MessageService.sharedInstance.sendViaSms(phoneNumber: self.phoneNumberTextField.text!, content: self.contentTextView.text) { sent in
                    print("sendViaSms=\(sent)")
                    self.showMessageSendStatus(sent)
                }
            }
        }).disposed(by: bag)
    }

    func bindControls() {
        let input = ComposeMessageInput(phoneNumber: phoneNumberTextField.rx.text.orEmpty.asObservable(), email: emailTextField.rx.text.orEmpty.asObservable(), content: contentTextView.rx.text.orEmpty.asObservable(), sendButtonTap: sendButton.rx.tap.asObservable())
        viewModel = ComposeMessegeViewModel(input: input)
        
        Observable.combineLatest(viewModel.canSendSms, viewModel.canSendEmail) { (canSendSms, canSendEmail) -> Void in
            self.sendButton.isEnabled = canSendSms || canSendEmail
            self.sendButton.alpha = canSendSms || canSendEmail ? 1 : 0.5
            self.emailTextField.textColor = canSendEmail ? .black : .red
            self.phoneNumberTextField.textColor = canSendSms ? .black : .red
        }.subscribe().disposed(by: bag)
    }
    
    // Display the message sending result
    func showMessageSendStatus(_ sent: Bool) {
        statusLabel.alpha = 1
        if sent {
            statusLabel.text = "Message sent!"
            statusLabel.textColor = .green
        } else {
            statusLabel.text = "Send failed!"
            statusLabel.textColor = .red
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.statusLabel.alpha = 0
        })
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        phoneNumberTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
    }
}
