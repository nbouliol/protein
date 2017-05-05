//
//  ViewController.swift
//  SwiftyProteins
//
//  Created by Nicolas BOULIOL on 4/27/17.
//  Copyright © 2017 Nicolas BOULIOL. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    let context = LAContext()
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func login(_ sender: Any) {
        if username.text != nil && password.text != nil && username.text! != "" && password.text! != "" {
//            self.showAlertWithTitle(title: "success", message: "GG")
            goToList()
        } else {
            ft_alert(title: "Unable to connect", msg: "Please specify both username and password", dismiss: "Ok, I'll try again")
        }
    }
    @IBOutlet weak var touchIdButton: UIButton!
    func goToList()  {
        print("test1")
        performSegue(withIdentifier: "segueToList", sender: self)
        print("test2")
    }
    @IBAction func touchId(_ sender: Any) {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Only awesome people are allowed",
                reply: { [unowned self] (success, error) -> Void in
                    
                    if( success ) {
                        
                        // Fingerprint recognized
                        // Go to view controller
//                        self.navigateToAuthenticatedViewController()
//                        self.showAlertWithTitle(title: "success", message: "GG")
                        self.goToList()
                    }else {
                        
                        // Check if there is an error
                        if let error = error {
                            
                            self.showAlertWithTitle(title: "error", message: error.localizedDescription)
                            
                        }
                        
                    }
                    
            })
        } else {
            
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
            
        }
    }
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
        
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
//        dispatch_get_main_queue().asynchronously() { () -> Void in
        
            self.present(alertVC, animated: true, completion: nil)
            
//        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)  {
            touchIdButton.isHidden = true
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToList" {
//            if let dest = segue.destination as? InfosController {
//                dest.useri = self.user
//            }
            print("caca")
        }
    }

}

