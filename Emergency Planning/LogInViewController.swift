//
//  LogInViewController.swift
//  Emergency Planning
//
//  Created by Jin Seok Park on 7/16/15.
//  Copyright (c) 2015 Jin Seok Park. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var signupButton2: UIButton!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var loginBtn2: UIButton!
    @IBOutlet var passwordReTextField: UITextField!
    @IBOutlet var notLabel: UILabel!
    @IBOutlet var alreadyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.passwordReTextField.hidden = true
        self.signupButton2.hidden = true
        self.loginBtn2.hidden = true
        self.alreadyLabel.hidden = true


        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        self.passwordReTextField.hidden = true
        self.signupButton2.hidden = true
        self.loginBtn.hidden = false
        self.loginBtn2.hidden = true
        self.notLabel.hidden = false
        self.signupButton.hidden = false
        self.alreadyLabel.hidden = true
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signupBtn2_click(sender: AnyObject) {
        
        var user = PFUser()
        user.username = emailTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text
        
        var query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: emailTextField.text)
        
        var objects = query.findObjects()
        
        user.signUpInBackgroundWithBlock
            { (succeeded:Bool, signUpError:NSError?) -> Void in
                
                if (self.passwordTextField.text != self.passwordReTextField.text) {
                    var alert = UIAlertView(title: "Error", message: "Password does not match", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
                
                if objects != nil {
                    var alert = UIAlertView(title: "Error", message: "You already created an account", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
                    
                    
                    if signUpError == nil {
                        var alert = UIAlertView(title: "Congratulations!", message: "Sign Up Successful", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                        
                        //installation
                        var installation:PFInstallation = PFInstallation.currentInstallation()
                        installation["user"] = PFUser.currentUser()
                        installation.saveInBackgroundWithBlock{ (succeeded:Bool, error:NSError?) -> Void in
                            
                            if succeeded == true {
                                println("success")
                            } else {
                                println("There is a certain \(error!.description)")
                            }
                            
                        }
                        
                        
                        self.performSegueWithIdentifier("goToMain", sender: self)
                        
                    }
                
        }
        
    }
    
    @IBAction func signupBtn_click(sender: AnyObject) {
        
        self.passwordReTextField.hidden = false
        self.signupButton2.hidden = false
        self.loginBtn.hidden = true
        self.signupButton.hidden = true
        self.notLabel.hidden = true
        self.loginBtn2.hidden = false
        self.alreadyLabel.hidden = false

        
    }
    
    @IBAction func loginBtn2_click(sender: AnyObject) {
        
        self.passwordReTextField.hidden = true
        self.signupButton2.hidden = true
        self.loginBtn.hidden = false
        self.signupButton.hidden = false
        self.notLabel.hidden = false
        self.loginBtn2.hidden = true
        self.alreadyLabel.hidden = true

    }
    
//    override func viewWillAppear(animated: Bool) {
//        self.navigationItem.hidesBackButton = true
//    }

    @IBAction func loginBtn_click(sender: AnyObject) {
        
        
        println("USERNAME: \(emailTextField.text) && PASSWORD: \(passwordTextField.text)")
        
        PFUser.logInWithUsernameInBackground(emailTextField.text, password: passwordTextField.text, block: {
            (user:PFUser?, logInError:NSError?)->Void in
            
            if logInError == nil{
                println("Login successful")
                

                
                
                //Push Notification Step 2
                var installation:PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackgroundWithBlock{ (succeeded:Bool, error:NSError?) -> Void in
                    
                }
                
                self.performSegueWithIdentifier("goToMain", sender: self)

                
                
            } else{
                var alert = UIAlertView(title: "Error", message: "Login failed", delegate: self, cancelButtonTitle: "OK")
                alert.show()

                println(logInError)
            }
            
        })
        

    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
