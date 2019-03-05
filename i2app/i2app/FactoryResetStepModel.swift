//
//  FactoryResetStepModel.swift
//  i2app
//
//  Arcus Team on 4/19/18.
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

struct FactoryResetStepModel {

  let stepText: String
  let stepNumber: Int

  init (_ stepNumber: Int, instruction: String) {
    self.stepText = instruction
    self.stepNumber = stepNumber
  }
  
  func numberImage() -> UIImage? {
    return UIImage(named: "step\(stepNumber)_teal_30x30")
  }
  
  static func fromSteps(_ stepData: [Any?]?) -> [FactoryResetStepModel] {
    var steps: [FactoryResetStepModel] = []
    
    for thisStepData in stepData ?? [] {
      if let stepAttributes = thisStepData as? [String:AnyObject?],
         let stepOrder = stepAttributes["order"] as? Int,
         let stepInstructions = stepAttributes["instructions"] as? [String] {
        
        var instructions = ""
        for (index, instruction) in stepInstructions.enumerated() {
          instructions += instruction
          if index < stepInstructions.count - 1 {
            instructions += "\n\n"
          }
        }
        
        steps.append(FactoryResetStepModel(stepOrder, instruction: instructions))
      }
    }
    
    return steps.sorted(by: { $0.stepNumber < $1.stepNumber })
  }
}
