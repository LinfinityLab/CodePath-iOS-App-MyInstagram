//
//  NewPostViewController.swift
//  MyInstagram
//
//  Created by Weifan Lin on 4/1/16.
//  Copyright © 2016 Weifan Lin. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var postPhoto: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var photo: UIImage!
    var editedPhoto: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postPhoto.image = photo
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPost(sender: AnyObject) {
        Post.postUserImage(editedPhoto, withCaption: captionTextField.text!) { (success: Bool, error: NSError?) -> Void in
            if success {
                print("Posted")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
