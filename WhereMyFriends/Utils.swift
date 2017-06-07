//
//  Utils.swift
//  WhereMyFriends
//
//  Created by Anton Pavlov on 06.06.17.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//

import Foundation

func formatDate(date:Date) -> String {
    let dateFormator  = DateFormatter()
    
    dateFormator.dateStyle = DateFormatter.Style.full
    return dateFormator.string(for: date)!
    
}
