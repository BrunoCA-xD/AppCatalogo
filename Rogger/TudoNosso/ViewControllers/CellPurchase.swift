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

	@IBOutlet weak var deleteButton: UIButton!

	@IBOutlet weak var unitsItem: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var additionalsLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!


	@IBAction func AddButton(_ sender: Any) {
		unitsItem.text = String(Int(unitsItem.text!)! + 1)
	}

	@IBAction func subButton(_ sender: Any) {
		if(Int(unitsItem.text!)! > 1) {
			unitsItem.text = String(Int(unitsItem.text!)! - 1)
		}
	}

}
