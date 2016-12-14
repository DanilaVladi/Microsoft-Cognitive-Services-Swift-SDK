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


import Foundation
import UIKit
import CoreGraphics

protocol AnalyzeImageDelegate {

	/// Images that contain faces will be analyzed further for the emotions contained in the image. Since that might take longer than the initially returned object this delegate is recommended. 
    func finnishedGeneratingObject(_ analyzeImageObject: AnalyzeImage.AnalyzeImageObject)
}

/**
 RequestObject is the required parameter for the AnalyzeImage API containing all required information to perform a request
 - parameter resource: The path or data of the image or
 - parameter visualFeatures, details: Read more about those [here](https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa)
 */
typealias AnalyzeImageRequestObject = (resource: Any, visualFeatures: [AnalyzeImage.AnalyzeImageVisualFeatures])

/**
 Analyze Image
 
 This operation extracts a rich set of visual features based on the image content.
 
 - You can try Image Analysation here: https://www.microsoft.com/cognitive-services/en-us/computer-vision-api
 
 */
class AnalyzeImage: NSObject {
    
    
    var delegate: AnalyzeImageDelegate?
    
    
    final class AnalyzeImageObject {
        
        
        // Categories
        var categories: [[String : AnyObject]]?
        
        // Faces
        var faces: [FaceObject]? = []
        
        // Metadata
        var rawMetaData: [String : AnyObject]?
        var imageSize: CGSize?
        var imageFormat: String?
        
        // ImageType
        var imageType: (clipArtType: Int?, lineDrawingType: Int?)?
        
        
        // Description
        var rawDescription: [String : AnyObject]?
        var rawDescriptionCaptions: [String : AnyObject]?
        var descriptionText: String?
        var descriptionTextConfidence: Float?
        var tags: [String]?
        
        // Color
        var blackAndWhite: Bool?
        var dominantColors: [String]?
        var accentColorHex: String?
        var dominantForegroundColor: String?
        var dominantBackgroundColor: String?
        
        
        var isAdultContent: Bool?
        var adultScore: Float?
        var isRacyContent: Bool?
        var racyContentScore: Float?
        
        
        var imageData: Data!
        var rawDict: [String : AnyObject]?
        var requestID: String?
        
        
        // Intern Object classes
        typealias FaceObject = FaceStruct
        struct FaceStruct {
            let age: Int?
            let gender: String?
            let faceRectangle: CGRect?
            let emotion: String?
        }
        
    }
    
    
    /// The url to perform the requests on
    final let url = "https://api.projectoxford.ai/vision/v1.0/analyze"
    
    /// Your private API key. If you havn't changed it yet, go ahead!
    let key = CognitiveServicesApiKeys.ComputerVision.rawValue
    
    enum AnalyzeImageErros: Error {
        
        case error(code: String, message: String)
        case invalidImageFormat(message: String)
        
        // Unknown Error
        case unknown(message: String)
    }
    

    /**
     Used as a parameter for `recognizeCharactersOnImageUrl`
     
     Read more about it [here](https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa)
     */
    enum AnalyzeImageVisualFeatures: String {
        case None = ""
        case Categories = "Categories"
        case Tags = "Tags"
        case Description = "Description"
        case Faces = "Faces"
        case ImageType = "ImageType"
        case Color = "Color"
        case Adult = "Adult"
    }
    
    
    
    /**
     Used as a parameter for `recognizeCharactersOnImageUrl`
     
     Read more about it [here](https://dev.projectoxford.ai/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa)
     */
    enum AnalyzeImageDetails: String {
        case None = ""
        case Description = "Description"
    }

    final func analyzeImageWithRequestObject(_ requestObject: AnalyzeImageRequestObject, completion: @escaping (_ response: AnalyzeImageObject?) -> Void) throws {
        
        if key == "ComputerVision Key" {
            assertionFailure("Enter your ComputerVision API key first")
        }

        // Query parameters
        let visualFeatures = requestObject.visualFeatures
            .map {$0.rawValue}
            .joined(separator: ",")
        
        let parameters = ["visualFeatures=\(visualFeatures)"].joined(separator: "&")
        let requestURL = URL(string: url + "?" + parameters)!
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        
        // Request Parameter
        if let path = requestObject.resource as? String {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"url\":\"\(path)\"}".data(using: String.Encoding.utf8)
        }
        else if let imageData = requestObject.resource as? Data {
            request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            request.httpBody = imageData
        }
        else if let image = requestObject.resource as? UIImage {
            request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            let imageData = UIImageJPEGRepresentation(image, 0.7)
            request.httpBody = imageData
        }
        else {
            throw AnalyzeImageErros.invalidImageFormat(message: "[Swift SDK] Input data is not a valid image.")
        }
        
        let imageData = request.httpBody!
        request.setValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        let started = Date()
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                completion(nil)
                return
            } else {
                
                let results = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                let analyzeObject = self.objectFromDict(results, data: imageData)
                
                let interval = Date().timeIntervalSince(started)
                print(interval)
                
                // Hand dict over
                DispatchQueue.main.async {
                    completion(analyzeObject)
                }
            }
            
        }

        task.resume()
    }

    private func objectFromDict(_ dict: [String : AnyObject]?, data: Data) -> AnalyzeImageObject {
        let analyzeObject = AnalyzeImageObject()
        
        analyzeObject.rawDict = dict
        analyzeObject.imageData = data
        
        if let categories = dict?["categories"] as? [[String : AnyObject]] {
            analyzeObject.categories = categories
        }
        
        var containsFaces = false
        if let faces = dict?["faces"] as? [[String : AnyObject]] {
            containsFaces = faces.count != 0
            
            if faces.count >= 1 {
                analyzeObject.getEmotions({ emotionFaces in
                    
                    faces.enumerated().forEach({ faceDict in
                        
                        let emotionFace = emotionFaces![faceDict.offset]
                        
                        
                        // Analyze Image face
                        let age = faceDict.element["age"] as? Int
                        let gender = faceDict.element["gender"] as? String
                        let emotionFaceRectangle = emotionFace["faceRectangle"] as? [String : CGFloat]
                        var rect: CGRect? {
                            if let left = emotionFaceRectangle?["left"],
                                let top = emotionFaceRectangle?["top"],
                                let width = emotionFaceRectangle?["width"],
                                let height = emotionFaceRectangle?["height"] {
                                
                                return CGRect(x: left, y: top, width: width, height: height)
                            }
                            
                            return nil
                        }
                        
                        
                        let emotions = emotionFace["scores"] as? [String : AnyObject]
                        
                        let sortedEmotions = emotions?.sorted { (val1, val2) -> Bool in
                            return val1.1 as! Float > val2.1 as! Float
                            }.map {
                                $0.0
                        }
                        
                        print("Sorted emotions: " + sortedEmotions!.description)
                        
                        let primaryEmotion = sortedEmotions?.first
                        print("Primary Emotion :" + primaryEmotion!)
                        
                        let face = AnalyzeImageObject.FaceObject (
                            age: age,
                            gender: gender,
                            faceRectangle: rect,
                            emotion: primaryEmotion
                        )
                        
                        analyzeObject.faces?.append(face)
                    })
                    
                    self.delegate?.finnishedGeneratingObject(analyzeObject)
                })
            }
        }
        
        
        analyzeObject.requestID = dict?["requestId"] as? String
        
        
        // Medadata values
        if let metaData = dict?["metadata"] as? [String : AnyObject] {
            analyzeObject.rawMetaData = metaData
            
            if let width = metaData["width"] as? CGFloat,
                let height = metaData["height"] as? CGFloat {
                
                analyzeObject.imageSize = CGSize(width: width, height: height)
            }
            
            analyzeObject.imageFormat = metaData["format"] as? String
        }
        
        
        if let imageType = dict?["imageType"] as? [String : Int] {
            analyzeObject.imageType = (imageType["clipArtType"], imageType["lineDrawingType"])
        }
        
        // Description values
        if let description = dict?["description"] as? [String : AnyObject] {
            
            analyzeObject.rawDescription = description
            analyzeObject.tags = description["tags"] as? [String]
            
            // Captions values
            if let captionsRaw = description["captions"] as? NSArray {
                let captions = captionsRaw.firstObject as? [String : AnyObject]
                analyzeObject.rawDescriptionCaptions = captions
                
                analyzeObject.descriptionText = captions?["text"] as? String
            }
            
        }
        
        if let color = dict?["color"] as? [String : AnyObject] {
            analyzeObject.blackAndWhite = color["isBWImg"] as? Bool
            analyzeObject.dominantForegroundColor = color["dominantColorForeground"] as? String
            analyzeObject.dominantBackgroundColor = color["dominantColorBackground"] as? String
            analyzeObject.dominantColors = color["dominantColors"] as? [String]
            analyzeObject.accentColorHex = color["accentColor"] as? String
        }
        
        
        if containsFaces == false {
            delegate?.finnishedGeneratingObject(analyzeObject)
        }
        
        return analyzeObject
        
    }
    
}

extension AnalyzeImage.AnalyzeImageObject {
    
    func getEmotions(_ completion: @escaping (_ response: [[String : AnyObject]]?) -> Void) {

        let path = "https://api.projectoxford.ai/emotion/v1.0/recognize"
        
        let requestURL = URL(string: path)!
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        // Request Parameter
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpBody = self.imageData
        
        let key = CognitiveServicesApiKeys.Emotion.rawValue
        
        if key == "Emotion Key" {
            assertionFailure("Enter your Emotion API key")
        }

        request.setValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                completion(nil)
                return
            } else {

				if let results = try! JSONSerialization.jsonObject(with: data!, options: []) as? [[String : AnyObject]] {
					// Hand dict over
					DispatchQueue.main.async {
						completion(results)
					}
				}
				else {
					print((try! JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]) ?? "Something went wrong with the Emotion API")
				}
            }
            
        }
        task.resume()
    }
}

extension AnalyzeImage.AnalyzeImageObject {
    
    class func createTestFace() -> FaceObject {
        
        let emotions = ["Neutral", "Happy", "Bored", "Excited"]
        
        let face = FaceObject(
            age: Int(arc4random_uniform(60)),
            gender: "Male",
            faceRectangle: CGRect(x: 0, y: 0, width: 400, height: 400),
            emotion: emotions[Int(arc4random_uniform(UInt32(emotions.count - 1)))]
        )
        
        return face
    }
    
}
