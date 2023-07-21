//
//  BDsoFeaturePreviewList.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/5.
//

import UIKit
import ScalingCarousel

class BDsoFeaturePreviewList: UIView {

    var scalingCarousel: ScalingCarouselView!
    var featureItemClickBlock: ((FeatureTypeItem, IndexPath)->Void)?
    var currentInfoIndex: Int = 0
    var isAutoScroll: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if UIScreen.isDevice8SEPaid() {
            
        }
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupV() {
        self.backgroundColor(.clear)
        scalingCarousel = ScalingCarouselView(withFrame: frame, andInset: 50)
        scalingCarousel.scrollDirection = .horizontal
        scalingCarousel.dataSource = self
        scalingCarousel.delegate = self
        scalingCarousel.translatesAutoresizingMaskIntoConstraints = false
        scalingCarousel.backgroundColor = .clear
        
        scalingCarousel.register(BDsoFeaturePreviewCell.self, forCellWithReuseIdentifier: "BDsoFeaturePreviewCell")
        
        addSubview(scalingCarousel)
        scalingCarousel.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
    
}


extension BDsoFeaturePreviewList: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BDsoToManager.default.featureList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BDsoFeaturePreviewCell", for: indexPath)
        let item = BDsoToManager.default.featureList[indexPath.item]
        if let scalingCell = cell as? BDsoFeaturePreviewCell {
            scalingCell.mainView.backgroundColor = .blue
            scalingCell.contentImgV.image = UIImage(named: item.iconBigStr)
        }
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }

        return cell
    }
}

extension BDsoFeaturePreviewList: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isAutoScroll = false
    }
    
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scalingCarousel.didScroll()
        if !isAutoScroll {
            if scrollView == scalingCarousel {
                if let indexP = scalingCarousel.indexPathForItem(at: CGPoint(x: self.bounds.width/2 + scalingCarousel.contentOffset.x, y: 100)) {
                    if indexP.item != currentInfoIndex {
                        currentInfoIndex = indexP.item
                        let item = BDsoToManager.default.featureList[currentInfoIndex]
                        BDsoToManager.default.currentSelectItem = item
                        self.featureItemClickBlock?(item, indexP)
                    }
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isAutoScroll = false
    }
    
    
}


class BDsoFeaturePreviewCell: ScalingCarouselCell {
    //
    let contentImgV = UIImageView()
    let lineV = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mainView = UIView(frame: contentView.bounds)
        contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        mainView.cornerRadius(20)
        //
        mainView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        contentImgV.contentMode(.scaleAspectFill)
            .clipsToBounds()
        //
        mainView.addSubview(lineV)
        lineV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(4)
        }
        lineV.backgroundColor(.white)
            .shadow(color: UIColor(hexString: "#161B37"), radius: 4, opacity: 0.15, offset: CGSize(width: 4, height: 0), path: nil)
            .cornerRadius(2, masksToBounds: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
