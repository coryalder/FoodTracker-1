//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Adam DesLauriers on 2016-02-14.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            
            
            if let photoFile = meal.photo {
                
                photoFile.getDataInBackgroundWithBlock {
                    maybeData, error in
                    
                    if let data = maybeData {
                        self.photoImageView.image = UIImage(data: data)
                    }
                }
                
            }
            
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidMealName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
    
        saveButton.enabled = false
    }
    
    func checkValidMealName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        checkValidMealName()
        navigationItem.title = textField.text
        
    }
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoImageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)


    }
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let photo = photoImageView.image,
           let imageData = UIImageJPEGRepresentation(photo, 0.5)
            where saveButton === sender {
                
            let name = nameTextField.text ?? ""
            let rating = ratingControl.rating
            
            meal = Meal()
            meal?.name = name
            
            
            
            let file = PFFile(data: imageData)
            
            meal?.photo = file
            meal?.rating = rating
                
                // send a push/
                
                if let type = PFUser.currentUser()?["userType"] as? String where type == "Food Critic" {
                    
                    let push = PFPush()
                    
                    push.setData(["title" : "new food!", "alert" : "there is new food available!"])
                    
//                    push.setQuery(<#T##query: PFQuery?##PFQuery?#>)
                    
                    do {
                        try push.sendPush()
                    } catch {
                        print("oops push failed \(error)")
                    }
                    
                }
        }
    }
    
    // MARK: Actions

    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)

    }
    
    @IBAction func logoutPressed(sender: UIButton) {
        
        PFUser.logOut()
    }
    

}
