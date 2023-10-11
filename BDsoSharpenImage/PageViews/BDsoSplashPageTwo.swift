//
//  BDsoSplashPageTwo.swift
//  BDsoSharpenImage
//
//  Created by Joe on 2023/8/16.
//

import UIKit


class BDsoSplashPageTwo: UIView {
    var iconImgStr = "storebgimg"
    var infoStr = "Unlimited access to all features and future updates only for $9.99 per week, auto renewable, cancel anytime."
    var nameStr = "Make Awesome Photos"
    let infoL = UILabel()
    var continueClickBlock: (()->Void)?
    var cancelBtnClickBlock: (()->Void)?
    let contiNextBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupV()
        fetchPriceLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func startAni() {
//
//    }
    
    func setupV() {
        backgroundColor(.white)
        let iconImgV = UIImageView()
            .adhere(toSuperview: self) {
                $0.left.right.top.bottom.equalToSuperview()
            }
            .image(iconImgStr)
            .contentMode(.scaleAspectFill)
        //
        
        contiNextBtn
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(self.snp.bottom).offset(-54)
                $0.width.equalTo(320)
                $0.height.equalTo(60)
            }
            .backgroundColor(UIColor(hexString: "#22214B")!)
            .cornerRadius(30)
            .title("CONTINUE")
            .titleColor(.white)
            .font(UIFont.FontName_PoppinsBold, 16)
            .target(target: self, action: #selector(contiNextBtnClick), event: .touchUpInside)
        
        contiNextBtn.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        
       //
       let nameL = UILabel()
           .adhere(toSuperview: self) {
               $0.bottom.equalTo(contiNextBtn.snp.top).offset(-130)
               $0.centerX.equalToSuperview()
               $0.left.equalToSuperview().offset(10)
               $0.height.greaterThanOrEqualTo(24)
           }
           .font(UIFont.FontName_PoppinsBold, 24)
           .color(UIColor(hexString: "#22214B")!)
           .textAlignment(.center)
           .text(nameStr)
           .adjustsFontSizeToFitWidth()
       //
       
        infoL
           .adhere(toSuperview: self) {
               $0.top.equalTo(nameL.snp.bottom).offset(8)
               $0.centerX.equalToSuperview()
               $0.left.equalToSuperview().offset(10)
               $0.height.lessThanOrEqualTo(75)
           }
           .font(UIFont.FontName_PoppinsRegular, 16)
           .color(UIColor(hexString: "#22214B")!.withAlphaComponent(0.7))
           .textAlignment(.center)
           .adjustsFontSizeToFitWidth()
           .numberOfLines(3)
        
        //
        let cancelBtn = UIButton()
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(contiNextBtn.snp.top).offset(-5)
                $0.width.equalTo(288)
                $0.height.equalTo(30)
            }
//            .titleColor(UIColor(hexString: "#262B55")!.withAlphaComponent(0.3))
//            .font(UIFont.SFProTextMedium, 12)
//            .backgroundImage(UIImage(named: "splash1button"))
            .target(target: self, action: #selector(cancelBtnClick), event: .touchUpInside)
        
        let attriStr = NSAttributedString(string: "Or proceed with limited version", attributes: [NSAttributedString.Key.font : UIFont(name: UIFont.FontName_PoppinsRegular, size: 12) ?? UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#22214B")!.withAlphaComponent(0.7), NSAttributedString.Key.underlineStyle : 1, NSAttributedString.Key.underlineColor : UIColor(hexString: "#22214B")!.withAlphaComponent(0.7)])
        
        cancelBtn.setAttributedTitle(attriStr, for: .normal)
    }
    
    func startAnimal(isStart: Bool) {
        if isStart {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15) {
                [weak self] in
                guard let `self` = self else {return}
                self.startAnimal()
            }
            
        } else {
            stopAnimal()
        }
    }
    
    func startAnimal() {
        //transform.scale
        let animation = CABasicAnimation(keyPath: "transform.scale")

        animation.fromValue = 0.95
        animation.toValue = 1.08
        animation.duration  = 0.45
        animation.autoreverses = true
        animation.fillMode = .forwards
        animation.repeatCount = HUGE
        
        contiNextBtn.layer.add(animation, forKey: "zoom")
        
        
//        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
//        animation.fromValue = 0.0
//        animation.toValue = CGFloat.pi * 2
//        animation.duration  = 1
//        animation.autoreverses = false
//        animation.fillMode = .forwards
//        animation.repeatCount = HUGE
//
//        contiNextBtn.layer.add(animation, forKey: "radarAnimation")
        
        
    }
    
    func stopAnimal() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            [weak self] in
            guard let `self` = self else {return}
            self.contiNextBtn.layer.removeAllAnimations()
        }
        
    }
    
    func fetchPriceLabels() {
        
        if BDsoSharSubscbeManager.default.iapPriceFetchResultList.count >= 1 {
            updatePrice()
        } else {
            updatePrice()
            BDsoSharSubscbeManager.default.loadContentData {[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.updatePrice()
                }
            }
        }
    }
    
    
    func updatePrice() {
        let symbol = BDsoSharSubscbeManager.default.currentSymble()
        let weekprice = BDsoSharSubscbeManager.default.currentProductPrice(purchaseIapStr: BDsoSharSubscbeManager.default.weekIap)
        infoL.text = "Unlimited access to all features and future updates only for \(symbol)\(weekprice) per week, auto renewable, cancel anytime."
        
    }
    
    

    @objc func contiNextBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        continueClickBlock?()
        
    }
    @objc func cancelBtnClick() {
        cancelBtnClickBlock?()
        
    }
    

}
