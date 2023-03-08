//
//  AuthenticationViewModel.swift
//  Midas Technical
//
//  Created by Tb. Daffa Amadeo Zhafrana on 08/03/23.
//

import Foundation
import CoreData
import CommonCrypto
import UIKit

class AuthViewModel {
    var username: String?
    var email: String?
    var password: String?
    var userType: UserType = .user
    
    var nextViewController: UIViewController?
    
    // MARK: - Public functions
    
    func signIn(with email: String, password: String, completion: @escaping (Bool, Error?, UIViewController?) -> Void) {
        // Validate the user's input
        guard !email.isEmpty, !password.isEmpty else {
            completion(false, SignInError.emptyInput, nil)
            return
        }
        
        // Check if the user exists in Core Data
        let request: NSFetchRequest<User> = User.fetchRequest()

        request.predicate = NSPredicate(format: "email = %@", email)
        do {
            let results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            guard let user = results.first else {
                completion(false, SignInError.invalidCredentials, nil)
                return
            }
            if user.password == hashPassword(password: password) {
                nextViewController = user.userType == UserType.user.rawValue ? PictureViewController() : UserListViewController()
                completion(true, nil, nextViewController)
                
            } else {
                completion(false, SignInError.invalidCredentials, nil)
            }
        } catch {
            completion(false, error, nil)
        }
    }
    
    func saveUser(completion: @escaping (Error?) -> Void) {
            
        guard let username = username, let email = email, let password = password else { return }
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        // Check for email format
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)

        if !emailPredicate.evaluate(with: email) {
            // The email address is invalid
            let error = NSError(domain: "com.example.AuthViewModel", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Email format is incorrect"
            ])
            completion(error)
            return
        }
        
        // Check if there is already a user with the same email or username
        let request = NSFetchRequest<User>(entityName: "UserEntity")
        request.predicate = NSPredicate(format: "email == %@ OR username == %@", email, username)
        
        do {
            let existingUsers = try context.fetch(request)
            if existingUsers.count > 0 {
                // There is already a user with the same email or username
                let error = NSError(domain: "com.example.AuthViewModel", code: 1, userInfo: [
                    NSLocalizedDescriptionKey: "A user with the same email or username already exists."
                ])
                completion(error)
                return
            }
        } catch let error as NSError {
            completion(error)
            return
        }
        
        // Create a new User entity
        let newUser = User(context: context)
        newUser.id = UUID()
        newUser.username = username
        newUser.email = email
        newUser.password = hashPassword(password: password)
        newUser.userType = userType.rawValue
        
        // Save the changes to Core Data
        do {
            try context.save()
            completion(nil)
        } catch let error as NSError {
            completion(error)
        }
    }
    
    private func hashPassword(password: String) -> String {
        if let data = password.data(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            data.withUnsafeBytes {
                _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
            }
            let hashedData = Data(digest)
            return hashedData.base64EncodedString()
        }
        return ""
    }
}

enum SignInError: Error {
    case emptyInput
    case invalidCredentials
}
