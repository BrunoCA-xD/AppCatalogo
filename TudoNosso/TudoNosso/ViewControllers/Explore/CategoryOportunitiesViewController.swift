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
        "X-Egg": "R$ 23",
        "X-Onion": "R$ 24",
        "X-Pepperoni": "R$ 25"
    ]
    
    var dictDescription =
    [
        "Bacon Cheddar":
        "Alface americana, tomate, milho, cebola, hamburguer premium 200grs, mussarela, porção grande de bacon, maionese, catchup, mostarda.",
        
        "Pepperoni Venture":
        "Alface americana, tomate, milho, cebola, hamburguer premium 200grs, mussarela, bacon, maionese, catchup, mostarda, provolone e catupiry.",
        
        "X-Egg":
        "Alface americana, tomate, milho, cebola, bacon, hamburguer premium de 200 grs, mussarela, ovo, salsicha, catupiry, maionese, catchup e mostarda.",
        
        "X-Onion":
        "Hamburguer premium de picanha, maionese, catchup, mostarda,mussarela, tomate, alface americana, milho, bacon, cebola, catupiry, queijo mineiro e provolone",
        
        "X-Pepperoni":
        "Hamburguer premium de picanha, maionese, catchup, mostarda,mussarela, tomate, alface americana, milho, bacon, cebola, catupiry, e queijo mineiro"
    ]
    
    var unitsInt = 1
    
    //MARK: - OUTLETS
    @IBOutlet weak var headerItem: UINavigationItem!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var buttonBuy: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var unitsProduct: UILabel!
    
    @IBOutlet weak var aditionalsButton: UIButton!
    @IBOutlet weak var aditionalDescriptionView: UIView!
    
    
    //MARK: - ACTIONS
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addMarketPlace(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showAdditionals(_ sender: Any) {
        if(aditionalDescriptionView.isHidden) {
            aditionalsButton.titleLabel?.text = "Adicionais"
            aditionalDescriptionView.isHidden = false
        }
        else {
            aditionalsButton.titleLabel?.text = "Esconder"
            aditionalDescriptionView.isHidden = true
        }
    }
    
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
    
    
    
    
    //MARK: - PROPERTIES
    var titleHeader: String = ""
    
    //MARK: - LIFECYCLE
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        setupPopulate()
        aditionalsButton.titleLabel?.text = "Ver Adicionais"
    }
}



