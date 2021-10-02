//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Владимир Втулкин on 02.10.2021.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var text: String
    @NSManaged public var id: UUID
    @NSManaged public var image: Data?

}

extension Note : Identifiable {

}
