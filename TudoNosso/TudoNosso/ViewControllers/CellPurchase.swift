//
//  cellPurchase.swift
//  TudoNosso
//
//  Created by Joao Flores on 31/07/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import CoreData

class CellPurchase: UITableViewCell {

	var dictPrice =
		[
			"Bacon Cheddar": 22,
			"Pepperoni Venture": 22,
			"Rogger Egg": 22,
			"Rogger Onion": 25,
			"Rogger Pepperoni": 25,

			"Duplo Salada": 40,
			"Duplo Burguer": 40,
			"Triplo Cheese": 40,
			"Duplo Cheddar": 40,

			"Refrigerante": 5,
			"Cerveja": 8,
			"Água": 5
	]

	@IBOutlet weak var deleteButton: UIButton!

	@IBOutlet weak var unitsItem: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var additionalsLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!

	var priceUnit = 0

	@IBAction func AddButton(_ sender: Any) {
		unitsItem.text = String(Int(unitsItem.text!)! + 1)
		priceLabel.text = "R$ " + String(priceUnit * Int(unitsItem.text!)!)
	}

	@IBAction func subButton(_ sender: Any) {
		if(Int(unitsItem.text!)! > 1) {
			unitsItem.text = String(Int(unitsItem.text!)! - 1)
			priceLabel.text = "R$ " + String(priceUnit * Int(unitsItem.text!)!)
		}
	}

}
