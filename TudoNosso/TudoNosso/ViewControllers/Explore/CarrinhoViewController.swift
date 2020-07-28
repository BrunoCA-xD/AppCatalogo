//
//  CarrinhoViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 20/07/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

class CarrinhoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //  MARK: - IBAction
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var tableItens: UITableView!
    
    //  MARK: - IBAction
    @IBAction func sendCarrinho(_ sender: Any) {
      
        var str =
            
            "*Pedido* \n" +
            "1x Bacon Cheddar \n" +
            "   * _catupiry_\n" +
            "   * _onion_\n\n" +
            
            "1x Guaraná lata \n\n" +
                
            "*Observações* \n" +
            "Lanche sem alface\n\n" +
        
            "*Pagamento* \n" +
            "Cartão Elo \n\n" +
                
            "*Total* \n" +
            "R$ 30,00 \n\n" +
                
            "*Endereço* \n" +
            "Rua Número, Bairro - Cidade"
        
        str = str.addingPercentEncoding(withAllowedCharacters: (NSCharacterSet.urlQueryAllowed))!
        
        let phoneNumber =  "+5514996525883" // you need to change this number
        
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)&text=\(str)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            print("WhatsApp is not installed")
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearList(_ sender: Any) {
        print("limpando carrinho")
    }
    
    //  MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonSend.layer.cornerRadius = 10
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        tableItens.delegate = self
        tableItens.dataSource = self
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //  MARK: - TableView
    let cellIdentifier = "CellIdentifier"
    
    //tags
    let titleTag = 1000
    let addsTag = 1001
    let obsTag = 1002
    let priceTag = 1003
    let unitsTag = 1004
    let viewTag = 100
    let imageTag = 10
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
         
        // Fetch Fruit
        let fruit = fruits[indexPath.row]

        let label = cell.viewWithTag(1000) as! UILabel
        label.text = fruit
        
        
        
        return cell
    }
    
    let fruits = ["Apple", "Pineapple", "Orange", "Blackberry", "Banana", "Pear", "Kiwi", "Strawberry", "Mango", "Walnut", "Apricot", "Tomato", "Almond", "Date", "Melon"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = fruits.count
        return numberOfRows
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
}
