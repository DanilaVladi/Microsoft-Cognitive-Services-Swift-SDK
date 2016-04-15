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
    func recognizeCharactersOnImageUrl(imageUrl: String, visualFeatures: AnalyzeImageVisualFeatures = .All, details: AnalyzeImageDetails = .Categories, completion: (response: JSON) -> Void) throws {
     
        // Create the Query parameters
        var computedVisualFeatures: String {
            if visualFeatures != .None {
                return  "visualFeatures=" + visualFeatures.rawValue
            }
            else {
                return ""
            }
        }
        
        var computedDetails: String {
            
            if details != .None {
                return "details=" + details.rawValue
            }
            else {
                return ""
            }
            
        }
        
        var qMark: String {
            if computedDetails.isEmpty != false || computedVisualFeatures.isEmpty != false {
                return "?"
            }
            else {
                return ""
            }
        }
        
        // Generate the url
        let requestUrlString = url + qMark + computedVisualFeatures + computedDetails
        let requestUrl = NSURL(string: requestUrlString)

        
        // Set the request headers
        let headers: [String : String] = [
            "Content-Type" : "application/json",
            "Ocp-Apim-Subscription-Key" : key
        ]
        
        // Check if 'imageUrl' is formatted as an url
        guard let _ = NSURL(string: imageUrl) else {
            throw AnalyseImageErros.ImageUrlWrongFormatted
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
                
                
                let responseJson = JSON(data: data)
                
                completion(response: responseJson)
                
                
        }
        
        
    }
    
}
