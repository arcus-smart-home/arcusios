//
//  NestDeviceRemovedViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/3/17.
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

class NestDeviceRemovedViewController: UIViewController {
  
  // MARK: Properties
  
  var presenter: NestDeviceRemovedPresenterProtocol!
  
  // MARK: Actions
  
  @IBAction func closeButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureBackgroundGradient()
    
    ArcusAnalytics.tag(AnalyticsTags.NestRemoved, attributes: [:])
  }
  
  private func configureBackgroundGradient() {
    let gradientLayer = CAGradientLayer()
    
    let light = UIColor(red: 211/255.0,
                        green: 0/255.0,
                        blue: 75/255.0,
                        alpha: 1.0).cgColor as CGColor
    
    let dark = UIColor(red: 136/255.0,
                       green: 0/255.0,
                       blue: 96/255.0,
                       alpha: 1.0).cgColor as CGColor
    
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [light, dark]
    gradientLayer.locations = [0.0, 1.0]
    
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
}

extension NestDeviceRemovedViewController: NestDeviceRemovedPresenterDelegate {
  
}
