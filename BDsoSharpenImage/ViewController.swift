//
//  ViewController.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/4.
//

import UIKit

class ViewController: UIViewController {

    let bgCoverImgV = UIImageView()
    let contentBgV = UIView()
    
    let featureTypeCollection = BDsoFeatureTypeCollection()
    let previewListCollection = BDsoFeaturePreviewList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        setup
        
        contentBgV.addSubview(previewListCollection)
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
        let settingBtn = UIButton()
            .adhere(toSuperview: view) {
                $0.left.equalToSuperview().offset(20)
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
                $0.width.equalTo(175)
                $0.height.equalTo(48)
            }
            .image(UIImage(named: "effect"))
            .title(" Sharpen")
            .font(UIFont.FontName_PoppinsBold, 32)
            .titleColor(UIColor(hexString: "#22214B")!)
            .target(target: self, action: #selector(settingBtnClick), event: .touchUpInside)
        
        
        //
        let upoproBtn = UIButton()
            .adhere(toSuperview: view) {
                $0.right.equalToSuperview().offset(-20)
                $0.centerY.equalTo(settingBtn.snp.centerY).offset(0)
                $0.width.equalTo(71)
                $0.height.equalTo(32)
            }
            .image(UIImage(named: "homeproicon"))
            .target(target: self, action: #selector(upoproBtnClick), event: .touchUpInside)
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
                
            }
        }
        //
        contentBgV.adhere(toSuperview: view) {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(featureTypeCollection.snp.bottom).offset(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-160)
        }
        //
        
      
        
        //
        let usereffectBtn = UIButton()
            .adhere(toSuperview: view) {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(290)
                $0.height.equalTo(60)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            }
            .backgroundColor(UIColor(hexString: "#22214B")!)
            .cornerRadius(30)
        
    }
    
    
    
    

    @objc func settingBtnClick() {
        self.sideMenuController?.showLeftView()
        if let setvc = self.sideMenuController?.leftViewController as? BDsoShareSettingVC {
            setvc.viewWillAppear(true)
        }
    }
    
    @objc func upoproBtnClick() {
        
    }
}

