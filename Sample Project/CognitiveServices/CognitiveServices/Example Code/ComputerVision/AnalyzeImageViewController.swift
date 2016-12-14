//
//  AnalyzeImageViewController.swift
//  CognitiveServices
//
//  Created by Vladimir Danila on 16/05/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class AnalyzeImageViewController: UIViewController, UITextFieldDelegate, AnalyzeImageDelegate {

    @IBOutlet var textView: UITextView!
    @IBOutlet var urlTextField: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func analyzeFromURLDidPush(_ sender: AnyObject) {
        
        let analyzeImage = CognitiveServices.sharedInstance.analyzeImage
		analyzeImage.delegate = self

        let visualFeatures: [AnalyzeImage.AnalyzeImageVisualFeatures] = [.Categories, .Description, .Faces, .ImageType, .Color, .Adult]
        let requestObject: AnalyzeImageRequestObject = (urlTextField.text!, visualFeatures)
        
        try! analyzeImage.analyzeImageWithRequestObject(requestObject, completion: { (response) in
            DispatchQueue.main.async(execute: { 
                self.textView.text = response?.descriptionText
            })
        })
    }

    
    @IBAction func analyzeImageDidPush(_ sender: AnyObject) {

        let analyzeImage = CognitiveServices.sharedInstance.analyzeImage
		analyzeImage.delegate = self

        let visualFeatures: [AnalyzeImage.AnalyzeImageVisualFeatures] = [.Categories, .Description, .Faces, .ImageType, .Color, .Adult]
        let requestObject: AnalyzeImageRequestObject = (imageView.image!, visualFeatures)
        
        try! analyzeImage.analyzeImageWithRequestObject(requestObject, completion: { (response) in
            DispatchQueue.main.async(execute: {
                self.textView.text = response?.descriptionText
            })
        })

    }


	// MARK: - TextFieldDelegate

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()

		return true
	}

	// MARK: - AnalyzeImageDelegate

	func finnishedGeneratingObject(_ analyzeImageObject: AnalyzeImage.AnalyzeImageObject) {

		// Here you could do more with this object. It for instance contains the recognized emotions that weren't available before.
		print(analyzeImageObject)
	}

}
