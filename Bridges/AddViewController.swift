//
//  AddViewController.swift
//  Bridges
//
//  Created by Thijs Lucassen on 20-10-16.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIPopoverControllerDelegate {

    
    @IBAction func saveBridgeButton(_ sender: UIBarButtonItem) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let imageName = "\(NSUUID().uuidString).png"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/png"
            let image = UIImagePNGRepresentation(self.presentingView.image!)
            FIRStorage.storage().reference().child(imageName).put(image!, metadata: metadata).observe(.success) { (snapshot) in
                DispatchQueue.main.async {
                    let text = self.nameTextField.text
                    FIRDatabase.database().reference().child(text!).setValue(BridgeObject(
                        name: text!,
                        descript: self.descriptionText.text!,
                        image: imageName,
                        latitude: Double(self.locationLatitude.text!)!,
                        longitude: Double(self.locationLongitude.text!)!
                        ).toAnyObject())
                }
            }
        }
        _ = self.navigationController?.popViewController(animated: true)

    }


    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    

    
    @IBAction func choosePicture(_ sender: UIGestureRecognizer) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Do you want to take a picture or choose on from the photolibrary?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let galleryAction = UIAlertAction(title: "Photolibrary", style: UIAlertActionStyle.default) { UIAlertAction in
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
                
            }
            
            if UIImagePickerController .isSourceTypeAvailable(.camera){
                let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { UIAlertAction in
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.present(imagePicker, animated: true, completion: nil)
                    
                }
                alert.addAction(cameraAction)
                
            } else {
                
                //print("Camera not available")
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { UIAlertAction in
                //print("Cancel Pressed")
            }
            
            alert.addAction(galleryAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    

    

    @IBOutlet var nameLabel        : UILabel!
    @IBOutlet var latitudeLabel    : UILabel!
    @IBOutlet var longitudeLabel   : UILabel!
    @IBOutlet var descriptionText  : UITextView!
    @IBOutlet var saveButton       : UIBarButtonItem!
    @IBOutlet var presentingView   : UIImageView!
    @IBOutlet var locationLatitude : UITextField!
    @IBOutlet var locationLongitude: UITextField!
    @IBOutlet var nameTextField    : UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        locationLatitude.delegate = self
        locationLongitude.delegate = self
        descriptionText.delegate = self

        presentingView.isUserInteractionEnabled = true
        
        descriptionText.text = "Description of the new bridge"
        descriptionText.textColor = UIColor.lightGray
        descriptionText.font = UIFont(name: "Futura", size: 14)
        descriptionText.textRange(from: descriptionText.beginningOfDocument, to: descriptionText.beginningOfDocument)
        
        saveButton.isEnabled = false
        
        
        // Font type and size
        
        nameTextField.font = UIFont(name: "Futura", size: 14)
        locationLatitude.font = UIFont(name: "Futura", size: 14)
        locationLongitude.font = UIFont(name: "Futura", size: 14)
        nameLabel.font = UIFont(name: "Futura", size: 14)
        latitudeLabel.font = UIFont(name: "Futura", size: 14)
        longitudeLabel.font = UIFont(name: "Futura", size: 14)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        presentingView.image = image
        dismiss(animated: true, completion: nil)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:NSString = descriptionText.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        if updatedText.isEmpty {
            descriptionText.text = "Description of the new bridge"
            descriptionText.textColor = UIColor.lightGray
            descriptionText.textRange(from: descriptionText.beginningOfDocument, to: descriptionText.beginningOfDocument)
            return false
        } else if descriptionText.textColor == UIColor.lightGray && !text.isEmpty {
            descriptionText.text = nil
            descriptionText.textColor = UIColor.black
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if descriptionText.textColor == UIColor.lightGray {
                descriptionText.textRange(from: descriptionText.beginningOfDocument, to: descriptionText.beginningOfDocument)
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if nameTextField.hasText && locationLatitude.hasText && locationLongitude.hasText && descriptionText.hasText && presentingView.image != nil {
            saveButton.isEnabled = true
    }
    }
    
        func textFieldDidEndEditing(_ textField: UITextField) {
            if nameTextField.hasText && locationLatitude.hasText && locationLongitude.hasText && descriptionText.hasText && presentingView.image != nil {
                saveButton.isEnabled = true
        }
    
        }
}

