//
//  MentalHealthViewController.swift
//  Heartadvisor
//
//  Created by Tejal Patel on 1/26/21.
//

import UIKit

class MentalHealthViewController: UIViewController {

    @IBOutlet weak var recommendedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarSetup()
        
        Utilities.styleSubHeaderLabel(recommendedLabel)
    }

}
