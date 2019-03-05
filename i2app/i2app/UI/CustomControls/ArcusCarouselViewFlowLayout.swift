//
//  File.swift
//  i2app
//
//  Created by Arcus Team on 5/12/16.
/*
 * Copyright 2019 Arcus Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//

import UIKit

class ArcusCarouselViewFlowLayout: UICollectionViewFlowLayout {
  let minScale: CGFloat = 0.65
  let maxScale: CGFloat = 1.0

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  override func prepare() {
    super.prepare()

    self.scrollDirection = UICollectionViewScrollDirection.horizontal
    self.collectionView?.decelerationRate = UIScrollViewDecelerationRateFast

    let visibleCells: [UICollectionViewCell]? =
      self.collectionView!.visibleCells as [UICollectionViewCell]
    let visibleWidth: CGFloat = self.collectionView!.bounds.size.width
    for cell in visibleCells! {
      let cellX: CGFloat = self.collectionView!.superview!.convert(cell.center,
                                                                   from: self.collectionView).x
      var scaling: CGFloat = self.calculateScalingWithWidth(visibleWidth,
                                                            andPosition: cellX)

      if visibleCells!.count <= 1 {
        scaling = self.maxScale
      }

      cell.layer.transform = CATransform3DMakeScale(scaling,
                                                    scaling,
                                                    1.0)
    }
  }

  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                    withScrollingVelocity velocity: CGPoint) -> CGPoint {

    if let collectionView = self.collectionView {
      let bounds = collectionView.bounds
      let halfWidth = bounds.size.width * 0.5
      let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth

      let visibleCellAttributes: [UICollectionViewLayoutAttributes] =
        self.layoutAttributesForElements(in: bounds)!

      var newAttributes: UICollectionViewLayoutAttributes?
      for attributes in visibleCellAttributes
        where attributes.representedElementCategory == UICollectionElementCategory.cell {
          if newAttributes != nil {
            let attrCenter: CGFloat = attributes.center.x - proposedContentOffsetCenterX
            let newAttrCenter: CGFloat = newAttributes!.center.x - proposedContentOffsetCenterX
            let distance: CGFloat = fabs(attrCenter - newAttrCenter)

            if fabsf(Float(attrCenter)) < fabsf(Float(newAttrCenter)) &&
              distance < bounds.width {
              newAttributes = attributes
            }
          } else {
            newAttributes = attributes
            continue
          }
          return CGPoint(x: floor(newAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
      }
    }

    // Fallback
    return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
  }

  func calculateScalingWithWidth(_ width: CGFloat,
                                 andPosition xVal: CGFloat) -> CGFloat {
    if xVal < 0 || xVal > width {
      return self.minScale
    }
    return -2 * (self.maxScale - self.minScale) / width * fabs(xVal - width / 2) + self.maxScale
  }
}
