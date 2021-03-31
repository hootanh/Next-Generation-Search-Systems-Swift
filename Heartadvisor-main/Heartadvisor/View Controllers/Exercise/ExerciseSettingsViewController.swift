//
//  ExerciseSettingsViewController.swift
//  Heartadvisor
//
//  Created by Andrew Tsui on 2/10/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ExerciseSettingsViewController: UIViewController {
        
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var equipmentLabel: UILabel!
    @IBOutlet weak var recommendationLabel: UILabel!
    @IBOutlet weak var recommendationSublabel: UILabel!
    
    @IBOutlet weak var exerciseSwitch: UISwitch!
    @IBOutlet weak var coreTextField: UITextField!
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var lowerTextField: UITextField!
    @IBOutlet weak var newTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.collection("users").document(user)
            .getDocument { querySnapshot, error in
                guard let querySnapshot = querySnapshot, querySnapshot.exists else {return}
            let data = querySnapshot.data()
            
            self.coreTextField.text = String( data?["coreFreq"] as? Double ?? 0.25)
            self.upperTextField.text = String( data?["upperFreq"]  as? Double ?? 0.25)
            self.lowerTextField.text = String(data?["lowerFreq"] as? Double ?? 0.25)
            self.newTextField.text = String( data?["newFreq"] as? Double ?? 0.25)
            if(data?["hasEquipment"] as? Bool == false) {
                self.exerciseSwitch.setOn(false, animated: true)
            }
            else {
                self.exerciseSwitch.setOn(true, animated: true)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        Utilities.styleSubHeaderLabel(equipmentLabel)
        Utilities.styleSubHeaderLabel(recommendationLabel)
        Utilities.styleParagraphLabel(recommendationSublabel)
    }
    
    @IBAction func unwindSettings(_ sender: Any) {
        
        var sum = Double(newTextField.text!)!
        sum += Double(upperTextField.text!)!
        sum +=  Double(lowerTextField.text!)!
        sum += Double(coreTextField.text!)!
        
        if(sum > 1) {
            self.showError(message: "Frequencies must add up to 1")
            return
        }
        
        db.collection("users").document(user).updateData([
            "hasEquipment": self.exerciseSwitch.isOn ? true : false,
            "newFreq": Double(newTextField.text!) ?? 0.25,
            "upperFreq": Double(upperTextField.text!) ?? 0.25,
            "lowerFreq": Double(lowerTextField.text!) ?? 0.25,
            "coreFreq": Double(coreTextField.text!) ?? 0.25
        ]){ (error) in
            if error != nil {
                print("Error saving user data.")
            }
        }
        
        performSegue(withIdentifier: "unwindSettings", sender: self)
    }
}
