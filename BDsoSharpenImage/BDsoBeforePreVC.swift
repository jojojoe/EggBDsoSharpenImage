//
//  BDsoBeforePreVC.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/10.
//

import UIKit

enum ProcessingStep {
    case before
    case processStep1
    case processStep2
    case processStepFinish
    case downloadSave
}

class BDsoBeforePreVC: UIViewController {
    
    var originImg: UIImage
    let contentImgV = UIImageView()
    let shareBtn = UIButton()
    let downloadSaveBtn = UIButton()
    let processedDescribeLabel = UILabel()
    let processedCountLabel = UILabel()
    let processedChecknowBtn = UIButton()
    let processingLoadingImgV = UIImageView()
    let overlayerBgView = UIView()
    
    var currentProcessingStep: ProcessingStep = .before
    
    init(originImg: UIImage) {
        self.originImg = originImg
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupV()
        setupProccessingOverlayerView()
        updateDownloadStatus(processingStep: .before)
        
    }
    

    func setupV() {
        view.backgroundColor(UIColor(hexString: "#1E1E1E")!)
            .clipsToBounds()
        //
        let backBtn = UIButton()
            .adhere(toSuperview: view) {
                $0.left.equalToSuperview().offset(20)
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
                $0.width.equalTo(48)
                $0.height.equalTo(48)
            }
            .image(UIImage(named: "back_icon_b"))
            .target(target: self, action: #selector(backBtnClick), event: .touchUpInside)
        //
        
        shareBtn
            .adhere(toSuperview: view) {
                $0.left.equalToSuperview().offset(20)
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
                $0.width.equalTo(48)
                $0.height.equalTo(48)
            }
            .image(UIImage(named: "icon_share_b"))
            .target(target: self, action: #selector(shareBtnClick), event: .touchUpInside)
        //
        let contentBgV = UIView()
        contentBgV.adhere(toSuperview: view) {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-140)
        }
        //
        
        contentImgV
            .adhere(toSuperview: contentBgV) {
                $0.edges.equalToSuperview()
            }
            .contentMode(.scaleAspectFit)
        contentImgV.image = originImg
        //
        let startBtn = UIButton()
            .adhere(toSuperview: view) {
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(35)
                $0.height.equalTo(60)
                $0.bottom.equalTo(-44)
            }
            .backgroundColor(.white)
            .title("Start")
            .font(UIFont.FontName_PoppinsBold, 16)
            .titleColor(UIColor(hexString: "#21212D")!)
            .cornerRadius(30, masksToBounds: false)
            .shadow(color: UIColor(hexString: "#29263D")!, radius: 20, opacity: 0.05, offset: CGSize(width: 0, height: 10), path: nil)
            .target(target: self, action: #selector(startBtnClick), event: .touchUpInside)
        //
        
        downloadSaveBtn
            .adhere(toSuperview: view) {
                $0.edges.equalTo(startBtn)
            }
            .backgroundColor(.white)
            .title(" SAVE")
            .image(UIImage(named: "download"))
            .font(UIFont.FontName_PoppinsBold, 16)
            .titleColor(UIColor(hexString: "#21212D")!)
            .cornerRadius(30, masksToBounds: false)
            .shadow(color: UIColor(hexString: "#29263D")!, radius: 20, opacity: 0.05, offset: CGSize(width: 0, height: 10), path: nil)
            .target(target: self, action: #selector(saveBtnClick), event: .touchUpInside)
    }
    
    func setupProccessingOverlayerView() {
        
        overlayerBgView.adhere(toSuperview: view) {
            $0.left.right.top.bottom.equalToSuperview()
        }
        .backgroundColor(.clear)
        //
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.adhere(toSuperview: overlayerBgView) {
            $0.edges.equalToSuperview()
        }

        processedCountLabel
            .adhere(toSuperview: overlayerBgView) {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(overlayerBgView.snp.centerY).offset(20)
                $0.width.greaterThanOrEqualTo(10)
                $0.height.equalTo(20)
            }
            .font(UIFont.FontName_PoppinsBold, 16)
            .color(UIColor(hexString: "#22214B")!)
            .text("1/3")
        
        processedDescribeLabel
            .adhere(toSuperview: overlayerBgView) {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(processedCountLabel.snp.bottom).offset(10)
                $0.width.greaterThanOrEqualTo(10)
                $0.height.equalTo(20)
            }
            .font(UIFont.FontName_PoppinsMedium, 14)
            .color(UIColor(hexString: "#FFFFFF")!)
            .text("Analyzing and \(BDsoToManager.default.currentSelectItem.featureName)...")
        // "Uploading image..." "Downloading image..."
        //
        let processedCancelBtn = UIButton()
        processedCancelBtn
            .adhere(toSuperview: overlayerBgView) {
                $0.top.equalTo(processedDescribeLabel.snp.bottom).offset(40)
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(35)
                $0.height.equalTo(60)
            }
            .backgroundColor(UIColor(hexString: "#606078")!)
            .title("CANCEL")
            .font(UIFont.FontName_PoppinsBold, 16)
            .titleColor(UIColor(hexString: "#FFFFFF")!)
            .cornerRadius(30, masksToBounds: false)
            .shadow(color: UIColor(hexString: "#29263D")!, radius: 20, opacity: 0.05, offset: CGSize(width: 0, height: 10), path: nil)
            .target(target: self, action: #selector(processedCancelBtnClick), event: .touchUpInside)
        //
        
        processedChecknowBtn
            .adhere(toSuperview: overlayerBgView) {
                $0.edges.equalTo(processedCancelBtn)
            }
            .backgroundColor(UIColor(hexString: "#22214B")!)
            .cornerRadius(30, masksToBounds: false)
            .title("CHECK NOW")
            .font(UIFont.FontName_PoppinsBold, 16)
            .titleColor(UIColor(hexString: "#FFFFFF")!)
            .shadow(color: UIColor(hexString: "#29263D")!, radius: 20, opacity: 0.05, offset: CGSize(width: 0, height: 10), path: nil)
            .target(target: self, action: #selector(processedChecknowBtnClick), event: .touchUpInside)
        //
        
        processingLoadingImgV
            .adhere(toSuperview: overlayerBgView) {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(processedCountLabel.snp.top).offset(-40)
                $0.width.height.equalTo(160)
            }
            .image("fe_processingloading")
//
        
    }
    
    func updateDownloadStatus(processingStep: ProcessingStep) {
        self.currentProcessingStep = processingStep
        switch processingStep {
        case .before:
            shareBtn.isHidden = true
            downloadSaveBtn.isHidden = true
            overlayerBgView.isHidden = true
        case .processStep1:
            overlayerBgView.isHidden = false
            processedChecknowBtn.isHidden = true
            processedCountLabel.text("1/3")
            processedDescribeLabel.text("Uploading image...")
            processingLoadingImgV.image("fe_processingloading")
        case .processStep2:
            overlayerBgView.isHidden = false
            processedChecknowBtn.isHidden = true
            processedCountLabel.text("2/3")
            processedDescribeLabel.text("Analyzing and \(BDsoToManager.default.currentSelectItem.featureName)...")
            processingLoadingImgV.image("fe_processingloading")
        case .processStepFinish:
            overlayerBgView.isHidden = false
            processedChecknowBtn.isHidden = false
            processedCountLabel.text("Finished")
            processedDescribeLabel.text("Downloading image...")
            processingLoadingImgV.image("fe_processeddone")
        case .downloadSave:
            overlayerBgView.isHidden = true
            shareBtn.isHidden = false
            downloadSaveBtn.isHidden = false
        }
        
    }
    
    func updateProcessedImg(processedImg: UIImage) {
        self.contentImgV.image = processedImg
    }
    
  
    @objc func backBtnClick() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func shareBtnClick() {
        
    }
    
    @objc func startBtnClick() {
        
        if let token = BDsoNetManager.default.getTokenInfo() {
            BDsoNetManager.default.accessTokey = token
            processRequestImg()
        } else {
            BDsoNetManager.default.apiRequest(target: .requestToken) {[weak self] jsonObject, error in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if let jsonObject_m = jsonObject {
                        let accesstoken = jsonObject_m["access_token"].stringValue
                        let expire = jsonObject_m["expires_in"].numberValue.doubleValue
                        BDsoNetManager.default.saveTokenInfo(tokenStr: accesstoken, expiresTime: expire)
                        BDsoNetManager.default.accessTokey = accesstoken
                        self.processRequestImg()
                    }
                }
            }
        }
    }
    
    func processRequestImg() {
        let base64str = BDsoToManager.default.processBase64Img(img: originImg)
        if let base64str_m = base64str {
            if base64str_m == "error_1" {
                self.showAlert(title: "Sorry", message: "Make sure that the longest side of the image is not four times higher than the shortest side")
            } else {
                self.requestFeature(imgBase64: base64str_m)
            }
        } else {
            self.showAlert(title: "Sorry", message: "Some errors have occurred, please replace the picture and try again")
        }
        
    }
    
    func dicToJsonString(dicArr: [[String: Any]]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: dicArr, options: []) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func requestFeature(imgBase64: String) {
        
        var outapi: OutAPI = OutAPI.requestToken
        switch BDsoToManager.default.currentSelectItem.ftype {
        case .sharpen:
            outapi = .sharpen(imgBase64: imgBase64)
        case .enhancer:
            outapi = .enhancer(imgBase64: imgBase64)
        case .repair:
            let w: CGFloat = originImg.size.width * (1.0/2.0)
            let h: CGFloat = originImg.size.height * (1.0/2.0)
            let offx: CGFloat = originImg.size.width * (1.0/4.0)
            let offy: CGFloat = originImg.size.height * (1.0/4.0)
            
            let arr: [[String: Any]] = [["width" : w, "top" : offy, "height" : h, "left" : offx]]
            if let arrjsonstr = self.dicToJsonString(dicArr: arr) {
                outapi = .repair(imgBase64: imgBase64, rectangle: arrjsonstr)
            } else {
                self.showAlert(title: "Sorry", message: "Some errors have occurred, please replace the picture and try again")
            }
            
        case .restoration:
            outapi = .restoration(imgBase64: imgBase64)
        case .denoise:
            outapi = .denoise(imgBase64: imgBase64, option: 100)
        case .enlarge:
            outapi = .enlarge(imgBase64: imgBase64)
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if let img = BDsoToManager.default.processImgFrom(base64: processBase64) {
                    debugPrint(img)
                    self.contentImgV.image = img
                }
            }

        }
        
        
        
        /*
        BDsoNetManager.default.apiRequest(target: outapi) {[weak self] jsonObject, error in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if let jsonObject_m = jsonObject {
                    let processedImgBase64 = jsonObject_m["image"].stringValue
                    debugPrint("processedImgBase64 - \(processedImgBase64)")
                    if let img = BDsoToManager.default.processImgFrom(base64: processedImgBase64) {
                        debugPrint(img)
                        self.contentImgV.image = img
                    }
                }
            }
        }
        */
        
    }
    
    @objc func saveBtnClick() {
        
    }

    @objc func processedCancelBtnClick() {
        
    }
    
    @objc func processedChecknowBtnClick() {
        
    }
    
    
}
