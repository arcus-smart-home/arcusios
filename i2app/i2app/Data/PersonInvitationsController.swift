//
// Created by Arcus Team on 5/5/16.
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

@objc protocol PersonInvitationsCallback {
  func showInvitationsPending(_ invitations: [Invitation])
  @objc optional func showNoInvitations()
  @objc optional func showInvitationAccepted(_ invitation: Invitation)
  @objc optional func showInvitationAcceptInvalidError()
  @objc optional func showInvitationDeclined(_ invitation: Invitation)
}

@objc class PersonInvitationsController: NSObject {
  fileprivate let model: PersonModel
  fileprivate var callback: PersonInvitationsCallback?

  @objc(initWithModel:callback:)
  init(model: PersonModel, callback: PersonInvitationsCallback) {
    self.model = model
    self.callback = callback

    super.init()

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(pendingInvitationReceived(_:)),
                                           name: Notification.Name(rawValue: kEvtPersonInvitationPending),
                                           object: nil)

    checkForPendingInvitations()
  }

  @objc func pendingInvitationReceived(_ notification: Notification) {
    checkForPendingInvitations()
  }

  fileprivate func checkForPendingInvitations() {
    DispatchQueue.global(qos: .background).async {
      _ = PersonCapability.pendingInvitations(on: self.model).swiftThen { response in
        if let invitationsResponse = (response as? PersonPendingInvitationsResponse) {
          guard let invitations = invitationsResponse.getInvitations(),
            let count = invitationsResponse.getInvitations()?.count,
            count > 0 else {
              self.callback?.showNoInvitations?()
              return nil
          }

          var invites: [Invitation] = [Invitation]()
          for attributes in invitations {
            invites.append(Invitation(attributes: attributes as? NSDictionary))
          }
          self.callback?.showInvitationsPending(invites)
        }
        return nil
      }
    }
  }

  @objc func removeCallback() {
    self.callback = nil
  }

  // MARK: Invitation Actions
  @objc func acceptInvitation(_ invitation: Invitation) {
    guard invitation.code != nil && invitation.inviteeEmail != nil else {
      print("Invitation Code || invitee email is nil")
      return
    }
    
    ArcusAnalytics.tag(named: AnalyticsTags.InvitationAccept)

    DispatchQueue.global(qos: .background).async {
      _ = PersonCapability.acceptInvitation(withCode: invitation.code!,
                                            withInviteeEmail: invitation.inviteeEmail!,
                                            on: self.model)
        .swiftThen({ _ in
          self.checkForPendingInvitations()
          self.callback?.showInvitationAccepted?(invitation)

          return nil
        }).swiftCatch({ _ in
          self.callback?.showInvitationAcceptInvalidError?()

          return nil
        })
    }
  }

  @objc func declineInvitation(_ invitation: Invitation) {
    guard invitation.code != nil && invitation.inviteeEmail != nil else {
      print("Invitation Code || invitee email is nil")
      return
    }
    
    ArcusAnalytics.tag(named: AnalyticsTags.InvitationReject)

    DispatchQueue.global(qos: .background).async {
      _ = PersonCapability.rejectInvitation(withCode: invitation.code!,
                                            withInviteeEmail: invitation.inviteeEmail!,
                                            withReason: "",
                                            on: self.model)
        .swiftThen({ _ in
          self.checkForPendingInvitations()
          self.callback?.showInvitationDeclined?(invitation)

          return nil
        })
    }
  }
}
