//
//  User.swift
//  Midas Technical
//
//  Created by Tb. Daffa Amadeo Zhafrana on 08/03/23.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

    @NSManaged public var id: UUID
    @NSManaged public var username: String
    @NSManaged public var email: String
    @NSManaged public var password: String
    @NSManaged public var userType: Int16
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "UserEntity")
    }
}

enum UserType: Int16 {
    case admin = 0
    case user = 1
}
