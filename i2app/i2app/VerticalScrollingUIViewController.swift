//
//  VerticalScrollingUIViewController.swift
//  i2app
//
//  Arcus Team on 5/1/18.
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
import UIKit

/// A handy utility to make a view controller vertically scrollable without the heinous complexity
/// of getting all the storyboard constraints working correctly.
///
/// How to use:
///   1. Create a view controller in the storyboard as you normally would, then
///   2. Assign this class as the storyboard's view controller, or have your own custom view
///      controller extend this class.
///   3. Marvel in the fact that you didn't have to spend hours futzing with stupid constraints.
///
/// This utility calculates the smallest vertical size of its contents that meets the layout
/// constraints even if that vertical size is larger the viewport height of the containing view
/// controller. If the resized height is smaller than the containing view controller's height, then
/// this class has no affect on layout (i.e., your contents don't need to scroll). However, if the
/// resized height exceeds available screen real estate, then this view controller's view is placed
/// inside of a UIScrollView and provisioned for vertical-only scrolling. In order for this utility
/// to correctly calculate the scrollable height, each element in your layout should be vertically
/// constrained to one another.
///
/// Consider a VC with two views: a label with a very large amout of text pinned to the top safe area
/// guide and button pinned to the bottom of the safe area guide (with no constraints tieing the
/// label to the button). If you apply this utility to such a layout on a very small screen, the
/// result will be the top label runs over the bottom button (and potentially clipped off the bottom
/// of screen) and there will be no scroll applied.
///
/// FAQS:
///
/// Can I have buttons that stay pinned to the bottom of the screen on large devices, but scroll
/// beneith the contents on smaller devices?
///
///   Yep. Piece of cake: Pin your bottom buttons to the bottom of the VC. This will address the
///   large-screen device cases. Then, apply a second "greater-than-or-equals" constraint between the
///   top of your pinned buttons and bottom of the contents they should sit below (this should
///   represent the minimum amount of margin you want between the buttons and contents on small screen
///   devices). Finally, assign this '>=' constraint a lower priority (typically 750) so the layout
///   manager can break it on large screen devices.
///
///   In general, I've been able to apply this tool to existing (non-scrolling) layouts where one or
///   more buttons are pinned to the bottom of the screen by simply adding this one '>=' constraint
///   to the preexisting storyboard layout.
///
public class VericalScrollingUIViewController: UIViewController,
                                               VerticalAutoScrollable {
  
  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    makeVerticallyScrolling()
  }
}

protocol VerticalAutoScrollable where Self: UIViewController {
  func makeVerticallyScrolling()
}

extension VerticalAutoScrollable {

  func makeVerticallyScrolling() {
    if let contents = view {
      let bgColor = contents.backgroundColor

      // Create a scroll view that's the same size as the view controller's view
      let scrollView = UIScrollView(
        frame: CGRect(origin: CGPoint(x: 0, y: 0),
        size: CGSize(width: view.bounds.width, height: view.bounds.height)))
      
      // Calculate preferred size
      let resized = contents.systemLayoutSizeFitting(
          CGSize(width: contents.bounds.width, height: 0),
          withHorizontalFittingPriority: UILayoutPriorityRequired,
          verticalFittingPriority: UILayoutPriorityDefaultLow)

      // Don't do jack if expanded content height doesn't exceed bounds of existing view
      // (i.e., content doesn't need to scroll to fit screen)
      if resized.height > contents.frame.height {
        contents.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                                size: CGSize(width: contents.bounds.width, height: resized.height))
        contents.layoutIfNeeded()
        contents.layoutSubviews()

        scrollView.addSubview(contents)
        scrollView.contentSize = CGSize(width: contents.bounds.width, height: resized.height)
      
        view = scrollView
        view.backgroundColor = bgColor
      }
    }
  }

}
