//
//  LoginSignupViewController.swift
//  FoodTracker
//
//  Created by Adam DesLauriers on 2016-02-15.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit

class LoginSignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var imageToUpload: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    
    var pickerData: [String]  = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
}












