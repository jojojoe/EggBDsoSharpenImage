//
//  BDsoSharSubscbeManager.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/4.
//

import Foundation
import SwiftyStoreKit
import TPInAppReceipt
import UIKit
import KRProgressHUD

public struct SubNotificationKeys {
    static let success = "success"
    static let failed = "failed"
}

public enum VerifySubscriptionResult {
    case purchased(expiryDate: Date, items: [InAppReceipt])
    case expired(expiryDate: Date, items: [InAppReceipt])
    case purchasedOnceTime
    case notPurchased
}

public enum VerifyReceiptResult {
    case success(receipt: InAppReceipt)
    case error(error: IARError)
}

class BDsoSharSubscbeManager: NSObject {
    static let `default` = BDsoSharSubscbeManager()
    let weekIap = "com.sharpen.image.week"
    let monthIap = "com.sharpen.image.month"
    let yearIap = "com.sharpen.image.year"
    
    var currentSelectIapStr = "com.sharpen.image.month"
    
    let defuWeekPrice = "2.99"
    let defuMonthPrice = "9.99"
    let defuYearPrice = "29.99"
    
    
    var subscribeIaps: [String] = []
    
    let k_priceCache = "k_pricecache"
    
    var iapPriceFetchResultList: [String:[String: String]] = [:]
    
    var inSubscription: Bool = false
 
    let feedvImpact = UIImpactFeedbackGenerator.init(style: .medium)
    
    func giveTapVib() {
        feedvImpact.impactOccurred(intensity: 1)
    }
    
    
    func loadContentData(completion: @escaping (()->Void)) {
        subscribeIaps = [weekIap, monthIap, yearIap]
        fetchPrice(iapList: subscribeIaps) {
            [weak self] productlist in
            guard let `self` = self else {return}
            completion()
        }
    }
    
    func currentSymble() -> String {
        if let dict = iapPriceFetchResultList[weekIap], let sym = dict["csymbol"] {
            return sym
        } else {
            return "$"
        }
    }
    
    func currentProductPrice(purchaseIapStr: String) -> String {
        
        if let dict = iapPriceFetchResultList[purchaseIapStr], let value = dict["value"] {
            return value
        } else {
            if purchaseIapStr == weekIap {
                return defuWeekPrice
            } else if purchaseIapStr == monthIap {
                return defuMonthPrice
            } else if purchaseIapStr == yearIap {
                return defuYearPrice
            }
            return "1.99"
        }
        
    }
    
    func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    break
                case .failed, .purchasing, .deferred:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
    
    
    func fetchPrice(iapList: [String], completion: @escaping (([String: [String: String]]?) -> Void)) {
        guard let cache = UserDefaults.standard.object(forKey: k_priceCache) as? [String: [String: String]] else {
            let iapLists = Set(iapList)
            SwiftyStoreKit.retrieveProductsInfo(iapLists) { result in
                guard result.error == nil else {
                    completion(nil)
                    return
                }
                let priceList = result.retrievedProducts.compactMap { $0 }
                let list = Dictionary(uniqueKeysWithValues: priceList.map {
                    ($0.productIdentifier, ["csymbol": $0.priceLocale.currencySymbol ?? "",
                                            "value": $0.price.doubleValue.roundTo(places: 2).string])
                })
                UserDefaults.standard.set(list, forKey: self.k_priceCache)
                self.iapPriceFetchResultList = list
                completion(list)
            }
            return
        }
        self.iapPriceFetchResultList = cache
        completion(cache)
    }
    
    public func subscribe(iapType: String, completion: ((Bool, String?) -> Void)? = nil) {
        
        SwiftyStoreKit.purchaseProduct(iapType) { result in
            DispatchQueue.main.async {
                
                switch result {
                case let .success(purchase: purchaseDetail):
                    if purchaseDetail.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchaseDetail.transaction)
                    }
                    self.refreshUserReceipt { (_, _) in
                        DispatchQueue.main.async {
                            self.checkIsPurchased { (status) in
                                DispatchQueue.main.async {
                                    if status {
                                        KRProgressHUD.showSuccess(withMessage: "The subscription was successful")
                                    }
                                    NotificationCenter.default.post(
                                        name: NSNotification.Name(rawValue: SubNotificationKeys.success),
                                        object: nil,
                                        userInfo: nil)
                                    completion?(status, nil)
                                }
                            }
                        }
                    }
                    break
                default:
                    completion?(false, "Purchase failed, please try again")
                    break
                }
            }
        }
    }
    
    func showRestoreFailed() {
            KRProgressHUD.showInfo(withMessage: "You have no subscription to restore")
    }
    
    func restore(_ successBlock: ((Bool) -> Void)? = nil) {
        
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                if results.restoreFailedPurchases.count > 0 {
                    self.showRestoreFailed()
                    successBlock?(false)
                    debugPrint("Restore Failed: \(results.restoreFailedPurchases)")
                } else if results.restoredPurchases.count > 0 {
                    for purchase in results.restoredPurchases {
                        if purchase.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                    }
                    
                    self.refreshUserReceipt { (_, _) in
                        DispatchQueue.main.async {
                            self.checkIsPurchased { (status) in
                                DispatchQueue.main.async {
                                    if status {
                                        NotificationCenter.default.post(
                                            name: NSNotification.Name(rawValue: SubNotificationKeys.success),
                                            object: nil,
                                            userInfo: nil)
                                        debugPrint("Restore Success: \(results.restoredPurchases)")
                                        KRProgressHUD.showInfo(withMessage: "You have restore successfully")
                                        successBlock?(true)
                                    } else {
                                        self.showRestoreFailed()
                                        successBlock?(false)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    self.showRestoreFailed()
                    successBlock?(false)
                }
            }
        }
    }
    
    func refreshUserReceipt(completion: @escaping(FetchReceiptResult?, Error?) -> Void) {
        SwiftyStoreKit.fetchReceipt(forceRefresh: true, completion: { result in
            switch result {
            case .success:
               completion(result, nil)
            case .error(let error):
                completion(nil, error)
            }
        })
    }
    func checkIsPurchased(completion: @escaping (_ purchased: Bool) -> Void) {
        let dispatchGroup = DispatchGroup()
        var validPurchases: [String: VerifySubscriptionResult] = [:]
        var errors: [String: Error] = [:]
        for key in subscribeIaps {
            dispatchGroup.enter()
            
            verifyPurchase(key) { [weak self] purchaseResult, error in
                guard let _ = self else {
                    dispatchGroup.leave()
                    return
                }
                
                guard let purchase = purchaseResult else {
                    dispatchGroup.leave()
                    return
                }
                
                if let err = error {
                    errors[key] = err
                    dispatchGroup.leave()
                    return
                }
                
                switch purchase {
                case .purchased(let expiryDate, let receiptItems):
                    let now = Date()
                    if now < expiryDate {
                        validPurchases[key] = purchase
                    }
                    validPurchases[key] = purchase
                    dispatchGroup.leave()
                case .expired(let expiryDate, let receiptItems):
                    print("Product is expired since \(expiryDate)")
                    dispatchGroup.leave()
                    let format = DateFormatter()
                    format.timeZone = .current
                    format.dateFormat = "EEEE, MMM d, yyyy h:mm a"
                    let dateString = format.string(from: expiryDate)
                    debugPrint("dateString = \(dateString)")
                case .purchasedOnceTime:
                    validPurchases[key] = purchase
                    dispatchGroup.leave()
                case .notPurchased:
                    dispatchGroup.leave()
                    
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let hasValid = validPurchases.count > 0
            BDsoSharSubscbeManager.default.inSubscription = hasValid
            completion(hasValid)
        }
    }
    
    func verifyPurchase(_ purchaseIapStr: String,
                        completion: @escaping(VerifySubscriptionResult?, Error?) -> Void) {
     
        verifyReceipt { [weak self] (receiptResult, validationError) in
            guard let _ = self else {
                completion(nil, nil)
                return
            }
            if let error = validationError {
                completion(nil, nil)
                return
            }
            
            guard let result = receiptResult else {
                completion(nil, nil)
                return
            }
            
            switch result {
            // receipt is validated
            case .success(let receipt):
                let oneTimePurchase = "life"//IAPType.life.rawValue
                let item = receipt.purchases.first {
                    return $0.productIdentifier == oneTimePurchase
                }
                if let _ = item {
                    completion(.purchasedOnceTime, nil)
                    return
                }
                
                let productId = purchaseIapStr
                // check there is a subscription first
                if let subscription = receipt.activeAutoRenewableSubscriptionPurchases(ofProductIdentifier: productId, forDate: Date()) {
                    if let expiryDate = subscription.subscriptionExpirationDate {
                        completion(.purchased(expiryDate: expiryDate, items: [receipt] ), nil)
                        return
                    }
                    // no expiry date?
                    completion(.notPurchased, nil)
                }
                let purchases = receipt.purchases( ofProductIdentifier: productId ) { (InAppPurchase, InAppPurchase2) -> Bool in
                    return InAppPurchase.purchaseDate > InAppPurchase2.purchaseDate
                }
                if purchases.isEmpty {
                    completion(.notPurchased, nil)
                } else {
                    // get last purchase
                    let lastSubscription = purchases[0]
                    completion( .expired(expiryDate: lastSubscription.subscriptionExpirationDate ?? Date(), items: [receipt] ), nil )
                }
            // validation error
            case .error(let error):
                completion(nil, error)
            }
        }
    }
    func verifyReceipt( completion: @escaping(VerifyReceiptResult?, Error?) -> Void ) {
        do {
            let receipt = try InAppReceipt.localReceipt()
            do {
                try receipt.verifyHash()
                completion(.success(receipt: receipt), nil)
            } catch IARError.initializationFailed(let reason) {
                completion(.error(error: .initializationFailed(reason: reason)),nil)
            } catch IARError.validationFailed(let reason) {
                completion(.error(error: IARError.validationFailed(reason: reason)), nil)
            } catch IARError.purchaseExpired {
                completion(.error(error: .purchaseExpired), nil)
            } catch {
                // unknown error
                completion(nil, error)
            }
        } catch {
            completion(
                .error(error: .initializationFailed(reason: .appStoreReceiptNotFound)),
                error
            )
        }
    }
}
