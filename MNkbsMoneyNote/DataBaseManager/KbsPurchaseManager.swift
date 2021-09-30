//
//  KbsPurchaseManager.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/7/28.
//

import Foundation
import Defaults
import NoticeObserveKit
import SwiftyStoreKit
import StoreKit
import ZKProgressHUD
import Alertift


struct PurchaseStatusNotificationKeys {
    static let success = "success"
    static let failed = "failed"
}


public class PurchaseManager {
    public static var `default` = PurchaseManager()
    var test: Bool = false
    public var receiptInfo: ReceiptInfo? {
        set {
            guard let newValue = newValue else { return }
            if let data = try? JSONSerialization
                .data(withJSONObject: newValue, options: .init(rawValue: 0)) {
                Defaults[.localIAPReceiptInfo] = data
                Notice.Center.default
                    .post(name: Notice.Names.receiptInfoDidChange, with: nil)
            }
        }
        get {
            guard let data = Defaults[.localIAPReceiptInfo] else { return nil }
            let receiptInfo = try? JSONSerialization
                .jsonObject(with: data, options: .init(rawValue: 0)) as? ReceiptInfo
            return receiptInfo
        }
    }

    

    public let iapTypeList: [IAPType] = [.year, .month]

    var inSubscription: Bool {
        if UIApplication.shared.inferredEnvironment == .debug && test {
            return true
        }
        guard let receiptInfo = receiptInfo else { return false }

        let subscriptionIDList = Set([IAPType.year.rawValue, IAPType.month.rawValue])
        let subscriptionInfo = SwiftyStoreKit.verifySubscriptions(productIds: subscriptionIDList, inReceipt: receiptInfo)
        switch subscriptionInfo {
        case let .purchased(expiryDate, items):
            let compare = Date().compare(expiryDate)
            let inPurchase = compare != .orderedDescending
            if inPurchase {
                let targetDate = Date()
                let preMonth = Calendar.current.date(byAdding: .month, value: -1, to: targetDate)
                let preHalfYear = Calendar.current.date(byAdding: .month, value: -6, to: targetDate)
                let preYear = Calendar.current.date(byAdding: .year, value: -1, to: targetDate)
                
                 debugPrint("preMonth = \(preMonth), preHalfYear = \(preHalfYear), preYear = \(preYear)")
            } else {
                 

            }
            return inPurchase
        case .expired, .notPurchased:
            return false
        }
    }

    public func purchaseInfo(block: @escaping (([PurchaseManager.IAPProduct]) -> Void)) {
        let iapList = iapTypeList.map { $0.rawValue }
        retrieveProductsInfo(iapList: iapList) { items in
            block(items)
        }
    }

    public func restore(_ success: (() -> Void)? = nil) {
        HUD.show()
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
            guard let `self` = self else { return }
            HUD.hide()
            if results.restoreFailedPurchases.count > 0 {
                if let vis = UIApplication.rootController?.visibleVC {
                    Alert.error("Restore Failed")
                } else {
                    Alert.error("Restore Failed")
                }
                debugPrint("Restore Failed: \(results.restoreFailedPurchases)")
            } else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }

                self.verify({ receipt in
                    let status = self.inSubscription
                    if status {
                        if let vis = UIApplication.rootController?.visibleVC {
                            Alert.message("Restore Success", success: {
                                success?()
                            })
                        } else {
                            Alert.message("Restore Success", success: {
                                success?()
                            })
                        }
                        
                        debugPrint("Restore Success: \(results.restoredPurchases)")
                    } else {
                        if let vis = UIApplication.rootController?.visibleVC {
                            Alert.error("Nothing to Restore")
                        } else {
                            Alert.error("Nothing to Restore")
                        }
                    }
                })
            } else {
                if let vis = UIApplication.rootController?.visibleVC {
                    Alert.error("Nothing to Restore")
                } else {
                    Alert.error("Nothing to Restore")
                }
            }
        }
    }

    public func order(iapType: IAPType, source: String, page: String, isInTest: Bool, success: (() -> Void)? = nil) {
        

        HUD.show()
        SwiftyStoreKit.purchaseProduct(iapType.rawValue) { purchaseResult in
            switch purchaseResult {
            case let .success(purchaseDetail):
                self.verify { verifyReceiptInfo in
                    HUD.hide()
                    // TODO: Month halfyear adjust token
                    var eventString: String
                    

                    let price = purchaseDetail.product.price.doubleValue
                    let productId = purchaseDetail.productId
                    let currencyCode = purchaseDetail.product.priceLocale.currencyCode ?? "USD"
                      

                    success?()
                }

            case let .error(error):
                HUD.hide()
                var errorStr = error.localizedDescription
                switch error.code {
                case .unknown: errorStr = "Unknown error. Please contact support. If you are sure you have purchased it, please click the \"Restore\" button."
                case .clientInvalid: errorStr = "Not allowed to make the payment"
                case .paymentCancelled: errorStr = "Payment cancelled"
                case .paymentInvalid: errorStr = "The purchase identifier was invalid"
                case .paymentNotAllowed: errorStr = "The device is not allowed to make the payment"
                case .storeProductNotAvailable: errorStr = "The product is not available in the current storefront"
                case .cloudServicePermissionDenied: errorStr = "Access to cloud service information is not allowed"
                case .cloudServiceNetworkConnectionFailed: errorStr = "Could not connect to the network"
                case .cloudServiceRevoked: errorStr = "User has revoked permission to use this cloud service"
                default: errorStr = (error as NSError).localizedDescription
                }
                
                if let vis = UIApplication.rootController?.visibleVC {
                    Alert.error(errorStr)
                } else {
                    Alert.error(errorStr)
                }
            }
        }
    }
    
    func formateErrorType(error: SKError) -> String {
        if error.code == .unknown {
            return "unknown"
        } else if error.code == .clientInvalid {
            return "clientInvalid"
        } else if error.code == .paymentCancelled {
            return "paymentCancelled"
        } else if error.code == .paymentInvalid {
            return "paymentInvalid"
        } else if error.code == .paymentNotAllowed {
            return "paymentNotAllowed"
        } else if error.code == .storeProductNotAvailable {
            return "storeProductNotAvailable"
        } else if error.code == .cloudServicePermissionDenied {
            return "cloudServicePermissionDenied"
        } else if error.code == .cloudServiceRevoked {
            return "cloudServiceRevoked"
        } else {
            if #available(iOS 12.2, *) {
                if error.code == .privacyAcknowledgementRequired {
                    return "privacyAcknowledgementRequired"
                } else if error.code == .unauthorizedRequestData {
                    return "unauthorizedRequestData"
                } else if error.code == .invalidOfferIdentifier {
                    return "invalidOfferIdentifier"
                } else if error.code == .missingOfferParams {
                    return "missingOfferParams"
                } else if error.code == .invalidOfferPrice {
                    return "invalidOfferPrice"
                }
            } else {
                return "unknown"
            }
        }
        return "unknown"
    }

    public func verify(_ success: ((ReceiptInfo) -> Void)? = nil) {
        #if DEBUG
        debugPrint("* DEBUG")
        let receiptValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: IAPsharedSecret)
        #else
        debugPrint("* NO DEBUG")
        let receiptValidator = AppleReceiptValidator(service: .production, sharedSecret: IAPsharedSecret)
        #endif
        SwiftyStoreKit.verifyReceipt(using: receiptValidator) { verifyResult in
            switch verifyResult {
            case let .success(receipt):
                self.receiptInfo = receipt
                success?(receipt)
            case let .error(error):
                debugPrint("Verify Error", error.localizedDescription)
                if let vis = UIApplication.rootController?.visibleVC {
                    Alert.error(error.localizedDescription)
                } else {
                    Alert.error(error.localizedDescription)
                }
            }
        }
    }
}

public extension PurchaseManager {
    struct IAPProduct: Codable {
        public var iapID: String
        public var price: Double
        public var priceLocale: Locale
        public var localizedPrice: String?
        public var currencyCode: String?
    }

    static var localIAPProducts: [IAPProduct]? = Defaults[.localIAPProducts] {
        didSet { Defaults[.localIAPProducts] = localIAPProducts }
    }

    static var localIAPCacheTime: TimeInterval? = Defaults[.localIAPCacheTime] {
        didSet { Defaults[.localIAPCacheTime] = localIAPCacheTime }
    }

    /// 获取多项价格(maybe sync)
    func retrieveProductsInfo(iapList: [String],
                              completion: @escaping (([IAPProduct]) -> Void)) {
        let oldLocalList = PurchaseManager.localIAPProducts ?? []
        let localIAPIDList = oldLocalList.compactMap { $0.iapID }
        if localIAPIDList.contains(iapList) {
            completion(oldLocalList)
            if let cacheTime = PurchaseManager.localIAPCacheTime,
                Date().unixTimestamp - cacheTime < 1.0.hour  {
                return
            }
        }
        SwiftyStoreKit.retrieveProductsInfo(Set(iapList)) { result in
            let priceList = result.retrievedProducts.compactMap { $0 }
            let localList = priceList.compactMap { PurchaseManager.IAPProduct(iapID: $0.productIdentifier, price: $0.price.doubleValue, priceLocale: $0.priceLocale, localizedPrice: $0.localizedPrice, currencyCode: $0.priceLocale.currencyCode) }

            var tempItems = localList
            for iapItem in oldLocalList {
                let identicalItems = localList.filter { $0.iapID == iapItem.iapID }
                if identicalItems.isEmpty {
                    tempItems.append(iapItem)
                }
            }
            PurchaseManager.localIAPProducts = tempItems
            
            completion(tempItems)
        }
    }

    /// 获取单项价格(maybe sync)
    func retrieveProductsInfo(iapID: String,
                              completion: @escaping ((IAPProduct?) -> Void)) {
        retrieveProductsInfo(iapList: [iapID]) { result in
            completion(result.filter { $0.iapID == iapID }.first)
        }
    }
}
 
