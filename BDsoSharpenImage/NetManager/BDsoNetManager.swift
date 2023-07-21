//
//  BDsoNetManager.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/10.
//

import UIKit
import Moya
import Alamofire
import MoyaSugar
import SwiftyJSON
import SwiftyTimer


class BDsoNetManager: NSObject {
    static let `default` = BDsoNetManager()
    let clinetcred = "client_credentials"
    let apikey = "GraoOM2s0FYGv7ymTKoOV3M6"
    let sk = "rEYGntHa0SvgzR9RxYC3iKAfMi1htFS2"
    let OutlieProvider = RequestProvider<OutAPI>(plugins: [TimeoutPlugin()])
    var accessTokey: String = ""
    
    override init() {
        super.init()
    }
    
    static func networkReachable() -> Bool {
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true
        
    }
    
    static func cancelAllNetworkRequest() {
        Alamofire.Session.default.session.getTasksWithCompletionHandler {
            (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    enum OutError: Error {
        case verificationFailed
        case networkFailure
        case parseJsonFailure
        var errorDescription: String {
            switch self {
            case .verificationFailed:
                return "token error"
            case .networkFailure:
                return "Internal Error, Please try again later"
            default :
                return "Something Error"
                
            }
        }
    }
    
}

extension BDsoNetManager {
    func saveTokenInfo(tokenStr: String, expiresTime: TimeInterval) {
        let defaults = UserDefaults.standard
        let expiresDate = Date().addingTimeInterval(expiresTime - 600)
        let expiresDateTimeInt = expiresDate.timeIntervalSince1970
        defaults.set(tokenStr, forKey: "tokenStr")
        defaults.set(expiresDateTimeInt, forKey: "expiresTime")
    }
    
    func getTokenInfo() -> String? {
        let defaults = UserDefaults.standard
        let expiresTime = defaults.double(forKey: "expiresTime")
        let nowTimeint = Date().timeIntervalSince1970
        if nowTimeint < expiresTime {
            let tokenStr = defaults.string(forKey: "tokenStr")
            return tokenStr
        }
        return nil
        
    }
}

extension BDsoNetManager {
      
    func apiRequest(target: OutAPI,
                                success: ((JSON?, Int) -> Void)?,
                                failure: ((OutError?) -> Void)? = nil) {
        OutlieProvider
            .request(target) { result in
                switch result {
                case let .success(response):
                    switch response.statusCode {
                    case 200:
                        do {
                            let jsondata =  try JSON(data: response.data)
                            success?(jsondata, response.statusCode)
                        } catch let error {
                            debugPrint("error- \(error)")
                            failure?(.networkFailure)

                        }
                    default:
//                        success?(nil, response.statusCode)
                        failure?(.networkFailure)
                    }
                case let .failure(error):
                    debugPrint("errorstr error = \(error)")
                    failure?(.networkFailure)
                }
        }
    }
}

class RequestProvider<Target: SugarTargetType>: MoyaSugarProvider<Target> {
    
}


class TimeoutPlugin: PluginType {
    init() {}

    func prepare(_ request: URLRequest, target _: TargetType) -> URLRequest {
        var request = request
        request.timeoutInterval = 15
        return request
    }
}

