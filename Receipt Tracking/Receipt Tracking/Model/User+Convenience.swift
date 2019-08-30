//
//  User+Convenience.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

extension User {
    @discardableResult convenience init(username: String, password: String, email: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.username = username
        self.password = password
        self.email = email
    }
    
    @discardableResult convenience init?(userRepresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.username = userRepresentation.username
        self.password = userRepresentation.password
        self.email = userRepresentation.email
    }
    
    var userRepresentation: UserRepresentation {
        return UserRepresentation(username: username, password: password, email: email)
    }
}
