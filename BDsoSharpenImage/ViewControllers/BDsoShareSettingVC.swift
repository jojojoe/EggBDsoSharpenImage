//
//  BDsoShareSettingVC.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/4.
//

import UIKit

enum SettingType {
    case progum
    case share
    case rateus
    case privacy
    case terms
    
}

class SettingContentItem {
    
    var settype: SettingType
    var iconStr: String
    var nameStr: String
    init(settype: SettingType) {
        self.settype = settype
        switch settype {
        case .progum:
            iconStr = ""
            nameStr = ""
        case .share:
            iconStr = "ic_setting_feedback"
            nameStr = "Share"
        case .terms:
            iconStr = "ic_setting_term_of_use"
            nameStr = "Terms of use"
        case .privacy:
            iconStr = "ic_setting_privacy_policy"
            nameStr = "Privacy policy"
        case .rateus:
            iconStr = "ic_setting_rest_us"
            nameStr = "Rate us"
        }
    }
}


class BDsoShareSettingVC: UIViewController {

    var collection: UICollectionView!
    var basicSettingList: [SettingContentItem] = []
    let goldpro = SettingContentItem(settype: .progum)
    let share = SettingContentItem(settype: .share)
    let terms = SettingContentItem(settype: .terms)
    let privacy = SettingContentItem(settype: .privacy)
    let rateus = SettingContentItem(settype: .rateus)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSettingList = [goldpro, share, rateus, privacy, terms]
        setupContent()
    }
    
//    func addnoti() {
//        NotificationCenter.default.addObserver(self, selector: #selector(updateContentProStatus(noti: )), name: NSNotification.Name(rawValue: SubNotificationKeys.success), object: nil)
//
//    }
//
//    @objc func updateContentProStatus(noti: Notification) {
//        DispatchQueue.main.async {
//            if FPoodPHotoConfigSubscribePro.default.inSubscription {
//                self.basicList = [self.feedback, self.terms, self.privacy]
//                self.collection.reloadData()
//            }
//        }
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    
    func setupContent() {
        view.backgroundColor = .white
        view.clipsToBounds()
        //
        let bbtn = UIButton()
            .adhere(toSuperview: view) {
                $0.left.equalToSuperview().offset(10)
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
                $0.width.height.equalTo(40)
            }
            .title("B")
            .image(UIImage(named: ""))
            .target(target: self, action: #selector(bbtnClick), event: .touchUpInside)
        //
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.bottom.right.left.equalToSuperview()
            $0.top.equalTo(bbtn.snp.bottom).offset(25)
        }
        collection.register(cellWithClass: BDsoSettingCell.self)
        
        
        
    }

    @objc func bbtnClick() {
        self.sideMenuController?.hideLeftView()
    }

}

extension BDsoShareSettingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: BDsoSettingCell.self, for: indexPath)
        let item = basicSettingList[indexPath.item]
        cell.updateContent(item: item)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return basicSettingList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension BDsoShareSettingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = basicSettingList[indexPath.item]
        if item.settype == .progum {
            collectionView.bounds.size.width
            return CGSize(width: collectionView.bounds.size.width, height: 90)
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 64)
        }
        
        return CGSize(width: 10, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension BDsoShareSettingVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = basicSettingList[indexPath.item]
        if item.settype == .progum {
            
        } else if item.settype == .share {
            
        } else if item.settype == .rateus {
            
        } else if item.settype == .privacy {
            
        } else if item.settype == .terms {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class BDsoSettingCell: UICollectionViewCell {
    
    let upgradeBgV = UIView()
    let nLabel = UILabel()
    let iconImgV = UIImageView()
    
    func updateContent(item: SettingContentItem) {
        if item.settype == .progum {
            upgradeBgV.isHidden = false
        } else {
            upgradeBgV.isHidden = true
            nLabel.text(item.nameStr)
            iconImgV.image(item.iconStr)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {

        iconImgV
            .adhere(toSuperview: contentView) {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(32)
                $0.width.height.equalTo(24)
            }
        
        nLabel
            .adhere(toSuperview: contentView) {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(iconImgV.snp.right).offset(12)
                $0.width.height.greaterThanOrEqualTo(20)
            }
        let arrowImgV = UIImageView()
            .adhere(toSuperview: contentView) {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().offset(-24)
                $0.width.height.equalTo(16)
            }
            .image("")
        
        //
        
        upgradeBgV
            .adhere(toSuperview: contentView) {
                $0.left.equalToSuperview().offset(20)
                $0.top.bottom.equalToSuperview()
                $0.centerX.equalToSuperview()
            }
            .cornerRadius(20)
            .backgroundColor(UIColor(hexString: "#22214B")!)
        //
        let upgradeTitle1 = UILabel()
            .adhere(toSuperview: upgradeBgV) {
                $0.bottom.equalTo(upgradeBgV.snp.centerY).offset(-4)
                $0.left.equalToSuperview().offset(20)
                $0.height.equalTo(21)
                $0.width.equalTo(156)
            }
            .font(UIFont.FontName_PoppinsRegular, 14)
            .color(.white)
            .text("Upgrade to Premium".uppercased())
            .adjustsFontSizeToFitWidth()
            .textAlignment(.left)
        //
        let upgradeTitle2 = UILabel()
            .adhere(toSuperview: upgradeBgV) {
                $0.top.equalTo(upgradeBgV.snp.centerY).offset(4)
                $0.left.equalToSuperview().offset(20)
                $0.height.equalTo(21)
                $0.right.equalToSuperview().offset(-20)
            }
            .font(UIFont.FontName_PoppinsRegular, 12)
            .color(.white)
            .text("Unlock all photo processing features")
            .adjustsFontSizeToFitWidth()
            .textAlignment(.left)
        //
        let guanImgV = UIImageView()
            .adhere(toSuperview: upgradeBgV) {
                $0.centerY.equalTo(upgradeTitle1.snp.centerY)
                $0.left.equalTo(upgradeTitle1.snp.right).offset(12)
                $0.width.height.equalTo(24)
            }
            .image("")
        
    }
}
