//
//  BannerPresenter.swift
//  i2app
//
//  Created by Arcus Team on 7/12/16.
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

class Banner: NSObject {
    var tag: Int = -1

    var priority: Int = -1

    var title: String = ""
    var subtitle: String = ""

    var alertType: Int = -1
    var sceneType: Int = -1
    var bannerType: Int = -1

    var action: String?
}

@objc protocol BannerPresenterCallback: class {
    func showBanner(_ banner: Banner)
    func removeBanner(_ tag: Int)
    func removeAllBanners()
}

class BannerPresenter: NSObject {
    fileprivate weak var callback: BannerPresenterCallback?

    fileprivate var banners: [Banner] = [Banner]()

    init(callback: BannerPresenterCallback) {
        self.callback = callback
    }

    @objc func addBanner(_ banner: Banner) {
        banners.append(banner)

        self.sortBannersByPriority()

        self.showTopBanner()
    }

    @objc func removeBanner(_ bannerType: Int) {
        if let index = banners.index(where: {$0.bannerType == bannerType}) {
            let banner = self.banners.remove(at: index)

            if self.banners.isEmpty {
                // Remove the last banner with animation
                self.callback?.removeBanner(banner.tag)
            } else {
                self.sortBannersByPriority()

                // Since the index was the shown banner
                if index == 0 {
                    self.showTopBanner()
                }
            }
        }
    }

    @objc func containsBanner(_ bannerType: Int) -> Bool {
        if banners.index(where: {$0.bannerType == bannerType}) != nil {
            return true
        }

        return false
    }

    func showTopBanner() {
        // Remove any current banners
        self.callback?.removeAllBanners()

        // Show the highest priority banner
        if let banner = self.banners[safe: 0] {
            self.callback?.showBanner(banner)
        }
    }

    func sortBannersByPriority() {
        banners.sort { (a: Banner, b: Banner) -> Bool in
            a.priority < b.priority
        }
    }
}
