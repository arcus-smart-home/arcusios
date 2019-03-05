//
//  GenericPresenterDelegates.swift
//  i2app
//
//  Created by Arcus Team on 1/12/17.
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

/// Presenters who only have one function to ask the View to update its layout
public protocol GenericPresenterDelegate: class {

  /// update layout (and data from the presenter)
  func updateLayout()
}

public protocol GenericListPresenterDelegate: class, GenericPresenterDelegate {
  /// update the data of a specific index path
  func updateAtIndexPath(_ indexPath: IndexPath)
}

/// If you have a `tableView` and you are a `GenericPresenterDelegate` we can easily conform to
/// `SimpleTableViewGenericPresenterDelegate` to get the functionality of `updateLayout()` &
/// updateAtIndexPath(_ indexPath: IndexPath) reloading from the tableView's datasource, safely
/// on the main thread
public protocol SimpleTableViewGenericPresenterDelegate: GenericListPresenterDelegate {
  var tableView: UITableView! { get }
}

extension SimpleTableViewGenericPresenterDelegate {
  func updateLayout() {
    DispatchQueue.main.async {
      guard let tableView = self.tableView else {
        return
      }
      tableView.reloadData()
    }
  }

  func updateAtIndexPath(_ indexPath: IndexPath) {
    DispatchQueue.main.async {
      guard let tableView = self.tableView else {
        return
      }
      tableView.reloadRows(at: [indexPath], with: .none)
    }
  }
}
