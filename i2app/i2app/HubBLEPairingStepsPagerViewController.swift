//
//  HubBLEPairingStepsPagerViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/16/18.
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
import RxSwift

/// Delegate definition for Hub Pairing Steps Pager
internal protocol HubBLEPairingStepsPagerDelegate: class {
  /// called on every page change
  func pageDidChange(_ index: Int, direction: UIPageViewControllerNavigationDirection)
}


class HubBLEPairingStepsPagerViewController: UIPageViewController,
  UIPageViewControllerDelegate {
  
  fileprivate var stepViewControllers: [HubBLEPairingInstructionViewController] = [] //Actually
  weak var stepsDelegate: HubBLEPairingStepsPagerDelegate?

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    // Feels kinda hacky, but this appears to be the best way to change dot color and disable user interaction
    for subView in view.subviews {
      if let pageControl = subView as? UIPageControl {
        pageControl.isUserInteractionEnabled = false
        
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = ScleraColor.teal
      }
    }
  }

  public func goToPageIndex(_ index: Int, completion: ((Bool) -> Void)? = nil) {
    guard stepViewControllers.count > index else { return }

    let page = stepViewControllers[index]
    let currentIndex = getCurrentPageIndex()

    setViewControllers([page], direction: .reverse, animated: true, completion: completion)
    stepsDelegate?.pageDidChange(currentIndex, direction: .reverse)
  }

  func setPages(_ pages: [HubBLEPairingInstructionViewController]) {
    self.stepViewControllers = pages
    self.dataSource = self
    
    if let firstStep = pages.first {
      let steps = [firstStep]
      self.setViewControllers(steps, direction: .forward, animated: true, completion: nil)
    }
  }
  
  func isLastPage() -> Bool {
    return getCurrentPageIndex() == stepViewControllers.count - 1
  }
  
  @discardableResult
  func goNextPage() -> Bool {
    if getCurrentPageIndex() < stepViewControllers.count - 1 {
      let nextIdx = getCurrentPageIndex() + 1
      let nextVc = stepViewControllers[nextIdx]
      setViewControllers([nextVc], direction: .forward, animated: true, completion: nil)
      stepsDelegate?.pageDidChange(nextIdx, direction: .forward)
      return true
    } else {
      return false
    }
  }

  @discardableResult
  public func goPreviousPage() -> Bool {
    let index = getCurrentPageIndex()
    if index > 0 {
      let prevVc = stepViewControllers[getCurrentPageIndex() - 1]
      setViewControllers([prevVc], direction: .reverse, animated: true, completion: nil)
      stepsDelegate?.pageDidChange(index, direction: .reverse)
      return true
    } else {
      return false
    }
  }
  
  func getCurrentPage() -> UIViewController {
    return stepViewControllers[getCurrentPageIndex()]
  }
  
  private func getCurrentPageIndex() -> Int {
    if let thisVc = self.viewControllers?.first,
      let thisIndex = (stepViewControllers as [UIViewController]).index(of: thisVc) {
      return thisIndex
    }
    return 0
  }
  
  // MARK: UIPageViewControllerDelegate
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          didFinishAnimating finished: Bool,
                          previousViewControllers: [UIViewController],
                          transitionCompleted completed: Bool) {
    //Do Nothing?
  }

  // MARK: Enable/Disable Paging of Views

  public func disablePaging() {
    for view in self.view.subviews {
      if let scrollview = view as? UIScrollView {
        scrollview.isScrollEnabled = false
      }
    }
  }

  public func enablePaging() {
    for view in self.view.subviews {
      if let scrollview = view as? UIScrollView {
        scrollview.isScrollEnabled = true
      }
    }
  }
  
}

extension HubBLEPairingStepsPagerViewController: UIPageViewControllerDataSource {
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = (stepViewControllers as [UIViewController])
      .index(of: viewController) else {
      return nil
    }
    return stepViewControllers[safe: viewControllerIndex - 1]
  }
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = (stepViewControllers as [UIViewController])
      .index(of: viewController) else {
      return nil
    }
    return stepViewControllers[safe: viewControllerIndex + 1]
  }
  
  public func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return stepViewControllers.count
  }
  
  public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    guard let thisVc = pageViewController.viewControllers?.first,
      let viewControllerIndex = (stepViewControllers as [UIViewController]).index(of: thisVc) else {
        return 0
    }
    return viewControllerIndex
  }
  
}

extension HubBLEPairingStepsPagerViewController: HubIDGettable {
  /// Delegate the Hub ID gettable to the pairing steps,
  /// last first since its most likely to be the Hub ID
  /// I could assume it must be the last VC, but the implementation may need to change in the future
  var hubId: String? {
    for vc in self.stepViewControllers.reversed() {
      if let vc = vc as? HubIDGettable,
        let hubId = vc.hubId {
        return hubId
      }
    }
    return nil
  }
}

