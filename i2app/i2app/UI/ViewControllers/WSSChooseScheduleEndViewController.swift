//
//  WSSChooseScheduleEndViewController.swift
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

import UIKit
import Cornea

class WSSChooseScheduleEndViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
PostPairingSchedulerUIProtocol {
    @IBOutlet var tableView: UITableView!

    internal var scheduler: WSSPostPairingScheduler?

    var popupWindow: PopupSelectionWindow?
    var endDate: ArcusDateTime = ArcusDateTime(date: NSDate(timeInHour: 23, withMins: 00) as Date!)

    let schedulerStep: PostPairingSchedulerStep = PostPairingSchedulerStep(stepType: .endTime)

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar(self,
                               title: navigationItem.title!,
                               showClose: true)
        configureBackgroundView(self)
        configureTableView(tableView)
    }

    // MARK: IBActions
    @IBAction func saveButtonPressed(_ sender: ArcusButton) {
        scheduler?.processSchedulerStep(schedulerStep, value: endDate, completionHandler: {
            (success: Bool, error: NSError?) in
            if success == true {
                self.performSegue(withIdentifier: "PostPairSelectDaysSegue", sender: self)
            } else {
                self.displayErrorMessage(error?.localizedDescription)
            }
        })
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return postPairingSchedulerCell(tableView,
                                        identifier: "cell",
                                        title: schedulerStep.title,
                                        value: endDate.formatDateTimeStamp())
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if popupWindow != nil {
            if popupWindow?.displaying == true {
                popupWindow?.close()
            }
        }

        let container: PopupSelectionBaseContainer = timePicker(endDate)
        popupWindow = popup(self,
                            container: container,
                            completion: #selector(closePopup(_:)))

        popupWindow?.open()
    }

    func closePopup(_ sender: AnyObject) {
        if let value = sender as? ArcusDateTime {
            endDate.update(value)
            tableView.reloadData()
        }
    }

    // MARK: PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostPairSelectDaysSegue" {
            if let chooseDaysViewController = segue
                .destination as? WSSChooseScheduleDaysViewController {
                chooseDaysViewController.scheduler = scheduler
            }
        }
    }
}
