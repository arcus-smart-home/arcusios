//
//  DashboardHomeFamilyProvider.swift
//  i2app
//
//  Created by Arcus Team on 1/5/17.
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

import Cornea

protocol DashboardHomeFamilyProvider {
  weak var delegate: DashboardPresenterDelegate? { get set }

  // MARK: Extended
  func fetchDashboardHomeFamily()
}

extension DashboardHomeFamilyProvider where Self: DashboardProvider {
  func fetchDashboardHomeFamily() {
    let viewModel = DashboardHomeFamilyViewModel()

    if let controller: PresenceSubsystemController =
      SubsystemsController.sharedInstance().presenceController {
      if controller.allAddresses.count > 0 {
        viewModel.isEnabled = true

        guard let peopleAtHome = controller.allPeopleAtHomeAddresses as? [String],
          let devicesAtHome = controller.allDevicesAtHomeAddresses as? [String]
          else {
          storeViewModel(viewModel)
          return
        }
        let orderedPeopleAtHome: [String] = orderPeopleForDashboardDisplay(people: peopleAtHome)
        var additionalCount = devicesAtHome.count + peopleAtHome.count

        if orderedPeopleAtHome.count > 0 {

          // If there are more than 2 people at home then the first two will
          // be shown face up on the cell
          if orderedPeopleAtHome.count >= 2 {
            additionalCount -= 1

            let address: String = orderedPeopleAtHome[1]
            if let model = RxCornea.shared.modelCache?.fetchModel(address) as? Model {
              viewModel.secondImage = imageForModel(model)
            }
          }

          additionalCount -= 1

          let address = orderedPeopleAtHome[0]
          if let model = RxCornea.shared.modelCache?.fetchModel(address) as? Model {
            viewModel.firstImage = imageForModel(model)
          }
        }

        if additionalCount > 0 {
          viewModel.additionalCount = "\(additionalCount)"
        } else {
          viewModel.additionalCount = ""
        }
      }
    }

    storeViewModel(viewModel)
  }

  func orderPeopleForDashboardDisplay(people: [String]) -> [String] {
    return people.sorted { (p1, p2) -> Bool in

      if let m1 = RxCornea.shared.modelCache?.fetchModel(p1) as? PersonModel,
        let m2 = RxCornea.shared.modelCache?.fetchModel(p2) as? PersonModel {

        // Person 1 is a hump; person 2 has an image then person 2 comes first
        if m1.image != nil && m2.image == nil {
          return true
        }

        // Person 1 has an image; person 2 is a hump then person 1 comes first
        else if m1.image == nil && m2.image != nil {
          return false
        }

        // Neither or both have images; order by name
        return m1.fullName < m2.fullName
      }
      return false
    }
  }

  private func imageForModel(_ model: Model?) -> UIImage {
    var personImage: UIImage!

    if let personModel = model as? PersonModel {
      personImage = personModel.image
    }

    if personImage == nil {
      personImage = UIImage(named: "userIcon")
    }

    personImage = personImage.exactZoomScaleAndCutSize(
      inCenter: CGSize(width: 30, height: 30))
    personImage = personImage.roundCornerImageWithsize(
      CGSize(width: 28, height: 28))

    return personImage
  }
}
