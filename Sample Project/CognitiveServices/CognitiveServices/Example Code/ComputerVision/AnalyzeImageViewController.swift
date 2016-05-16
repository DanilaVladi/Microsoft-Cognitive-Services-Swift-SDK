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
    
    
    @IBAction func analyzeFromURLDidPush(sender: AnyObject) {
        
        let analyzeImage = CognitiveServices.sharedInstance.analyzeImage
        
        try! analyzeImage.analyzeImageOnURL(urlTextField.text!) { response in
            self.textView.text = response!.description
        }
        
    }
    

}
