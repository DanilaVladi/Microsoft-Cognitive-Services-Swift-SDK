//
//  StringExtension.swift
//  CognitiveServices
//
//  Created by Vladimir Danila on 16/05/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation
import AVFoundation

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
    
    
    func speak() -> AVSpeechSynthesizer {
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
        try! audioSession.setActive(true)
        
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance = AVSpeechUtterance(string: self)
        
        let defaultVoice = AVSpeechSynthesisVoice(language: "en-US")
        speechUtterance.voice = defaultVoice
        
        speechSynthesizer.speak(speechUtterance)
        return speechSynthesizer
        
    }
    
}
