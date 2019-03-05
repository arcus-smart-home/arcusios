

/// View Controllers conforming to ArcusMessageBoxViewable can have a banner View
/// managed by this protocol as a trait
/// Must have an Obj-C Interface for this `func hideMessageBox() { shouldHideAdvancedPairingBanner() }`
protocol ArcusMessageBoxViewable {

  /// Message Box View to animate when a new device is paired
  var messageBox: UIView! { get }

  /// Label to display pairing text
  var messageLabel: UILabel! { get }

  /// This constraint should be set to -60 and animated to 0 when the banner is shown
  /// the inverse animation will occur when hidden
  var messageBoxTopConstraint: NSLayoutConstraint! { get }

  /// Extended to 60
  var bannerHeight: CGFloat { get }
}

/// A Viewable Message Box when a UIViewController
/// - seealso: CheckYourEmailViewController which conforms to this protocol
extension ArcusMessageBoxViewable where Self: UIViewController {
  /// Extended to 60
  var bannerHeight: CGFloat {
    return 60
  }

  func shouldPresentBanner(withText text: String) {
    messageLabel.text = text
    if messageBox.isHidden {
      messageBox.isHidden = false
      UIView.animate(withDuration: 0.35) {
        self.messageBoxTopConstraint.constant = 0.0
        self.view.layoutIfNeeded()
      }
    } else {
      /// Don't reanimate an already presented View
      self.messageBoxTopConstraint.constant = 0.0
      self.view.layoutIfNeeded()
      return
    }
  }

  func shouldHideBanner(_ animated: Bool = true) {
    if animated {
      UIView.animate(withDuration: 0.35, animations: {
        self.messageBoxTopConstraint.constant = -self.bannerHeight
        self.view.layoutIfNeeded()
      }, completion: { _ in
        self.messageBox.isHidden = true
      })
    } else {
      self.messageBox.isHidden = true
      self.messageBoxTopConstraint.constant = -self.bannerHeight
      self.view.layoutIfNeeded()
    }
  }
}
