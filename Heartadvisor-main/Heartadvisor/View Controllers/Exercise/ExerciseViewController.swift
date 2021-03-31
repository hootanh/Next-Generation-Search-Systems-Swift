//
//  ExerciseViewController.swift
//  Heartadvisor
//
//  Created by Andrew Tsui on 1/26/21.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import Kingfisher

class exerciseCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
}

class ExerciseViewController: UIViewController {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser!.uid
    
    var weeklyGoal: String = ""
    var currentProgress: String = ""
    var hasEquipment: Bool = false
    var coreFreq = 0.0
    var lowerFreq = 0.0
    var upperFreq = 0.0
    var newFreq = 0.0
        
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var lowerLabel: UILabel!
    @IBOutlet weak var coreLabel: UILabel!
    @IBOutlet weak var weeklyProgressLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var recommendedView: UICollectionView!
    @IBOutlet weak var newView: UICollectionView!
    @IBOutlet weak var upperView: UICollectionView!
    @IBOutlet weak var lowerView: UICollectionView!
    @IBOutlet weak var coreView: UICollectionView!
    @IBOutlet weak var progressView: UIProgressView!

    var recommendedTitles = ["", "", "", "", ""]
    let newTitles = ["15 Min TikTok Dance Party Workout (No Equipment)","30 Min Cardio Kickboxing Workout (No Equipment)", "20 Min Zumba Workout (No Equipment)", "30 Min At Home Pilates Workout"]
    let upperTitles = ["20 Min Dumbbell Only Total Upper Body","10 Min Full Upper Body Workout Routine Using Dumbbells Only", "20 Min Intense At Home Upper Body Workout (No Equipment)", "15 Minute Upper Body Workout (No Equipment)", "20 Minute Upper Body Dumbbell Workout", "30 Minute Upper Body Workout (No Equipment)"]
    let lowerTitles = ["15 Min At Home Leg/Butt/Thigh Workout (No Equipment)","15 Min Toned Legs & Round Booty Workout With Dumbbells", "30 Min No Repeat Leg Workout With Dumbbells", "20 Min Lower Body Workout (No Equipment)", "30 Min Killer Lower Body HIIT Workout (No Equipment)", "20 Min Lower Body Workout With Dumbbells"]
    let coreTitles = ["10 Min Bodyweight Ab Workout (No Equipment)","15 Min Dumbbell Abs Workout", "20 Min Total Core/Ab Workout (No Equipment)", "12 Min Best Dumbbell Exercises for Abs", "30 Min Core Workout (No Equipment)"]
    
    var recommendedImgs = ["", "", "", "", ""]
    let newImgs = ["exercise/newWorkouts/newworkout_noequip1.jpg", "exercise/newWorkouts/newworkout_noequip2.jpg", "exercise/newWorkouts/newworkout_noequip3.jpg", "exercise/newWorkouts/newworkout4.jpg"]
    let upperImgs = ["exercise/upperBody/yesEquip/upperbody_yesequip1.jpg", "exercise/upperBody/yesEquip/upperbody_yesequip2.jpg", "exercise/upperBody/noEquip/upperbody_noequip1.jpg", "exercise/upperBody/noEquip/upperbody_noequip2.jpg", "exercise/upperBody/yesEquip/upperbody_yesequip3.jpg", "exercise/upperBody/noEquip/upperbody_noequip3.jpg"]
    let lowerImgs = ["exercise/lowerBody/noEquip/lowerbody_noequip1.jpg", "exercise/lowerBody/yesEquip/lowerbody_yesequip1.jpg", "exercise/lowerBody/yesEquip/lowerbody_yesequip2.jpg", "exercise/lowerBody/noEquip/lowerbody_noequip2.jpg", "exercise/lowerBody/noEquip/lowerbody_noequip3.jpg", "exercise/lowerBody/yesEquip/lowerbody_yesequip3.jpg"]
    let coreImgs = ["exercise/core/noEquip/core_noequip1.jpg", "exercise/core/yesEquip/core_yesequip1.jpg", "exercise/core/noEquip/core_noequip2.jpg", "exercise/core/yesEquip/core_yesequip2.jpg", "exercise/core/noEquip/core_noequip3.jpg",""]
    
    @IBAction func unwindFromAddProgress(sender: UIStoryboardSegue) {
        db.collection("users").document(user).getDocument { (document, error) in
            if let document = document, document.exists {
                self.currentProgress = document.get("currentExerciseProgress") as! String
                
                self.progressLabel.text = String(self.currentProgress) + " / " + String(self.weeklyGoal) + " minutes"
                self.progressView.setProgress(Float(self.currentProgress)!/Float(self.weeklyGoal)!, animated: true)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func unwindFromSaveChanges(sender: UIStoryboardSegue) {
        db.collection("users").document(user).getDocument { (document, error) in
            if let document = document, document.exists {
                self.weeklyGoal = document.get("weeklyExerciseGoal") as! String
                self.currentProgress = document.get("currentExerciseProgress") as! String
                
                self.progressLabel.text = String(self.currentProgress) + " / " + String(self.weeklyGoal) + " minutes"
                self.progressView.setProgress(Float(self.currentProgress)!/Float(self.weeklyGoal)!, animated: true)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func unwindFromSettings(sender: UIStoryboardSegue) {
        
        db.collection("users").document(user).getDocument { (document, error) in
            if let document = document, document.exists {
                self.hasEquipment = document.get("hasEquipment") as! Bool
            
                self.newView.reloadData()
                self.upperView.reloadData()
                self.lowerView.reloadData()
                self.coreView.reloadData()
                
                self.createRecommendedView()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetup()
        
        recommendedView.dataSource = self
        recommendedView.delegate = self
        
        newView.dataSource = self
        newView.delegate = self
        
        upperView.dataSource = self
        upperView.delegate = self
        
        lowerView.dataSource = self
        lowerView.delegate = self
        
        coreView.dataSource = self
        coreView.delegate = self
    
        db.collection("users").document(user).getDocument { (document, error) in
            if let document = document, document.exists {
                self.weeklyGoal = document.get("weeklyExerciseGoal") as! String
                self.currentProgress = document.get("currentExerciseProgress") as! String
                self.hasEquipment = document.get("hasEquipment") as! Bool
                
                self.progressLabel.text = String(self.currentProgress) + " / " + String(self.weeklyGoal) + " minutes"
                self.progressView.setProgress(Float(self.currentProgress)!/Float(self.weeklyGoal)!, animated: true)
                
                self.newView.reloadData()
                self.upperView.reloadData()
                self.lowerView.reloadData()
                self.coreView.reloadData()
                self.createRecommendedView()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        Utilities.styleSubHeaderLabel(recommendedLabel)
        Utilities.styleSubHeaderLabel(newLabel)
        Utilities.styleSubHeaderLabel(upperLabel)
        Utilities.styleSubHeaderLabel(lowerLabel)
        Utilities.styleSubHeaderLabel(coreLabel)
        Utilities.styleSubHeaderLabel(weeklyProgressLabel)
        Utilities.styleParagraphLabel(progressLabel)
    }
    
    func createRecommendedView() {
        recommendedImgs.removeAll()
        recommendedTitles.removeAll()
        
        let db = Firestore.firestore()
        
        db.collection("users").document(user)
            .getDocument { querySnapshot, error in
                guard let querySnapshot = querySnapshot, querySnapshot.exists else {return}
                let data = querySnapshot.data()
                
                self.coreFreq = data?["coreFreq"] as? Double ?? 0.25
                self.lowerFreq = data?["lowerFreq"]  as? Double ?? 0.25
                self.upperFreq = data?["upperFreq"] as? Double ?? 0.25
                self.newFreq = data?["newFreq"] as? Double ?? 0.25
                
                self.setRecommendedView()
        }
    }
    
    func setRecommendedView() {
        //Randomly select from titles based on freq of items
        //If not already in recommended, add to recommended
        //Continue until size is 5
        let recSize = newFreq == 1.0 ? 3 : 5
        
        let upper = Array(repeating: "upper", count: Int(upperFreq*100))
        let lower = Array(repeating: "lower", count: Int(lowerFreq*100))
        let core = Array(repeating: "core", count: Int(coreFreq*100))
        let new = Array(repeating: "new", count: Int(newFreq*100))
        
        let randomArray = upper + lower + core + new
            
        while(recommendedTitles.count != recSize) {
            let type = randomArray.randomElement()
            if (type == "upper") {
                if(hasEquipment == true) {
                    var title = upperTitles.randomElement()
                    while(recommendedTitles.contains(title!)) {
                        title = upperTitles.randomElement()
                    }
                    recommendedTitles.append(title!)
                    recommendedImgs.append(upperImgs[upperTitles.firstIndex(of: title!)!])
                }
                else {
                    let filteredTitles = upperTitles.filter { $0.contains("(No Equipment)") }
                    let filteredImgs = upperImgs.filter {$0.contains("noequip")}
                    var title = filteredTitles.randomElement()
                    while(recommendedTitles.contains(title!)) {
                        title = filteredTitles.randomElement()
                    }
                    recommendedTitles.append(title!)
                    recommendedImgs.append(filteredImgs[filteredTitles.firstIndex(of: title!)!])
                }
            }
            if (type == "lower") {
                if(hasEquipment == true) {
                    var title = lowerTitles.randomElement()
                    while(recommendedTitles.contains(title!)) {
                        title = lowerTitles.randomElement()
                    }
                    recommendedTitles.append(title!)
                    recommendedImgs.append(lowerImgs[lowerTitles.firstIndex(of: title!)!])
                }
                else {
                    let filteredTitles = lowerTitles.filter { $0.contains("(No Equipment)") }
                    let filteredImgs = lowerImgs.filter {$0.contains("noequip")}
                    var title = filteredTitles.randomElement()
                    while(recommendedTitles.contains(title!)) {
                        title = filteredTitles.randomElement()
                    }
                    recommendedTitles.append(title!)
                    recommendedImgs.append(filteredImgs[filteredTitles.firstIndex(of: title!)!])
                }
            }
            if (type == "new") {
                if(hasEquipment == true) {
                    var title = newTitles.randomElement()
                    while(recommendedTitles.contains(title!)) {
                        title = newTitles.randomElement()
                    }
                    recommendedTitles.append(title!)
                    recommendedImgs.append(newImgs[newTitles.firstIndex(of: title!)!])
                }
                else {
                    let filteredTitles = newTitles.filter { $0.contains("(No Equipment)") }
                    let filteredImgs = newImgs.filter {$0.contains("noequip")}
                    var title = filteredTitles.randomElement()
                    while(recommendedTitles.contains(title!)) {
                        title = filteredTitles.randomElement()
                    }
                    recommendedTitles.append(title!)
                    recommendedImgs.append(filteredImgs[filteredTitles.firstIndex(of: title!)!])
                }
            }
            if (type == "core") {
                if(hasEquipment == true) {
                    var title = coreTitles.randomElement()
                    while(recommendedTitles.contains(title!)) {
                        title = coreTitles.randomElement()
                    }
                    recommendedTitles.append(title!)
                    recommendedImgs.append(coreImgs[coreTitles.firstIndex(of: title!)!])
                }
                else {
                    let filteredTitles = coreTitles.filter { $0.contains("(No Equipment)") }
                    let filteredImgs = coreImgs.filter {$0.contains("noequip")}
                    var title = filteredTitles.randomElement()
                    while(recommendedTitles.contains(title!)) {
                        title = filteredTitles.randomElement()
                    }
                    recommendedTitles.append(title!)
                    recommendedImgs.append(filteredImgs[filteredTitles.firstIndex(of: title!)!])
                }
            }
        }
        recommendedView.reloadData()
    }
}

extension ExerciseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == coreView) {
            if(self.hasEquipment == true) {
                return coreTitles.count
            }
            else {
                let filtered = coreTitles.filter { $0.contains("(No Equipment)") }
                return filtered.count
            }
        }
        else if(collectionView == newView) {
            if(self.hasEquipment == true) {
                return newTitles.count
            }
            else {
                let filtered = newTitles.filter { $0.contains("(No Equipment)") }
                return filtered.count
            }
        }
        else if(collectionView == upperView) {
            if(self.hasEquipment == true) {
                return upperTitles.count
            }
            else {
                let filtered = upperTitles.filter { $0.contains("(No Equipment)") }
                return filtered.count
            }
        }
        else if(collectionView == lowerView) {
            if(self.hasEquipment == true) {
                return lowerTitles.count
            }
            else {
                let filtered = lowerTitles.filter { $0.contains("(No Equipment)") }
                return filtered.count
            }
        }
        return recommendedTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exeCell", for: indexPath) as? exerciseCell
                
        Utilities.styleParagraphLabel((cell?.title)!)
                
        var imageString = ""
        
        if(collectionView == recommendedView) {
            if(recommendedTitles.count > 0) {
                cell?.title.text = recommendedTitles[indexPath.row]
                imageString = recommendedImgs[indexPath.row]
            }
        }
        else if(collectionView == newView) {
            if(self.hasEquipment == true) {
                cell?.title.text = newTitles[indexPath.row]
                imageString = newImgs[indexPath.row]
            }
            else {
                let filteredTitles = newTitles.filter { $0.contains("(No Equipment)") }
                let filteredImgs = newImgs.filter{ $0.contains("noequip")}
                cell?.title.text = filteredTitles[indexPath.row]
                imageString = filteredImgs[indexPath.row]
            }
        }
        else if(collectionView == upperView) {
            if(self.hasEquipment == true) {
                cell?.title.text = upperTitles[indexPath.row]
                imageString = upperImgs[indexPath.row]
            }
            else {
                let filteredTitles = upperTitles.filter { $0.contains("(No Equipment)") }
                let filteredImgs = upperImgs.filter{ $0.contains("noequip")}
                cell?.title.text = filteredTitles[indexPath.row]
                imageString = filteredImgs[indexPath.row]
            }
        }
        else if(collectionView == lowerView) {
            if(self.hasEquipment == true) {
                cell?.title.text = lowerTitles[indexPath.row]
                imageString = lowerImgs[indexPath.row]
            }
            else {
                let filteredTitles = lowerTitles.filter { $0.contains("(No Equipment)") }
                let filteredImgs = lowerImgs.filter{ $0.contains("noequip")}
                cell?.title.text = filteredTitles[indexPath.row]
                imageString = filteredImgs[indexPath.row]
            }
        }
        else if(collectionView == coreView) {
            if(self.hasEquipment == true) {
                cell?.title.text = coreTitles[indexPath.row]
                imageString = coreImgs[indexPath.row]
            }
            else {
                let filteredTitles = coreTitles.filter { $0.contains("(No Equipment)") }
                let filteredImgs = coreImgs.filter{ $0.contains("noequip")}
                cell?.title.text = filteredTitles[indexPath.row]
                imageString = filteredImgs[indexPath.row]
            }
        }


        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child(imageString)

        // Fetch the download URL
        imageRef.downloadURL { url, error in
            if let error = error {
                // Handle any errors
                print(error)
            } else {
                cell?.img.kf.indicatorType = .activity
                cell?.img.kf.setImage(with: url)
            }
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = storyboard!.instantiateViewController(withIdentifier: "player") as! PlayerViewController
            
            if(collectionView == recommendedView) {
                if(self.hasEquipment == true) {
                    vc.name = recommendedImgs[indexPath.row];
                }
                else {
                    let filtered = recommendedImgs.filter { $0.contains("noequip") }
                    vc.name = filtered[indexPath.row];
                }
            }
            else if (collectionView == newView) {
                if(self.hasEquipment == true) {
                    vc.name = newImgs[indexPath.row];
                }
                else {
                    let filtered = newImgs.filter { $0.contains("noequip") }
                    vc.name = filtered[indexPath.row];
                }
            }
            else if (collectionView == upperView) {
                if(self.hasEquipment == true) {
                    vc.name = upperImgs[indexPath.row];
                }
                else {
                    let filtered = upperImgs.filter { $0.contains("noequip") }
                    vc.name = filtered[indexPath.row];
                }
            }
            else if (collectionView == lowerView) {
                if(self.hasEquipment == true) {
                    vc.name = lowerImgs[indexPath.row];
                }
                else {
                    let filtered = lowerImgs.filter { $0.contains("noequip") }
                    vc.name = filtered[indexPath.row];
                }
            }
            else if (collectionView == coreView) {
                if(self.hasEquipment == true) {
                    vc.name = coreImgs[indexPath.row];
                }
                else {
                    let filtered = coreImgs.filter { $0.contains("noequip") }
                    vc.name = filtered[indexPath.row];
                }
            }
            
            vc.name = String(vc.name.dropLast(3)) + "mp4"

            self.navigationController?.pushViewController(vc, animated: true)
        }
}
