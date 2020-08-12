//
//  PortionDAO.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 10/08/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation

class PortionDAO: GenericsDAO {
    typealias managedEntity = Portion
    typealias managedFields = PortionFields
    let TABLENAME  = "portions"
    
    /// Saves or updates an element
    func save(element: inout managedEntity) {
        if let id = element.id {//updates
            db.collection(TABLENAME).document(id).setData(element.representation)
        }else { //saves/creates
            let doc = self.db.collection(self.TABLENAME).document()
            element.id = doc.documentID
            db.collection(TABLENAME).document(doc.documentID).setData(element.representation)
        }
    }
    
    /// Deletes an element using its id
    func delete(element: managedEntity) {
        db.collection(TABLENAME).document(element.id!).delete { error in
            if let error = error {
                print("error deleting snackL \(error.localizedDescription)")
            }
        }
    }
    
    /// Lists all elements
    /// - Parameter completion: what to do with the list
    func listAll(completion: @escaping ([managedEntity]?, Error?) -> ()) {
        db.collection(TABLENAME).getDocuments { (snapshot, error) in
            self.handleDocuments(snapshot, error, completion: completion)
        }
    }
    
    /// Finds N elements that matches field values given a comparison
    /// - Parameters:
    ///   - field: What  field to compare
    ///   - type: how to compare (e.g: greaterThan, equal)
    ///   - value: what is expected to match
    ///   - completion: what to do with the result
    func find(inField field: managedFields, comparisonType type: ComparisonType, withValue value: Any, completion: @escaping ([managedEntity]?,Error?) ->()) {
        switch type {
        case .equal:
            db.collection(TABLENAME).whereField(field.rawValue, isEqualTo: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        case .lessThan:
            db.collection(TABLENAME).whereField(field.rawValue, isLessThan: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        case .lessThanOrEqual:
            db.collection(TABLENAME).whereField(field.rawValue, isLessThanOrEqualTo: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        case .greaterThan:
            db.collection(TABLENAME).whereField(field.rawValue, isGreaterThan:  value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        case .greaterThanOrEqual:
            db.collection(TABLENAME).whereField(field.rawValue, isGreaterThanOrEqualTo:  value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        case .arrayContains:
            db.collection(TABLENAME).whereField(field.rawValue, arrayContains: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        case .inArray:
            guard let array = value as? Array<Any> else {fatalError("not an array")}
            db.collection(TABLENAME).whereField(field.rawValue, in: array).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        }
    }
}

extension PortionDAO: StorageAccessor {
    var storageName: String {TABLENAME}
}
