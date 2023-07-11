//
//  BDsoEffectPreview.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/10.
//

import UIKit

class BDsoEffectPreview: UIView {

    let lineV = UIView()
    let touchMoveBtn = UIImageView()
    let afterImgV = UIImageView()
    var localPointX: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent() {
        
        self.cornerRadius(20)
        let beforeImgV = UIImageView()
            .adhere(toSuperview: self) {
                $0.left.right.top.bottom.equalToSuperview()
            }
            .contentMode(.scaleAspectFill)
            .clipsToBounds()
            .image(BDsoToManager.default.currentSelectItem.preImage1Str)
        //
        afterImgV
            .adhere(toSuperview: self) {
                $0.left.right.top.bottom.equalToSuperview()
            }
            .contentMode(.scaleAspectFill)
            .clipsToBounds()
            .image(BDsoToManager.default.currentSelectItem.preImage2Str)
        
        //
        self.addSubview(lineV)
        lineV.frame = CGRect(x: (self.frame.size.width / 2) - 2, y: 0, width: 4, height: self.frame.size.height)
        lineV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(4)
        }
        lineV.backgroundColor(.white)
            .shadow(color: UIColor(hexString: "#161B37"), radius: 4, opacity: 0.15, offset: CGSize(width: 4, height: 0), path: nil)
            .cornerRadius(2, masksToBounds: false)
        //
        self.addSubview(touchMoveBtn)
        touchMoveBtn.isUserInteractionEnabled = true
        touchMoveBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        touchMoveBtn.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height * (3.0/4.0))
        touchMoveBtn
        .image("slidermovetouchpoint")
        .contentMode(.scaleAspectFit)
        //
        let panMoveGes = UIPanGestureRecognizer()
        panMoveGes.addTarget(self, action: #selector(panMoveGesAction(gesture: )))
        touchMoveBtn.addGestureRecognizer(panMoveGes)
        
        localPointX = self.frame.size.width/2
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(rect: CGRect(x: localPointX, y: 0, width: self.frame.size.width - localPointX, height: self.frame.size.height)).cgPath
        afterImgV.layer.mask = maskLayer
        
        //
        let beforeLabel = UILabel()
            .backgroundColor(UIColor.black.withAlphaComponent(0.4))
            .text("Before")
            .color(.white)
            .font(UIFont.FontName_PoppinsMedium, 14)
            .textAlignment(.center)
            .cornerRadius(25/2)
            .adhere(toSuperview: self) {
                $0.width.equalTo(66)
                $0.height.equalTo(25)
                $0.bottom.equalToSuperview().offset(-20)
                $0.left.equalToSuperview().offset(18)
            }
        
        //
        let afterLabel = UILabel()
            .backgroundColor(UIColor.black.withAlphaComponent(0.4))
            .text("After")
            .color(.white)
            .font(UIFont.FontName_PoppinsMedium, 14)
            .textAlignment(.center)
            .cornerRadius(25/2)
            .adhere(toSuperview: self) {
                $0.width.equalTo(66)
                $0.height.equalTo(25)
                $0.bottom.equalToSuperview().offset(-20)
                $0.right.equalToSuperview().offset(-18)
            }
        
    }

    @objc func panMoveGesAction(gesture: UIPanGestureRecognizer) {
        
        
        switch gesture.state {
        case .began:
            localPointX = touchMoveBtn.center.x
        case .changed:
            let point = gesture.translation(in: self)
            let targetX = localPointX + point.x
            if targetX + 18 >= self.frame.size.width || targetX - 18 <= 0 {
                
            } else {
                touchMoveBtn.center = CGPoint(x: targetX, y: self.bounds.size.height * (3.0/4.0))
                lineV.center = CGPoint(x: targetX, y: self.frame.size.height/2)
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(rect: CGRect(x: targetX, y: 0, width: self.frame.size.width - targetX, height: self.frame.size.height)).cgPath
                afterImgV.layer.mask = maskLayer
            }
            
        default:
            break;
        }
        
         
    }
}
