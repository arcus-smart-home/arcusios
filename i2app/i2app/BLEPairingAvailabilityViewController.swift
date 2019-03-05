 //
 //  BLEPairingAvailabilityViewController.swift
 //  i2app
 //
 //  Created by Arcus Team on 7/17/18.
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
 import RxSwift
 import RxSwiftExt
 import RxCocoa
 import CoreBluetooth

 fileprivate struct BLEAvailabilityStrings {
  static let on: String = "Awesome! Bluetooth on your iOS device is on."
  static let off: String = "Bluetooth on your iOS Device is currently off."
  static let onDescription: String = "Tap ‘Next’ to start searching for the <ShortName> over Bluetooth."
  static let offDescription: String = "Bluetooth must be enabled to pair the <ShortName>. "
    + "Please turn on Bluetooth in your iOS Settings and then return to the Arcus app to continue setup"

  static let settings: String = "iOS Settings"
 }

 typealias TextLinkAttributes = (attributedText: NSAttributedString, linkAttributes: [String: Any])

 class BLEPairingAvailabilityViewController: UIViewController,
  HubBLEInstructionable,
  StoryboardCreatable {

  @IBOutlet weak var availabilityLabel: UILabel!
  @IBOutlet weak var settingsInfoTextView: UITextView!

  static var storyboardName: String = DeviceBLEPairingStoryboardName
  static var storyboardIdentifier: String = "BLEPairingAvailabilityViewController"

  // MARK: - PairingStepsPresenter
  var step: ArcusPairingStepViewModel?
  var presenter: PairingStepsPresenter?

  weak var customStepDelegate: PairingStepsCustomStepDelegate?

  // MARK: - ArcusBLEPairingClient
  var bleClient: ArcusBLEAvailability!
  var disposeBag: DisposeBag = DisposeBag()

  // MARK - Constructor

  static func fromPairingStep(step: ArcusPairingStepViewModel,
                              presenter: PairingStepsPresenter) -> BLEPairingAvailabilityViewController? {
    let storyboard = UIStoryboard(name: "BLEDevicePairing", bundle: nil)
    if let vc = storyboard.instantiateViewController(withIdentifier: "BLEPairingAvailabilityViewController")
      as? BLEPairingAvailabilityViewController {
      vc.step = step
      vc.presenter = presenter

      if let step = step as? CustomPairingStepViewModel,
        let client = step.config as? ArcusBLEAvailability {
        vc.bleClient = client
      }

      return vc
    }
    return nil
  }

  // MARK - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    if let presenterDelegate = presenter?.customStepDelegate {
      customStepDelegate = presenterDelegate
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    configureBindings()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    disposeBag = DisposeBag()
  }

  // MARK: UI Configuration

  func configureBindings() {
    let isAvailable = bleClient.isBLEAvailable()

    isAvailable
      .map { available in
        return available ? BLEAvailabilityStrings.on : BLEAvailabilityStrings.off
      }
      .bind(to: availabilityLabel.rx.text)
      .disposed(by: disposeBag)

    let textObservable: Observable<TextLinkAttributes> = isAvailable
      .map { [unowned self] available in
        let shortName = self.customStepDelegate?.deviceShortName ?? "device"
        if available {
          let description = BLEAvailabilityStrings.onDescription.replacingOccurrences(of: "<ShortName>",
                                                                                      with: shortName)
          return self.clearedAttributedString(description)
        } else {
          let description = BLEAvailabilityStrings.offDescription.replacingOccurrences(of: "<ShortName>",
                                                                                      with: shortName)
          return self.attributedString(description)
        }
    }

    textObservable
      .subscribe(onNext: { [unowned self] textLinkAttributes in
        self.settingsInfoTextView.attributedText = textLinkAttributes.attributedText
        self.settingsInfoTextView.linkTextAttributes = textLinkAttributes.linkAttributes
      })
      .disposed(by: disposeBag)

    if let delegate = customStepDelegate {
      isAvailable
        .shareReplay(1)
        .bind(to: delegate.pagingEnabled)
        .disposed(by: disposeBag)
    }
  }

  func attributedString(_ string: String) -> TextLinkAttributes {
    let range = (string as NSString).range(of: BLEAvailabilityStrings.settings)
    let font = settingsInfoTextView.font

    let style = NSMutableParagraphStyle()
    style.alignment = settingsInfoTextView.textAlignment

    let attributes = [NSFontAttributeName : font!, NSParagraphStyleAttributeName: style]

    let attributedString: NSMutableAttributedString =
      NSMutableAttributedString(string: string, attributes: attributes)

    attributedString.addAttribute(NSLinkAttributeName, value: "settings", range: range)

    return (attributedString, [NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue])
  }

  func clearedAttributedString(_ string: String) -> TextLinkAttributes {
    let font = settingsInfoTextView.font

    let style = NSMutableParagraphStyle()
    style.alignment = settingsInfoTextView.textAlignment

    let attributes = [NSFontAttributeName : font!, NSParagraphStyleAttributeName: style]

    let attributedString: NSMutableAttributedString =
      NSMutableAttributedString(string: string, attributes: attributes)

    return (attributedString, [:])
  }
 }

 // MARK: - UITextViewDelegate

 extension BLEPairingAvailabilityViewController: UITextViewDelegate {
  func textView(_ textView: UITextView,
                shouldInteractWith URL: URL,
                in characterRange: NSRange) -> Bool {
    if URL.absoluteString == "settings" {
      guard let settingsUrl = settingsURL() else {
        return false
      }

      if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, completionHandler: nil)
      }

      return false
    }
    return true
  }

  private func settingsURL() -> URL? {
    return URL(string: "App-Prefs:")
  }
 }
