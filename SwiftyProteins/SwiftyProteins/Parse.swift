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
    
    class func covalent (sdf: String) -> [Connection] {
        var connections : [Connection] = []
        var lines = sdf.components(separatedBy: .newlines)
        lines.removeFirst()
        lines.removeFirst()
        lines.removeFirst()
//        print(lines[0].components(separatedBy: .whitespaces)[0])
        print("cacacacacca")
        print(lines[0].components(separatedBy: .whitespaces))
        let nbAtom = Int(lines[0].components(separatedBy: .whitespaces)[1])
        lines.removeFirst()
        for _ in 0..<nbAtom! {
            lines.removeFirst()
        }
        lines.removeLast()
        lines.removeLast()
        lines.removeLast()
        for line in lines {
            var arr = line.components(separatedBy: .whitespaces)
            arr = arr.filter() { $0 != "" }
            connections.append(Connection(f: Int(arr[0])!, t: Int(arr[1])!, n: Int(arr[2])!))
        }
        return connections
    }

}
