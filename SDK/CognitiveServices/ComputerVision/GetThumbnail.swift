//
//  GetThumbnail.swift
//  CognitiveServices
//
//  Created by Vladimir Danila on 4/14/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class GetThumbnail: NSObject {

    /// The url to perform the requests on
    let url = "https://api.projectoxford.ai/vision/v1.0/generateThumbnail[?width][&height][&smartCropping]"
    
    /// Your private API key. If you havn't changed it yet, go ahead!
    let key = CognitiveServicesApiKeys.ComputerVision.rawValue
    
}
