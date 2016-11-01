//
//  AddViewController.swift
//  Bridges
//
//  Created by Thijs Lucassen on 20-10-16.
//  Copyright © 2016 TL. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBAction func saveBridge(_ sender: UIBarButtonItem) {
        DispatchQueue.global(qos: .userInitiated).async {
            let imageName = "\(NSUUID().uuidString).png"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/png"
            let image = UIImagePNGRepresentation(self.imageView.image!)
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
        
    }

    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBOutlet var saveBridgeButton : UIButton!
    @IBOutlet var cancelButton     : UIBarButtonItem!
    @IBOutlet var descriptionText  : UITextView!
    @IBOutlet var imageView        : UIImageView!
    
    @IBOutlet var photoLibrary     : UIImageView!
    @IBOutlet var locationLatitude : UITextField!
    @IBOutlet var locationLongitude: UITextField!
    @IBOutlet var nameTextField    : UITextField!
    
    let saveButtonState = UIButton(type: UIButtonType.system) as UIButton
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapLibraryRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoLibraryTapped))
        photoLibrary.isUserInteractionEnabled = true
        photoLibrary.addGestureRecognizer(tapLibraryRecognizer)
        
        

        descriptionText.text = "Description of the new bridge"
        descriptionText.textColor = UIColor.lightGray
        //        descriptionText.becomeFirstResponder()
        descriptionText.textRange(from: descriptionText.beginningOfDocument, to: descriptionText.beginningOfDocument)
        
        // Setting back button text to back - testing
        
//        self.backButton.title = "Back"

        
//         // Disable save button when not all fields are filled
//        
//        if nameTextField.text!.isEmpty, descriptionText.text!.isEmpty, locationLatitude.text!.isEmpty, locationLongitude.text!.isEmpty {
//            saveButtonState.isEnabled = false
//            
//        } else {
//            
//            saveButtonState.isEnabled = true
//        }
        
        
    }
    
    func imageViewTapped(imgage: AnyObject) {
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
    
    func photoLibraryTapped(imgage: AnyObject) {
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
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
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
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if descriptionText.textColor == UIColor.lightGray {
                descriptionText.textRange(from: descriptionText.beginningOfDocument, to: descriptionText.beginningOfDocument)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image.resizedImageWithinRect(rectSize: CGSize(width: 300, height: 200))
        imageView.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
    
    }
    
    func libraryPickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageLibrary = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoLibrary.image = imageLibrary.resizedImageWithinRect(rectSize: CGSize(width: 300, height: 200))
        photoLibrary.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldReturn(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
}
extension UIImage {
    func resizedImage(newSize: CGSize) -> UIImage {
        guard self.size != newSize else { return self }
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        return resizedImage(newSize: CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor))
    }
    
}

