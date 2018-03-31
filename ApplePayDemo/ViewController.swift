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
    
//    var paymentRequest: PKPaymentRequest! {
//        didSet {
//
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func itemToSell(shipping: Double) -> [PKPaymentSummaryItem]{
        let teeShirt = PKPaymentSummaryItem(label: "My tshirt", amount: 45.00)
        let discount = PKPaymentSummaryItem(label: "Discount", amount: -20.00)
        let shipping = PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(string: "(shipping)"))
        let totalAmount = teeShirt.amount.adding(discount.amount)
        let totalPrice = PKPaymentSummaryItem(label: "Learnly", amount: totalAmount)
        return [teeShirt, discount, shipping, totalPrice]
    }
    
    
    func getPaymentItem(cost: Double) -> PKPaymentSummaryItem {
        let voucher = PKPaymentSummaryItem(label: "Amount", amount: NSDecimalNumber(string: "(cost)"))
        return voucher
    }
    
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, handler completion: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
//        completion(shippingMethod)
//    }
//
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        <#code#>
//    }
//
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, handler completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
//        completion(PKPaymentAuthorizationStatus.success, itemToSell(shipping: Double(shippingMethod.amount)))
//    }
//
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
//        completion(PKPaymentAuthorizationStatus.success)
//    }
    
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
            paymentReq.requiredShippingContactFields = [.postalAddress]
            
            if let rewardAmount = Double(amount.text!) {
                paymentReq.paymentSummaryItems = [getPaymentItem(cost: rewardAmount)]
                
                let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentReq)
                applePayVC?.delegate = self;
                self.present(applePayVC!, animated: true, completion: nil)
                
            } else {
                print("Invalid number")
            }
            
//            paymentReq.paymentSummaryItems = self.itemToSell(shipping: 4.99)
            
//            let sameDayShipping = PKShippingMethod(label: "Same Day Delivery", amount: 12.99)
//            sameDayShipping.detail = "Delivery is guaranteed the same day"
//            sameDayShipping.identifier = "sameDay"
//            let twoDayShipping = PKShippingMethod(label: "Two Day Delivery", amount: 4.99)
//            twoDayShipping.detail = "Delivered within 2 days"
//            twoDayShipping.identifier = "twoDay"
//            let freeShipping = PKShippingMethod(label: "Free Delivery", amount: 0)
//            freeShipping.detail = "Delivered to you within 7 to 10 days"
//            freeShipping.identifier = "freeShip"
            
//            paymentReq.shippingMethods = [sameDayShipping, twoDayShipping, freeShipping]

        } else {
            print("Set up Apple Pay")
        }
    }
}

extension String {
    func toDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        return numberFormatter.number(from: self)?.doubleValue
    }
}

