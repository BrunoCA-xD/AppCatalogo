//
//  CarrinhoViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 20/07/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

class CarrinhoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

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

		view.addGestureRecognizer(tap)

		//keyboard
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);

		nameText.delegate = self
		cellphoneText.delegate = self
		endressText.delegate = self
		payformText.delegate = self
		obsText.delegate = self

		
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

		let title = cell.viewWithTag(titleTag) as! UILabel
		title.text = fruit

		let adds = cell.viewWithTag(addsTag) as! UILabel
		adds.text = "Hamburguer extra"

		let obs = cell.viewWithTag(obsTag) as! UILabel
		obs.text = "Sem Alface"

		let price = cell.viewWithTag(priceTag) as! UILabel
		price.text = "R$ 25"

		let units = cell.viewWithTag(unitsTag) as! UILabel
		units.text = "1"

		let viewProd = cell.viewWithTag(viewTag)!
		viewProd.layer.cornerRadius = 10
		viewProd.layer.shadowOpacity = 0.5
		viewProd.layer.shadowRadius = 3
		viewProd.layer.shadowOffset = CGSize.zero


		let image = cell.viewWithTag(imageTag) as! UIImageView
		image.image = UIImage(named: "Bacon Cheddar")
		image.layer.cornerRadius = 5



		return cell
	}

	let fruits = ["Apple", "Pineapple", "Orange", "Blackberry"]

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

//	MARK:  - Keyboard

	//IBOutlet
	@IBOutlet weak var nameText: UITextField!
	@IBOutlet weak var cellphoneText: UITextField!
	@IBOutlet weak var endressText: UITextField!
	@IBOutlet weak var payformText: UITextField!
	@IBOutlet weak var obsText: UITextField!

	var isShowing = false

	@objc func dismissKeyboard() {
		if(isShowing) {
			view.endEditing(true)
			isShowing = false
		}
	}

	@objc func keyboardWillShow(sender: NSNotification) {
		if (!isShowing)  {

			let info = sender.userInfo!
			let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

//			let const = buttonSend.constraints.first(where: {$0.identifier == "bottom"})
//			const?.constant = 300 //keyboardFrame.size.height
			self.view.frame.origin.y = -keyboardFrame.size.height

			isShowing = true
		}
	}

	@objc func keyboardWillHide(sender: NSNotification) {
		if (isShowing)  {
			self.view.frame.origin.y = 0
			isShowing = false
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let nextTag = textField.tag + 1

		if let nextResponder = textField.superview?.viewWithTag(nextTag) {
			nextResponder.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
		}

		return true
	}
}
