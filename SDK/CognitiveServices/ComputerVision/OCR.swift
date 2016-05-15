//  OcrComputerVision.swift
//
//  Copyright (c) 2016 Vladimir Danila
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


import UIKit


/**
 Title Read text in images
 
 Optical Character Recognition (OCR) detects text in an image and extracts the recognized words into a machine-readable character stream. Analyze images to detect embedded text, generate character streams and enable searching. Allow users to take photos of text instead of copying to save time and effort.
 
 - You can try OCR here: https://www.microsoft.com/cognitive-services/en-us/computer-vision-api
 
 */
class OcrComputerVision: NSObject {

    /// The url to perform the requests on
    let url = "https://api.projectoxford.ai/vision/v1.0/ocr"
    
    /// Your private API key. If you havn't changed it yet, go ahead!
    let key = CognitiveServicesApiKeys.ComputerVision.rawValue
    
    
    /// Detectable Languages
    enum Langunages: String {
        case Automatic = "unk"
        case ChineseSimplified = "zh-Hans"
        case ChineseTraditional = "zh-Hant"
        case Czech = "cs"
        case Danish = "da"
        case Dutch = "nl"
        case English = "en"
        case Finnish = "fi"
        case French = "fr"
        case German = "de"
        case Greek = "el"
        case Hungarian = "hu"
        case Italian = "it"
        case Japanese = "Ja"
        case Korean = "ko"
        case Norwegian = "nb"
        case Polish = "pl"
        case Portuguese = "pt"
        case Russian = "ru"
        case Spanish = "es"
        case Swedish = "sv"
        case Turkish = "tr"
    }
    
    
    enum RecognizeCharactersErrors: ErrorType {
        case UnknownError
        case ImageUrlWrongFormatted
        case EmptyDictionary
    }
    
    
    
    
    
    /**
     Optical Character Recognition (OCR) detects text in an image and extracts the recognized characters into a machine-usable character stream.
     
     - parameter imageUrl: The Url of the image
     - parameter language: The languange
     - parameter completion: Once the request has been performed the response is returend in the completion block.
     */
    func recognizeCharactersOnImageUrl(imageUrl: String, language: Langunages, detectOrientation: Bool = true, completion: (response: [String:AnyObject] ) -> Void) throws {
        
        // Generate the url
        let requestUrlString = url + "?language=" + language.rawValue + "&detectOrientation%20=\(detectOrientation)"
        let requestUrl = NSURL(string: requestUrlString)
        
        // Set the request headers
        let headers: [String : String] = [
            "Content-Type" : "application/json",
            "Ocp-Apim-Subscription-Key" : key
        ]
        
        // Check if 'imageUrl' is formatted as an url
        guard let _ = NSURL(string: imageUrl) else {
            throw RecognizeCharactersErrors.ImageUrlWrongFormatted
        }
        
        
        // Set the request parameters
        let parameters: [String : AnyObject] = [
            "url" : imageUrl
        ]
        
        
        // Perform the request
        request(.POST, requestUrl!, headers: headers, parameters: parameters, encoding: .JSON)
        .responseData { response in
            
            // Check if data is empty
            guard let data = response.data else {
                return
            }
            
            
            let responseDictionary = data.convertJSONToDictionary()
            
            completion(response: responseDictionary!)
            
        }
        
    }
  
    
    // TODO: - Implementation Missing
    
    
    /**
     Optical Character Recognition (OCR) detects text in an image and extracts the recognized characters into a machine-usable character stream.
     
     - parameter imageData: The data of the image
     - parameter language: The languange
     - parameter completion: Once the request has been performed the response is returend in the completion block.
     */
    func recognizeCharactersOnImageData(imageData: NSData, language: Langunages, detectOrientation: Bool = true, completion: (response: [String:AnyObject]? ) -> Void) throws {

        // Generate the url
        let requestUrlString = url + "?language=" + language.rawValue + "&detectOrientation%20=\(detectOrientation)"
        let requestUrl = NSURL(string: requestUrlString)
        
        
        let request = NSMutableURLRequest(URL: requestUrl!)
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.setValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.HTTPBody = imageData
        request.HTTPMethod = "POST"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                completion(response: nil)
                return
            }else{
                let results = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
                
                // Hand dict over
                dispatch_async(dispatch_get_main_queue()) {
                    completion(response: results)
                }
            }
            
        }
        task.resume()

    }
        
        
        
    

    /**
     Returns an Array of Strings extracted from the Dictionary generated from `recognizeCharactersOnImageUrl()`
     
     - Parameter dictionary:   The Dictionary created by `recognizeCharactersOnImageUrl()`.
     
     - Returns: An String Array extracted from the Dictionary.
     */
    func extractStringsFromDictionary(dictionary: [String : AnyObject]) -> [String] {
        
        // Get Regions from the dictionary
        let regions = (dictionary["regions"] as! NSArray)[0] as? [String:AnyObject]
        
        // Get lines from the regions dictionary
        let lines = regions!["lines"] as! NSArray
        
        // Get words from lines
        let inLine = lines.enumerate().map {$0.element["words"] as! [[String : AnyObject]] }
        
        // Get text from words
        let extractedText = inLine.enumerate().map { $0.element[0]["text"] as! String}
        
        return extractedText
    }
    
    /**
     Returns a String extracted from the Dictionary generated from `recognizeCharactersOnImageUrl()`
     
     - Parameter dictionary:   The Dictionary created by `recognizeCharactersOnImageUrl()`.
     
     - Returns: A String extracted from the Dictionary.
     */
    func extractStringFromDictionary(dictionary: [String:AnyObject]) -> String {
        
        let stringArray = extractStringsFromDictionary(dictionary)
        
        let reducedArray = stringArray.enumerate().reduce("", combine:
            {
                $0 + $1.element + ($1.index < stringArray.endIndex-1 ? " " : "")
            }
        )
        return reducedArray
    }
    
}
