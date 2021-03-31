//
//  LoginViewController.swift
//  Heartadvisor
//
//  Created by Tejal Patel on 1/26/21.
//

import UIKit
import PanModal

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var paragraph1: UILabel!
    @IBOutlet weak var switchBtn: UIButton!
    @IBOutlet weak var signBtn: UIButton!
    @IBOutlet weak var firstLastStack: UIStackView!
    @IBOutlet weak var emailTopConstraint: NSLayoutConstraint!
    
    var type = "Sign Up"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Below code is to hide keyboard on screen tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Initially hide forgot password because we start off on the sign up screen
        forgotPasswordBtn.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        Utilities.styleTextField(emailField)
        Utilities.styleTextField(passwordField)
        Utilities.styleTextField(firstNameField)
        Utilities.styleTextField(lastNameField)
        
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        firstNameField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        lastNameField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        Utilities.styleLinkButton(switchBtn)
        Utilities.styleLinkButton(forgotPasswordBtn)
        
        Utilities.styleParagraphLabel(paragraph1)
        
        Utilities.styleFilledButton(signBtn)
    }
    
    @IBAction func onSwitch(_ sender: Any) {
        if(type == "Sign In") {
            type = "Sign Up"
            
            paragraph1.text = "Already have an account?"
            switchBtn.setTitle("Sign In", for: .normal)
            signBtn.setTitle("Sign Up", for: .normal)
            
            forgotPasswordBtn.isHidden = true
            firstLastStack.isHidden = false
            emailTopConstraint.constant = emailTopConstraint.constant + firstLastStack.frame.height
            
            view.layoutIfNeeded()
        }
        else if(type == "Sign Up") {
            type = "Sign In"
            
            paragraph1.text = "Don't have an account?"
            switchBtn.setTitle("Sign Up", for: .normal)
            signBtn.setTitle("Sign In", for: .normal)
            
            forgotPasswordBtn.isHidden = false
            firstLastStack.isHidden = true
            emailTopConstraint.constant = emailTopConstraint.constant - firstLastStack.frame.height
            
            view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onForgotPassword(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "forgotPasswordVC") as! ForgotPasswordViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.presentPanModal(vc)
    }
    
    
}
