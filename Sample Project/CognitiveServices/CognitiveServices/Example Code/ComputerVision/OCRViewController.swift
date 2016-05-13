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
    

    @IBAction func textFromUrlDidPush(sender: UIButton) {
        do {
            try ocr.recognizeCharactersOnImageUrl(urlTextField.text!, language: .Automatic) { (response) in
            
                let string = self.ocr.extractStringFromDictionary(response)
                self.resultTextView.text = string
                
            }
        } catch {
            print("Something went wrong")
        }
    }
    
    
    @IBAction func textFromImageDidPush(sender: UIButton) {
        do {
            try ocr.recognizeCharactersOnImageData(UIImagePNGRepresentation(UIImage(named: "ocrDemo")!)!, language: .Automatic, completion: { (response) in
                
                let string = self.ocr.extractStringFromDictionary(response!)
                self.resultTextView.text = string

                
            })
        } catch {
            print("Something went wrong")
        }
    }

    

}
