//
//  ViewController.swift
//  CognitiveServices
//
//  Created by Vladimir Danila on 13/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let cognitiveServices = CognitiveServices.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - ComputerVision Examples
    

    @IBAction func recognizeCharactersOnImageDidPush(sender: AnyObject) {
        
        let urlString = "http://digitalsynopsis.com/wp-content/uploads/2015/03/web-designer-developer-jokes-humour-funny-34.jpg"
        
        do {
            try cognitiveServices.ocr.recognizeCharactersOnImageUrl(urlString, language: .Automatic, completion: { response in
            
                let string = self.cognitiveServices.ocr.extractStringFromDictionary(response)
                print(string)
                
            })
        }
        catch {
            print("Something went wrong")
        }
    
    
    }

}

