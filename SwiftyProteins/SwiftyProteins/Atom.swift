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
        static var fluorine : UIColor { return UIColor(red: 0, green: 255, blue: 0, alpha: 1) }
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
    var name : String
    var color : UIColor
    var number : Int
    var connections : [Int] = []
    
    init(name: String, number: Int){
        self.number = number
        switch name {
        case "H":
            self.name = "Hydrogen"
            self.color = .hydrogen
            break
        case "Li":
            self.name = "Lithium"
            self.color = .alkaliniMetals
            break
        case "Na":
            self.name = "Sodium"
            self.color = .alkaliniMetals
            break
        case "K":
            self.name = "Potassium"
            self.color = .alkaliniMetals
            break
        case "Rb":
            self.name = "Rubidium"
            self.color = .alkaliniMetals
            break
        case "Cs":
            self.name = "Caesium"
            self.color = .alkaliniMetals
            break
        case "Fr":
            self.name = "Francium"
            self.color = .alkaliniMetals
            break
        case "Be":
            self.name = "Berylium"
            self.color = .alkaliniEarthMetals
            break
        case "Mg":
            self.name = "Magnesium"
            self.color = .alkaliniEarthMetals
            break
        case "Ca":
            self.name = "Calcium"
            self.color = .alkaliniEarthMetals
            break
        case "Sr":
            self.name = "Strontium"
            self.color = .alkaliniEarthMetals
            break
        case "Ba":
            self.name = "Barium"
            self.color = .alkaliniEarthMetals
            break
        case "Ra":
            self.name = "Radium"
            self.color = .alkaliniEarthMetals
            break
        case "He":
            self.name = "Helium"
            self.color = .noblGases
            break
        case "Ne":
            self.name = "Neon"
            self.color = .noblGases
            break
        case "Ar":
            self.name = "Argon"
            self.color = .noblGases
            break
        case "Kr":
            self.name = "Krypton"
            self.color = .noblGases
            break
        case "Xe":
            self.name = "Xenon"
            self.color = .noblGases
            break
        case "Rn":
            self.name = "Radon"
            self.color = .noblGases
            break
        case "Fe":
            self.name = "Iron"
            self.color = .iron
            break
        case "I":
            self.name = "Iodine"
            self.color = .iodine
            break
        case "B":
            self.name = "Boron"
            self.color = .boron
            break
        case "Ti":
            self.name = "Titanium"
            self.color = .titanium
            break
        case "N":
            self.name = "Nitrogen"
            self.color = .nitrogen
            break
        case "C":
            self.name = "Carbon"
            self.color = .carbon
            break
        case "N":
            self.name = "Nitrogen"
            self.color = .nitrogen
            break
        case "F":
            self.name = "Fluorine"
            self.color = .fluorine
            break
        case "Cl":
            self.name = "Chlorine"
            self.color = .chlorine
            break
        case "Br":
            self.name = "Bromine"
            self.color = .bromine
            break
        case "O":
            self.name = "Oxygen"
            self.color = .oxygen
            break
        case "S":
            self.name = "Sulfur"
            self.color = .sulfure
            break
        default:
            self.name = "unknown \(name)"
            self.color = .others
        }
    }
}
