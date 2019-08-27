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
    @discardableResult convenience init(username: String?, password: String?, email: String?, identifier: Int32?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.username = username
        self.password = password
        self.email = email
        self.identifier = identifier!
    }
    
    @discardableResult convenience init?(userRepresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        guard let id = userRepresentation.identifier else { return nil }
        
        self.username = userRepresentation.username
        self.password = userRepresentation.password
        self.email = userRepresentation.email
        self.identifier = Int32(id)
    }
    
    var userRepresentation: UserRepresentation {
        return UserRepresentation(username: username, password: password, email: email, identifier: Int(identifier))
    }
}
