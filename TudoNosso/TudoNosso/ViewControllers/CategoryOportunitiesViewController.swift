//
//  CategoryOportunitiesViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 11/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit
class CategoryOportunitiesViewController : UIViewController,UISearchBarDelegate {

	//MARK: - Variables
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
			"Duplo Cheddar": 40
	]

	var dictDescription =
		[
			"Bacon Cheddar":
			"Alface americana, tomate, milho, cebola, hamburguer premium 200grs, mussarela, porção grande de bacon, maionese, catchup, mostarda.",

			"Pepperoni Venture":
			"Alface americana, tomate, milho, cebola, hamburguer premium 200grs, mussarela, bacon, maionese, catchup, mostarda, provolone e catupiry.",

			"Rogger Egg":
			"Alface americana, tomate, milho, cebola, bacon, hamburguer premium de 200 grs, mussarela, ovo, salsicha, catupiry, maionese, catchup e mostarda.",

			"Rogger Onion":
			"Hamburguer premium de picanha, maionese, catchup, mostarda,mussarela, tomate, alface americana, milho, bacon, cebola, catupiry, queijo mineiro e provolone",

			"Rogger Pepperoni":
			"Hamburguer premium de picanha, maionese, catchup, mostarda,mussarela, tomate, alface americana, milho, bacon, cebola, catupiry, e queijo mineiro",

			"Duplo Salada":
			"Dois lanches com hamburguer premium de picanha, maionese, catchup, mostarda,mussarela, tomate, alface americana, milho, bacon, cebola, catupiry, queijo mineiro e provolone",

			"Duplo Burguer":
			"Dois lanches com hamburguer premium de picanha, maionese, catchup, mostarda,mussarela, tomate, alface americana, milho, bacon, cebola, catupiry, queijo mineiro e provolone",

			"Triplo Cheese":
			"Três lanches com hamburguer premium de picanha, maionese, catchup, mostarda,mussarela, tomate, alface americana, milho, bacon, cebola, catupiry, queijo mineiro e provolone",

			"Duplo Cheddar":
			"Dois lanches com hamburguer premium de picanha, maionese, catchup, mostarda,mussarela, tomate, alface americana, milho, bacon, cebola, catupiry, queijo mineiro e provolone",
	]

	var additionals = [
		"Bacon", "Ovo na chapa", "Cebola Roxa no Molho Barbecue",
		"Cebola Roxa na chapa", "Catupiry", "Hambúrguer Angus 180g",
		"Doritos", "Barbecue", "Salada de alface e tomate", "Onion",
		"Hambúrguer de Frango", "Hambúrguer Angus 120g"
	]

	var additionalsPriceDict = [
		"Bacon" : 3,
		"Ovo na chapa" : 2,
		"Cebola Roxa no Molho Barbecue" : 3,
		"Cebola Roxa na chapa" : 3,
		"Catupiry" : 3,
		"Hambúrguer Angus 180g" : 6,
		"Doritos" : 3,
		"Barbecue" : 3,
		"Salada de alface e tomate" : 2,
		"Onion" : 3,
		"Hambúrguer de Frango" : 6,
		"Hambúrguer Angus 120g" : 6
	]
	var unitsInt = 1

	//MARK: - OUTLETS
	@IBOutlet weak var headerItem: UINavigationItem!
	@IBOutlet weak var imageProduct: UIImageView!
	@IBOutlet weak var buttonBuy: UIButton!

	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!

	@IBOutlet weak var unitsProduct: UILabel!
	@IBOutlet weak var aditionalDescriptionView: UIView!

	@IBOutlet var additionalImages: [UIImageView]!
	@IBOutlet var additionalLabels: [UILabel]!

	//MARK: - ACTIONS
	@IBAction func closeView(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func addMarketPlace(_ sender: Any) {

		let adds = getAditionals()
		CoreDataManager().save(
			title: titleHeader,
			units: String(unitsInt),
			adds: adds
		)
		self.dismiss(animated: true, completion: nil)
	}

	func getAditionals() -> String{
		var addsVet = [String]()

		for add in additionalLabels {
			if(add.textColor == UIColor.init(rgb: 0x33BE00)) {
				addsVet.append(add.text!)
			}
		}

		let stringRepresentation = addsVet.joined(separator:" • ")

		var adds = ""
		if(!addsVet.isEmpty) {
			adds = "Adicionais: " + stringRepresentation
		}
		else {
			adds = "Adicionais: " + "Sem  adicionais"
		}
		return adds
	}

	//MARK: - Aditionals options
	@IBAction func addUnit(_ sender: Any) {
		unitsInt += 1
		unitsProduct.text = String(unitsInt)
		priceLabel.text = "R$ " + String(dictPrice[titleHeader]! * unitsInt)
	}

	@IBAction func subUnit(_ sender: Any) {
		if(unitsInt > 1) {
			unitsInt -= 1
			unitsProduct.text = String(unitsInt)
			priceLabel.text = "R$ " + String(dictPrice[titleHeader]! * unitsInt)
		}
	}

	@IBAction func additionalPressed(_ sender: UIButton) {
		if(additionalLabels[sender.tag].textColor == UIColor.init(rgb: 0x33BE00)) {
			additionalImages[sender.tag].image = UIImage(named: "circle")
			additionalLabels[sender.tag].textColor  = UIColor.black
		}
		else {
			additionalImages[sender.tag].image = UIImage(named: "circleSelected")
			additionalLabels[sender.tag].textColor  = UIColor.init(rgb: 0x33BE00)
		}

		var addsVet = [Int]()

		for add in additionalLabels {
			if(add.textColor == UIColor.init(rgb: 0x33BE00)) {
				print(additionals[add.tag])
				print(additionalsPriceDict[additionals[add.tag]]!)
				addsVet.append(additionalsPriceDict[additionals[add.tag]]!)
			}
		}

		let sum = addsVet.reduce(0, +)
		priceLabel.text = "R$ " + String((dictPrice[titleHeader]! * unitsInt) + (sum * unitsInt))
	}

	func populateAdditionals() {
		for x in 0...11 {
			additionalLabels[x].text = additionals[x] + " R$" + String(additionalsPriceDict[additionals[x]]!)
		}
	}


	//MARK: - PROPERTIES
	var titleHeader: String = ""

	//MARK: - SETUPS
	func setupStyle() {
		imageProduct.image = UIImage(named: titleHeader)!
		imageProduct.layer.cornerRadius = 30
		imageProduct.layer.masksToBounds = true
		buttonBuy.layer.cornerRadius = 10
	}

	func setupPopulate() {
		headerItem.title = titleHeader
		priceLabel.text = "R$ " + String(dictPrice[titleHeader]!)
		descriptionLabel.text = dictDescription[titleHeader]
	}

	//MARK: - LIFECYCLE
	override func viewDidLoad() {
		super.viewDidLoad()

		setupStyle()
		setupPopulate()
		populateAdditionals()
	}
}



