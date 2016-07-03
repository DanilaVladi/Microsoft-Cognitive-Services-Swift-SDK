//
//  AnalyzeImageViewController.swift
//  CognitiveServices
//
//  Created by Vladimir Danila on 16/05/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class AnalyzeImageViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var urlTextField: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func analyzeFromURLDidPush(_ sender: AnyObject) {
        
        let analyzeImage = CognitiveServices.sharedInstance.analyzeImage
        let visualFeatures: [AnalyzeImage.AnalyzeImageVisualFeatures] = [.Categories, .Description, .Faces, .ImageType, .Color, .Adult]
        let requestObject: AnalyzeImageRequestObject = (urlTextField.text!, visualFeatures)
        
        try! analyzeImage.analyzeImageWithRequestObject(requestObject, completion: { (response) in
            self.textView.text = response?.descriptionText
        })
        
        
    }

    
    @IBAction func analyzeImageDidPush(_ sender: AnyObject) {
        
        
        let analyzeImage = CognitiveServices.sharedInstance.analyzeImage

        let visualFeatures: [AnalyzeImage.AnalyzeImageVisualFeatures] = [.Categories, .Description, .Faces, .ImageType, .Color, .Adult]
        let requestObject: AnalyzeImageRequestObject = (imageView.image!, visualFeatures)
        
        try! analyzeImage.analyzeImageWithRequestObject(requestObject, completion: { (response) in
            self.textView.text = response?.descriptionText
        })

    }

}
