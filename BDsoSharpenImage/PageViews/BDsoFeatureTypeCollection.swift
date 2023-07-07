//
//  BDsoFeatureTypeCollection.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/5.
//

import UIKit
import DeviceKit

class BDsoFeatureTypeCollection: UIView {

    var collection: UICollectionView!

    var featureItemClickBlock: ((FeatureTypeItem, IndexPath)->Void)?
    
     
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: BDsoFeaTypeCell.self)
    }

}

extension BDsoFeatureTypeCollection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: BDsoFeaTypeCell.self, for: indexPath)
        let item = BDsoToManager.default.featureList[indexPath.item]
        cell.updateContentItem(item: item)
        if item == BDsoToManager.default.currentSelectItem {
            cell.updateSelectStatus(isselect: true)
        } else {
            cell.updateSelectStatus(isselect: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BDsoToManager.default.featureList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension BDsoFeatureTypeCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellw: CGFloat = CGFloat(Int((UIScreen.width() - (BDsoToManager.default.cpadding * CGFloat((BDsoToManager.default.featureList.count + 1)))) / CGFloat(BDsoToManager.default.featureList.count)))
        let cellh: CGFloat = cellw + 16
        return CGSize(width: cellw, height: cellh)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: BDsoToManager.default.cpadding, bottom: 0, right: BDsoToManager.default.cpadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return BDsoToManager.default.cpadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return BDsoToManager.default.cpadding
    }
    
}

extension BDsoFeatureTypeCollection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = BDsoToManager.default.featureList[indexPath.item]
        BDsoToManager.default.currentSelectItem = item
        collectionView.reloadData()
        
        featureItemClickBlock?(item, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class BDsoFeaTypeCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let selectV = UIView()
    let nametLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func updateSelectStatus(isselect: Bool) {
        if isselect {
            nametLabel.font(UIFont.FontName_PoppinsBold, 8)
            contentView.alpha = 1
        } else {
            nametLabel.font(UIFont.FontName_PoppinsMedium, 8)
            contentView.alpha = 0.5
        }
    }
    
    func updateContentItem(item: FeatureTypeItem) {
        contentImgV.image(item.iconThumbStr)
        nametLabel.text(item.featureName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.left.equalToSuperview()
            $0.height.equalTo(self.snp.width)
        }
        contentImgV.cornerRadius(10)
        //
        
        selectV
            .adhere(toSuperview: contentView) {
                $0.edges.equalTo(contentImgV)
            }
            .backgroundColor(.clear)
            .borderColor(UIColor(hexString: "#22214B")!, width: 1)
            .cornerRadius(10)
        
        nametLabel
            .adhere(toSuperview: contentView) {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.width.greaterThanOrEqualTo(10)
                $0.height.greaterThanOrEqualTo(10)
            }
            .color(UIColor(hexString: "#22214B")!)
            .textAlignment(.center)
            .font(UIFont.FontName_PoppinsMedium, 8)
        
        
    }
}
