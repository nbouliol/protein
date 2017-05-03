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
    
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func parse(){
        for line in self.lines {
            var words = line.components(separatedBy: .whitespaces)
            words = words.filter { $0 != "" }
            if words.count > 0 && words[0] == "ATOM" {
                let tmp = words[6...8]
                let floatArray = tmp.map { Float($0)! }
                atoms.append(Atom(name: words.last!, number: Int(words[1])!, coords: floatArray))
            } else if words.count > 0 && words[0] == "CONECT" {
                atoms[Int(words[1])! - 1].connections = words[2..<words.count].map { Int($0)! }
            }
        }
    }
}
