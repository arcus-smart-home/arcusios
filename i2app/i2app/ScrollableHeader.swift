//
//  ScrollableHeader.swift
//  i2app
//
//  Created by Arcus Team on 2/4/18.
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

import Foundation
import Cornea

/**
 Allows the scrollable header view to hide and show in accordance to the scroll view action.

 - seealso: CatalogBrandListViewController, CatalogDeviceListViewController
 */
protocol HeaderScrollable: class {
  
  /**
   The view to be hidden and showed by the scroll view.
   */
  var scrollableHeader: UIView! { get set }
  
  /**
   Top constraint of the scrollable header.
   */
  var scrollableHeaderTopConstraint: NSLayoutConstraint! { get set }
  
  /**
   Tracks the previous y offset of the scroll view driving the scrollable header.
   */
  var scrollableHeaderPreviousOffsetY: CGFloat { get set }
  
  // MARK: Extended
  
  /**
   Updates the scrollable header.
   - parameter scrollView: The scroll view driving the scrollable header.
   */
  func scrollableHeaderScrollViewDidUpdate(_ scrollView: UIScrollView)
  
}

extension HeaderScrollable {
  
  func scrollableHeaderScrollViewDidUpdate(_ scrollView: UIScrollView) {
    let scrollViewContentHeight = scrollView.contentSize.height
    let scrollViewHeight = scrollView.frame.height
    let headerHeight = scrollableHeader.frame.height
    let headerCurrentTop = scrollableHeaderTopConstraint.constant
    
    guard scrollViewContentHeight > scrollViewHeight + headerHeight || headerCurrentTop != 0 else {
      return
    }
    
    let absoluteTop: CGFloat = 0
    let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
    let scrollDiff = scrollView.contentOffset.y - scrollableHeaderPreviousOffsetY
    let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
    let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
    
    var newHeight = headerCurrentTop
    if isScrollingDown {
      newHeight = max(scrollableHeader.frame.height * -1,
                      headerCurrentTop - abs(scrollDiff))
    } else if isScrollingUp {
      newHeight = min(0, headerCurrentTop + abs(scrollDiff))
    }
    
    if newHeight != headerCurrentTop {
      scrollableHeaderTopConstraint.constant = newHeight
      scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollableHeaderPreviousOffsetY)
    }
    
    scrollableHeaderPreviousOffsetY = scrollView.contentOffset.y
  }
  
}
