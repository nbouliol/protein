//
//  ProteinViewController.swift
//  SwiftyProteins
//
//  Created by Nicolas BOULIOL on 4/28/17.
//  Copyright © 2017 Nicolas BOULIOL. All rights reserved.
//

import UIKit

class ProteinViewController: UIViewController {

    var ligVal : String? = ""
    var pdbFile : String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        testLabel.text = ligVal!
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var testLabel: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let Url = "http://ligand-expo.rcsb.org/reports/\(ligVal![ligVal!.index(ligVal!.startIndex, offsetBy: 0)])/\(ligVal!)/\(ligVal!)_ideal.pdb"
        
        // Start background thread so that image loading does not make app unresponsive
        guard let myURL = URL(string: Url) else {
            print("Error: \(Url) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
//            print("HTML : \(myHTMLString)")
            pdbFile = myHTMLString
            let parser = Parser(pdb: pdbFile!)
            parser.parse()
            print(parser.atoms)
        } catch let error {
            print("Error: \(error)")
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
