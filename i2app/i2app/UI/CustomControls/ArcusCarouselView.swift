//
//  ArcusCarouselView.swift
//  CollectionViewProto
//
//  Created by Arcus Team on 5/12/16.
//
//

import UIKit

@objc protocol ArcusCarouselDataSource {
  func carouselView(_ carouselView: ArcusCarouselView,
                    numberOfItemsInSection section: Int) -> Int
  func carouselView(_ carouselView: ArcusCarouselView,
                    cellForIndexPath indexPath: IndexPath,
                    itemAtIndexPath dataIndexPath: IndexPath) -> UICollectionViewCell
}

@objc protocol ArcusCarouselDelegate {
  @objc optional func carouselView(_ carouselView: ArcusCarouselView,
                                   didSelectCellAtIndexPath indexPath: IndexPath,
                                   itemAtIndexPath dataIndexPath: IndexPath)
  @objc optional func carouselView(_ carouselView: ArcusCarouselView,
                                   didDeselectCellAtIndexPath indexPath: IndexPath,
                                   itemAtIndexPath dataIndexPath: IndexPath)

  @objc optional func carouselView(_ carouselView: ArcusCarouselView,
                                   layout collectionViewLayout: UICollectionViewLayout,
                                   sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize

  @objc optional func carouselView(_ carouselView: ArcusCarouselView,
                                   layout collectionViewLayout: UICollectionViewLayout,
                                   insetForSectionAtIndex section: Int) -> UIEdgeInsets

  @objc optional func carouselView(_ carouselView: ArcusCarouselView,
                                   didEndOnIndexPath indexPath: IndexPath,
                                   dataIndexPath: IndexPath)
}

class ArcusCarouselView: UICollectionView,
  UICollectionViewDataSource,
  UICollectionViewDelegate,
UIScrollViewDelegate {

  fileprivate var endlessCellMultiplier: Int = 1001
  fileprivate var currentCellCount: Int = 0

  @IBOutlet weak var carouselDataSource: ArcusCarouselDataSource!
  @IBOutlet weak var carouselDelegate: ArcusCarouselDelegate!

  // Workaround for Xcode bug that prevents you from connecting the delegate in the storyboard.
  // Remove this extra property once Xcode gets fixed.
  @IBOutlet var icDataSource: AnyObject? {
    get { return self.carouselDataSource }
    set { self.carouselDataSource = newValue as? ArcusCarouselDataSource }
  }

  // Workaround for Xcode bug that prevents you from connecting the delegate in the storyboard.
  // Remove this extra property once Xcode gets fixed.
  @IBOutlet var icDelegate: AnyObject? {
    get { return self.carouselDelegate }
    set { self.carouselDelegate = newValue as? ArcusCarouselDelegate }
  }

  // MARK: Initialization
  required init?(coder: NSCoder) {
    super.init(coder: coder)

    self.delegate = self
    self.dataSource = self
  }

  required override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)

    self.delegate = self
    self.dataSource = self
  }

  // MARK: UI Configuration
  func configureCarouselForIndex(_ index: Int) {
    self.superview!.layoutIfNeeded()

    if self.currentCellCount > 1 {

      let adjustedIndex: Int = ((self.currentCellCount * self.endlessCellMultiplier) / 2)
        - (self.currentCellCount / 2) + index

      let indexPath = IndexPath(row: adjustedIndex, section: 0)
      self.scrollToItem(at: indexPath,
                        at: .centeredHorizontally,
                        animated: false)
    }

    self.layoutIfNeeded()

    if let flowLayout = self.collectionViewLayout as? ArcusCarouselViewFlowLayout {
      flowLayout.invalidateLayout()
    }
  }

  // MARK: UICollectionViewDataSource
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1 // Current implementation limits us to a single section
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    var itemCount: Int = 0

    let carouselView: ArcusCarouselView? = collectionView as? ArcusCarouselView

    self.currentCellCount = self.carouselDataSource.carouselView(carouselView!,
                                                                 numberOfItemsInSection: section)

    if self.currentCellCount <= 1 {
      itemCount = self.currentCellCount
      collectionView.isScrollEnabled = false
    } else {
      collectionView.isScrollEnabled = true
      itemCount = self.currentCellCount * self.endlessCellMultiplier
    }

    return itemCount
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let carouselView: ArcusCarouselView? = collectionView as? ArcusCarouselView
    return self.carouselDataSource.carouselView(carouselView!,
                                                cellForIndexPath: indexPath,
                                                itemAtIndexPath: self.dataIndexPath(indexPath))
  }

  // MARK: UICollectionView Delegate
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    let carouselView: ArcusCarouselView? = collectionView as? ArcusCarouselView

    self.carouselDelegate.carouselView?(carouselView!,
                                        didSelectCellAtIndexPath: indexPath,
                                        itemAtIndexPath: self.dataIndexPath(indexPath))
  }

  func collectionView(_ collectionView: UICollectionView,
                      didDeselectItemAt indexPath: IndexPath) {
    let carouselView: ArcusCarouselView? = collectionView as? ArcusCarouselView
    self.carouselDelegate.carouselView?(carouselView!,
                                        didDeselectCellAtIndexPath: indexPath,
                                        itemAtIndexPath: self.dataIndexPath(indexPath))
  }

  // MARK: UICollectionViewFlowLayoutDelegate
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
    var size: CGSize = CGSize(width: 300, height: 325) // default

    let carouselView: ArcusCarouselView? = collectionView as? ArcusCarouselView
    if let delegateSize: CGSize? = self.carouselDelegate.carouselView?(carouselView!,
                                                                       layout: collectionViewLayout,
                                                                       sizeForItemAtIndexPath: indexPath) {
      size = delegateSize!
    }

    return size
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAtIndex section: Int) -> UIEdgeInsets {

    var insets: UIEdgeInsets = UIEdgeInsets.zero // Default

    let carouselView: ArcusCarouselView? = collectionView as? ArcusCarouselView
    if let delegateInsets: UIEdgeInsets? =
      self.carouselDelegate.carouselView?(carouselView!,
                                          layout: collectionViewLayout,
                                          insetForSectionAtIndex: section) {
      insets = delegateInsets!
    }

    return insets
  }

  // MARK: UIScrollViewDelegate
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let indexPaths = self.indexPathsForVisibleItems
    if indexPaths.count >= 3 {
      var rowIndex: Int = -1
      var sum: Int = 0
      for indexPath in indexPaths {
        sum += indexPath.row
      }

      rowIndex = sum / indexPaths.count

      let indexPath: IndexPath = IndexPath(row: rowIndex, section: 0)

      self.carouselDelegate.carouselView?(self,
                                          didEndOnIndexPath: indexPath,
                                          dataIndexPath: self.dataIndexPath(indexPath))
    }
  }

  // MARK: Private Helpers
  func dataIndexPath(_ indexPath: IndexPath) -> IndexPath {
    return IndexPath(row: indexPath.row % self.currentCellCount,
                     section: 0)
  }
}
