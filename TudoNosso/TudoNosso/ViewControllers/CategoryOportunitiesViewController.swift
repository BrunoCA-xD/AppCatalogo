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
        "Bacon Cheddar": "R$ 21",
        "Pepperoni Venture": "R$ 22",
        "Rogger Egg": "R$ 23",
        "Rogger Onion": "R$ 24",
        "Rogger Pepperoni": "R$ 25",
        
        "Duplo Salada": "R$ 40",
        "Duplo Burguer": "R$ 40",
        "Triplo Cheese": "R$ 65",
        "Duplo Cheddar": "R$ 45"
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

		print("=============")
		for add in additionalLabels {
			if(add.textColor == UIColor.init(rgb: 0x33BE00)) {
				print(add.text)
				addsVet.append(add.text!)
				print("-------")
			}
		}
		print("=============")

		let stringRepresentation = addsVet.joined(separator:" • ")

		var adds = ""
		if(!addsVet.isEmpty) {
			adds = "Adicionais:  " + stringRepresentation
		}
		else {
			adds = "Adicionais: \n" + "Sem  adicionais"
		}
		return adds
	}

    //MARK: - Aditionals buttons
    @IBAction func addUnit(_ sender: Any) {
        unitsInt += 1
        unitsProduct.text = String(unitsInt)
    }
    
    @IBAction func subUnit(_ sender: Any) {
        if(unitsInt > 1) {
            unitsInt -= 1
            unitsProduct.text = String(unitsInt)
        }
    }

	@IBAction func additionalPressed(_ sender: UIButton) {
		print(sender.tag)
		if(additionalLabels[sender.tag].textColor == UIColor.init(rgb: 0x33BE00)) {
			additionalImages[sender.tag].image = UIImage(named: "circle")
			additionalLabels[sender.tag].textColor  = UIColor.black
		}
		else {
			additionalImages[sender.tag].image = UIImage(named: "circleSelected")
			additionalLabels[sender.tag].textColor  = UIColor.init(rgb: 0x33BE00)
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
        var currentTitle = titleHeader.replacingOccurrences(of: " 1", with: "", options: .literal, range: nil)
        currentTitle = currentTitle.replacingOccurrences(of: " 2", with: "", options: .literal, range: nil)
        currentTitle = currentTitle.replacingOccurrences(of: " 3", with: "", options: .literal, range: nil)
        currentTitle = currentTitle.replacingOccurrences(of: " 4", with: "", options: .literal, range: nil)
        currentTitle = currentTitle.replacingOccurrences(of: " 0", with: "", options: .literal, range: nil)
        
        headerItem.title = currentTitle
        priceLabel.text = dictPrice[currentTitle]
        descriptionLabel.text = dictDescription[currentTitle]
    }
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        setupPopulate()
    }
}



