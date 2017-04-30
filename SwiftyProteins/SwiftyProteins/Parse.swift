//
//  Parse.swift
//  SwiftyProteins
//
//  Created by Nicolas BOULIOL on 4/30/17.
//  Copyright © 2017 Nicolas BOULIOL. All rights reserved.
//

import Foundation
import UIKit

class Parser {
    var pdbFile : String
    var lines : [String]
    var atoms : [Atom] = []
    
    init(pdb:String) {
        self.pdbFile = pdb
        self.lines = self.pdbFile.components(separatedBy: .newlines)
    }

    
    func parse(){
        for line in self.lines {
            let words = line.components(separatedBy: .whitespaces)
            if words[0] == "ATOM" {
                atoms.append(Atom(name: words.last!))
            }
        }
    }
}
