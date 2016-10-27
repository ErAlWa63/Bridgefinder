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
    
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        let imageName = "\(NSUUID().uuidString).png"
        let photoRef = FIRStorage.storage().reference().child("photos").child(imageName)
        print("Bridges: photoRef = \(photoRef)")
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/png"
        let image = UIImagePNGRepresentation(imageView.image!)
        DispatchQueue.global(qos: .userInitiated).async {
            photoRef.put(image!, metadata: metadata).observe(.success) { (snapshot) in
                DispatchQueue.main.async {
                    let text = self.nameTextField.text
                    let description = self.descriptionText.text
                    let latitude = Double(self.locationLatitude.text!)
                    let longitude = Double(self.locationLongitude.text!)
                    let BridgeObjectCalculated = BridgeObject(name: text!, description: description!, image: imageName, latitude: latitude!, longitude: longitude!)
                    let ref = FIRDatabase.database().reference(withPath: "Bridges/")
                    print("Bridges: ref = \(ref)")
                    let BridgeObjectRef = ref.child(text!)
                    print("Bridges: BridgeObjectRef = \(BridgeObjectRef)")
                    BridgeObjectRef.setValue(BridgeObjectCalculated.toAnyObject())
                    self.performSegue(withIdentifier: "unwindToMenuWithSegueListView", sender: self)
                    
                }
            }
        }
        
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        // If device has a camera, take picture; otherwise pick one from library
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        
        // Place image picker on screen
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet var cancelButton     : UIBarButtonItem!
    @IBOutlet var descriptionText  : UITextView!
    @IBOutlet var imageView        : UIImageView!
    @IBOutlet var locationLatitude : UITextField!
    @IBOutlet var locationLongitude: UITextField!
    @IBOutlet var nameTextField    : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionText.text = "Description of the new bridge"
        descriptionText.textColor = UIColor.lightGray
        //        descriptionText.becomeFirstResponder()
        descriptionText.textRange(from: descriptionText.beginningOfDocument, to: descriptionText.beginningOfDocument)
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
        imageView.image = image
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
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
    
}

