import UIKit

class SleepViewController: UIViewController {
    

    @IBOutlet weak var topQ: UILabel!
    @IBOutlet weak var missingSleepLable: UILabel!
    @IBOutlet weak var missingSleepOut: UILabel!
    @IBOutlet weak var recommendSleepLable: UILabel!
    @IBOutlet weak var recommendSleepOut: UILabel!
    @IBOutlet weak var recommendWakeLable: UILabel!
    @IBOutlet weak var recommendWakeOut: UILabel!
    @IBOutlet weak var preferredWakeWeek: UILabel!
    @IBOutlet weak var preferredWakeWeekOut: UILabel!
    @IBOutlet weak var preferredSleepWeek: UILabel!
    @IBOutlet weak var preferredSleepWeekOut: UILabel!
    @IBOutlet weak var enterWakeLable: UILabel!
    @IBOutlet weak var enterWakeHourIn: UITextField!
    @IBOutlet weak var enterWakeDot: UILabel!
    @IBOutlet weak var enterWakeMinIn: UITextField!
    @IBOutlet weak var enterSleepLable: UILabel!
    @IBOutlet weak var enterSleepHourIn: UITextField!
    @IBOutlet weak var enterSleepDot: UILabel!
    @IBOutlet weak var enterSleepMinIn: UITextField!
    var wakeTimesWeek: [Int] = []
    var sleepTimesWeek: [Int] = []
 
    
    @IBOutlet weak var OverSleepLable: UILabel!
    @IBOutlet weak var OverSleepOut: UILabel!
    
    
     @objc func enterWakeHourInDidChange(_ textField: UITextField) {
        if enterWakeHourIn.text != "" && enterWakeMinIn.text != "" && enterSleepHourIn.text != "" && enterSleepMinIn.text != "" {
            missingRecommendSleepTime()
        }
     }
     
     @objc func enterWakeMinInDidChange(_ textField: UITextField) {
        if enterWakeHourIn.text != "" && enterWakeMinIn.text != "" && enterSleepHourIn.text != "" && enterSleepMinIn.text != "" {
            missingRecommendSleepTime()
        }
     }
     
     @objc func enterSleepHourInDidChange(_ textField: UITextField) {
        if enterWakeHourIn.text != "" && enterWakeMinIn.text != "" && enterSleepHourIn.text != "" && enterSleepMinIn.text != "" {
            missingRecommendSleepTime()
        }
     }
     
     @objc func enterSleepMinInDidChange(_ textField: UITextField) {
        if enterWakeHourIn.text != "" && enterWakeMinIn.text != "" && enterSleepHourIn.text != "" && enterSleepMinIn.text != "" {
            missingRecommendSleepTime()
        }
     }
     
    
    
    @IBOutlet weak var my_image: UIImageView!
    
    
    //collectionView
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    
    @IBOutlet weak var pageView: UIPageControl!
    
    //array of images for collectionView
    var imgArr = [UIImage(named: "clock zz"),
                  UIImage(named: "xs")]
    
     override func viewDidLoad() {
         super.viewDidLoad()

         my_image.image = UIImage(named: "clock zz")
        
         navigationBarSetup()
         
         enterWakeHourIn.addTarget(self, action: #selector(SleepViewController.enterWakeHourInDidChange(_:)), for: .editingChanged)
         
         enterWakeMinIn.addTarget(self, action: #selector(SleepViewController.enterWakeMinInDidChange(_:)), for: .editingChanged)
         
         enterSleepHourIn.addTarget(self, action: #selector(SleepViewController.enterSleepHourInDidChange(_:)), for: .editingChanged)
         
         enterSleepMinIn.addTarget(self, action: #selector(SleepViewController.enterSleepMinInDidChange(_:)), for: .editingChanged)

     }

    
    func missingRecommendSleepTime() {
        
        //calculating missing hours of last night sleep / calculating recommended wake up and sleep time
        //calculating preferred wake up and sleep time based on the collected user data
        var missingSleep: Int = 0
        var overSleep: Int = 0
        var wakeHourMiss: Int = 0
        var sleepHourMiss: Int = 0
        var aveWakeWeek: Int = 0
        var aveSleepWeek: Int = 0
        wakeHourMiss = Int(enterSleepHourIn.text!) ?? 0
        sleepHourMiss = Int(enterWakeHourIn.text!) ?? 0
        var s: Int = sleepHourMiss
        let w: Int = wakeHourMiss
        
        if (Int(enterWakeMinIn.text!) ?? 0) >= 30 {
            wakeHourMiss += 1
        }
        
        if (Int(enterSleepMinIn.text!) ?? 0) >= 30 {
            sleepHourMiss += 1
        }
        
                 
        //if s >= 0  && s <= 12 && sleepTimesWeek.count != 0 {
         //   s += 24
        //}
   
        
        wakeTimesWeek.append(w)
        sleepTimesWeek.append(s)
        
        aveWakeWeek = Int(ceil(Double((wakeTimesWeek.reduce(0, +))/(wakeTimesWeek.count))))
        aveSleepWeek = Int(ceil(Double((sleepTimesWeek.reduce(0, +))/(sleepTimesWeek.count))))
        
        if aveSleepWeek == 24 {
            aveSleepWeek = 00
        }
        
        //preferredWakeWeekOut.text = "Based on recorded data:    " + String(aveWakeWeek) + " : 00"
       // preferredSleepWeekOut.text = "Based on recorded data:    " + String(aveSleepWeek) + " : 00"
        
        
        
        missingSleep = wakeHourMiss - sleepHourMiss
        
        if missingSleep < 0 {
            missingSleep += 24
        }
        
        if missingSleep == 9 {
            missingSleep = 0
            overSleep = 0
        }
        else if missingSleep > 9 {
            overSleep = missingSleep - 9
            missingSleep = 0
            if overSleep == 1 {
                sleepHourMiss += 1
                if sleepHourMiss == 24 {
                    sleepHourMiss = 0
                }
            }
            else {
                wakeHourMiss = wakeHourMiss - Int(floor(Double(overSleep)/2))
                sleepHourMiss = sleepHourMiss + Int(ceil(Double(overSleep)/2))
                if wakeHourMiss == 24 {
                    wakeHourMiss = 0
                }
                if sleepHourMiss == 24 {
                    sleepHourMiss = 0
                }
                if 3 <= sleepHourMiss && sleepHourMiss > 0 {
                    sleepHourMiss -= 2
                    wakeHourMiss -= 2
                    if sleepHourMiss < 0 {
                        sleepHourMiss += 24
                    }
                }
            }
        }
        else {
            overSleep = 0
            missingSleep = 9 - missingSleep
            if missingSleep == 1 {
                sleepHourMiss -= 1
            }
            else {
                wakeHourMiss = wakeHourMiss + Int(floor(Double(missingSleep)/2))
                sleepHourMiss = sleepHourMiss - Int(ceil(Double(missingSleep)/2))
            }
        }
        
        missingSleepOut.text = String(missingSleep) + "    Hours"
        
        OverSleepOut.text = String(overSleep) + "    Hours"
        
        if sleepHourMiss < 0 {
            sleepHourMiss += 24
        }
        
        recommendWakeOut.text = String(wakeHourMiss) + " : 00"
        recommendSleepOut.text = String(sleepHourMiss) + " : 00"
        
        //testing preferred times to match the user input
        //preferredWakeWeekOut.text = "Based on recorded data:    " + String(wakeHourMiss) + " : 00"
        //preferredSleepWeekOut.text = "Based on recorded data:    " + String(sleepHourMiss) + " : 00"
        
        
        //testing preferred times to add to the database for the user and computing the average of it
        if wakeTimesWeek.count == 7 && sleepTimesWeek.count == 7 {
            aveWakeWeek = (wakeTimesWeek.reduce(0, +))/7
            aveSleepWeek = (sleepTimesWeek.reduce(0, +))/7
            //preferredWakeWeekOut.text = "Based on recorded data:    " + String(aveWakeWeek) + " : 00"
            //preferredSleepWeekOut.text = "Based on recorded data:    " + String(aveSleepWeek) + " : 00"
            wakeTimesWeek = []
            sleepTimesWeek = []
        }
        else {
            aveWakeWeek = Int(ceil(Double((wakeTimesWeek.reduce(0, +))/(wakeTimesWeek.count))))
            aveSleepWeek = Int(floor(Double((sleepTimesWeek.reduce(0, +))/(sleepTimesWeek.count))))
            //preferredWakeWeekOut.text = "Based on recorded data:    " + String(aveWakeWeek) + " : 00"
            //preferredSleepWeekOut.text = "Based on recorded data:    " + String(aveSleepWeek) + " : 00"
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        Utilities.styleSubHeaderLabel(topQ)
        Utilities.styleSubHeaderLabel(missingSleepLable)
        Utilities.styleSubHeaderLabel(missingSleepOut)
        Utilities.styleSubHeaderLabel(recommendSleepLable)
        Utilities.styleSubHeaderLabel(recommendSleepOut)
        Utilities.styleSubHeaderLabel(recommendWakeLable)
        Utilities.styleSubHeaderLabel(recommendWakeOut)
        Utilities.styleSubHeaderLabel(enterWakeLable)
        Utilities.styleSubHeaderLabel(enterWakeDot)
        Utilities.styleSubHeaderLabel(enterSleepLable)
        Utilities.styleSubHeaderLabel(enterSleepDot)
        //Utilities.styleSubHeaderLabel(preferredWakeWeek)
        //Utilities.styleSubHeaderLabel(preferredWakeWeekOut)
        //Utilities.styleSubHeaderLabel(preferredSleepWeek)
        //Utilities.styleSubHeaderLabel(preferredSleepWeekOut)
        Utilities.styleSubHeaderLabel(OverSleepLable)
        Utilities.styleSubHeaderLabel(OverSleepOut)
    }

    
}


extension SleepViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.image = imgArr[indexPath.row]
        } else if let ab = cell.viewWithTag(222) as? UIPageControl {
            ab.currentPage = indexPath.row
        }
        return cell
    }
}


extension SleepViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
}
