//  AnalyzeImageComputerVision.swift
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
 Analyze Image
 
This operation extracts a rich set of visual features based on the image content. 
 
 - You can try Image Analysation here: https://www.microsoft.com/cognitive-services/en-us/computer-vision-api
 
 */
class AnalyzeImage: NSObject {

    /// The url to perform the requests on
    let url = "https://api.projectoxford.ai/vision/v1.0/analyze"
    
    /// Your private API key. If you havn't changed it yet, go ahead!
    let key = CognitiveServicesApiKeys.ComputerVision.rawValue

    enum AnalyseImageErros: ErrorType {
        
        case ImageUrlWrongFormatted
        
        // Response 400
        case InvalidImageUrl
        case InvalidImageFormat
        case InvalidImageSize
        case NotSupportedVisualFeature
        case NotSupportedImage
        case InvalidDetails

        // Response 415
        case InvalidMediaType
        
        // Response 500
        case FailedToProcess
        case Timeout
        case InternalServerError
    }
    
    
    
    /**
     Used as a parameter for `recognizeCharactersOnImageUrl`
     
    Read more about it [here](https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa)
    */
    enum AnalyzeImageVisualFeatures: String {
        case None = ""
        case ImageType = "ImageType"
        case Color = "Color"
        case Faces = "Faces"
        case Adult = "Adult"
        case Categories = "Categories"
        case All = "All"
    }
    
    
    
    /**
    Used as a parameter for `recognizeCharactersOnImageUrl`
    
    Read more about it [here](https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa)
    */
    enum AnalyzeImageDetails: String {
        case None = ""
        case ImageType = "ImageType"
        case Celebrities = "Celebrities"
        case Faces = "Faces"
        case Adult = "Adult"
        case Categories = "Categories"
        case Color = "Color"
        case Tags = "Tags"
        case Description = "Description"
    }
 
    
    /**
     This operation extracts a rich set of visual features based on the image content.
     
     - parameter imageUrl: The Url of the image
     - parameter visualFeatures, details: Read more about those [here](https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa)
     - parameter completion: Once the request has been performed the response is returend as a JSON Object in the completion block.
     */
    func analyzeImageOnURL(imageURL: String, visualFeatures: AnalyzeImageVisualFeatures = .All, completion: (response: [String : AnyObject]?) -> Void) throws {

        //Query parameters
        let parameters = ["entities=true", "visualFeature=\(visualFeatures.rawValue)"].joinWithSeparator("&")
        let requestURL = NSURL(string: url + "?" + parameters)!
        
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "POST"

        // Request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        // Request body
        request.HTTPBody = "{\"url\":\"\(imageURL!)\"}".dataUsingEncoding(NSUTF8StringEncoding)
        
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
    
}
