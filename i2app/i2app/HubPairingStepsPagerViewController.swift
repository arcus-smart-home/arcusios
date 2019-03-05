//
//  HubPairingStepsPagerViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/2/18.
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

/// Delegate definition for Hub Pairing Steps Pager
internal protocol HubPairingStepsPagerDelegate: class {
  /// called on every page change returning if it is the last page
  func onPageChanged(isLastPage: Bool)
}

/// delegate down a tree heirarchy to find the object with the Hub ID
internal protocol HubIDGettable: class {
  var hubId: String? { get }
}

/// View controller responsible for displaying pairing steps inside the view pager; this view
/// controller is embedded in the PairingStepsParentViewController.
///
/// This is nearly the same as PairingStepsParentViewController, but different so that if we need
/// one off changes in the future there is not a strong reference to the other implmentation
///
/// -seealso: HubPairingStepsParentViewController, PairingStepsParentViewController
internal class HubPairingStepsPagerViewController: UIPageViewController,
  UIPageViewControllerDelegate {

  fileprivate var stepViewControllers: [UIViewController] = []
  weak var stepsDelegate: HubPairingStepsPagerDelegate?

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

  func setPages(_ pages: [UIViewController]) {
    self.stepViewControllers = pages
    self.dataSource = self

    if let firstStep = pages.first {
      self.setViewControllers([firstStep], direction: .forward, animated: true, completion: nil)
    }
  }

  func isLastPage() -> Bool {
    return getCurrentPageIndex() == stepViewControllers.count - 1
  }

  func goNextPage() -> Bool {
    if getCurrentPageIndex() < stepViewControllers.count - 1 {
      let nextVc = stepViewControllers[getCurrentPageIndex() + 1]
      setViewControllers([nextVc], direction: .forward, animated: true, completion: nil)
      stepsDelegate?.onPageChanged(isLastPage: isLastPage())
      return true
    } else {
      return false
    }
  }

  func goPreviousPage() -> Bool {
    if getCurrentPageIndex() > 0 {
      let prevVc = stepViewControllers[getCurrentPageIndex() - 1]
      setViewControllers([prevVc], direction: .reverse, animated: true, completion: nil)
      stepsDelegate?.onPageChanged(isLastPage: isLastPage())
      return true
    } else {
      return false
    }
  }

  func getCurrentPage() -> UIViewController {
    return stepViewControllers[getCurrentPageIndex()]
  }

  private func getCurrentPageIndex() -> Int {
    if let thisVc = self.viewControllers?.first, let thisIndex = stepViewControllers.index(of: thisVc) {
      return thisIndex
    }
    return 0
  }

  // MARK: UIPageViewControllerDelegate

  func pageViewController(_ pageViewController: UIPageViewController,
                          didFinishAnimating finished: Bool,
                          previousViewControllers: [UIViewController],
                          transitionCompleted completed: Bool) {

    stepsDelegate?.onPageChanged(isLastPage: isLastPage())
  }

}

extension HubPairingStepsPagerViewController: UIPageViewControllerDataSource {

  public func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = stepViewControllers.index(of: viewController) else {
      return nil
    }
    return stepViewControllers[safe: viewControllerIndex - 1]
  }

  public func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = stepViewControllers.index(of: viewController) else {
      return nil
    }
    return stepViewControllers[safe: viewControllerIndex + 1]
  }

  public func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return stepViewControllers.count
  }

  public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    guard let thisVc = pageViewController.viewControllers?.first,
      let viewControllerIndex = stepViewControllers.index(of: thisVc) else {
        return 0
    }
    return viewControllerIndex
  }

}

extension HubPairingStepsPagerViewController: HubIDGettable {
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
