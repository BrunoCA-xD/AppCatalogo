//
//  GenericsDAO.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 10/08/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation
import FirebaseFirestore

class GenericsDAO {
    var db = Firestore.firestore()
    
    /// Transforms a firestore query result (list) into a T list, the T cclass needs to implement DatabaseManipulable protocol
    /// - Parameters:
    ///   - querySnapshot: firestore documents list
    ///   - error: firestore error
    ///   - completion: what to do with the result
    func handleDocuments<T: DatabaseManipulatable>(_ querySnapshot: QuerySnapshot?, _ error: Error?, completion: @escaping ([T]?,Error?) -> ()) {
        if let error = error {
            completion(nil, error)
        } else if let snapshot = querySnapshot {
            let resultList = snapshot.documents.compactMap{ (child) -> T? in
                if let interpreted = T.interpret(data: child.data() as NSDictionary) {
                    return interpreted
                }
                return nil
            }
            completion(resultList, nil)
        } else {
            completion(nil, nil)
        }
    }
    
    /// Transforms a firestore document into a T element, the T class needs to implement DatabaseManipulable protocol
    /// - Parameters:
    ///   - snapshot: firestore document (register, e.g: A line of a firestore table)
    ///   - error: firestore error
    ///   - completion: what to do with the result
    func handleSingleDocument<T: DatabaseManipulatable>(_ snapshot: DocumentSnapshot?, _ error: Error?, completion: @escaping (T?,Error?) -> ()) {
        
        if let error = error {
            completion(nil, error)
        }
        guard
            let snapshot = snapshot,
            let data = snapshot.data(),
            let interpreted = T.interpret(data: data as NSDictionary)
        else { completion(nil, nil) ; return }
        
        completion(interpreted, nil)
    }
}

enum ComparisonType{
    case equal
    case lessThan
    case lessThanOrEqual
    case greaterThan
    case greaterThanOrEqual
    case arrayContains
    case inArray
}


