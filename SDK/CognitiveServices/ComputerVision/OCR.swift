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


import Foundation


/**
 RequestObject is the required parameter for the OCR API containing all required information to perform a request
 - parameter resource: The path or data of the image or
 - parameter language, detectOrientation: Read more about those [here](https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa)
 */
typealias OCRRequestObject = (resource: Any, language: OCR.Langunages, detectOrientation: Bool)


/**
 Title Read text in images
 
 Optical Character Recognition (OCR) detects text in an image and extracts the recognized words into a machine-readable character stream. Analyze images to detect embedded text, generate character streams and enable searching. Allow users to take photos of text instead of copying to save time and effort.
 
 - You can try OCR here: https://www.microsoft.com/cognitive-services/en-us/computer-vision-api
 
 */
class OCR: NSObject {
    
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
    
    enum RecognizeCharactersErrors: Error {
        case unknownError
        case imageUrlWrongFormatted
        case emptyDictionary
    }
    
    /**
     Optical Character Recognition (OCR) detects text in an image and extracts the recognized characters into a machine-usable character stream.
     - parameter requestObject: The required information required to perform a request
     - parameter language: The languange
     - parameter completion: Once the request has been performed the response is returend in the completion block.
     */
    func recognizeCharactersWithRequestObject(_ requestObject: OCRRequestObject, completion: @escaping (_ response: [String:AnyObject]? ) -> Void) throws {

        // Generate the url
        let requestUrlString = url + "?language=" + requestObject.language.rawValue + "&detectOrientation%20=\(requestObject.detectOrientation)"
        let requestUrl = URL(string: requestUrlString)
        
        
        var request = URLRequest(url: requestUrl!)
        request.setValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        // Request Parameter
        if let path = requestObject.resource as? String {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"url\":\"\(path)\"}".data(using: String.Encoding.utf8)
        }
        else if let imageData = requestObject.resource as? Data {
            request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            request.httpBody = imageData
        }
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                completion(nil)
                return
            }else{
                let results = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                
                // Hand dict over
                DispatchQueue.main.async {
                    completion(results)
                }
            }
            
        }
        task.resume()
        
    }
    
	/**
     Returns an Array of Strings extracted from the Dictionary generated from `recognizeCharactersOnImageUrl()`
     - Parameter dictionary: The Dictionary created by `recognizeCharactersOnImageUrl()`.
     - Returns: An String Array extracted from the Dictionary.
     */
    func extractStringsFromDictionary(_ dictionary: [String : AnyObject]) -> [String] {
        
        // Get Regions from the dictionary
        let regions = (dictionary["regions"] as! NSArray).firstObject as? [String:AnyObject]
        
        // Get lines from the regions dictionary
        let lines = regions!["lines"] as! NSArray


        // TODO: Check if this works

        // Get words from lines
        let inLine = lines.enumerated().map {($0.element as? NSDictionary)?["words"] as! [[String : AnyObject]] }
        
        // Get text from words
        let extractedText = inLine.enumerated().map { $0.element[0]["text"] as! String}

        return extractedText
    }
    
    /**
     Returns a String extracted from the Dictionary generated from `recognizeCharactersOnImageUrl()`
     - Parameter dictionary: The Dictionary created by `recognizeCharactersOnImageUrl()`.
     - Returns: A String extracted from the Dictionary.
     */
    func extractStringFromDictionary(_ dictionary: [String:AnyObject]) -> String {
        
        let stringArray = extractStringsFromDictionary(dictionary)
        
        let reducedArray = stringArray.enumerated().reduce("", {
                $0 + $1.element + ($1.offset < stringArray.endIndex-1 ? " " : "")
            }
        )
        return reducedArray
    }
    
}
