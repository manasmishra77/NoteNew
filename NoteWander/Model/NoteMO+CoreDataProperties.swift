//
//  NoteMO+CoreDataProperties.swift
//  NoteWander
//
//  Created by Manas Mishra on 15/04/18.
//  Copyright © 2018 manas. All rights reserved.
//
//

import Foundation
import CoreData


extension NoteMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteMO> {
        return NSFetchRequest<NoteMO>(entityName: "Note")
    }

    @NSManaged public var title: String?
    @NSManaged public var noteDescription: String?
    @NSManaged public var updatedAt: NSDate?

}
