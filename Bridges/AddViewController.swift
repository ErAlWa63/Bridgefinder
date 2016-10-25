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
    
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    @IBOutlet var imageView: UIImageView!
    
    
    @IBOutlet var nameTextField: UITextField!

    @IBOutlet var locationLatitude: UITextField!
    
    @IBOutlet var locationLongitude: UITextField!
    
    @IBOutlet var descriptionText: UITextView!
    
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
    

    
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        
        let text = nameTextField.text
        let description = descriptionText.text
        let latitude = 0.0
        let longitude = 0.0
        let BridgeObjectCalculated = BridgeObject(name: text!, description: description!, image: "Fixed image", latitude: latitude, longitude: longitude)
        let ref = FIRDatabase.database().reference(withPath: "Bridges/")
        print("Bridges: ref = \(ref)")
        let BridgeObjectRef = ref.child(text!)
        print("Bridges: BridgeObjectRef = \(BridgeObjectRef)")
        BridgeObjectRef.setValue(BridgeObjectCalculated.toAnyObject())
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        descriptionText.text = "Description of the new bridge"
        descriptionText.textColor = UIColor.lightGray
        
//        descriptionText.becomeFirstResponder()
        
        
        descriptionText.textRange(from: descriptionText.beginningOfDocument, to: descriptionText.beginningOfDocument)

    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = descriptionText.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            descriptionText.text = "Description of the new bridge"
            descriptionText.textColor = UIColor.lightGray
            
            descriptionText.textRange(from: descriptionText.beginningOfDocument, to: descriptionText.beginningOfDocument)
            
            return false
        }
    
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if descriptionText.textColor == UIColor.lightGray && !text.isEmpty {
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
