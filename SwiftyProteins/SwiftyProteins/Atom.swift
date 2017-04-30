//
//  Atom.swift
//  SwiftyProteins
//
//  Created by Nicolas BOULIOL on 4/30/17.
//  Copyright © 2017 Nicolas BOULIOL. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

        static var hydrogen: UIColor  { return UIColor(red: 0, green: 0, blue: 0, alpha: 1) }
        static var carbon: UIColor { return UIColor(red: 255, green: 255, blue: 255, alpha: 1) }
        static var nitrogen : UIColor { return UIColor(red: 34, green: 51, blue: 255, alpha: 1) }
        static var oxygen : UIColor { return UIColor(red: 255, green: 0, blue: 0, alpha: 1) }
        static var fluorine : UIColor { return UIColor(red: 00, green: 255, blue: 00, alpha: 1) }
        static var chlorine : UIColor { return UIColor(red: 0, green: 255, blue: 0, alpha: 1) }
        static var bromine : UIColor { return UIColor(red: 155, green: 35, blue: 0, alpha: 1) }
        static var iodine : UIColor { return UIColor(red: 102, green: 0, blue: 187, alpha: 1) }
        static var noblGases : UIColor { return .cyan }
        static var phosphorus : UIColor { return .orange }
        static var sulfure : UIColor { return .yellow }
        static var boron : UIColor { return UIColor(red: 255, green: 170, blue: 119, alpha: 1) }
        static var alkaliniMetals : UIColor { return .purple }
        static var alkaliniEarthMetals : UIColor { return UIColor(red: 0, green: 77, blue: 0, alpha: 1) }
        static var titanium : UIColor { return .gray }
        static var iron : UIColor { return UIColor(red: 221, green: 119, blue: 0, alpha: 1) }
        static var others : UIColor { return UIColor(red: 221, green: 119, blue: 255, alpha: 1) }
}



struct Atom {
    var name : String?
    var color : UIColor
    
    init(name: String){
//        self.name = name
        switch name {
        case "H":
            self.name = "Hydrogen"
            self.color = .hydrogen
            break
        case "C":
            self.name = "Carbon"
            self.color = .carbon
            break
        default:
            self.name = "unknown \(name)"
            self.color = .others
        }
    }
}
