//
//  DrinksViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 26/07/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

class DrinksViewController: UIViewController,UISearchBarDelegate {
    
    //MARK: - Variables
    var dictPrice =
    [
        "Suco Natural": "R$ 8",
        "Refrigerante": "R$ 5",
        "Doses": "R$ 20",
        "Cerveja": "R$ 8",
        "Água": "R$ 5"
    ]
    
    var dictDescription =
    [
        "Suco Natural":
        "Sucos naturais 500 ml",
        
        "Refrigerante":
        "Refrigerante lata 350 ml",
        
        "Doses":
        "Doses 50 ml",
        
        "Cerveja":
        "Cervejas long neck 390 ml",
        
        "Água":
        "Garrafa de água 500 ml"
    ]
    
    var dictDescription2 =
    [
        "Suco Natural":
        ["Laranja", "Abacaxi", "Uva"],
        
        "Refrigerante":
        ["Coca-Cola", "Guaraná", "Sprite"],
        
        "Doses":
        ["Vodka Smirnoff", "Whiskey Red Label"],
        
        "Cerveja":
        ["Brahma", "Skol", "Itaipava"],
        
        "Água":
        ["Com gás", "Sem gás"]
        ] as [String : Array<String>]
    
    var unitsInt = 1
    
    //MARK: - OUTLETS
    @IBOutlet weak var headerItem: UINavigationItem!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var buttonBuy: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var unitsProduct: UILabel!
    
    @IBOutlet weak var aditionalDescriptionView: UIView!
    
    
    //MARK: - ACTIONS
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addMarketPlace(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    @IBOutlet weak var onionImage: UIImageView!
    @IBOutlet weak var onionLabel: UILabel!
    @IBAction func addOnion(_ sender: Any) {
        if(onionLabel.textColor == UIColor.init(rgb: 0x33BE00)) {
            onionLabel.textColor = UIColor.black
            onionImage.image = UIImage(named: "circle")
        }
        else {
            onionLabel.textColor = UIColor.init(rgb: 0x33BE00)
            onionImage.image = UIImage(named: "circleSelected")
            
            cheeseLabel.textColor = UIColor.black
            cheeseImage.image = UIImage(named: "circle")
            
            hamburgerLabel.textColor = UIColor.black
            hambuergerImage.image = UIImage(named: "circle")
        }
    }
    
    @IBOutlet weak var cheeseImage: UIImageView!
    @IBOutlet weak var cheeseLabel: UILabel!
    @IBAction func addCheese(_ sender: Any) {
        if(cheeseLabel.textColor == UIColor.init(rgb: 0x33BE00)) {
            cheeseLabel.textColor = UIColor.black
            cheeseImage.image = UIImage(named: "circle")
        }
        else {
            cheeseLabel.textColor = UIColor.init(rgb: 0x33BE00)
            cheeseImage.image = UIImage(named: "circleSelected")
            
            onionLabel.textColor = UIColor.black
            onionImage.image = UIImage(named: "circle")
            
            hamburgerLabel.textColor = UIColor.black
            hambuergerImage.image = UIImage(named: "circle")
        }
    }
    
    @IBOutlet weak var hambuergerImage: UIImageView!
    @IBOutlet weak var hamburgerLabel: UILabel!
    @IBAction func addHamburger(_ sender: Any) {
        if(hamburgerLabel.textColor == UIColor.init(rgb: 0x33BE00)) {
            hamburgerLabel.textColor = UIColor.black
            hambuergerImage.image = UIImage(named: "circle")
        }
        else {
            hamburgerLabel.textColor = UIColor.init(rgb: 0x33BE00)
            hambuergerImage.image = UIImage(named: "circleSelected")
            
            onionLabel.textColor = UIColor.black
            onionImage.image = UIImage(named: "circle")
            
            cheeseLabel.textColor = UIColor.black
            cheeseImage.image = UIImage(named: "circle")
        }
    }
    
    //MARK: - PROPERTIES
    var titleHeader: String = ""
    
    //MARK: - SETUPS
    func setupStyle() {
        if let imageProd = UIImage(named: titleHeader) {
            imageProduct.image = imageProd
        }
        imageProduct.layer.cornerRadius = 30
        imageProduct.layer.masksToBounds = true
        buttonBuy.layer.cornerRadius = 10
    }
    
    func setupPopulate() {
        
        priceLabel.text = dictPrice[titleHeader]
        descriptionLabel.text = dictDescription[titleHeader]
        
        var currentTitle = titleHeader.replacingOccurrences(of: " 1", with: "", options: .literal, range: nil)
        currentTitle = currentTitle.replacingOccurrences(of: " 2", with: "", options: .literal, range: nil)
        currentTitle = currentTitle.replacingOccurrences(of: " 3", with: "", options: .literal, range: nil)
        currentTitle = currentTitle.replacingOccurrences(of: " 4", with: "", options: .literal, range: nil)
        currentTitle = currentTitle.replacingOccurrences(of: " 0", with: "", options: .literal, range: nil)
        print(currentTitle)
        headerItem.title = currentTitle
    }
    
    func populateOptions() {
        
        if let options = dictDescription2[titleHeader] {
            
            let optionsLabels = [onionLabel, cheeseLabel, hamburgerLabel]
            let optionsVar = options
            
            for i in 0...(options.count-1) {
                print(i)
                optionsLabels[i]?.text = optionsVar[i]
            }
        }
    }
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateOptions()
        setupStyle()
        setupPopulate()
        
        cheeseLabel.tintColor = UIColor.black
        hamburgerLabel.tintColor = UIColor.black
        onionLabel.tintColor = UIColor.black
    }
}
