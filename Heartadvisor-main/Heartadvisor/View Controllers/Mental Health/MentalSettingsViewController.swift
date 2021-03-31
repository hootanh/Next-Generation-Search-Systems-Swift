//
//  MentalSettingsViewController.swift
//  Heartadvisor
//
//  Created by Tejal Patel on 2/18/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MentalSettingsViewController: UIViewController {

    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var paragraphLabel: UILabel!
    @IBOutlet weak var relaxParagraph: UILabel!
    @IBOutlet weak var energeticParagraph: UILabel!
    @IBOutlet weak var flowParagraph: UILabel!
    @IBOutlet weak var energyParagraph: UILabel!
    
    @IBOutlet weak var relaxNum: UITextField!
    @IBOutlet weak var energeticNum: UITextField!
    @IBOutlet weak var flowNum: UITextField!
    @IBOutlet weak var energyNum: UITextField!
    
    @IBOutlet weak var relaxStepper: UIStepper!
    @IBOutlet weak var energeticStepper: UIStepper!
    @IBOutlet weak var flowStepper: UIStepper!
    @IBOutlet weak var energyStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        
        db.collection("users").document(Auth.auth().currentUser!.uid)
            .getDocument { querySnapshot, error in
                guard let querySnapshot = querySnapshot, querySnapshot.exists else {return}
                let data = querySnapshot.data()
                
                self.relaxNum.text = String( data?["med_relax_freq"] as? Double ?? 0.25)
                self.relaxStepper.value = data?["med_relax_freq"] as? Double ?? 0.25
                self.energeticNum.text = String( data?["med_energetic_freq"]  as? Double ?? 0.25)
                self.energeticStepper.value = data?["med_energetic_freq"] as? Double ?? 0.25
                self.flowNum.text = String(data?["med_flow_freq"] as? Double ?? 0.25)
                self.flowStepper.value = data?["med_flow_freq"] as? Double ?? 0.25
                self.energyNum.text = String( data?["med_energy_freq"] as? Double ?? 0.25)
                self.energyStepper.value = data?["med_energy_freq"] as? Double ?? 0.25
        }
    }

    override func viewDidLayoutSubviews() {
        Utilities.styleSubHeaderLabel(genresLabel)
        Utilities.styleParagraphLabel(paragraphLabel)
        Utilities.styleParagraphLabel(relaxParagraph)
        Utilities.styleParagraphLabel(energeticParagraph)
        Utilities.styleParagraphLabel(flowParagraph)
        Utilities.styleParagraphLabel(energyParagraph)
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        // If addition of frequencies are greater than 1, error
        
        var sum = Double(relaxNum.text!)!
        sum += Double(energeticNum.text!)!
        sum +=  Double(flowNum.text!)!
        sum += Double(energyNum.text!)!
        
        if(sum > 1) {
            self.showError(message: "Please make sure that all frequency values are <= 1.0")
            return
        }
        
        let db = Firestore.firestore()
        
        // Store image url
        db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
            "med_relax_freq":relaxNum.text?.toDouble() ?? 0.25,
            "med_energetic_freq": energeticNum.text?.toDouble() ?? 0.25,
            "med_flow_freq": flowNum.text?.toDouble() ?? 0.25,
            "med_energy_freq": energyNum.text?.toDouble() ?? 0.25
        ]){ (error) in
            if error != nil {
                self.showError(message: "Error saving meditation settings. Please try again later.")
                print(error?.localizedDescription)
            }
        }
        
        performSegue(withIdentifier: "unwindToMeditation", sender: self)
    }
    
    @IBAction func relax_stepperValueChanged(_ sender: UIStepper) {
        relaxNum.text = String(round(1000.0 * Double(Double(sender.value).description)!) / 1000.0)
        //round(1000.0 * Double(sender.value).description) / 1000.0
    }
    @IBAction func energetic_stepperValueChanged(_ sender: UIStepper) {
        energeticNum.text = String(round(1000.0 * Double(Double(sender.value).description)!) / 1000.0)
    }
    @IBAction func flow_stepperValueChanged(_ sender: UIStepper) {
        flowNum.text = String(round(1000.0 * Double(Double(sender.value).description)!) / 1000.0)    }
    @IBAction func energy_stepperValueChanged(_ sender: UIStepper) {
        energyNum.text = String(round(1000.0 * Double(Double(sender.value).description)!) / 1000.0)
    }
    
    
}
