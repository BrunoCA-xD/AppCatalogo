//
//  CarrinhoViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 20/07/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

class CarrinhoViewController: UIViewController {

    @IBOutlet weak var buttonSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonSend.layer.cornerRadius = 10
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
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
    
}
