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
        scalingCarousel = ScalingCarouselView(withFrame: CGRect.zero, andInset: 20)
        scalingCarousel.scrollDirection = .horizontal
        scalingCarousel.dataSource = self
        scalingCarousel.delegate = self
        scalingCarousel.translatesAutoresizingMaskIntoConstraints = false
        scalingCarousel.backgroundColor = .white
        scalingCarousel.contentSize = CGRect(x: 0, y: 0, width: 0, height: 0)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scalingCarousel.didScroll()
    }
}


class BDsoFeaturePreviewCell: ScalingCarouselCell {
    //
    let contentImgV = UIImageView()
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
