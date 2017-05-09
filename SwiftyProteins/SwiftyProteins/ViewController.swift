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
            self.touchIdButton.isEnabled = false
            self.loginButton.isEnabled = false
            goToList()
        } else {
            ft_alert(title: "Unable to connect", msg: "Please specify both username and password", dismiss: "Ok, I'll try again")
        }
    }
    @IBOutlet weak var touchIdButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    func goToList()  {
        performSegue(withIdentifier: "segueToList", sender: self)
    }
    @IBAction func touchId(_ sender: Any) {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Only awesome people are allowed",
                reply: { [unowned self] (success:Bool, error: Error?) -> Void in
                    
                    DispatchQueue.main.async {  () -> Void in
                        
                    if( success ) {
                        
                        // Fingerprint recognized
                        // Go to view controller
//                        self.navigateToAuthenticatedViewController()
//                        self.showAlertWithTitle(title: "success", message: "GG")
                        self.goToList()
                        self.touchIdButton.isEnabled = false
                        self.loginButton.isEnabled = false
                    }else {
                        
                        // Check if there is an error
                        
                        if error != nil {
                            let error = error as! LAError
                            if error.code == LAError.Code.userFallback {
                                self.ft_alert(title: "Error", msg: "You pressed password", dismiss: "Fuck it")
                            }
                        }
                        
//                        if let error = error {
//                            
//                            self.showAlertWithTitle(title: "error", message: error.localizedDescription)
//                            
//                        }
                        
                        
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
        if !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            touchIdButton.isHidden = true
        }
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
    
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToList" {
//            if let dest = segue.destination as? InfosController {
//                dest.useri = self.user
//            }
        }
    }

}

