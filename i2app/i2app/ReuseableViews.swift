//
//  ReuseableViews.swift
//  i2app
//
//  Created by Arcus Team on 1/10/17.
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

/**
 Useful for UITableViewCells & UICollectionViewCells with only one reuseIdentifier available to 
 them. Allows the Datasource to use autocompletion
 
 - warning: The String must be the same as the the reuseIdentifier in the Storyboard or Nib
 
 **Usage:**
 
        // In implementation of the ReuseableCell
        class RealReuseableCell : ReuseableCell {
            class var reuseIdentifier : String {
                get {
                    return "RealReuseableCell"
                }
            }
        }
 
        // In UITableViewDatasouce's `tableView:cellForRowAtIndexPath:`
        let cell = tableView.dequeueReusableCellWithIdentifier(RealReuseableCell.reuseIdentifier, 
                                forIndexPath: indexPath) as! RealReuseableCell
 
 */
protocol ReuseableCell : class {
  ///extended to be String(describing:self)
  static var reuseIdentifier: String { get }
}

extension ReuseableCell where Self: UIView {

  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

protocol NibLoadableView: class { }

extension NibLoadableView where Self: UIView {

  static var NibName: String {
    return String(describing: self)
  }
}

/// MARK: UITableView Extensions

extension UITableView {

  func register<T: UITableViewCell>(_: T.Type) where T: ReuseableCell, T: NibLoadableView {
    let nib = UINib(nibName: T.NibName, bundle:nil)
    register(nib, forCellReuseIdentifier: T.reuseIdentifier)
  }
}

extension UITableView {

  /**
   Usage:
   ```
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   return tableView.dequeueReusableCell(forIndexPath: indexPath) as RealReuseableCell
   }
   ```
   */
  func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T
    where T: ReuseableCell {
      guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
        fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
      }
      return cell
  }
}

/// MARK: UICollectionView Extensions

extension UICollectionView {

  func register<T: UICollectionViewCell>(_: T.Type) where T: ReuseableCell, T: NibLoadableView {
    let nib = UINib(nibName: T.NibName, bundle:nil)
    register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
  }
}

extension UICollectionView {
  func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T
    where T: ReuseableCell {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
    }
    return cell
  }
}
