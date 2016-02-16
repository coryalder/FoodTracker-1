//
//  LoginSignupViewController.swift
//  FoodTracker
//
//  Created by Adam DesLauriers on 2016-02-15.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse

class LoginSignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var imageToUpload: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    var pickerData: [String]  = [String]()
    var imageFile: PFFile!
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userTypePickerView.delegate = self
        self.userTypePickerView.dataSource = self

        pickerData = ["Food Critic", "Casual Foodie"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) thats being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - Image Picker Delegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageToUpload.image = selectedImage
        
        
        if let data = UIImageJPEGRepresentation(selectedImage, 0.5){
            imageFile = PFFile(data: data)
            imageFile.saveInBackground()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
        // MARK: - Actions
    @IBAction func selectImageFromLibrary(sender: UITapGestureRecognizer) {
        usernameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func sumbitButtonPressed(sender: UIButton) {
    
        if let username = usernameTextField.text,
            let password = userPasswordTextField.text {
                
                let newUser = PFUser()
                
                newUser.username = username
                newUser.password = password
                
                if let imageFile = imageFile {
                    newUser.setObject(imageFile, forKey: "profilePic")
                }
                
                let selectedRow = userTypePickerView.selectedRowInComponent(0)
                
                newUser.setObject(pickerData[selectedRow], forKey: "userType")
                
                newUser.signUpInBackgroundWithBlock { (success, error) -> Void in
                    if success {
                        print("Created new user")
                       self.dismissViewControllerAnimated(true, completion: nil)
                    } else  {
                        PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                            if let user = user {
                                print("logged in")
                                
                                if let imageFile = self.imageFile {
                                    user.setObject(imageFile, forKey: "profilePic")
                                }
                                
                                user.saveInBackground()
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                            } else {
                                print("ERROR")
                            }
                        })
                    }
                }
        }
    }
}

