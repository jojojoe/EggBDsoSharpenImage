//
//  BDsoSubscribeStoreVC.swift
//  BDsoSharpenImage
//
//  Created by Joe on 2023/7/21.
//

import UIKit
import SnapKit
import KRProgressHUD

class BDsoSubscribeStoreVC: UIViewController {
    
    let monthProBtn = NEwStoreBtn(frame: .zero, productTypeIap: BDsoSharSubscbeManager.default.weekIap)
    let weekProBtn = NEwStoreBtn(frame: .zero, productTypeIap: BDsoSharSubscbeManager.default.monthIap)
    let yearProBtn = NEwStoreBtn(frame: .zero, productTypeIap: BDsoSharSubscbeManager.default.yearIap)
    var didlayoutOnce = Once()
    var pageDisappearBlock: (()->Void)?
    var purchaseSuccessBlock: (()->Void)?
    var backClickDisappearBlock: (()->Void)?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupV()
    }
    
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pageDisappearBlock?()
    }
   
    func setupV() {
        view.clipsToBounds = true
        //
        setupTopBanner()
        setupBottomBanner()
        fetchPriceLabels()
        
    }
    
    func setupTopBanner() {
        let _ = UIImageView()
            .adhere(toSuperview: view) {
                $0.left.right.top.bottom.equalToSuperview()
            }
            .image("storebgimg")
        //
        
        
        //
//        let backButton = UIButton()
//        backButton.adhere(toSuperview: view) {
//            $0.left.equalToSuperview().offset(10)
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
//            $0.width.height.equalTo(44)
//        }
//        .image(UIImage(named: "whiteArrowLeft"))
//        .target(target: self, action: #selector(backButtonClick), event: .touchUpInside)
        //
        let restoreButton = UIButton()
        restoreButton.adhere(toSuperview: view) {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.width.equalTo(64)
            $0.height.equalTo(44)
        }
        .title("Restore")
        .font(UIFont.FontName_PoppinsSemiBold, 16)
        .titleColor(UIColor(hexString: "#22214B")!)
        .target(target: self, action: #selector(restoreButtonClick), event: .touchUpInside)
    
    }
    
    func setupBottomBanner() {
        let bottomBanner = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 435, width: UIScreen.main.bounds.size.width, height: 435))
            .backgroundColor(UIColor.clear)
        view.addSubview(bottomBanner)
//        bottomBanner.roundCorners([.topLeft, .topRight], radius: 40)
        //
        let btitleL = UILabel()
            .adhere(toSuperview: bottomBanner) {
                $0.centerX.equalToSuperview().offset(0)
                $0.top.equalToSuperview().offset(0)
                $0.width.greaterThanOrEqualTo(10)
                $0.height.equalTo(42)
            }
            .font(UIFont.FontName_PoppinsBold, 28)
            .color(UIColor(hexString: "#22214B")!)
            .text("Upgrade to Premium")
        let btitle2L = UILabel()
            .adhere(toSuperview: bottomBanner) {
                $0.centerX.equalTo(btitleL.snp.centerX)
                $0.top.equalTo(btitleL.snp.bottom).offset(12)
                $0.width.greaterThanOrEqualTo(10)
                $0.height.greaterThanOrEqualTo(24)
            }
            .font(UIFont.FontName_PoppinsRegular, 16)
            .color(UIColor(hexString: "#22214B")!.withAlphaComponent(0.7))
            .text("All features can be used unlimitly")
       
        monthProBtn.adhere(toSuperview: bottomBanner) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(btitle2L.snp.bottom).offset(20)
            $0.width.equalTo(120)
            $0.height.equalTo(152)
        }
        .target(target: self, action: #selector(monthProBtnClick), event: .touchUpInside)
        //
        weekProBtn.adhere(toSuperview: bottomBanner) {
            $0.right.equalTo(monthProBtn.snp.left).offset(-8)
            $0.bottom.equalTo(monthProBtn.snp.bottom).offset(0)
            $0.width.equalTo(102)
            $0.height.equalTo(136)
        }
        .target(target: self, action: #selector(weekProBtnClick), event: .touchUpInside)
        //
        yearProBtn.adhere(toSuperview: bottomBanner) {
            $0.left.equalTo(monthProBtn.snp.right).offset(8)
            $0.bottom.equalTo(monthProBtn.snp.bottom).offset(0)
            $0.width.equalTo(102)
            $0.height.equalTo(136)
        }
        .target(target: self, action: #selector(yearProBtnClick), event: .touchUpInside)
        //
        monthProBtnClick()
        //
//        let monthBestView = UIButton()
//            .adhere(toSuperview: bottomBanner) {
//                $0.centerX.equalToSuperview()
//                $0.centerY.equalTo(monthProBtn.snp.top)
//                $0.width.equalTo(85)
//                $0.height.equalTo(24)
//            }
//            .backgroundImage(UIImage(named: "bestvalueicon"))
//            .title("Most Popular")
//            .font(UIFont.FontName_PoppinsRegular, 12)
//            .titleColor(UIColor.white)
//        monthBestView.isUserInteractionEnabled = false
        
        //
        let proContinueBtn = UIButton()
            .adhere(toSuperview: bottomBanner, {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(340)
                $0.height.equalTo(60)
                $0.top.equalTo(monthProBtn.snp.bottom).offset(52)
            })
            .backgroundColor(UIColor(hexString: "#22214B")!)
            .title("Continue".uppercased())
            .cornerRadius(30)
            .titleColor(UIColor.white)
            .font(UIFont.FontName_PoppinsBold, 16)
            .target(target: self, action: #selector(proContinueBtnClick), event: .touchUpInside)
        //
        let cancelBtn = UIButton()
            .adhere(toSuperview: view) {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(proContinueBtn.snp.top).offset(-5)
                $0.width.equalTo(288)
                $0.height.equalTo(36)
            }
            .target(target: self, action: #selector(backButtonClick), event: .touchUpInside)
        
        let attriStr = NSAttributedString(string: "Or proceed with limited version", attributes: [NSAttributedString.Key.font : UIFont(name: UIFont.FontName_PoppinsRegular, size: 12) ?? UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor(hexString: "#22214B")!.withAlphaComponent(0.7), NSAttributedString.Key.underlineStyle : 1, NSAttributedString.Key.underlineColor : UIColor(hexString: "#22214B")!.withAlphaComponent(0.7)])
        
        cancelBtn.setAttributedTitle(attriStr, for: .normal)
        
        //
        let termsofBtn = UIButton()
            .adhere(toSuperview: bottomBanner) {
                $0.right.equalTo(bottomBanner.snp.centerX).offset(-8)
                $0.top.equalTo(proContinueBtn.snp.bottom).offset(5)
                $0.width.equalTo(86)
                $0.height.equalTo(34)
            }
            .target(target: self, action: #selector(termsBtnClick), event: .touchUpInside)
            .title("Terms of Use")
            .titleColor(UIColor(hexString: "#22214B")!.withAlphaComponent(0.5))
            .font(UIFont.FontName_PoppinsRegular, 12)
        //
        let privacypoBtn = UIButton()
            .adhere(toSuperview: bottomBanner) {
                $0.left.equalTo(bottomBanner.snp.centerX).offset(8)
                $0.top.equalTo(termsofBtn.snp.top).offset(0)
                $0.width.equalTo(86)
                $0.height.equalTo(34)
            }
            .target(target: self, action: #selector(privacyBtnClick), event: .touchUpInside)
            .title("Privacy Policy")
            .titleColor(UIColor(hexString: "#22214B")!.withAlphaComponent(0.5))
            .font(UIFont.FontName_PoppinsRegular, 12)
        
        let lineoof = UIView()
            .adhere(toSuperview: bottomBanner) {
                $0.centerX.equalToSuperview()
                $0.centerY.equalTo(termsofBtn.snp.centerY)
                $0.width.equalTo(1)
                $0.height.equalTo(14)
            }
            .backgroundColor(UIColor(hexString: "#22214B")!.withAlphaComponent(0.5))
        
    }
    
     
}

extension BDsoSubscribeStoreVC {
    
    @objc func weekProBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        weekProBtn.isSelected = true
        monthProBtn.isSelected = false
        yearProBtn.isSelected = false
        BDsoSharSubscbeManager.default.currentSelectIapStr = BDsoSharSubscbeManager.default.monthIap
    }
    
    @objc func monthProBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        weekProBtn.isSelected = false
        monthProBtn.isSelected = true
        yearProBtn.isSelected = false
        BDsoSharSubscbeManager.default.currentSelectIapStr = BDsoSharSubscbeManager.default.weekIap
    }
    
    @objc func yearProBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        weekProBtn.isSelected = false
        monthProBtn.isSelected = false
        yearProBtn.isSelected = true
        BDsoSharSubscbeManager.default.currentSelectIapStr = BDsoSharSubscbeManager.default.yearIap
    }
    
    @objc func proContinueBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        BDsoSharSubscbeManager.default.subscribe(iapType: BDsoSharSubscbeManager.default.currentSelectIapStr) {[weak self] subSuccess, errorStr in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if subSuccess {
                    KRProgressHUD.showSuccess(withMessage: "The subscription was successful!")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.appbackbtnAction()
                        
                        self.purchaseSuccessBlock?()
                    }
                } else {
                    KRProgressHUD.showError(withMessage: errorStr ?? "The subscription failed")
                }
            }
        }
         
    }
    
    func appbackbtnAction() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func backButtonClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
//            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        self.backClickDisappearBlock?()
    }
    
    @objc func termsBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        BDsoToManager.default.userTermsAction()
    }
    
    @objc func privacyBtnClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        BDsoToManager.default.userPrivacyAction()
    }
    
    @objc func restoreButtonClick() {
        BDsoSharSubscbeManager.default.giveTapVib()
        if BDsoSharSubscbeManager.default.inSubscription {
            KRProgressHUD.showSuccess(withMessage: "You are already in the subscription period!")
        } else {
            BDsoSharSubscbeManager.default.restore { success in
                if success {
                    KRProgressHUD.showSuccess(withMessage: "The subscription was restored successfully")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.appbackbtnAction()
                    }
                } else {
                    KRProgressHUD.showMessage("Nothing to Restore")
                }
            }
        }
    }
}

extension BDsoSubscribeStoreVC {
    
    func updatePrice() {
        
        //"\(currentSymbol)\(Double(defaultYearPrice/12).accuracyToString(position: 2))/mo"
        let symbol = BDsoSharSubscbeManager.default.currentSymble()
        let weekprice = BDsoSharSubscbeManager.default.currentProductPrice(purchaseIapStr: BDsoSharSubscbeManager.default.weekIap)
        let monthprice = BDsoSharSubscbeManager.default.currentProductPrice(purchaseIapStr: BDsoSharSubscbeManager.default.monthIap)
        let yearprice = BDsoSharSubscbeManager.default.currentProductPrice(purchaseIapStr: BDsoSharSubscbeManager.default.yearIap)
        
        monthProBtn.updatePrice(str: "\(symbol) \(weekprice)")
        weekProBtn.updatePrice(str: "\(symbol) \(monthprice)")
        yearProBtn.updatePrice(str: "\(symbol) \(yearprice)")
        
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
}


class NEwStoreBtn: UIButton {
    var productTypeIap: String
    let typeLabel = UILabel()
    let priceLabel = UILabel()
    let priceTypeLabel = UILabel()
    let bgImgV = UIImageView()
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                if productTypeIap == BDsoSharSubscbeManager.default.weekIap {
                    bgImgV.image("Subscription_s")
                } else {
                    bgImgV.image("SubscriptionSmall_s")
                }
                
                
                
                let colorStrS = "#22214B"
                typeLabel.textColor = UIColor(hexString: colorStrS)
                priceLabel.textColor = UIColor(hexString: colorStrS)
                priceTypeLabel.textColor = UIColor(hexString: colorStrS)
            } else {
                
                if productTypeIap == BDsoSharSubscbeManager.default.weekIap {
                    bgImgV.image("Subscription_n")
                } else {
                    bgImgV.image("SubscriptionSmall_n")
                }
                
                let colorStrN = UIColor(hexString: "#22214B")?.withAlphaComponent(0.7)
                typeLabel.textColor = colorStrN
                priceLabel.textColor = UIColor(hexString: "#22214B")
                priceTypeLabel.textColor = colorStrN
            }
        }
    }
    
    init(frame: CGRect, productTypeIap: String) {
        self.productTypeIap = productTypeIap
        super.init(frame: frame)
        //
        self
            .backgroundColor(UIColor.clear)
//            .borderColor(UIColor(hexString: "#595F97")!, width: 1)
//            .cornerRadius(16, masksToBounds: true)
        //
        
        bgImgV.image("selectbgstore")
            .adhere(toSuperview: self) {
                $0.left.right.top.bottom.equalToSuperview()
            }
        //
        priceTypeLabel
            .adhere(toSuperview: self) {
                $0.centerY.equalToSuperview().offset(15)
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(2)
                $0.height.greaterThanOrEqualTo(20)
            }
            .textAlignment(.center)
            .font(UIFont.FontName_PoppinsRegular, 12)
            .color(UIColor(hexString: "#22214B")!.withAlphaComponent(0.7))
        //
        
        priceLabel
            .adhere(toSuperview: self) {
                $0.top.equalTo(priceTypeLabel.snp.bottom).offset(4)
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(4)
                $0.height.greaterThanOrEqualTo(18)
            }
            .textAlignment(.center)
            .font(UIFont.FontName_PoppinsSemiBold, 20)
            .color(UIColor(hexString: "#22214B")!.withAlphaComponent(1))
            .adjustsFontSizeToFitWidth()
        
        //
        var typeStr: String = ""
        if productTypeIap == BDsoSharSubscbeManager.default.weekIap {
            typeStr = "Weekly"
        } else if productTypeIap == BDsoSharSubscbeManager.default.monthIap {
            typeStr = "Monthly"
        } else if productTypeIap == BDsoSharSubscbeManager.default.yearIap {
            typeStr = "Yearly"
        }
        
        //
        
        typeLabel
            .adhere(toSuperview: self) {
                $0.bottom.equalTo(priceTypeLabel.snp.top).offset(-4)
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(10)
                $0.height.greaterThanOrEqualTo(18)
            }
            .textAlignment(.center)
            .font(UIFont.FontName_PoppinsSemiBold, 16)
            .color(UIColor(hexString: "#595F97")!)
            .text(typeStr)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePrice(str: String) {
        priceLabel.text(str)
        var typeStr: String = ""
        
        if productTypeIap == BDsoSharSubscbeManager.default.weekIap {
            typeStr = "week"
        } else if productTypeIap == BDsoSharSubscbeManager.default.monthIap {
            typeStr = "month"
        } else if productTypeIap == BDsoSharSubscbeManager.default.yearIap {
            typeStr = "year"
        }
        priceTypeLabel.text("\(str) / \(typeStr)")
    }
    
    
}
