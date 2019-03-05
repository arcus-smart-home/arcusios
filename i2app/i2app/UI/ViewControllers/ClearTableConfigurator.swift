//
//  ClearTableConfigurator.swift
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

import UIKit

/**
 To Be an Arcus Tableable View Controller we want a specific configuration of the ViewController and 
 the Storyboard of the View Controller
 
 The Storyboard needs to have a ViewController not a UITableViewController subclass
 
 The Root View of the tableview need to be a UIView, this view in the storyboard can be set to any
 color like grey to allow white labels to be visible the extension will draw the default background 
 over this view anyways
 
 TableViews, UITableViewCells should have clear backgrounds and White Label colors to look right
 
 A class that implements the protocol needs only to call `configureLayout()` in the
 `viewDidLoad()` function to get the configuration handled for them
 
 - seealso: ClearTableConfigurator Where the function is implemented
 
 */
protocol ClearTableConfigurator : class {
    weak var tableView: UITableView! { get }
    func configureClearLayout()
}

extension ClearTableConfigurator where Self: UIViewController {

    /**
     ClearTableConfigurator implmentation
     
     * The Navigation item's title will be a Label with the correct styled font and color
     * The Backgound will be the shared Background common to most TableViews in the App
     * The TableView's background will be set to clear programically, allowing our storyboard's to use a
     grey background that we can read white labels on
     
     */
    func configureClearLayout() {
        navBar(withTitle: navigationItem.title, enableBackButton: true)
        setBackgroundColorToDashboardColor()
        addDarkOverlay(BackgroupOverlayLightLevel)
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
    }

}
