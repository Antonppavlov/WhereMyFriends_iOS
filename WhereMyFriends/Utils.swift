//
//  Utils.swift
//  WhereMyFriends
//
//  Created by Anton Pavlov on 06.06.17.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//
import UIKit
import Foundation

func formatDate(date:Date) -> String {
    let dateFormator  = DateFormatter()
    
    dateFormator.dateStyle = DateFormatter.Style.full
    return dateFormator.string(for: date)!
    
}
func format(phoneNumber s: String) -> String {

//    let s2 = String(format: "%@ (%@) %@ %@ %@", s.substringToIndex(s.startIndex.advancedBy(1)),
//                    s.substringWithRange(s.startIndex.advancedBy(1) ... s.startIndex.advancedBy(3)),
//                    s.substringWithRange(s.startIndex.advancedBy(4) ... s.startIndex.advancedBy(6)),
//                    s.substringWithRange(s.startIndex.advancedBy(7) ... s.startIndex.advancedBy(8)),
//                    s.substringWithRange(s.startIndex.advancedBy(9) ... s.startIndex.advancedBy(10))
//    )
//    
    return s
}


//MARK: Populate Image
func populateImage(imageString: String) ->UIImage{
    let decodedData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
    let decodedImage = UIImage(data: decodedData!)
    return decodedImage!
}





