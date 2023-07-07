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
            iconThumbStr = ""
            iconBigStr = ""
            preImage1Str = ""
            preImage2Str = ""
            featureName = ""
            descriName = ""
        case .enhancer:
            iconThumbStr = ""
            iconBigStr = ""
            preImage1Str = ""
            preImage2Str = ""
            featureName = ""
            descriName = ""
        case .repair:
            iconThumbStr = ""
            iconBigStr = ""
            preImage1Str = ""
            preImage2Str = ""
            featureName = ""
            descriName = ""
        case .restoration:
            iconThumbStr = ""
            iconBigStr = ""
            preImage1Str = ""
            preImage2Str = ""
            featureName = ""
            descriName = ""
        case .denoise:
            iconThumbStr = ""
            iconBigStr = ""
            preImage1Str = ""
            preImage2Str = ""
            featureName = ""
            descriName = ""
        case .enlarge:
            iconThumbStr = ""
            iconBigStr = ""
            preImage1Str = ""
            preImage2Str = ""
            featureName = ""
            descriName = ""
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


