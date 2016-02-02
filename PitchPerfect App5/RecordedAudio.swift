//
//  RecordedAudio.swift
//  Pitch Perfect 
//
//  Created by Shanmathi Mayuram Krithivasan on 11/20/15.
//  Copyright © 2015 Shanmathi Mayuram Krithivasan. All rights reserved.
//

import Foundation
//Class to save the audio file attributes: Url of the path and the title.
class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl:NSURL,title:String){
        self.filePathUrl = filePathUrl
        self.title = title
        super.init()
    }
}
