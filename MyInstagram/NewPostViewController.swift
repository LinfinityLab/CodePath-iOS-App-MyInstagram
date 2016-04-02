//
//  NewPostViewController.swift
//  MyInstagram
//
//  Created by Weifan Lin on 4/1/16.
//  Copyright © 2016 Weifan Lin. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var postPhoto: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var photo: UIImage!
    var editedPhoto: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionTextField.delegate = self

        postPhoto.image = photo
        
        captionTextField.text = "Say something about your photo :)"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    @IBAction func onPost(sender: AnyObject) {
//        Post.postUserImage(resize(editedPhoto, newSize: CGSize(width: 100, height: 100)), withCaption: captionTextField.text!) { (success: Bool, error: NSError?) -> Void in
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (self.captionTextField.text == "Say something about your photo :)") {
            self.captionTextField.text = ""
        }
    }

    @IBAction func onTap(sender: AnyObject) {
        self.captionTextField.endEditing(true)
    }
    
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        
//        let currentCharacterCount = textField.text?.characters.count ?? 0
//        if (range.length + range.location > currentCharacterCount){
//            return false
//        }
//        let newLength = currentCharacterCount + string.characters.count - range.length
//        return newLength <= 25
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
