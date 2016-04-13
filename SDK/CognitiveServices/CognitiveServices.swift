//
//  CognitiveServices.swift
//  Hackathon
//
//  Created by Vladimir Danila on 4/7/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit


/** WARNING: - Put your own keys in here
  Get your keys [here](https://www.microsoft.com/cognitive-services/)
*/
enum CognitiveServicesApiKeys: String {
    
    // Vision
    case ComputerVision = "ComputerVision Key"
    case Emotion = "Emotion Key"
    case Face = "Face Key"
    case Video = "Video Key"
    
    
    // Speech
    case CustomRecognition = "CustomRecognition Key"
    case SpeakerRecognition = "SpeakerRecognition Key"
    case Speech = "Speech Key"
    case Language = "Language Key"
    
    
    // Language
    case BingSpellCheck = "BingSpellCheck Key"
    case LanguageUnderstanding = "LanguageUnderstanding Key"
    case LinguisticAnalysis = "LinguisticAnalysis Key"
    case TextAnalytics = "TextAnalytics Key"
    case WebLM = "WebLM Key"
    
    
    
    // TODO: - Finish here 
    
    
    
    // Knowledge
    
    
    // Search
    
    
    
}

/**
 Microsoft Cognitive Services (formerly Project Oxford) are a set of APIs, SDKs and services available to developers to make their applications more intelligent, engaging and discoverable. Microsoft Cognitive Services expands on Microsoft’s evolving portfolio of machine learning APIs and enables developers to easily add intelligent features – such as emotion and video detection; facial, speech and vision recognition; and speech and language understanding – into their applications. Our vision is for more personal computing experiences and enhanced productivity aided by systems that increasingly can see, hear, speak, understand and even begin to reason.
 */

class CognitiveServices: NSObject {
    static let sharedInstance = CognitiveServices()
    
    let ocr = OcrComputerVision()
    let analyzeImage = AnalyzeImage()
}
