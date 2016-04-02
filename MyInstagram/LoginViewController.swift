//
//  LoginViewController.swift
//  MyInstagram
//
//  Created by Weifan Lin on 3/31/16.
//  Copyright © 2016 Weifan Lin. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.alpha = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func onLogin(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("login good")
                self.performSegueWithIdentifier("LoginSegue", sender: nil)
            } else {
                self.messageLabel.text = "\((error?.localizedDescription)!)"
                self.animateText(self.messageLabel)
                print(error?.localizedDescription)
            }
        }
    }
    @IBAction func onSignUp(sender: AnyObject) {
        
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("singup good")
                self.performSegueWithIdentifier("LoginSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
                self.messageLabel.text = "\((error?.localizedDescription)!)"
                self.animateText(self.messageLabel)
                if error?.code == 202 {
                    print("user name is taken")
                }
            }
        }
    }
    
    
    func animateText(label : UILabel){
        UIView.animateWithDuration(1.0, animations: {
            label.alpha = 1.0
            }, completion: {
                (completed : Bool) -> Void in
                UIView.animateWithDuration(1.0, delay: 2.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                    label.alpha = 0
                    }, completion: {(completed : Bool) -> Void in
                        completed
                })
        })
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
