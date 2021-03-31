//
//  PlayerViewController.swift
//  Heartadvisor
//
//  Created by Tejal Patel on 2/18/21.
//

import UIKit
import FirebaseStorage
import AVKit

class PlayerViewController: UIViewController {

    var player = AVPlayer()
    var avPlayerController = AVPlayerViewController()
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Transparent Background
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.tabBarController?.tabBar.isHidden = true
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let footageRef = storageRef.child(name)

        footageRef.downloadURL { url, error in
            if let error = error {
                // Handle any errors
                self.showError(message: error.localizedDescription)
            } else {
                self.player = AVPlayer(url: url!)
                self.avPlayerController = AVPlayerViewController()

                self.avPlayerController.player = self.player;
                self.avPlayerController.view.frame = UIScreen.main.bounds;
                self.avPlayerController.entersFullScreenWhenPlaybackBegins = true


                self.addChild(self.avPlayerController)
                self.view.addSubview(self.avPlayerController.view);
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.player.pause()
    }


}
