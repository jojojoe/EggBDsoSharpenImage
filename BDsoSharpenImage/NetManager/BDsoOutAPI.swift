//
//  BDsoOutAPI.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/10.
//

//import Alamofire
import Foundation
import Moya
import MoyaSugar
import SwifterSwift

enum OutAPI {
//    图像色彩增强
//
//    图像去噪
//
//    图像修复
//
//    拉伸图像修复
//
//    图像对比度增强
//
//    图像无损放大
//
    /*
     base64编码后大小不超过10M(参考：原图大约为8M以内），最短边至少10px，最长边最大5000px，长宽比4：1以内。注意：图片的base64编码是不包含图片头的，如（data:image/jpg;base64,）
     图像数据，base64编码字符串，大小不超过4M，最短边至少50px，最长边最大4096px，支持jpg/bmp/png格式
     */
    case requestToken
    case sharpen(imgBase64: String)
    case denoise(imgBase64: String, option: Int) // 在[0，200]区间内
    case repair(imgBase64: String, rectangle: String) // [{'width': 92, 'top': 25, 'height': 36, 'left': 543}]
    case restoration(imgBase64: String)
    case enhancer(imgBase64: String)
    case enlarge(imgBase64: String)
    
}

 
extension OutAPI: SugarTargetType {

    var baseURL: URL {
        switch self {
        case .requestToken:
            return URL(string: "https://aip.baidubce.com/oauth/2.0/")!
        default:
            return URL(string: "https://aip.baidubce.com/rest/2.0/image-process/v1/")!
        }
    }
    
    var route: Route {
        switch self {
        case .requestToken:
            return .post("token")
        case .sharpen( _):
            return .post("color_enhance")
        case .denoise( _, _):
            return .post("denoise")
        case .repair( _, _):
            return .post("inpainting")
        case .restoration( _):
            return .post("stretch_restore")
        case .enhancer( _):
            return .post("contrast_enhance")
        case .enlarge( _):
            return .post("image_quality_enhance")
        }
    }

    var task: Task {
        switch self {
        case .requestToken:
            let params = ["": ""] as [String : Any]
            let urlParameters = ["grant_type": BDsoNetManager.default.clinetcred, "client_id" : BDsoNetManager.default.apikey,  "client_secret" : BDsoNetManager.default.sk]
            return .requestCompositeParameters(bodyParameters: params,
                                               bodyEncoding: URLEncoding.httpBody,
                                               urlParameters: urlParameters)
        case .sharpen(let imgBase64):
            debugPrint("request api token = \(BDsoNetManager.default.accessTokey)")
            debugPrint("imgBase64 = \(imgBase64)")
            let urlParameters = ["access_token": BDsoNetManager.default.accessTokey]
            let params = ["image": imgBase64] as [String : Any]
            return .requestCompositeParameters(bodyParameters: params,
                                               bodyEncoding: URLEncoding.httpBody,
                                               urlParameters: urlParameters)
        case .denoise(let imgBase64, let option):
            let urlParameters = ["access_token": BDsoNetManager.default.accessTokey]
            let params = ["image": imgBase64, "option": "\(option)"] as [String : Any]
            return .requestCompositeParameters(bodyParameters: params,
                                               bodyEncoding: URLEncoding.httpBody,
                                               urlParameters: urlParameters)
        case .repair(let imgBase64, let rectangle):
            let urlParameters = ["access_token": BDsoNetManager.default.accessTokey]
            let params = ["image": imgBase64, "rectangle": rectangle] as [String : Any]
            return .requestCompositeParameters(bodyParameters: params,
                                               bodyEncoding: URLEncoding.httpBody,
                                               urlParameters: urlParameters)
        case .restoration(let imgBase64):
            let urlParameters = ["access_token": BDsoNetManager.default.accessTokey]
            let params = ["image": imgBase64] as [String : Any]
            return .requestCompositeParameters(bodyParameters: params,
                                               bodyEncoding: URLEncoding.httpBody,
                                               urlParameters: urlParameters)
        case .enhancer(let imgBase64):
            let urlParameters = ["access_token": BDsoNetManager.default.accessTokey]
            let params = ["image": imgBase64] as [String : Any]
            return .requestCompositeParameters(bodyParameters: params,
                                               bodyEncoding: URLEncoding.httpBody,
                                               urlParameters: urlParameters)
        case .enlarge(let imgBase64):
            let urlParameters = ["access_token": BDsoNetManager.default.accessTokey]
            let params = ["image": imgBase64] as [String : Any]
            return .requestCompositeParameters(bodyParameters: params,
                                               bodyEncoding: URLEncoding.httpBody,
                                               urlParameters: urlParameters)
        }
        
    }
   
    var parameters: Parameters? {
        
        return nil
    }
    
    var headers: [String: String]? {
         
        var headersDict: [String: String] = [:]
        var contentType: String = ""
        switch self {
        case .requestToken:
            contentType = "application/json"
            headersDict = ["Content-Type" : contentType, "Accept" : contentType]
            return headersDict
        case .repair(_, _):
            contentType = "application/json"
            headersDict = ["Content-Type" : contentType]
            return headersDict
        default:
            contentType = "application/x-www-form-urlencoded"
            headersDict = ["Content-Type" : contentType]
            return headersDict
        }

    }
}

 
