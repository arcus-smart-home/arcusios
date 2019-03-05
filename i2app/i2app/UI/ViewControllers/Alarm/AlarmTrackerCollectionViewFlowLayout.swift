//
//  AlarmTrackerCollectionViewFlowLayout.swift
//  i2app
//
//  Created by Arcus Team on 2/14/17.
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

class AlarmTrackerCollectionViewFlowLayout: UICollectionViewFlowLayout {
  let minScale: CGFloat = 0
  let maxScale: CGFloat = 1.0

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  override func prepare() {
    super.prepare()

    if collectionView != nil {
      scrollDirection = UICollectionViewScrollDirection.horizontal
      collectionView!.decelerationRate = UIScrollViewDecelerationRateFast

      let visibleCells: [UICollectionViewCell]? =
        collectionView!.visibleCells as [UICollectionViewCell]
      for cell in visibleCells! {
        let cellX: CGFloat = collectionView!.superview!.convert(cell.center,
                                                                from: self.collectionView).x

        if let trackerCell = cell as? AlarmTrackerCollectionViewCell {
          var scale: CGFloat = transitionScale(cellX, width: trackerCell.bounds.size.width)
          let itemCount = collectionView?.numberOfItems(inSection: 0)
          if itemCount != nil {
            if itemCount! <= 3 {
              scale = maxScale
            }
          }

          trackerCell.layer.zPosition = round(scale)
          trackerCell.updateTransitionState(scale)
        }
      }
    }
  }

  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                    withScrollingVelocity velocity: CGPoint) -> CGPoint {
    if let collectionView = self.collectionView {
      let bounds = collectionView.bounds
      let halfWidth = bounds.size.width / 2
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

  // MARK: Private Functions

  fileprivate func transitionScale(_ xPosition: CGFloat, width: CGFloat) -> CGFloat {
    let visibleWidth: CGFloat = self.collectionView!.bounds.size.width

    if xPosition <= 0 || xPosition >= visibleWidth {
      return minScale
    }

    let halfVisibleWidth = visibleWidth / 2
    let distanceFromCenter = fabs(xPosition - halfVisibleWidth)
    let halfCellWidth = width / 2
    let adjustedHalfWidth = halfVisibleWidth - halfCellWidth

    if distanceFromCenter >= adjustedHalfWidth {
      return minScale
    }

    let percentageFromCenter = distanceFromCenter / adjustedHalfWidth
    let scaleValue = fabs(percentageFromCenter - 1)

    return scaleValue
  }
}
