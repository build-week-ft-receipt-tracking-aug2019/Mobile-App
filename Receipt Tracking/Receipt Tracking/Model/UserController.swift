//
//  UserController.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/26/19.
//  Copyright © 2019 jake connerly. All rights reserved.
// testing change to Jake

import Foundation
import CoreData

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError(Error)
    case badData
    case noDecode
    case noEncode
    case badResponse
}

enum LoginType: String {
    case signUp = "register"
    case signIn = "login"
}

class UserController {
    var token: String?
    var user: UserRepresentation?
    
    static let shared = UserController()
    
    let baseURL = URL(string: "https://receipt-tracker-api.herokuapp.com/")!
    
    func loginWith(user: UserRepresentation, loginType: LoginType, completion: @escaping (Result<String, NetworkError>) -> ()) {
        let requestURL = baseURL.appendingPathComponent("\(loginType.rawValue)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            print("error encoding: \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                print(response.statusCode)
                completion(.failure(.badResponse))
                return
            }
            
            if let error = error {
                completion(.failure(.otherError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let result = try jsonDecoder.decode(UserResult.self, from: data)
                self.token = result.token
                self.user = user
                let context = CoreDataStack.shared.mainContext
                
                context.performAndWait {
                    User(userRepresentation: self.user!)
                }
                
                try CoreDataStack.shared.save(context: context)
                if let token = self.token {
                    KeychainWrapper.standard.set(token, forKey: "token")
                    completion(.success(token))
                }
            } catch {
                print("error decoding data/token: \(error)")
                completion(.failure(.noDecode))
                return
            }
            }.resume()
    }
    
    func registerWith(user: UserRepresentation, loginType: LoginType, completion: @escaping (NetworkError?) -> ()) {
        let requestURL = baseURL.appendingPathComponent("\(loginType.rawValue)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            print("error encoding: \(error)")
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                print(response.statusCode)
                completion(.badResponse)
                return
            }
            
            if let error = error {
                completion(.otherError(error))
                return
            }
            
            guard let data = data else {
                completion(.badData)
                return
            }
            
            do {
                
                let id = try JSONDecoder().decode([Int].self, from: data)
                self.user = user
                print("\(id)")
                let context = CoreDataStack.shared.mainContext
                context.performAndWait {
                    User(userRepresentation: self.user!)
                }
                try CoreDataStack.shared.save(context: context)
            } catch {
                completion(.noDecode)
            }
            
            completion(nil)
            }.resume()
    }
}
