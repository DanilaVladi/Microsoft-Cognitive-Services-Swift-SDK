//
//  OCRViewController.swift
//  CognitiveServices
//
//  Created by Vladimir Danila on 5/13/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class OCRViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    let ocr = CognitiveServices.sharedInstance.ocr

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func textFromUrlDidPush(_ sender: UIButton) {
        let requestObject: OCRRequestObject = (resource: urlTextField.text!, language: .Automatic, detectOrientation: true)
        try! ocr.recognizeCharactersWithRequestObject(requestObject, completion: { (response) in
            if (response != nil){
                let text = self.ocr.extractStringFromDictionary(response!)
                self.resultTextView.text = text
            }
        })

    }
    
     
    @IBAction func textFromImageDidPush(_ sender: UIButton) {
        
        let requestObject: OCRRequestObject = (resource: UIImagePNGRepresentation(UIImage(named: "ocrDemo")!)!, language: .Automatic, detectOrientation: true)
        try! ocr.recognizeCharactersWithRequestObject(requestObject, completion: { (response) in
            if (response != nil){
                let text = self.ocr.extractStringFromDictionary(response!)
                self.resultTextView.text = text
            }
        })

    }

    

}
