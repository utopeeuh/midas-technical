//
//  UserViewModel.swift
//  Midas Technical
//
//  Created by Tb. Daffa Amadeo Zhafrana on 08/03/23.
//

import Foundation
import CoreData

class UserViewModel {
    
    // Fetch all users
    func fetchAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try CoreDataStack.shared.persistentContainer.viewContext.fetch(fetchRequest)
            completion(.success(users))
        } catch {
            completion(.failure(error))
        }
    }
    
    // Update user data
    func updateUser(with id: UUID, username: String, email: String, type: UserType, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        context.perform {
            do {
                // Fetch user with the specified id
                let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                
                let users = try context.fetch(fetchRequest)
                guard let user = users.first else {
                    completion(.failure(CoreDataError.userNotFound))
                    return
                }
                
                // Update user data
                user.username = username
                user.email = email
                user.userType = type.rawValue
                
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Delete user data
    func deleteUser(with id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
            
        context.perform {
            do {
                // Fetch user with the specified id
                let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                
                let users = try context.fetch(fetchRequest)
                guard let user = users.first else {
                    completion(.failure(CoreDataError.userNotFound))
                    return
                }
                
                // Delete user
                context.delete(user)
                
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

enum CoreDataError: Error {
    case userNotFound
}
