//
//  ForgotPasswordViewController.swift
//  Heartadvisor
//
//  Created by Tejal Patel on 1/30/21.
//

import UIKit
import PanModal
import Firebase

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var paragraph1: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        Utilities.styleFilledButton(resetBtn)
        Utilities.styleTextField(emailField, "black")
        Utilities.styleSubHeaderLabel(headerLabel)
        Utilities.styleParagraphLabel(paragraph1)
    }
    
    @IBAction func onForgotPassword(_ sender: Any) {
        if(emailField.text == "") {
            showError(message: "Please enter an email")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: emailField.text!) { error in
            self.showError(message: error.debugDescription)
        }
        showError(message: "A password recovery email has been sent to \(emailField.text!)")
    }
    
}

extension ForgotPasswordViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }
    
    // The height of the forgot password modal view is 75% of the parent view
    var shortFormHeight: PanModalHeight {
        return .contentHeight(view.frame.height*0.75)
    }
}
