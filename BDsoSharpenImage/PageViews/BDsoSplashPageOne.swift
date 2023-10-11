//
//  BDsoSplashPageOne.swift
//  BDsoSharpenImage
//
//  Created by Joe on 2023/8/16.
//

import UIKit


class BDsoSplashPageOne: UIView {

    enum SplahsPageType {
        case page1
        case page2
    }
    
    var splType: SplahsPageType
    var iconImgStr = "splashp1"
    var pointIconStr = "splpoint_1"
    var nameStr = "Track Your Lost Devices"
    var infoStr = "Can't find your lost bluetooth\ndevices"
    var continueClickBlock: (()->Void)?
    
    init(frame: CGRect, splType: SplahsPageType) {
        self.splType = splType
        super.init(frame: frame)
        switch splType {
        case .page1:
            iconImgStr = "yind01"
            pointIconStr = ""
            nameStr = "Al Sharpen Photo"
            infoStr = "We'd appreciate your feedback and rate us using Sharpen."
            
        case .page2:
            iconImgStr = "yind02"
            pointIconStr = ""
            nameStr = "Enhance Your Photo"
            infoStr = "Enhance your old photo to make it clearer and better."
            
        }
        
        
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        backgroundColor(.white)
        let iconImgV = UIImageView()
            .adhere(toSuperview: self) {
                $0.left.right.top.bottom.equalToSuperview()
            }
            .image(iconImgStr)
            .contentMode(.scaleAspectFill)
        //
        let contiNextBtn = UIButton()
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
        let infoL = UILabel()
            .adhere(toSuperview: self) {
                $0.top.equalTo(nameL.snp.bottom).offset(16)
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(10)
                $0.height.greaterThanOrEqualTo(10)
            }
            .font(UIFont.FontName_PoppinsRegular, 16)
            .color(UIColor(hexString: "#22214B")!.withAlphaComponent(0.7))
            .textAlignment(.center)
            .text(infoStr)
            .adjustsFontSizeToFitWidth()
            .numberOfLines(2)
        
    }
    
    @objc func contiNextBtnClick() {
        continueClickBlock?()
    }

}
