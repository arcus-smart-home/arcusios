//
//  ScleraSegmentedControl.swift
//  i2app
//
//  Created by Arcus Team on 2/4/18.
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
import Cornea
import UIKit

/**
 Segmented control that allows for a Sclera look and feel customization.
 */
@IBDesignable
class ScleraSegmentedControl: UIControl {
  
  /**
   Flag to indicate that the buttons in the segmented control should be laid out proportionally
   instead of equally spaced.
   */
  @IBInspectable
  var isProportional: Bool = false {
    didSet {
      updateView()
    }
  }
  
  /**
   The border width of the whole segmented control.
   */
  @IBInspectable
  var borderWidth: CGFloat = 0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }
  
  /**
   The border width of the highlight view for a selected option.
   */
  @IBInspectable
  var selectedBorderWidth: CGFloat = 0 {
    didSet {
      updateView()
    }
  }
  
  /**
   The color of the segmented view border.
   */
  @IBInspectable
  var borderColor: UIColor = UIColor.black {
    didSet {
      layer.borderColor = borderColor.cgColor
    }
  }
  
  /**
   The color of the highlight view border.
   */
  @IBInspectable
  var selectedBorderColor: UIColor = UIColor.black {
    didSet {
      updateView()
    }
  }
  
  /**
   The background color of the segmented control.
   */
  @IBInspectable
  var segmentedColor: UIColor = UIColor.clear {
    didSet {
      layer.backgroundColor = segmentedColor.cgColor
    }
  }
  
  /**
   The color of the button text for non-selected buttons.
   */
  @IBInspectable
  var textColor: UIColor = UIColor.black {
    didSet {
      updateView()
    }
  }
  
  /**
   The color of the background of the highlight view.
   */
  @IBInspectable
  var selectedColor: UIColor = UIColor.white {
    didSet {
      updateView()
    }
  }
  
  /**
   The color of the text for the selected button.
   */
  @IBInspectable
  var selectedTextColor: UIColor = UIColor.black {
    didSet {
      updateView()
    }
  }
  
  /**
   Text containing the content of the button titles. The titles must be separated by a bar "|"
   */
  @IBInspectable
  var buttonTitles: String = "" {
    didSet {
      updateView()
    }
  }
  
  private var buttons = [UIButton]()
  private var selectedView = UIView()
  private(set) var selectedSegmentIndex = 0
  
  override func draw(_ rect: CGRect) {
    layer.cornerRadius = frame.height/2
  }
  
  /**
   Changes the selected index and updates the UI.
   - parameter index: The new selected index.
   */
  func setSelectedSegment(withIndex index: Int) {
    if index == selectedSegmentIndex {
      return
    }
    
    selectedSegmentIndex = index
    updateView()
  }
  
  private func updateView() {
    // Clear Previous Views.
    buttons.removeAll()
    subviews.forEach { $0.removeFromSuperview() }
    
    // Add or Reconfigure views.
    addButtons()
    addSelectedView()
    addStackView()
  }
  
  private func addSelectedView() {
    selectedView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: frame.height))
    selectedView.layer.cornerRadius = selectedView.frame.height / CGFloat(2)
    selectedView.layer.borderWidth = selectedBorderWidth
    selectedView.layer.borderColor = selectedBorderColor.cgColor
    selectedView.backgroundColor = selectedColor
    addSubview(selectedView)
  }
  
  private func addStackView() {
    let stackView = UIStackView(arrangedSubviews: buttons)
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = isProportional ? .fillProportionally : .fillEqually
    addSubview(stackView)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
  }
  
  private func addButtons() {
    let titleComponents = buttonTitles.components(separatedBy: "|")
    
    // Make the font smaller if there are three options on a small space
    var fontsize: CGFloat = 12
    if frame.width < 300 && titleComponents.count > 2 {
      fontsize = 11
    }
    
    for (index, buttonTitle) in titleComponents.enumerated() {
      let button = UIButton(type: .system)
      button.setTitle(buttonTitle.trimmingCharacters(in: .whitespaces), for: .normal)
      button.setTitleColor(textColor, for: .normal)
      button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: fontsize)
      button.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
      button.titleLabel?.adjustsFontSizeToFitWidth = true
      buttons.append(button)
      
      if index == selectedSegmentIndex {
        button.setTitleColor(selectedTextColor, for: .normal)
        button.layer.backgroundColor = selectedColor.cgColor
        button.layer.borderWidth = selectedBorderWidth
        button.layer.borderColor = selectedBorderColor.cgColor
        button.layer.cornerRadius = frame.height / 2
      }
    }
  }
  
  @objc private func buttonPressed(button: UIButton) {
    for (index, buttonFromList) in buttons.enumerated() {
      buttonFromList.setTitleColor(textColor, for: .normal)
      buttonFromList.layer.backgroundColor = UIColor.clear.cgColor
      buttonFromList.layer.borderColor = UIColor.clear.cgColor
      
      if selectedView.frame.width == 0 {
        selectedView.frame = buttons[selectedSegmentIndex].frame
      }
      
      if buttonFromList == button {
        UIView.animate(withDuration: 0.3, animations: {
          self.selectedView.frame = button.frame
        })
        
        button.setTitleColor(selectedTextColor, for: .normal)
        
        if selectedSegmentIndex != index {
          selectedSegmentIndex = index
          sendActions(for: .valueChanged)
        }
      }
    }
  }
  
}
