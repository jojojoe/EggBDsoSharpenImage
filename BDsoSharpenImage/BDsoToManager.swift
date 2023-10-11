//
//  BDsoToManager.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/5.
//

import UIKit
import MessageUI
import Photos
import DeviceKit
import KRProgressHUD

enum FeatureType {
    case sharpen
    case denoise
    case repair
    case restoration
    case enhancer
    case enlarge
}

class FeatureTypeItem: NSObject {
    
    var ftype: FeatureType
    var iconThumbStr: String
    var iconBigStr: String
    var preImage1Str: String
    var preImage2Str: String
    var featureName: String
    var descriName: String
    
    init(ftype: FeatureType) {
        self.ftype = ftype
        switch ftype {
        case .sharpen:
            iconThumbStr = "pic_sharpen_small"
            iconBigStr = "picbig_sharpen"
            preImage1Str = "e_before_sharpen"
            preImage2Str = "e_after_sharpen"
            featureName = "Sharpen"
            descriName = "Sharpen and clarify compressed images"
        case .enhancer:
            iconThumbStr = "pic_enhancer_small"
            iconBigStr = "picbig_enhance"
            preImage1Str = "e_before_enhance"
            preImage2Str = "e_after_enhance"
            featureName = "Enhance"
            descriName = "Enhance the image by adjusting contrast"
        case .repair:
            iconThumbStr = "pic_repair_small"
            iconBigStr = "picbig_repair"
            preImage1Str = "e_before_repair"
            preImage2Str = "e_after_repair"
            featureName = "Repair"
            descriName = "Remove occluders and repair the picture"
        case .restoration:
            iconThumbStr = "pic_restoreation_small"
            iconBigStr = "picbig_restore"
            preImage1Str = "e_before_restore"
            preImage2Str = "e_after_restore"
            featureName = "Restore"
            descriName = "Auto-fix overstretched images"
        case .denoise:
            iconThumbStr = "pic_denoise_small"
            iconBigStr = "picbig_denoise"
            preImage1Str = "e_before_denoise"
            preImage2Str = "e_after_denoise"
            featureName = "Denoise"
            descriName = "One-click remove old photos noise"
        case .enlarge:
            iconThumbStr = "pic_enlarge_small"
            iconBigStr = "picbig_enlarge"
            preImage1Str = "e_before_enlarge"
            preImage2Str = "e_after_enlarge"
            featureName = "Enlarge"
            descriName = "Enlarge the image by doubling L&W"
        }
    }
}

struct ApInfoConfig {
    //Picture Scan
    static let privacyUrl = "https://sites.google.com/view/sharpenimage-privacy-policy/home"
    static let termsUrl = "https://sites.google.com/view/sharpenimage-terms-of-use/home"
    static let feedbackEmail = "EburhardtHomburg001@outlook.com"
    static let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    static let shareStr = "Share with friends:\("itms-apps://itunes.apple.com/cn/app/id\("6451093147")?mt=8")"
}

class BDsoToManager: NSObject {
    static let `default` = BDsoToManager()
    
    let sharpenItem = FeatureTypeItem(ftype: .sharpen)
    let enhancerItem = FeatureTypeItem(ftype: .enhancer)
    let repairItem = FeatureTypeItem(ftype: .repair)
    let restorationItem = FeatureTypeItem(ftype: .restoration)
    let denoiseItem = FeatureTypeItem(ftype: .denoise)
    let enlargeItem = FeatureTypeItem(ftype: .enlarge)
    
    var featureList: [FeatureTypeItem] = []
    
    var currentSelectItem: FeatureTypeItem!
    var cpadding: CGFloat = 15
    
    override init() {
        super.init()
        loadDataConfig()
        if UIScreen.isDevice8SEPaid() {
            cpadding = 10
        }
    }
    
    func loadDataConfig() {
        featureList = [sharpenItem,
                       enhancerItem,
                       repairItem,
                       restorationItem,
                       denoiseItem,
                       enlargeItem]
        currentSelectItem = sharpenItem
    }
    
    func processBase64Img(img: UIImage) -> (UIImage , String?) {
        let maxLenght = max(img.size.width, img.size.height)
        let minLenght = min(img.size.width, img.size.height)
        if (maxLenght / minLenght > 4.0) {
            
            return (img, "error_1")
        }
        var targetImg: UIImage = img
        if maxLenght > 4000 {
            if img.size.width > img.size.height {
                if let im = img.scaled(toWidth: 2048) {
                    targetImg = im
                }
            } else {
                if let im = img.scaled(toHeight: 2048) {
                    targetImg = im
                } 
            }
        }
        if let basestr = targetImg.jpegBase64String(compressionQuality: 0.8) {
            let encodeStr = self.urlEncodeString(basestr)
            return (targetImg, encodeStr)
        }
       
        return (img, nil)
    }
    
    func processImgFrom(base64: String) -> UIImage? {
        let img = UIImage(base64String: base64)
        return img
    }
    
    // 对字符串进行UrlEncode
    func urlEncodeString(_ string: String) -> String? {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    
    /*
     图像色彩增强

     图像去噪

     图像修复

     拉伸图像修复

     图像对比度增强

     图像无损放大
     
     base64编码后大小不超过10M(参考：原图大约为8M以内），最短边至少10px，最长边最大5000px，长宽比4：1以内。注意：图片的base64编码是不包含图片头的，如（data:image/jpg;base64,）
     图像数据，base64编码字符串，大小不超过4M，最短边至少50px，最长边最大4096px，支持jpg/bmp/png格式
     */
}


extension BDsoToManager: MFMailComposeViewControllerDelegate {
    func userShareAction(viewCon: UIViewController) {
        let activityItems = [ApInfoConfig.shareStr] as [Any]
        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        viewCon.present(vc, animated: true)
    }
    
    func userPrivacyAction() {
        if let path = URL(string: ApInfoConfig.privacyUrl) {
            if UIApplication.shared.canOpenURL(path) {
                UIApplication.shared.open(path, options: [:]) { success in
                }
            }
        }
    }
    
    func userTermsAction() {
        if let path = URL(string: ApInfoConfig.termsUrl) {
            if UIApplication.shared.canOpenURL(path) {
                UIApplication.shared.open(path, options: [:]) { success in
                }
            }
        }
    }
    
    func userFeedbackEmail(viewCon: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let version = UIDevice.current.systemVersion
            
            let modelName = Device.current.description
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "0.0.0"
            let appName = "\(ApInfoConfig.appName)"
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            vc.setSubject("\(appName) Feedback")
            vc.setToRecipients([ApInfoConfig.feedbackEmail])
            vc.setMessageBody("\n\n\nSystem Version：\(version)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion)", isHTML: false)
            viewCon.present(vc, animated: true, completion: nil)
        } else {
            KRProgressHUD.showError(withMessage: "The device doesn't support email")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
