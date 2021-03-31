//
//  MentalHealthViewController.swift
//  Heartadvisor
//
//  Created by Tejal Patel on 1/26/21.
//

import UIKit
import Kingfisher
import FirebaseStorage
import ImageSlideshow
import FirebaseAuth
import FirebaseFirestore

class meditationCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
}

class MentalHealthViewController: UIViewController {
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var relaxLabel: UILabel!
    @IBOutlet weak var energeticLabel: UILabel!
    @IBOutlet weak var flowLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    
    @IBOutlet weak var recommendedView: UICollectionView!
    @IBOutlet weak var relaxView: UICollectionView!
    @IBOutlet weak var energeticView: UICollectionView!
    @IBOutlet weak var flowView: UICollectionView!
    @IBOutlet weak var energyView: UICollectionView!
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    var recommendedTitles = [String]()
    let relaxTitles = ["Relaxed Body Relaxed Mind", "Blissful Deep Relaxation", "Let Go & Relax", "10-Minute Meditation For Anxiety", "Sleep Hypnosis for Floating Relaxation"]
    let energeticTitles = ["10 Minute Guided Meditation","Power Check-In [Mindfulness Meditation]", "Positive Energy", "15 Minute Guided Meditation","Chakra Balance"]
    let flowTitles = ["Above & Beyond","Getting into the Flow","Get Into the Flow and Focus", "Guided Visual Meditation", "Arrive"]
    let energyTitles = ["Healing Light", "Soul Energy Alignment","Experience the Pure Loving Energy of the Universe", "Energy Healing", "Reiki Meditation"]
    
    var recommendedImgs = [String]()
    let relaxImgs = ["mentalHealth/Relax/relax1.jpg", "mentalHealth/Relax/relax2.jpg", "mentalHealth/Relax/relax3.jpg", "mentalHealth/Relax/relax4.jpg", "mentalHealth/Relax/relax5.jpg"]
    let energeticImgs = ["mentalHealth/Energetic/energetic1.jpg","mentalHealth/Energetic/energetic2.jpg","mentalHealth/Energetic/energetic3.jpg","mentalHealth/Energetic/energetic4.jpg","mentalHealth/Energetic/energetic5.jpg"]
    let flowImgs = ["mentalHealth/Flow/flow1.jpg","mentalHealth/Flow/flow2.jpg","mentalHealth/Flow/flow3.jpg","mentalHealth/Flow/flow4.jpg","mentalHealth/Flow/flow5.jpg"]
    let energyImgs = ["mentalHealth/Energy_Healing/energy1.jpg","mentalHealth/Energy_Healing/energy2.jpg","mentalHealth/Energy_Healing/energy3.jpg","mentalHealth/Energy_Healing/energy4.jpg","mentalHealth/Energy_Healing/energy5.jpg"]
    
    var relaxFreq = 0.0
    var energeticFreq = 0.0
    var flowFreq = 0.0
    var energyFreq = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarSetup()
        
        getFreq()
        
        recommendedView.dataSource = self
        recommendedView.delegate = self
        
        relaxView.dataSource = self
        relaxView.delegate = self
        
        energeticView.dataSource = self
        energeticView.delegate = self
        
        flowView.dataSource = self
        flowView.delegate = self
        
        energyView.dataSource = self
        energyView.delegate = self
        
        // Setting up image slideshow
        slideshow.setImageInputs([
            ImageSource(image: UIImage(named: "meditation-quotes-1")!),
            ImageSource(image: UIImage(named: "meditation-quotes-2")!),
            ImageSource(image: UIImage(named: "meditation-quotes-3")!),
            ImageSource(image: UIImage(named: "meditation-quotes-4")!),
            ImageSource(image: UIImage(named: "meditation-quotes-5")!)
        ])
        slideshow.slideshowInterval = 4
        
        // Set up settings bar button
    }
    
    override func viewDidLayoutSubviews() {
        Utilities.styleSubHeaderLabel(recommendedLabel)
        Utilities.styleSubHeaderLabel(relaxLabel)
        Utilities.styleSubHeaderLabel(energyLabel)
        Utilities.styleSubHeaderLabel(energeticLabel)
        Utilities.styleSubHeaderLabel(flowLabel)
    }
    
    func getFreq() {
        //Setup Recommendations
        
        recommendedImgs.removeAll()
        recommendedTitles.removeAll()
        
        let db = Firestore.firestore()
        
        db.collection("users").document(Auth.auth().currentUser!.uid)
            .getDocument { querySnapshot, error in
                guard let querySnapshot = querySnapshot, querySnapshot.exists else {return}
                let data = querySnapshot.data()
                
                self.relaxFreq = data?["med_relax_freq"] as? Double ?? 0.25
                self.energeticFreq = data?["med_energetic_freq"]  as? Double ?? 0.25
                self.flowFreq = data?["med_flow_freq"] as? Double ?? 0.25
                self.energyFreq = data?["med_energy_freq"] as? Double ?? 0.25
                
                self.setRecommendedView()
        }
    }
    
    func setRecommendedView() {
        //Randomly select from titles based on freq of items
        //If not already in recommended, add to recommended
        //Continue until size is 5
        let relaxArray = Array(repeating: "relax", count: Int(relaxFreq*100))
        let energeticArray = Array(repeating: "energetic", count: Int(energeticFreq*100))
        let flowArray = Array(repeating: "flow", count: Int(flowFreq*100))
        let energyArray = Array(repeating: "energy", count: Int(energyFreq*100))
        
        let randomArray = relaxArray+energeticArray+flowArray+energyArray
        
        print(randomArray)
        
        while(recommendedTitles.count != 5) {
            let type = randomArray.randomElement()
            if (type == "relax") {
                var title = relaxTitles.randomElement()
                while(recommendedTitles.contains(title!)) {
                    title = relaxTitles.randomElement()
                }
                recommendedTitles.append(title!)
                recommendedImgs.append(relaxImgs[relaxTitles.firstIndex(of: title!)!])
            }
            if (type == "energetic") {
                var title = energeticTitles.randomElement()
                while(recommendedTitles.contains(title!)) {
                    title = energeticTitles.randomElement()
                }
                recommendedTitles.append(title!)
                recommendedImgs.append(energeticImgs[energeticTitles.firstIndex(of: title!)!])
            }
            if (type == "flow") {
                var title = flowTitles.randomElement()
                while(recommendedTitles.contains(title!)) {
                    title = flowTitles.randomElement()
                }
                recommendedTitles.append(title!)
                recommendedImgs.append(flowImgs[flowTitles.firstIndex(of: title!)!])
            }
            if (type == "energy") {
                var title = energyTitles.randomElement()
                while(recommendedTitles.contains(title!)) {
                    title = energyTitles.randomElement()
                }
                recommendedTitles.append(title!)
                recommendedImgs.append(energyImgs[energyTitles.firstIndex(of: title!)!])
            }
        }
        print(recommendedTitles)
        print(recommendedImgs)
        recommendedView.reloadData()
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        getFreq()
    }

}

extension MentalHealthViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "medCell", for: indexPath) as? meditationCell
        
        Utilities.styleParagraphLabel((cell?.title)!)
        
        var imageString = ""
        
        if(collectionView == recommendedView) {
            if(recommendedTitles.count > 0) {
                cell?.title.text = recommendedTitles[indexPath.row]
                imageString = recommendedImgs[indexPath.row]
            }
        }
        else if (collectionView == relaxView) {
            cell?.title.text = relaxTitles[indexPath.row]
            imageString = relaxImgs[indexPath.row]
        }
        else if (collectionView == energeticView) {
            cell?.title.text = energeticTitles[indexPath.row]
            imageString = energeticImgs[indexPath.row]
        }
        else if (collectionView == flowView) {
            cell?.title.text = flowTitles[indexPath.row]
            imageString = flowImgs[indexPath.row]
        }
        else if (collectionView == energyView) {
            cell?.title.text = energyTitles[indexPath.row]
            imageString = energyImgs[indexPath.row]
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
            vc.name = recommendedImgs[indexPath.row];
        }
        else if (collectionView == relaxView) {
            vc.name = relaxImgs[indexPath.row];
        }
        else if (collectionView == energeticView) {
            vc.name = energeticImgs[indexPath.row];
        }
        else if (collectionView == flowView) {
            vc.name = flowImgs[indexPath.row];
        }
        else if (collectionView == energyView) {
            vc.name = energyImgs[indexPath.row];
        }
        
        vc.name = String(vc.name.dropLast(3)) + "mp4"

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
