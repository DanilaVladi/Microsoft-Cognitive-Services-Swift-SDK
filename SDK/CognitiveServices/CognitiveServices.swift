//  CognitiveServices.swift
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
}

/**
 Microsoft Cognitive Services (formerly Project Oxford) are a set of APIs, SDKs and services available to developers to make their applications more intelligent, engaging and discoverable. Microsoft Cognitive Services expands on Microsoft’s evolving portfolio of machine learning APIs and enables developers to easily add intelligent features – such as emotion and video detection; facial, speech and vision recognition; and speech and language understanding – into their applications. Our vision is for more personal computing experiences and enhanced productivity aided by systems that increasingly can see, hear, speak, understand and even begin to reason.
 */
class CognitiveServices: NSObject {
    static let sharedInstance = CognitiveServices()
    
    let ocr = OCR()
    let analyzeImage = AnalyzeImage()
}
