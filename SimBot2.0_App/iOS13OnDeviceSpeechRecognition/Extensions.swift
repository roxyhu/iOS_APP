//
//  Extensions.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by 魏廷昇 on 2020/8/18.
//  Copyright © 2020 iowncode. All rights reserved.
//

import Foundation


extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
