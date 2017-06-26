/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupMode = true
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupOrLoginButton: UIButton!
    @IBOutlet weak var changeSignupModeButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func signupOrLoginButtonClicked(_ sender: Any) {
        
        if signupMode {
            
            let user = PFUser()
            
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            
            user.signUpInBackground { (success, error) in
                
                if error != nil {
                    
                    var errorMessage = "Signup Failed - please try again."
                    
                    if let parseError = error?.localizedDescription {
                        
                        errorMessage = parseError
                        
                    }
                    
                    self.errorLabel.text = errorMessage
                    
                } else {
                    
                    print("Signed up successfully!")
                    
                }
                
            }
            
        } else {
                        
            if let username = usernameTextField.text, let password = passwordTextField.text {
                
                PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) in
                    if error != nil {
                        
                        var errorMessage = "Signup Failed - please try again."
                        
                        if let parseError = error?.localizedDescription {
                            
                            errorMessage = parseError
                            
                        }
                        
                        self.errorLabel.text = errorMessage
                        
                    } else {
                        
                        print("User logged in!")
                        
                    }
                })
                
            } else {
                
                print("Please make sure username and pasword are filled in")
                
            }
        }
    }
    
    @IBAction func changeSignupModeButtonClicked(_ sender: Any) {
        
        if signupMode {
            
            signupMode = false
            
            signupOrLoginButton.setTitle("Login", for: [])
            
            changeSignupModeButton.setTitle("Sign Up", for: [])
            
        } else {
            
            signupMode = true
            
            signupOrLoginButton.setTitle("Sign Up", for: [])
            
            changeSignupModeButton.setTitle("Login", for: [])
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //        let testObject = PFObject(className: "TestObject2")
        //
        //        testObject["foo"] = "bar"
        //
        //        testObject.saveInBackground { (success, error) -> Void in
        //
        //            // added test for success 11th July 2016
        //
        //            if success {
        //
        //                print("Object has been saved.")
        //
        //            } else {
        //
        //                if error != nil {
        //
        //                    print (error!)
        //
        //                } else {
        //
        //                    print ("Error")
        //                }
        //
        //            }
        //        }
        
        let label = UILabel(frame: CGRect(x: self.view.bounds.width / 2 - 100, y: self.view.bounds.height / 2 - 50, width: 200, height: 100))
        label.text = "Drag me!"
        label.textAlignment = NSTextAlignment.center
        view.addSubview(label)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer: )))
        
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
        
    }
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        let label = gestureRecognizer.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 100)
        
        let scale = min(abs(100 / xFromCenter), 1)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        label.transform = stretchAndRotation
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            if label.center.x < 100 {
                
                print("Not chosen")
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                print ("Chosen")
                
            }
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
            
            label.transform = stretchAndRotation
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
