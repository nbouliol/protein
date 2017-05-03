//
//  Atom.swift
//  SwiftyProteins
//
//  Created by Nicolas BOULIOL on 4/30/17.
//  Copyright © 2017 Nicolas BOULIOL. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {

        static var hydrogen: UIColor  { return .white }
        static var carbon: UIColor { return .black }
        static var nitrogen : UIColor { return .blue }
        static var oxygen : UIColor { return UIColor(red: 255/255, green: 0, blue: 0, alpha: 1) }
        static var fluorine : UIColor { return UIColor(red: 0, green: 255/255, blue: 0, alpha: 1) }
        static var chlorine : UIColor { return UIColor(red: 0, green: 255/255, blue: 0, alpha: 1) }
        static var bromine : UIColor { return UIColor(red: 155/255, green: 35/255, blue: 0, alpha: 1) }
        static var iodine : UIColor { return UIColor(red: 102/255, green: 0, blue: 187/255, alpha: 1) }
        static var noblGases : UIColor { return .cyan }
        static var phosphorus : UIColor { return .orange }
        static var sulfure : UIColor { return .yellow }
        static var boron : UIColor { return UIColor(red: 255/255, green: 170/255, blue: 119/255, alpha: 1) }
        static var alkaliniMetals : UIColor { return .purple }
        static var alkaliniEarthMetals : UIColor { return UIColor(red: 0, green: 77/255, blue: 0, alpha: 1) }
        static var titanium : UIColor { return .gray }
        static var iron : UIColor { return UIColor(red: 221/255, green: 119/255, blue: 0, alpha: 1) }
        static var others : UIColor { return UIColor(red: 221/255, green: 119/255, blue: 255, alpha: 1) }
        static var backGround : UIColor { return UIColor(red: 207/255, green: 216/255, blue: 220/255 ,alpha: 1) }
    static func random () -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}



struct Atom {
    var name : String
    var color : UIColor
    var number : Int
    var connections : [Int] = []
    var coordinates : [Float] = []
    var node : SCNNode?
    
    init(name: String, number: Int, coords:[Float]){
        self.number = number
        self.coordinates = coords
        switch name {
        case "H":
            self.name = "Hydrogen"
            self.color = .hydrogen
            break
        case "LI":
            self.name = "Lithium"
            self.color = .alkaliniMetals
            break
        case "NA":
            self.name = "Sodium"
            self.color = .alkaliniMetals
            break
        case "K":
            self.name = "Potassium"
            self.color = .alkaliniMetals
            break
        case "P":
            self.name = "Phosphorus"
            self.color = .phosphorus
            break
        case "RB":
            self.name = "Rubidium"
            self.color = .alkaliniMetals
            break
        case "CS":
            self.name = "Caesium"
            self.color = .alkaliniMetals
            break
        case "FR":
            self.name = "Francium"
            self.color = .alkaliniMetals
            break
        case "BE":
            self.name = "Berylium"
            self.color = .alkaliniEarthMetals
            break
        case "MG":
            self.name = "Magnesium"
            self.color = .alkaliniEarthMetals
            break
        case "CA":
            self.name = "Calcium"
            self.color = .alkaliniEarthMetals
            break
        case "SR":
            self.name = "Strontium"
            self.color = .alkaliniEarthMetals
            break
        case "BA":
            self.name = "Barium"
            self.color = .alkaliniEarthMetals
            break
        case "RA":
            self.name = "Radium"
            self.color = .alkaliniEarthMetals
            break
        case "HE":
            self.name = "Helium"
            self.color = .noblGases
            break
        case "NE":
            self.name = "Neon"
            self.color = .noblGases
            break
        case "AR":
            self.name = "Argon"
            self.color = .noblGases
            break
        case "KR":
            self.name = "Krypton"
            self.color = .noblGases
            break
        case "XE":
            self.name = "Xenon"
            self.color = .noblGases
            break
        case "RN":
            self.name = "Radon"
            self.color = .noblGases
            break
        case "FE":
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
        case "TI":
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
        case "CL":
            self.name = "Chlorine"
            self.color = .chlorine
            break
        case "BR":
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
