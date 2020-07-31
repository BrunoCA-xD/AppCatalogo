//
//  DataManager.swift
//  TudoNosso
//
//  Created by Joao Flores on 31/07/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class CoreDataManager {

	func save(title: String,
			  units: String,
			  adds: String) {

		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let entity = NSEntityDescription.entity(forEntityName: "CurrentPurchase", in: managedContext)!
		let person = NSManagedObject(entity: entity, insertInto: managedContext)
		person.setValue(title, forKeyPath: "title")
		person.setValue(units, forKeyPath: "units")
		person.setValue(adds, forKeyPath: "adds")

		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
		}
	}

	func deleteAllRecords() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrentPurchase")
		if let result = try? managedContext.fetch(fetchRequest) {
			for object in result {
				managedContext.delete(object)
			}
		}

		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
}
