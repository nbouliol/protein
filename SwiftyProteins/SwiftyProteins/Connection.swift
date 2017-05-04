//
//  Connection.swift
//  SwiftyProteins
//
//  Created by Nicolas BOULIOL on 5/3/17.
//  Copyright © 2017 Nicolas BOULIOL. All rights reserved.
//

import Foundation

struct Connection {
    var from : Int
    var to : Int
    var number : Int
    
    init(f:Int, t:Int, n:Int) {
        from = f
        to = t
        number = n
    }
}
