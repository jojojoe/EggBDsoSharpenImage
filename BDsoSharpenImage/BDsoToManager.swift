//
//  BDsoToManager.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/5.
//

import UIKit

enum FeatureType {
    case sharpen
    case enhancer
    case repair
    case restoration
    case denoise
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
    
    /*
     图像色彩增强

     图像去噪

     图像修复

     拉伸图像修复

     图像对比度增强

     图像无损放大
     
     */
}


