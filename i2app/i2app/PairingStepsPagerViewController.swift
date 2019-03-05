//
//  PairingStepsPagerViewController.swift
//  i2app
//
//  Arcus Team on 2/19/18.
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

/// View controller responsible for displaying pairing steps inside the view pager; this view
/// controller is embedded in the PairingStepsParentViewController.
///
/// -seealso: PairingStepsParentViewController
public class PairingStepsPagerViewController: UIPageViewController, UIPageViewControllerDelegate {

  fileprivate var stepViewControllers: [UIViewController] = []
  weak var stepsDelegate: PairingStepsPagerDelegate?

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
  }

  override public func viewDidLayoutSubviews() {
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

  public func setPages(_ pages: [UIViewController]) {
    self.stepViewControllers = pages
    self.dataSource = self
  
    if let firstStep = pages.first {
      self.setViewControllers([firstStep], direction: .forward, animated: true, completion: nil)
    }
  }
  
  public func isLastPage() -> Bool {
    return getCurrentPageIndex() == stepViewControllers.count - 1
  }
  
  public func goNextPage() -> Bool {
    let index = getCurrentPageIndex()
    if index < stepViewControllers.count - 1 {
      let nextVc = stepViewControllers[getCurrentPageIndex() + 1]
      setViewControllers([nextVc], direction: .forward, animated: true, completion: nil)
      
      stepsDelegate?.onPageChanged(isLastPage: isLastPage(),
                                   stepViewModel: (nextVc as? PairingInstructionViewController)?.step)
      stepsDelegate?.pageDidChange(index, direction: .forward)
      return true
    } else {
      return false
    }
  }

  public func goPreviousPage() -> Bool {
    let index = getCurrentPageIndex()
    if index > 0 {
      let prevVc = stepViewControllers[getCurrentPageIndex() - 1]
      setViewControllers([prevVc], direction: .reverse, animated: true, completion: nil)
      stepsDelegate?.onPageChanged(isLastPage: isLastPage(),
                                   stepViewModel: (prevVc as? PairingInstructionViewController)?.step ?? nil)
      stepsDelegate?.pageDidChange(index, direction: .reverse)
      return true
    } else {
      return false
    }
  }
  
  public func getCurrentPage() -> UIViewController {
    return stepViewControllers[getCurrentPageIndex()]
  }
  
  private func getCurrentPageIndex() -> Int {
    if let thisVc = self.viewControllers?.first, let thisIndex = stepViewControllers.index(of: thisVc) {
      return thisIndex
    }
    return 0
  }

  // MARK: UIPageViewControllerDelegate

  public func pageViewController(_ pageViewController: UIPageViewController,
                                 didFinishAnimating finished: Bool,
                                 previousViewControllers: [UIViewController],
                                 transitionCompleted completed: Bool) {
    let vc = viewControllers?.first
    
    stepsDelegate?.onPageChanged(isLastPage: isLastPage(),
                                 stepViewModel: (vc as? PairingInstructionViewController)?.step ?? nil)
  }

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

protocol PairingStepsPagerDelegate: class {
  func onPageChanged(isLastPage: Bool,
                     stepViewModel: ArcusPairingStepViewModel?)
  func pageDidChange(_ index: Int, direction: UIPageViewControllerNavigationDirection)
}

extension PairingStepsPagerViewController: UIPageViewControllerDataSource {

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
