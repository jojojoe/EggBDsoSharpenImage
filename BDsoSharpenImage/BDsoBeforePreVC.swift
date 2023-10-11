//
//  BDsoBeforePreVC.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/10.
//

import UIKit
import KRProgressHUD
import Photos

enum ProcessingStep {
    case before
    case processStep1
    case processStep2
    case processStepFinish
    case downloadSave
}

enum CurrentActionStatue {
    case none
    case save
    case share
}

class BDsoBeforePreVC: UIViewController {
    
    var originImg: UIImage
    let contentBgV = UIView()
    let canvasV = UIView()
    let contentImgV = UIImageView()
    let shareBtn = UIButton()
    let downloadSaveBtn = UIButton()
    let duibiBtn = UIButton()
    let processedDescribeLabel = UILabel()
    let processedCountLabel = UILabel()
    let processedChecknowBtn = UIButton()
    let processingLoadingImgV = UIImageView()
    let overlayerBgView = UIView()
    var loadingTimer: Timer?
    var currentProcessingStep: ProcessingStep = .before
    var processImg: UIImage?
    var isProcessing: Bool = false
    var loadingPenddingTime: Int = 0
    private let radarAnimation = "radarAnimation"
    var layoutSubsViewOnce = Once()
//    var isCurrentSaveClick = true
    var actionStatus: CurrentActionStatue = .none
    //
    private var quad: Quadrilateral
    private var quadViewWidthConstraint = NSLayoutConstraint()
    private var quadViewHeightConstraint = NSLayoutConstraint()
    private lazy var quadView: QuadrilateralView = {
        let quadView = QuadrilateralView()
        quadView.editable = true
        quadView.strokeColor = UIColor(hexString: "#FFFFFF")!.cgColor
        quadView.translatesAutoresizingMaskIntoConstraints = false
        return quadView
    }()
    private var zoomGestureController: ZoomGestureController!
    
    //
    
    static func defaultQuad(forImage image: UIImage) -> Quadrilateral {
        let topLeft = CGPoint(x: image.size.width * 0.3, y: image.size.height * 0.3)
        let topRight = CGPoint(x: image.size.width * 0.7, y: image.size.height * 0.3)
        let bottomLeft = CGPoint(x: image.size.width * 0.3, y: image.size.height * 0.7)
        let bottomRight = CGPoint(x: image.size.width * 0.7, y: image.size.height * 0.7)

        let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)

        return quad
    }
    
    
    
    init(originImg: UIImage) {
        let (img, _) = BDsoToManager.default.processBase64Img(img: originImg)
        self.originImg = img
        self.quad = BDsoBeforePreVC.defaultQuad(forImage: img)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if contentBgV.bounds.size.width == UIScreen.main.bounds.size.width {
            layoutSubsViewOnce.run {
                self.stupCanvasV()
                if BDsoToManager.default.currentSelectItem.ftype == .repair {
                    self.setupQuadView()
                    self.adjustQuadViewConstraints()
                    self.displayQuad()
                } else {
                    
                }
                
                
                
            }
        }
    }
    
    func stupCanvasV() {
        //
        let offsetX: CGFloat = 30
        let offsetY: CGFloat = 40
        var canvasVW: CGFloat = contentBgV.bounds.size.width - offsetX * 2
        var canvasVH: CGFloat = contentBgV.bounds.size.height - offsetY * 2
        let targetSizeW: CGFloat = originImg.size.width
        let targetSizeH: CGFloat = originImg.size.height
        
        if targetSizeW / targetSizeH > canvasVW / canvasVH {
            canvasVH = canvasVW * (targetSizeH/targetSizeW)
        } else {
            canvasVW = canvasVH * (targetSizeW/targetSizeH)
        }
        
        //
        contentBgV.addSubview(canvasV)
        canvasV.frame = CGRect(origin: CGPoint(x: (contentBgV.bounds.size.width - canvasVW)/2, y: (contentBgV.bounds.size.height - canvasVH)/2), size: CGSize(width: canvasVW, height: canvasVH))
        
        //
        contentImgV
            .adhere(toSuperview: canvasV) {
                $0.edges.equalToSuperview()
            }
            .contentMode(.scaleAspectFit)
        contentImgV.image = originImg
        
        
        
    }
    
    
    private func setupConstraints() {
        quadViewWidthConstraint = quadView.widthAnchor.constraint(equalToConstant: 0.0)
        quadViewHeightConstraint = quadView.heightAnchor.constraint(equalToConstant: 0.0)
        let quadViewConstraints = [
            quadView.centerXAnchor.constraint(equalTo: canvasV.centerXAnchor),
            quadView.centerYAnchor.constraint(equalTo: canvasV.centerYAnchor),
            quadViewWidthConstraint,
            quadViewHeightConstraint
        ]
        NSLayoutConstraint.activate(quadViewConstraints)
    }
    
    
    
    
    

    func setupQuadView() {
        //
        canvasV.addSubview(quadView)
        setupConstraints()
        
        //
        zoomGestureController = ZoomGestureController(image: originImg, quadView: quadView)
        let touchDown = UILongPressGestureRecognizer(target: zoomGestureController, action: #selector(zoomGestureController.handle(pan:)))
        touchDown.minimumPressDuration = 0
        contentBgV.addGestureRecognizer(touchDown)
        zoomGestureController.touchMoveBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if let qua = self.quadView.quad {
                    let scaledQuad = qua.scale(self.quadView.bounds.size, self.originImg.size)
                    self.quad = scaledQuad
                }
            }
        }
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
                $0.right.equalToSuperview().offset(-20)
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
                $0.width.equalTo(48)
                $0.height.equalTo(48)
            }
            .image(UIImage(named: "icon_share_b"))
            .target(target: self, action: #selector(shareBtnClick), event: .touchUpInside)
        //
        
        contentBgV.adhere(toSuperview: view) {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-140)
        }
        
        duibiBtn.adhere(toSuperview: view) {
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(contentBgV.snp.bottom).offset(-20)
            $0.width.height.equalTo(40)
        }
        duibiBtn.setImage(UIImage(named: "dibii"), for: .normal)
        duibiBtn.backgroundColor = .clear
        duibiBtn.addTarget(self, action: #selector(duibiBtnClickTouchDown), for: .touchDown)
        duibiBtn.addTarget(self, action: #selector(duibiBtnClickTouchUp), for: .touchUpInside)
        duibiBtn.addTarget(self, action: #selector(duibiBtnClickTouchUp), for: .touchUpOutside)
        
        //
        
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
        BDsoSharSubscbeManager.default.giveTapVib()
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func shareBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        actionStatus = .share
        saveImgsToAlbumOrShare()
        if BDsoSharSubscbeManager.default.inSubscription {
            
        } else {
            showSubscribeVC()
        }
        
    }
    
    func showSubscribeVC() {
        let vc = BDsoSubscribeStoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
//        vc.purchaseSuccessBlock = { [weak self] in
//            guard let `self` = self else {return}
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
////                self.processCheckAction()
//            }
//        }
//        vc.pageDisappearBlock = {
//            [weak self] in
//            guard let `self` = self else {return}
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
//                self.navigationController?.popToRootViewController(animated: true)
//            }
//        }
    }
    
    @objc func startBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        
        if BDsoSharSubscbeManager.default.inSubscription {
            isProcessing = true
            updateDownloadStatus(processingStep: .processStep1)
            makeRadarAnimation(animalView: processingLoadingImgV)
            if let token = BDsoNetManager.default.getTokenInfo() {
                BDsoNetManager.default.accessTokey = token
                processRequestImg()
                debugPrint("token = \(token)")
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
                            debugPrint("token api = \(accesstoken)")
                        }
                    }
                }
            }
        } else {
            isProcessing = true
            updateDownloadStatus(processingStep: .processStep1)
            makeRadarAnimation(animalView: processingLoadingImgV)
            
            let timer = Timer.after(2) {
                [weak self] in
                guard let `self` = self else {return}
                if self.isProcessing {
                    DispatchQueue.main.async {
                        self.updateDownloadStatus(processingStep: .processStep2)
                        Timer.after(2) {
                            [weak self] in
                            guard let `self` = self else {return}
                            if self.isProcessing {
                                DispatchQueue.main.async {
                                    if let timer = self.loadingTimer {
                                        timer.invalidate()
                                        self.loadingTimer = nil
                                    }
                                    self.processingLoadingImgV.layer.removeAnimation(forKey: self.radarAnimation)
                                    self.updateDownloadStatus(processingStep: .processStepFinish)
                                    
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
        
        
    }
    
    func processRequestImg() {
        let (_, base64str) = BDsoToManager.default.processBase64Img(img: originImg)
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
//            outapi = .enhancer(imgBase64: imgBase64)
            outapi = .denoise(imgBase64: imgBase64, option: 50)
        case .repair:
            
//            let scaledQuad = self.quad.scale(self.quadView.bounds.size, self.originImg.size)
//            debugPrint("self.originImg.size = \(self.originImg.size)")
            let scaledQuad = self.quad
            
            let w: Int = Int((scaledQuad.bottomRight.x) - (scaledQuad.topLeft.x))
            let h: Int = Int((scaledQuad.bottomRight.y) - (scaledQuad.topLeft.y))
            let offx: Int = Int(scaledQuad.topLeft.x)
            let offy: Int = Int(scaledQuad.topLeft.y)
            
            let arr: [[String: Int]] = [["width" : w, "top" : offy, "height" : h, "left" : offx]]
//            let arr: [[String: Int]] = [["width" : 100, "top" : 100, "height" : 100, "left" : 100]]
//            debugPrint("remove area = \(arr)")
            outapi = .repair(imgBase64: imgBase64, rectangle: arr)
//            if let arrjsonstr = self.dicToJsonString(dicArr: arr) {
//
//            } else {
//                self.showAlert(title: "Sorry", message: "Some errors have occurred, please replace the picture and try again")
//            }
        case .restoration:
            outapi = .restoration(imgBase64: imgBase64)
        case .denoise:
            outapi = .denoise(imgBase64: imgBase64, option: 50)
        case .enlarge:
            outapi = .enlarge(imgBase64: imgBase64)
        }
        
        let timer = Timer.after(2) {
            [weak self] in
            guard let `self` = self else {return}
            if self.isProcessing {
                DispatchQueue.main.async {
                    self.updateDownloadStatus(processingStep: .processStep2)
                    Timer.after(2) {
                        [weak self] in
                        guard let `self` = self else {return}
                        if self.isProcessing {
                            DispatchQueue.main.async {
                                self.loadingPenddingTime = 0
                                self.loadingTimer = Timer.every(1) {
                                    [weak self] in
                                    guard let `self` = self else {return}
                                    DispatchQueue.main.async {
                                        if self.isProcessing {
                                            self.checkResultStatus()
                                            self.loadingPenddingTime += 1
                                            if self.loadingPenddingTime == 120 {
                                                self.requestTimeoutAlert()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        /*
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if let img = BDsoToManager.default.processImgFrom(base64: processBase64) {
                    debugPrint(img)
                    self.processImg = img
                    
                }
            }
        }
        */
        
        
//        /*
        BDsoNetManager.default.apiRequest(target: outapi) { jsonObject, responseCode in
            DispatchQueue.main.async {
                if let jsonObject_m = jsonObject {
                    var imgKey: String = "image"
                    switch outapi {
                    case .denoise(_, _):
                        imgKey = "result"
                    default:
                        break
                    }
                    let processedImgBase64 = jsonObject_m[imgKey].stringValue
                    if processedImgBase64.count >= 1 {
                        
                        if BDsoToManager.default.currentSelectItem.ftype == .sharpen {
                            let processApi1: OutAPI = .quwu(imgBase64: processedImgBase64)
                            BDsoNetManager.default.apiRequest(target: processApi1) { jsonObject, responseCode in
                                DispatchQueue.main.async {
                                    if let jsonObject_m = jsonObject {
                                        var imgKey: String = "image"
                                        switch processApi1 {
                                        case .denoise(_, _):
                                            imgKey = "result"
                                        default:
                                            break
                                        }
                                        let processedImgBase64 = jsonObject_m[imgKey].stringValue
                                        if processedImgBase64.count >= 1 {
                                            let processApi2: OutAPI = .qingxiduzengqiang(imgBase64: processedImgBase64)
                                            BDsoNetManager.default.apiRequest(target: processApi2) { jsonObject, responseCode in
                                                DispatchQueue.main.async {
                                                    if let jsonObject_m = jsonObject {
                                                        var imgKey: String = "image"
                                                        switch processApi2 {
                                                        case .denoise(_, _):
                                                            imgKey = "result"
                                                        default:
                                                            break
                                                        }
                                                        let processedImgBase64 = jsonObject_m[imgKey].stringValue
                                                        if processedImgBase64.count >= 1 {
                                                            if let img = BDsoToManager.default.processImgFrom(base64: processedImgBase64) {
                                                                self.processImg = img
                                                            } else {
                                                                debugPrint("processedImgBase64 - 未解析图片")
                                                                self.requestTimeoutAlert()
                                                            }
                                                        } else {
                                                            debugPrint("processedImgBase64 - 未解析出来")
                                                            self.requestTimeoutAlert()
                                                        }

                                                    } else {
                                                        self.requestTimeoutAlert()
                                                    }
                                                }
                                            } failure: {[weak self] outerror in
                                                guard let `self` = self else {return}
                                                if let er = outerror {
                                                    DispatchQueue.main.async {
                                                        self.requestTimeoutAlert()
                                                    }
                                                }
                                            }
                                        } else {
                                            debugPrint("processedImgBase64 - 未解析出来")
                                            self.requestTimeoutAlert()
                                        }

                                    } else {
                                        self.requestTimeoutAlert()
                                    }
                                }
                            } failure: {[weak self] outerror in
                                guard let `self` = self else {return}
                                if let er = outerror {
                                    DispatchQueue.main.async {
                                        self.requestTimeoutAlert()
                                    }
                                }
                            }
                        } else if BDsoToManager.default.currentSelectItem.ftype == .enhancer {
                            let processApi: OutAPI = .sharpen(imgBase64: processedImgBase64)
                            BDsoNetManager.default.apiRequest(target: processApi) { jsonObject, responseCode in
                                DispatchQueue.main.async {
                                    if let jsonObject_m = jsonObject {
                                        var imgKey: String = "image"
                                        switch processApi {
                                        case .denoise(_, _):
                                            imgKey = "result"
                                        default:
                                            break
                                        }
                                        let processedImgBase64 = jsonObject_m[imgKey].stringValue
                                        if processedImgBase64.count >= 1 {
                                            if let img = BDsoToManager.default.processImgFrom(base64: processedImgBase64) {
                                                self.processImg = img
                                            } else {
                                                debugPrint("processedImgBase64 - 未解析图片")
                                                self.requestTimeoutAlert()
                                            }
                                        } else {
                                            debugPrint("processedImgBase64 - 未解析出来")
                                            self.requestTimeoutAlert()
                                        }

                                    } else {
                                        self.requestTimeoutAlert()
                                    }
                                }
                            } failure: {[weak self] outerror in
                                guard let `self` = self else {return}
                                if let er = outerror {
                                    DispatchQueue.main.async {
                                        self.requestTimeoutAlert()
                                    }
                                }
                            }
                        } else {
                            if let img = BDsoToManager.default.processImgFrom(base64: processedImgBase64) {
    //                            debugPrint(img)
                                self.processImg = img
                            } else {
                                debugPrint("processedImgBase64 - 未解析图片")
                                self.requestTimeoutAlert()
                            }
                        }
                      
                        
                    } else {
                        debugPrint("processedImgBase64 - 未解析出来")
                        self.requestTimeoutAlert()
                    }

                } else {
                    self.requestTimeoutAlert()
                }
            }
        } failure: {[weak self] outerror in
            guard let `self` = self else {return}
            if let er = outerror {
                DispatchQueue.main.async {
                    self.requestTimeoutAlert()
                }
            }
        }

//        */
        
    }
    
    @objc func saveBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        actionStatus = .save
        saveImgsToAlbumOrShare()
//        self.isCurrentSaveClick = true
        

    }

    @objc func processedCancelBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        isProcessing = false
        self.updateDownloadStatus(processingStep: .before)
        if self.processImg == nil {
            BDsoNetManager.cancelAllNetworkRequest()
        }
        KRProgressHUD.showInfo(withMessage: "You have canceled this operation")
    }
    
    @objc func processedChecknowBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        
        if BDsoSharSubscbeManager.default.inSubscription {
            processCheckAction()
        } else {
            
            showSubscribeVC()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.isProcessing = false
                    self.updateDownloadStatus(processingStep: .before)
                }
            }
        }
        
//        if let img = self.processImg {
//            self.updateProcessedImg(processedImg: img)
//        }
//        isProcessing = false
//        self.updateDownloadStatus(processingStep: .downloadSave)
//
//        if BDsoToManager.default.currentSelectItem.ftype == .repair {
//            self.quadView.isHidden = true
//        }
    }
    
    func processCheckAction() {
         
        if let img = self.processImg {
            self.updateProcessedImg(processedImg: img)
        }
        isProcessing = false
        self.updateDownloadStatus(processingStep: .downloadSave)
        
        if BDsoToManager.default.currentSelectItem.ftype == .repair {
            self.quadView.isHidden = true
        }
    }
    
    @objc func duibiBtnClickTouchDown() {
        BDsoSharSubscbeManager.default.giveTapVib()
        self.contentImgV.image = originImg
    }
    
    @objc func duibiBtnClickTouchUp() {
        if let img = processImg {
            self.contentImgV.image = img
        }
    }
    
}

extension BDsoBeforePreVC {
    func checkResultStatus() {
        if processImg != nil {
            if let timer = loadingTimer {
                timer.invalidate()
                loadingTimer = nil
            }
            processingLoadingImgV.layer.removeAnimation(forKey: radarAnimation)
            self.updateDownloadStatus(processingStep: .processStepFinish)
        }
    }
    
    private func makeRadarAnimation(animalView: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = CGFloat.pi * 2
        animation.duration  = 2
        animation.autoreverses = false
        animation.fillMode = .forwards
        animation.repeatCount = HUGE
        animalView.layer.add(animation, forKey: radarAnimation)
         
    }
    
    func requestTimeoutAlert() {
        isProcessing = false
        processingLoadingImgV.layer.removeAnimation(forKey: radarAnimation)
        self.updateDownloadStatus(processingStep: .before)
        if let timer = loadingTimer {
            timer.invalidate()
            loadingTimer = nil
        }
        BDsoNetManager.cancelAllNetworkRequest()
        KRProgressHUD.showInfo(withMessage: "Some problems occur, please check the network or restart and try again")
    }
    
    func saveImgsToAlbumOrShare() {
        let finishedImg = processImg ?? self.contentImgV.image ?? originImg
        let imgs = [finishedImg]
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            if self.actionStatus == .save {
                saveToAlbumPhotoAction(images: imgs)
            } else if self.actionStatus == .share {
                shareAction(images: imgs)
            }
            actionStatus = .none
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) {[weak self] status in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if status != .authorized || status != .limited {
                        return
                    }
                    if self.actionStatus == .save {
                        self.saveToAlbumPhotoAction(images: imgs)
                    } else if self.actionStatus == .share {
                        self.shareAction(images: imgs)
                    }
                    
                }
            }
        } else {
            // 权限提示
            showPhotoDeniedAlertV()
        }
    }
    
    
    func shareAction(images: [UIImage]) {
        let imgs = [processImg]
        let vc = UIActivityViewController(activityItems: images, applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view
        self.present(vc, animated: true)
    }
    
    
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    KRProgressHUD.showSuccess(withMessage: "The photo has been successfully saved to the album!")
                }
                
            }) { (finish, error) in
                if error != nil {
                    KRProgressHUD.showInfo(withMessage: "Sorry! please try again!")
                }
            }
        })
    }
    
    func showPhotoDeniedAlertV() {
        let alert = UIAlertController(title: "", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (goSettingAction) in
            DispatchQueue.main.async {
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:])
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    
}

extension BDsoBeforePreVC {
    private func displayQuad() {
        let imageSize = originImg.size
        let imageFrame = CGRect(
            origin: quadView.frame.origin,
            size: CGSize(width: quadViewWidthConstraint.constant, height: quadViewHeightConstraint.constant)
        )

        let scaleTransform = CGAffineTransform.scaleTransform(forSize: imageSize, aspectFillInSize: imageFrame.size)
        let transforms = [scaleTransform]
        let transformedQuad = self.quad.applyTransforms(transforms)

        quadView.drawQuadrilateral(quad: transformedQuad, animated: false)
    }
    
    private func adjustQuadViewConstraints() {
        let imgViewBound: CGRect = CGRect(x: 0, y: 0, width: canvasV.bounds.size.width, height: canvasV.bounds.size.height)
        let frame = AVMakeRect(aspectRatio: originImg.size, insideRect: imgViewBound)
        quadViewWidthConstraint.constant = frame.size.width
        quadViewHeightConstraint.constant = frame.size.height
    }
    
}
