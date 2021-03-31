//
//  ExerciseProgressSettingsViewController.swift
//  Heartadvisor
//
//  Created by Andrew Tsui on 2/10/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ExerciseProgressSettingsViewController: UIViewController {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var newWeeklyGoalTextField: UITextField!
    @IBOutlet weak var newCurrentProgressTextField: UITextField!
    @IBOutlet weak var addedProgressTextField: UITextField!
    
    @IBOutlet weak var currentWeeklyGoalLabel: UILabel!
    @IBOutlet weak var currentProgressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db.collection("users").document(user).getDocument { (document, error) in
            if let document = document, document.exists {
                self.currentWeeklyGoalLabel.text = document.get("weeklyExerciseGoal") as? String
                self.currentProgressLabel.text = document.get("currentExerciseProgress") as? String
    
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        
        let weeklyGoal = newWeeklyGoalTextField!.text == "" ? currentWeeklyGoalLabel!.text : newWeeklyGoalTextField!.text
        let currentProgress = newCurrentProgressTextField!.text == "" ? currentProgressLabel!.text : newCurrentProgressTextField!.text
            
        
        db.collection("users").document(user).updateData([
            "weeklyExerciseGoal": weeklyGoal!,
            "currentExerciseProgress": currentProgress!
        ]){ (error) in
            if error != nil {
                print("Error saving user data.")
            }
        }

        performSegue(withIdentifier: "unwindSaveChanges", sender: self)
    }
    
    @IBAction func addProgress(_ sender: Any) {
    
        var newProgress = ""
        if(addedProgressTextField.text == "") {
            newProgress = currentProgressLabel.text!
        }
        else {
            let sum = Int(currentProgressLabel.text!)! + Int(addedProgressTextField.text!)!
            newProgress = String(sum)
        }
        
        db.collection("users").document(user).updateData([
            "currentExerciseProgress": newProgress
        ]){ (error) in
            if error != nil {
                print("Error saving user data.")
            }
        }

        performSegue(withIdentifier: "unwindAddProgress", sender: self)
    }
}
