//
//  ViewController.swift
//  ApplePayDemo
//
//  Created by Karen Kong on 3/31/18.
//  Copyright © 2018 Karen Kong. All rights reserved.
//

import UIKit
import PassKit

class ViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {

    @IBOutlet weak var amount: UITextField!
    
    var paymentReq: PKPaymentRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stringtoDecimal(s: String) -> NSDecimalNumber {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter.number(from: s) as? NSDecimalNumber ?? 0
    }
    
    func getPaymentItem(cost: String) -> [PKPaymentSummaryItem] {
        let convertedCost = stringtoDecimal(s: cost)
        if convertedCost != 0 {
            let voucher = PKPaymentSummaryItem.init(label: "Voucher", amount: convertedCost)
            print("Voucher " + voucher.label + " Amount " + String(describing: voucher.amount))
            return [voucher]
        } else {
            return [PKPaymentSummaryItem.init(label: "INVALID", amount: convertedCost)]
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let paymentResult = PKPaymentAuthorizationResult(status: .success, errors: [])
        completion(paymentResult)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payAction(_ sender: Any) {
        let paymentNetworks = [PKPaymentNetwork.amex, .visa, .masterCard, .discover]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            
            paymentReq = PKPaymentRequest()
            paymentReq.currencyCode = "USD"
            paymentReq.countryCode = "US"
            paymentReq.merchantIdentifier = "merchant.com.learnly"
 
            paymentReq.supportedNetworks = paymentNetworks
            paymentReq.merchantCapabilities = .capability3DS
            
            print("Amount " + amount.text!)
            
            if let rewardAmount = amount.text {
                let voucher = getPaymentItem(cost: rewardAmount)
                paymentReq.paymentSummaryItems = voucher

                if let applePayVC = PKPaymentAuthorizationViewController.init(paymentRequest: paymentReq) {
                    applePayVC.delegate = self;
                    self.present(applePayVC, animated: true, completion: nil)
                } else {
                    print("Invalid applePayVC")
                }
            } else {
                print("Invalid rewardAmount")
            }

        } else {
            print("Set up Apple Pay")
        }
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

