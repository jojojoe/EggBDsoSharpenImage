//
//  ZoomGestureController.swift
//  WeScan
//
//  Created by Bobo on 5/31/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

final class ZoomGestureController {

    private let image: UIImage
    private let quadView: QuadrilateralView
    private var previousPanPosition: CGPoint?
    private var closestCorner: CornerPosition?
    var touchMoveBlock: (()->Void)?
    init(image: UIImage, quadView: QuadrilateralView) {
        self.image = image
        self.quadView = quadView
    }

    @objc func handle(pan: UIGestureRecognizer) {
        guard let drawnQuad = quadView.quad else {
            return
        }

        guard pan.state != .ended else {
            self.previousPanPosition = nil
            self.closestCorner = nil
            quadView.resetHighlightedCornerViews()
            touchMoveBlock?()
            return
        }

        let position = pan.location(in: quadView)

        let previousPanPosition = self.previousPanPosition ?? position
        let closestCorner = self.closestCorner ?? position.closestCornerFrom(quad: drawnQuad)

        let offset = CGAffineTransform(translationX: position.x - previousPanPosition.x, y: position.y - previousPanPosition.y)
        let cornerView = quadView.cornerViewForCornerPosition(position: closestCorner)
        let draggedCornerViewCenter = cornerView.center.applying(offset)

        
        debugPrint("draggedCornerViewCenter.x = \(draggedCornerViewCenter.x)")
        debugPrint("draggedCornerViewCenter.y = \(draggedCornerViewCenter.y)")
        //
        if closestCorner == .topLeft {
            let topR = quadView.cornerViewForCornerPosition(position: .topRight)
            let bottomL = quadView.cornerViewForCornerPosition(position: .bottomLeft)
            
            if draggedCornerViewCenter.y < bottomL.center.y - 10 && draggedCornerViewCenter.x < topR.center.x - 10 {
                quadView.moveCorner(cornerView: cornerView, atPoint: draggedCornerViewCenter)
                quadView.moveCorner(cornerView: topR, atPoint: CGPoint(x: topR.center.x, y: draggedCornerViewCenter.y))
                quadView.moveCorner(cornerView: bottomL, atPoint: CGPoint(x: draggedCornerViewCenter.x, y: bottomL.center.y))
            }

        } else if closestCorner == .topRight {
            let topL = quadView.cornerViewForCornerPosition(position: .topLeft)
            let bottomR = quadView.cornerViewForCornerPosition(position: .bottomRight)
            
            if draggedCornerViewCenter.y < bottomR.center.y - 10 && draggedCornerViewCenter.x > topL.center.x + 10 {
                quadView.moveCorner(cornerView: cornerView, atPoint: draggedCornerViewCenter)
                quadView.moveCorner(cornerView: topL, atPoint: CGPoint(x: topL.center.x, y: draggedCornerViewCenter.y))
                quadView.moveCorner(cornerView: bottomR, atPoint: CGPoint(x: draggedCornerViewCenter.x, y: bottomR.center.y))
            }
            

        } else  if closestCorner == .bottomLeft {
            let topL = quadView.cornerViewForCornerPosition(position: .topLeft)
            let bottomR = quadView.cornerViewForCornerPosition(position: .bottomRight)
            
            if draggedCornerViewCenter.y > topL.center.y + 10 && draggedCornerViewCenter.x < bottomR.center.x - 10 {
                quadView.moveCorner(cornerView: cornerView, atPoint: draggedCornerViewCenter)
                quadView.moveCorner(cornerView: topL, atPoint: CGPoint(x: draggedCornerViewCenter.x, y: topL.center.y))
                quadView.moveCorner(cornerView: bottomR, atPoint: CGPoint(x: bottomR.center.x, y: draggedCornerViewCenter.y))
            }
                
                

        } else if closestCorner == .bottomRight {
            let topR = quadView.cornerViewForCornerPosition(position: .topRight)
            let bottomL = quadView.cornerViewForCornerPosition(position: .bottomLeft)
            
            if draggedCornerViewCenter.y > topR.center.y + 10 && draggedCornerViewCenter.x > bottomL.center.x + 10 {
                quadView.moveCorner(cornerView: cornerView, atPoint: draggedCornerViewCenter)
                quadView.moveCorner(cornerView: topR, atPoint: CGPoint(x: draggedCornerViewCenter.x, y: topR.center.y))
                quadView.moveCorner(cornerView: bottomL, atPoint: CGPoint(x: bottomL.center.x, y: draggedCornerViewCenter.y))
            }
            

        }
        
        //
        
        
        self.previousPanPosition = position
        self.closestCorner = closestCorner

        let scale = image.size.width / quadView.bounds.size.width
        let scaledDraggedCornerViewCenter = CGPoint(x: draggedCornerViewCenter.x * scale, y: draggedCornerViewCenter.y * scale)
        guard let zoomedImage = image.scaledImage(
            atPoint: scaledDraggedCornerViewCenter,
            scaleFactor: 2.5,
            targetSize: quadView.bounds.size
        ) else {
            return
        }

        quadView.highlightCornerAtPosition(position: closestCorner, with: zoomedImage)
        
        
    }

}
