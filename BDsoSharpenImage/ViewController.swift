//
//  ViewController.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/4.
//

import UIKit
import EllipsePageControl

class ViewController: UIViewController {

    let bgCoverImgV = UIImageView()
    let contentBgV = UIView()
    let pagecontrol = EllipsePageControl()
    var layoutSubsViewOnce = Once()
    let featureTypeCollection = BDsoFeatureTypeCollection()
    var previewListCollection: BDsoFeaturePreviewList!
    
    var featureTitleLabel = UILabel()
    var featureInfoDesLabel = UILabel()
    let upoproBtn = UIButton()

    func updateProBtnStatus() {
        if BDsoSharSubscbeManager.default.inSubscription {
            upoproBtn.isHidden = true
        } else {
            upoproBtn.isHidden = false
        }
    }
    
    func addnoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateContentProStatus(noti: )), name: NSNotification.Name(rawValue: SubNotificationKeys.success), object: nil)

    }

    @objc func updateContentProStatus(noti: Notification) {
        DispatchQueue.main.async {
            self.updateProBtnStatus()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addnoti()
        setupContentView()
        updateCurrentEffectStatus(currentIdx: IndexPath(item: 0, section: 0))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if contentBgV.bounds.size.width == UIScreen.main.bounds.size.width {
            layoutSubsViewOnce.run {
                self.stupCanvasV()
            }
        }
    }
    
    func stupCanvasV() {
        //
        var canvasVW: CGFloat = contentBgV.bounds.size.width
        var canvasVH: CGFloat = contentBgV.bounds.size.height
        let targetSizeW: CGFloat = canvasVW
        let targetSizeH: CGFloat = canvasVH
        
        if targetSizeW / targetSizeH > canvasVW / canvasVH {
            canvasVH = canvasVW * (targetSizeH/targetSizeW)
        } else {
            canvasVW = canvasVH * (targetSizeW/targetSizeH)
        }
        
        previewListCollection = BDsoFeaturePreviewList(frame: CGRect(x: 0, y: 0, width: canvasVW, height: canvasVH))
        contentBgV.addSubview(previewListCollection)
        previewListCollection.featureItemClickBlock = {
            [weak self] feaitem, indexP in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateCurrentEffectStatus(currentIdx: indexP)
                self.selectScrollfeatureTypeCollectionStatus(currentIdx: indexP)
            }
        }
        
    }
    
    func setupContentView() {
        view.backgroundColor(.white)
            .clipsToBounds()
        bgCoverImgV
            .adhere(toSuperview: view) {
                $0.edges.equalToSuperview()
            }
            .contentMode(.scaleAspectFill)
        //
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.adhere(toSuperview: view) {
            $0.edges.equalToSuperview()
        }
        
        //
        let settingBtn = UIButton()
            .adhere(toSuperview: view) {
                $0.left.equalToSuperview().offset(20)
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
                $0.width.equalTo(180)
                $0.height.equalTo(48)
            }
            .image(UIImage(named: "effect"))
            .title(" Sharpen")
            .font(UIFont.FontName_PoppinsBold, 32)
            .titleColor(UIColor(hexString: "#22214B")!)
            .target(target: self, action: #selector(settingBtnClick), event: .touchUpInside)
        settingBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        //
       // /*

        
        upoproBtn
            .adhere(toSuperview: view) {
                $0.right.equalToSuperview().offset(-20)
                $0.centerY.equalTo(settingBtn.snp.centerY).offset(0)
                $0.width.equalTo(71)
                $0.height.equalTo(32)
            }
            .image(UIImage(named: "homeproicon"))
            .target(target: self, action: #selector(upoproBtnClick), event: .touchUpInside)

       // */
        //
        let cellw: CGFloat = CGFloat(Int((UIScreen.width() - (BDsoToManager.default.cpadding * CGFloat((BDsoToManager.default.featureList.count + 1)))) / CGFloat(BDsoToManager.default.featureList.count)))
        let cellh: CGFloat = cellw + 16
        
        featureTypeCollection
            .adhere(toSuperview: view) {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(settingBtn.snp.bottom).offset(10)
                $0.height.equalTo(cellh)
            }
        featureTypeCollection.featureItemClickBlock = {
            [weak self] feaitem, indexP in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateCurrentEffectStatus(currentIdx: indexP)
                self.selectScrollPreviewListStatus(currentIdx: indexP)
            }
        }
        //
        contentBgV.adhere(toSuperview: view) {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(featureTypeCollection.snp.bottom).offset(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-160)
        }
        //
        let usereffectBtn = UIButton()
            .adhere(toSuperview: view) {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(290)
                $0.height.equalTo(60)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            }
            .backgroundColor(UIColor(hexString: "#22214B")!)
            .cornerRadius(30)
            .title("Use Effect")
            .titleColor(UIColor.white)
            .font(UIFont.FontName_PoppinsBold, 16)
            .target(target: self, action: #selector(usereffectBtnClick), event: .touchUpInside)
        //
        
        featureTitleLabel
            .adhere(toSuperview: view) {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(contentBgV.snp.top).offset(-16)
                $0.width.height.greaterThanOrEqualTo(10)
            }
            .color(UIColor(hexString: "#22214B")!)
            .font(UIFont.FontName_PoppinsBold, 20)
        
        featureInfoDesLabel
            .adhere(toSuperview: view) {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(contentBgV.snp.bottom).offset(16)
                $0.width.height.greaterThanOrEqualTo(10)
            }
            .color(UIColor(hexString: "#22214B")!)
            .font(UIFont.FontName_PoppinsRegular, 14)
        
        //
        let pageControlBgV = UIView()
        view.addSubview(pageControlBgV)
        pageControlBgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(featureInfoDesLabel.snp.bottom).offset(12)
            $0.width.equalTo(75)
            $0.height.equalTo(6)
        }
        //
        pagecontrol.frame = CGRect(x: 0, y: 0, width: 75, height: 6)
        pagecontrol.numberOfPages = BDsoToManager.default.featureList.count
        pagecontrol.currentPage = 0
        pagecontrol.currentColor = UIColor.white
        pagecontrol.otherColor = UIColor.white.withAlphaComponent(0.3)
        
        pageControlBgV.addSubview(pagecontrol)
        
    }
    
    func updateCurrentEffectStatus(currentIdx: IndexPath) {
        featureTitleLabel.text(BDsoToManager.default.currentSelectItem.featureName)
        featureInfoDesLabel.text(BDsoToManager.default.currentSelectItem.descriName)
        pagecontrol.currentPage = currentIdx.item
        bgCoverImgV.image(BDsoToManager.default.currentSelectItem.preImage1Str)
    }
    
    func selectScrollPreviewListStatus(currentIdx: IndexPath) {
        if self.previewListCollection.isAutoScroll == false {
            previewListCollection.isAutoScroll = true
            previewListCollection.scalingCarousel.scrollToItem(at: currentIdx, at: .centeredHorizontally, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.previewListCollection.isAutoScroll = false
                }
            }
        }
        
         
    }
    
    func selectScrollfeatureTypeCollectionStatus(currentIdx: IndexPath) {
        featureTypeCollection.collection.reloadData()
    }
    
    @objc func usereffectBtnClick() {
        let effectVC = BDsoEffectContentVC()
        self.navigationController?.pushViewController(effectVC, animated: true)
    }
    
    @objc func settingBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        self.sideMenuController?.showLeftView()
        if let setvc = self.sideMenuController?.leftViewController as? BDsoShareSettingVC {
            setvc.viewWillAppear(true)
        }
    }
    
    @objc func upoproBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        let vc = BDsoSubscribeStoreVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

