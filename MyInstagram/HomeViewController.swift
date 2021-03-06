//
//  HomeViewController.swift
//  MyInstagram
//
//  Created by Weifan Lin on 4/1/16.
//  Copyright © 2016 Weifan Lin. All rights reserved.
//

import UIKit
import Parse
import AFNetworking
import MBProgressHUD

class HomeViewController: UIViewController {
    
    var posts: [PFObject]?
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        refreshControlAction(refreshControl)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshControlAction(refreshControl)
    }
    
    internal class Reachability {
        class func isConnectedToNetwork() -> Bool {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
                SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
            }
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        if Reachability.isConnectedToNetwork() {
            dismissNetworkErr()
            requestPosts()
        } else {
            showNetworkErr()
        }
        refreshControl.endRefreshing()
    }
    
    func showNetworkErr(){
        navigationItem.title = "Disconnected"
    }
    func dismissNetworkErr(){
        navigationItem.title = "Linfinity Instagram"
    }
    
    
    
    
    func requestPosts() {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        if (refreshControl.refreshing) {
            refreshControl.beginRefreshing()
        }
        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                print("successed to fetch posts")
                self.posts = posts
                for i in posts {
                    print (i)
                }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    @IBAction func onNewPost(sender: AnyObject) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Take photo")
            
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.Camera
            
            self.presentViewController(vc, animated: true, completion: nil)
        })
        let saveAction = UIAlertAction(title: "Choose from Photos", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Choose photos")
            
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(vc, animated: true, completion: nil)
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
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


////////// table \\\\\\\\\\
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count  = self.posts?.count
        if let count = count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostTableViewCell
        
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        
        
        cell.post = self.posts![indexPath.row]
        
        return cell
    }
}


extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            // Get the image captured by the UIImagePickerController
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: nil)
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigation = storyboard.instantiateViewControllerWithIdentifier("NewPostNavigationController") as! UINavigationController
            let newPostViewController = navigation.topViewController as! NewPostViewController
            
            newPostViewController.photo = originalImage
            newPostViewController.editedPhoto = editedImage
            
            presentViewController(navigation, animated: false, completion: nil)
    }
}

