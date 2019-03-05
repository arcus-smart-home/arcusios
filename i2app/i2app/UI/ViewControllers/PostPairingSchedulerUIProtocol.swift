//
//  PostPairingSchedulerUIProtocol.swift
//  i2app
//
//  Created by Arcus Team on 8/10/16.
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

protocol PostPairingSchedulerUIProtocol {
    // MARK: UI Configuration
    func configureNavigationBar(_ viewController: UIViewController,
                                title: String,
                                showClose: Bool)
    func configureBackgroundView(_ viewController: UIViewController)
    func configureTableView(_ tableView: UITableView)

    // MARK: TableViewCell
    func postPairingSchedulerCell(_ tableView: UITableView,
                                  identifier: String,
                                  title: String,
                                  value: String?) -> UITableViewCell

    // MARK: Popup Handling
    func timePicker(_ dateTime: ArcusDateTime) -> PopupSelectionSchedulerTimeView
    func popup(_ viewController: UIViewController,
               container: PopupSelectionBaseContainer,
               completion: Selector) -> PopupSelectionWindow
}

extension PostPairingSchedulerUIProtocol {
    // MARK: UI Configuration
    func configureNavigationBar(_ viewController: UIViewController,
                                title: String,
                                showClose: Bool) {
        if showClose == true {
            viewController.navBar(withCloseButtonAndTitle: title)
        } else {
            viewController.navBar(withBackButtonAndTitle: title)
        }
    }

    func configureBackgroundView(_ viewController: UIViewController) {
        viewController.setBackgroundColorToDashboardColor()
        viewController.addWhiteOverlay(BackgroupOverlayMiddleLevel)
    }

    func configureTableView(_ tableView: UITableView) {
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
    }

    // MARK: TableViewCell
    func postPairingSchedulerCell(_ tableView: UITableView,
                                  identifier: String,
                                  title: String,
                                  value: String?) -> UITableViewCell {

        var cell: ArcusTitleDetailTableViewCell? = tableView
            .dequeueReusableCell(withIdentifier: identifier)
            as? ArcusTitleDetailTableViewCell
        if cell == nil {
            cell = ArcusTitleDetailTableViewCell.init(style: .default,
                                                     reuseIdentifier: identifier)
        }

        cell?.backgroundColor = UIColor.clear
        cell?.selectionStyle = .none
        cell?.titleLabel.text = title
        if value != nil {
            cell?.accessoryLabel.text = value!
        } else {
            cell?.accessoryLabel.text = ""
        }

        return cell!
    }

    // MARK: Popup Handling
    func timePicker(_ dateTime: ArcusDateTime) -> PopupSelectionSchedulerTimeView {
        return PopupSelectionSchedulerTimeView.create(with: dateTime, showJustDate: false)
    }

    func popup(_ viewController: UIViewController,
               container: PopupSelectionBaseContainer,
               completion: Selector) -> PopupSelectionWindow {
       return PopupSelectionWindow.popup(viewController.view,
                                         subview: container,
                                         owner: viewController,
                                         close: completion)
    }
}
