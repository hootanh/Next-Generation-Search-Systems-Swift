//
//  Extensions.swift
//  Heartadvisor
//
//  Created by Tejal Patel on 1/26/21.
//

import Foundation
import UIKit
import SideMenu

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
     }
}

extension UIViewController {
    func navigationBarSetup() {
        //Set title
        let label = UILabel()
        label.text = "Heartadvisor"
        let title = UIBarButtonItem(customView: label)
        navigationItem.leftItemsSupplementBackButton = true
        
        //Set sidemenu bar button
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .done, target: self, action: #selector(sideMenuTapped))
        
        navigationItem.leftBarButtonItems = [menuButton, title]

    }
    
    @objc func sideMenuTapped() {
        let menu = storyboard!.instantiateViewController(withIdentifier: "LeftMenu") as! SideMenuNavigationController
        
        present(menu, animated: true, completion: nil)
    }
    
    func showError(message: String, title: String = "HeartAdvisor") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
