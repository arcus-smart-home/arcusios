//
//  WSSChooseScheduleDaysViewController.swift
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

class WSSChooseScheduleDaysViewController: BasePairingViewController,
  UITableViewDataSource,
  UITableViewDelegate,
  PostPairingSchedulerUIProtocol,
ArcusModalSelectionDelegate {
  @IBOutlet var tableView: UITableView!

  internal var scheduler: WSSPostPairingScheduler?

  var popupWindow: PopupSelectionWindow?
  let schedulerStep: PostPairingSchedulerStep = PostPairingSchedulerStep(stepType: .days)
  let days: [String] = ["Sunday",
                        "Monday",
                        "Tuesday",
                        "Wednesday",
                        "Thursday",
                        "Friday",
                        "Saturday"]
  let dayAbbrevs: [String] = ["S", "M", "T", "W", "Th", "F", "Sa"]
  var selectedDays: [String] = []

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
    scheduler?.processSchedulerStep(schedulerStep, value: selectedDays as AnyObject, completionHandler: {
      (success: Bool, error: NSError?) in
      if success == true {
        self.scheduler?.scheduleEvents({
          success in
          if success == true {
            self.nextButtonPressed(sender)
          } else {
            self.displayGenericErrorMessage()
          }
        })
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
                                    value: daysString(selectedDays))
  }

  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "SelectDaysModalSegue", sender: self)
  }

  // MARK: ArcusModalSelectionModel
  func selectionModelsForDays(_ days: [String]) -> [ArcusModalSelectionModel] {
    var selectionModels: [ArcusModalSelectionModel] = []

    for day in days {
      let selectionModel: ArcusModalSelectionModel = ArcusModalSelectionModel()
      selectionModel.title = day
      selectionModel.tag = String(describing: days.index(of: day))

      selectionModels.append(selectionModel)
    }

    return selectionModels
  }

  func daysString(_ selectedDays: [String]) -> String {
    var daysString: String = ""

    for day in selectedDays {
      daysString += " " + dayAbbrevs[days.index(of: day)!]
    }
    daysString = daysString
      .trimmingCharacters(in: CharacterSet.whitespaces)
    daysString = daysString.replacingOccurrences(of: " ", with: ", ")

    return daysString
  }

  // MARK: ArcusModalSelectionViewControllerDelegate
  func modalSelectionController(_ selectionController: UIViewController!,
                                didDismissWithSelectedModels selectedIndexes: [ArcusModalSelectionModel]!) {
    selectedDays = []

    for index in selectedIndexes {
      selectedDays.append(index.title)
    }

    tableView.reloadData()
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if segue.identifier == "SelectDaysModalSegue" {
      if let selectionViewController = segue.destination as? ArcusModalSelectionViewController {
        selectionViewController.delegate = self
        selectionViewController.allowMultipleSelection = true
        selectionViewController.selectionArray = selectionModelsForDays(days)
      }
    }
  }
}
