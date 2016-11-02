//
//  AddViewController.swift
//  Bridges
//
//  Created by Thijs Lucassen on 20-10-16.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    
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
        self.navigationController?.popViewController(animated: true)

    }


    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Enabling save button when fields have text
    
    
    
    
    
    @IBAction func nameTextFieldCheck(_ sender: UITextField) {
        if nameTextField.hasText && locationLatitude.hasText && locationLongitude.hasText && descriptionText.hasText && presentingView.image != nil {
                   saveButton.isEnabled = true
        }
    }
    

    @IBAction func latitudeCheck(_ sender: UITextField) {
        if nameTextField.hasText && locationLatitude.hasText && locationLongitude.hasText && descriptionText.hasText && presentingView.image != nil {
            saveButton.isEnabled = true
        }
    }

    @IBAction func longitudeCheck(_ sender: UITextField) {
        if nameTextField.hasText && locationLatitude.hasText && locationLongitude.hasText && descriptionText.hasText && presentingView.image != nil {
            saveButton.isEnabled = true
        }
    }
    
//    @IBAction func descriptionCheck(_ sender: UITextView) {
//        if nameTextField.hasText && locationLatitude.hasText && locationLongitude.hasText && descriptionText.hasText && (presentingView.image != nil){
//            saveButton.isEnabled = true
//        }
//        
//    }
    


    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var latitudeLabel: UILabel!
    
    @IBOutlet var longitudeLabel: UILabel!
    
    @IBOutlet var descriptionText  : UITextView!
    @IBOutlet var imageView        : UIImageView!
    
    @IBOutlet var saveButton       : UIBarButtonItem!
    @IBOutlet var presentingView   : UIImageView!
    @IBOutlet var photoLibrary     : UIImageView!
    @IBOutlet var locationLatitude : UITextField!
    @IBOutlet var locationLongitude: UITextField!
    @IBOutlet var nameTextField    : UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapLibraryRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoLibraryTapped))
        photoLibrary.isUserInteractionEnabled = true
        photoLibrary.addGestureRecognizer(tapLibraryRecognizer)
        
        
        presentingView.isUserInteractionEnabled = true
        
        descriptionText.text = "Description of the new bridge"
        descriptionText.textColor = UIColor.lightGray
        descriptionText.font = UIFont(name: "Futura", size: 14)
        //        descriptionText.becomeFirstResponder()
        descriptionText.textRange(from: descriptionText.beginningOfDocument, to: descriptionText.beginningOfDocument)
        
        saveButton.isEnabled = false
        
        
        // Font type and size
        
        nameTextField.font = UIFont(name: "Futura", size: 14)
        locationLatitude.font = UIFont(name: "Futura", size: 14)
        locationLongitude.font = UIFont(name: "Futura", size: 14)
        nameLabel.font = UIFont(name: "Futura", size: 14)
        latitudeLabel.font = UIFont(name: "Futura", size: 14)
        longitudeLabel.font = UIFont(name: "Futura", size: 14)
        
//        nameTextField.clearsOnBeginEditing = true
//        locationLatitude.clearsOnBeginEditing = true
//        locationLongitude.clearsOnBeginEditing = true
//        descriptionText.clearsOnInsertion = true
        
//        UINavigationBar.appearance().titleTextAttributes([NSFontAttributeName: UIFont.fontNames(forFamilyName: "Futura"), NSForegroundColorAttributeName:UIColor.white], for: UIControlState.normal)
        
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.fontNames(forFamilyName: "Futura"), NSForegroundColorAttributeName:UIColor.white], for: UIControlState.normal)
        
        
        
        

    }
    
    func imageCheck (image: AnyObject) {
        if nameTextField.hasText && locationLatitude.hasText && locationLongitude.hasText && descriptionText.hasText && presentingView.image != nil {
            saveButton.isEnabled = true
        }
    }
    
    func imageViewTapped(image: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func photoLibraryTapped(image: AnyObject) {
        let imagePickerLibrary = UIImagePickerController()
        imagePickerLibrary.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        imagePickerLibrary.sourceType = .photoLibrary
        } else {
            imagePickerLibrary.sourceType = .savedPhotosAlbum
        }
        imagePickerLibrary.delegate = self
        present(imagePickerLibrary, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        presentingView.image = image.resizedImageWithinRect(rectSize: CGSize(width: 300, height: 200))
        imageView.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
    
    }
    
    func libraryPickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageLibrary = info[UIImagePickerControllerOriginalImage] as! UIImage
        presentingView.image = imageLibrary.resizedImageWithinRect(rectSize: CGSize(width: 300, height: 200))
        photoLibrary.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func textViewShouldReturn(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
}

