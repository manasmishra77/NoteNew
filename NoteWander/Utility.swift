//
//  Utility.swift
//  NoteWander
//
//  Created by Manas Mishra on 14/04/18.
//  Copyright © 2018 manas. All rights reserved.
//

import Foundation

enum DateFormatType: String {
    /// Time
    case time = "HH:mm:ss"
    
    /// Date with hours
    case dateWithTime = "yyyy-MM-dd HH:mm:ss"
    
    /// Date
    case date = "dd-MMM-yyyy"
   
}
extension String
{
    func dropLast(_ n: Int = 1) -> String {
        return String(characters.dropLast(n))
    }
    var dropLast: String {
        return dropLast()
    }
    
}

