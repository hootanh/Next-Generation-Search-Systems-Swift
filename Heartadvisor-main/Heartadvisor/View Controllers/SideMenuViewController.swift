//
//  SideMenuViewController.swift
//  Heartadvisor
//
//  Created by Tejal Patel on 2/24/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class SideMenuViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
        
        db.collection("users").document(Auth.auth().currentUser!.uid)
            .getDocument { querySnapshot, error in
                guard let querySnapshot = querySnapshot, querySnapshot.exists else {return}
                let data = querySnapshot.data()
                
                self.headerLabel.text = ("Hi \(data?["first_name"] ?? "") \(data?["last_name"] ?? "")!" )

        }
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = true
        Utilities.styleHeaderLabel(headerLabel)
        Utilities.styleFilledButton(logoutBtn)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        do
        {
            print("signing out")
            try Auth.auth().signOut()

        }
        catch let error as NSError
        {
            self.showError(message: error.localizedDescription)
        }
    }
    

}
