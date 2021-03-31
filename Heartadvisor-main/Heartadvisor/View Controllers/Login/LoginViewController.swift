//
//  LoginViewController.swift
//  Heartadvisor
//
//  Created by Tejal Patel on 1/26/21.
//

import UIKit
import PanModal
import FirebaseAuth
import Firebase
import FirebaseFirestore

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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide Navigation bar when login screen appears
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
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
        
        passwordField.isSecureTextEntry = true
        
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        firstNameField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        lastNameField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        Utilities.styleLinkButton(switchBtn)
        Utilities.styleLinkButton(forgotPasswordBtn)
        
        Utilities.styleParagraphLabel(paragraph1)
        
        Utilities.styleFilledButton(signBtn)
        
        view.layoutIfNeeded()
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
    
    @IBAction func userSign(_ sender: Any) {
        // Make sure that the user entered an email and password
        if(emailField.text == "") {
            self.showError(message: "Please enter an email")
            return
        }
        if(passwordField.text == "") {
            self.showError(message: "Please enter a password")
            return
        }
        if(firstNameField.text == "" && type == "Sign Up") {
            self.showError(message: "Please enter a first name")
            return
        }
        if(lastNameField.text == "" && type == "Sign Up") {
            self.showError(message: "Please enter a last name")
            return
        }
        
        if(type == "Sign Up") {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
                if(error != nil) {
                    self.showError(message: error?.localizedDescription ?? "The system ran into an unexpected error. Please try again later.")
                    return
                }
                let db
                    = Firestore.firestore()
                db.collection("users").document(authResult!.user.uid).setData([
                    "first_name":self.firstNameField.text!,
                    "last_name":self.lastNameField.text!,
                    "uid":authResult!.user.uid,
                    "email":self.emailField.text!,
                    "currentExerciseProgress": "0",
                    "weeklyExerciseGoal": "300",
                    "hasEquipment": true,
                    "upperFreq": 0.25,
                    "lowerFreq": 0.25,
                    "coreFreq": 0.25,
                    "newFreq": 0.25
                ], merge: true){ (error) in
                    self.showError(message: error?.localizedDescription ?? "The system ran into an unexpected error. Please try again later.")
                    print("here2")
                }

                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
        else {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] authResult, error in
                //guard let strongSelf = self else { return }
                if(error != nil) {
                    self?.showError(message: error?.localizedDescription ?? "The system ran into an unexpected error. Please try again later.")
                    return
                }

                let homeViewController = self?.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                self?.view.window?.rootViewController = homeViewController
                self?.view.window?.makeKeyAndVisible()
        }
    }
}


}
