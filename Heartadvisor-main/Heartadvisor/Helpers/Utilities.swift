//
//  Utilities.swift
//  Heartadvisor
//
//  Created by Tejal Patel on 1/26/21.
//

/**This file includes all styling*/

import Foundation
import UIKit

class Utilities {
    // Text field stylings
    static func styleTextField(_ textfield:UITextField, _ color: String = "white") {
        // Because constraints-based views are still in the process of beign laidout
        // at the call of didLayoutSubviews(), this function finishes the layout
        // before using .frame
        textfield.layoutIfNeeded()
        textfield.backgroundColor = .clear
        
        textfield.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        //problematic, it moves also delete button inside textfield
        textfield.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);

        // Set up border on text field
        textfield.borderStyle = .none
        if(color == "white") {
            textfield.tintColor = .white
        }
        textfield.textColor = .white
        
        textfield.layer.cornerRadius = textfield.frame.height/2
        textfield.layer.borderWidth = 2.0
        textfield.layer.borderColor = UIColor.white.cgColor
        if(color == "black") {
            textfield.layer.borderColor = UIColor.black.cgColor
            textfield.textColor = .black
        }

        textfield.font = UIFont(name: Constants.smallFont, size: CGFloat(Constants.smallFontSize))
    }
    
    static func styleFilledButton(_ button: UIButton) {
        button.titleLabel?.font = UIFont(name: Constants.largeFont, size: CGFloat(Constants.largeFontSize))
        button.titleLabel?.textColor = UIColor.black

        button.backgroundColor = UIColor.init(hexString: Constants.heartadvisor_red)
            
        // Font color
        button.tintColor = UIColor.white
        
        button.heightAnchor.constraint(equalToConstant:50).isActive = true
        button.layoutIfNeeded()
        button.layer.cornerRadius = button.frame.height/2
        
        button.contentVerticalAlignment = .fill
        
        button.imageView?.contentMode = . scaleAspectFit
        
        // Handles resizing button font size (with smaller screens)
        button.titleLabel?.numberOfLines = 1;
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
    }
    
    // Link button (hyperlink)
    static func styleLinkButton(_ button:UIButton) {
        button.titleLabel?.font = UIFont(name: Constants.largeFont, size: CGFloat(Constants.largeFontSize))
        button.tintColor = UIColor(hexString: Constants.heartadvisor_red)
        button.contentVerticalAlignment = .fill

        button.titleLabel?.numberOfLines = 1;
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
    }
    
    // Typically for headers
    static func styleHeaderLabel(_ label:UILabel) {
        label.font = UIFont(name: Constants.xlargeFont, size: CGFloat(Constants.xlargeFontSize));
        
        label.heightAnchor.constraint(equalToConstant:40).isActive = true
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }
    
    // Typically for Buttons/Sub-headers
    static func styleSubHeaderLabel(_ label:UILabel) {
        label.font = UIFont(name: Constants.largeFont, size: CGFloat(Constants.largeFontSize));
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }
    
    // Typically for paragraphs/regular text
    static func styleParagraphLabel(_ label:UILabel) {
        label.font = UIFont(name: Constants.smallFont, size: CGFloat(Constants.smallFontSize));
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0;
    }
    
    // Typically for captions/footnote
    static func styleSmallLabel(_ label:UILabel) {
        label.font = UIFont(name: Constants.xsmallFont, size: CGFloat(Constants.xsmallFontSize));
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0;
    }
}
