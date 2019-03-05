//
//  YouTubePlayerViewController.swift
//  i2app
//
//  Arcus Team on 2/21/18.
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

public class YouTubePlayerViewController: UIViewController {

  @IBOutlet weak var webView: UIWebView!
  var videoId: String?

  public override func viewDidAppear(_ animated: Bool) {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
          let windowSize = appDelegate.window?.frame.size,
          let id = videoId else {
      
      self.dismiss(animated: true, completion: nil)
      return
    }
  
    // swiftlint:disable:next line_length
    let html = "<html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = 'http://www.youtube.com/player_api'; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'\(windowSize.width)', height:'\(windowSize.height)', videoId:'\(id)', events: { 'onReady': onPlayerReady } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>"
    
    webView.backgroundColor = UIColor.clear
    webView.isOpaque = false
    webView.mediaPlaybackRequiresUserAction = false
    webView.loadHTMLString(html, baseURL: Bundle.main.resourceURL)    

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.onVideoDismissed),
                                           name: NSNotification.Name.UIWindowDidBecomeKey,
                                           object: self.view.window)
  }

  @objc func onVideoDismissed(_ note: Notification) {
    self.dismiss(animated: true, completion: nil)
  }

}
