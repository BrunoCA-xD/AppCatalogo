//
//  RepeatViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 31/07/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import CoreData


//
//  CarrinhoViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 20/07/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

class RepeatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

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
	//  MARK: - IBAction
	@IBOutlet weak var buttonSend: UIButton!
	@IBOutlet weak var tableItens: UITableView!
	@IBOutlet weak var paymentTotalLabel: UILabel!

	//  MARK: - IBAction

	func sendToWhatsApp() {
		updateTextFields()

		var productsArray = [String]()
		var totalPrice = 0

		for x in 0...(tableItens.numberOfRows(inSection: 0)-1) {
			let cell = tableItens.cellForRow(at: IndexPath(row: x, section: 0)) as! CellPurchase

			let units = (cell.unitsItem.text ?? "1")
			let unitsString = units + "x "
			let title = cell.titleLabel.text! + " "
			var price = cell.priceLabel.text!
			price = price.replacingOccurrences(of: "R$ ", with: "")
			let adds = cell.additionalsLabel.text!
			let aditionals = "_" + adds + "_"
			let product = "*" + unitsString + title + "R$" + price  + "*" + "\n" + aditionals

			productsArray.append(product)

			print(price)
			totalPrice += Int(price)!
		}

		let productsList = productsArray.joined(separator:" \n\n") + "\n\n"
		let name = nameText.text ?? "Não preenchido"

		let payform = payformText.text ?? "Não preenchido"
		let endress = endressText.text ?? "Não preenchido"

		let obs = obsText.text
		let troco = returnPaymentText.text

		let price = String(totalPrice)
		var str =
			"*Nome:* " + name +
				"\n*Endereço:* " + endress +
				"\n\n*Pedido*\n\n" + productsList

		if let observation = obs {
			if(observation != "") {
				str += "*Observações*\n" + observation + "\n\n"
			}
		}

		str += "*Pagamento:* " + payform

		if let retrunMoney = troco {
			if(retrunMoney != "") {
				str += "\n*Troco:* R$" + retrunMoney
			}
		}

		str += "\n\n*Total: R$" + price + "*"

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

	@IBAction func sendCarrinho(_ sender: Any) {

		if(tableItens.numberOfRows(inSection: 0) == 0) {
			showAlert(title: "Carrinho Vazio", message: "Volte para o menu e selecione os produtos desejados")
		}
		else if(nameText.text == "" || nameText.text == nil) {
			nameText.becomeFirstResponder()
		}
		else if(endressText.text == "" || endressText.text == nil) {
			endressText.becomeFirstResponder()
		}
		else if(payformText.text == "" || payformText.text == nil) {
			payformText.becomeFirstResponder()
		}
		else {
			sendToWhatsApp()
		}
	}

	@IBAction func closeView(_ sender: Any) {
		updateTextFields()
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func clearList(_ sender: Any) {
		CoreDataManager().deleteAllRecords()
		updateData()
		tableItens.reloadData()
		updateTotalValue()
	}

	//	MARK: - UIALERT
	func showAlert(title: String, message: String) {

		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
			action in
			self.dismiss(animated: true, completion: nil)
		}))

		self.present(alert, animated: true, completion: nil)
	}

	//  MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()

		buttonSend.layer.cornerRadius = 10
		setepKeyboard()
		dataTableview()

		let picker = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.size.height-320, width: self.view.frame.size.width, height: 320))
		picker.dataSource = self
		picker.delegate = self

		payformText.inputAccessoryView = inputAccessoryViewPicker
		payformText.inputView = picker
	}

	var inputAccessoryViewPicker: UIView? {

		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		let doneButton = UIBarButtonItem(title: "Próximo", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneDatePicker))
		toolbar.setItems([spaceButton, doneButton], animated: false)

		return toolbar
	}

	@objc func doneDatePicker() {
		obsText.becomeFirstResponder()
	}

	func updateTotalValue() {
		var totalPrice = 0

		if (tableItens.numberOfRows(inSection: 0) > 0) {
			for x in 0...(tableItens.numberOfRows(inSection: 0)-1) {
				let cell = tableItens.cellForRow(at: IndexPath(row: x, section: 0)) as! CellPurchase

				var price = cell.priceLabel.text!
				price = price.replacingOccurrences(of: "R$ ", with: "")
				totalPrice += Int(price)!
			}
			let price = String(totalPrice)

			paymentTotalLabel.text = "Total: R$ " + price
		}
		else {
			paymentTotalLabel.text = "Total: R$ 0"
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		setupTextFields()
		updateTotalValue()
	}

	@IBAction func addButtonPressed(_ sender: Any) {
		updateTotalValue()
	}

	@IBAction func subButtonPressed(_ sender: Any) {
		updateTotalValue()
	}

	//  MARK: - PickerView
	var data =  ["Cartão","Dinheiro"]

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
		return data.count
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		payformText.text = data[row]
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return data[row]
	}

	//  MARK: - TableView
	let cellIdentifier = "CellIdentifier"

	//tags
	let titleTag = 1000
	let addsTag = 1001
	let priceTag = 1003
	let unitsTag = 1004
	let viewTag = 100
	let imageTag = 10
	let deleteTag = 1

	func dataTableview() {

		tableItens.delegate = self
		tableItens.dataSource = self

		guard (UIApplication.shared.delegate as? AppDelegate) != nil else {
			return
		}

		updateData()
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! CellPurchase

		let viewProd = cell.viewWithTag(viewTag)!
		viewProd.layer.cornerRadius = 10
		viewProd.layer.shadowOpacity = 0.5
		viewProd.layer.shadowRadius = 3
		viewProd.layer.shadowOffset = CGSize.zero

		// Fetch Fruit
		let fruit = itemsProduct[indexPath.row]

		let title = cell.viewWithTag(titleTag) as! UILabel
		title.text = fruit.value(forKeyPath: "title") as? String

		let adds = cell.viewWithTag(addsTag) as! UILabel
		adds.text = fruit.value(forKeyPath: "adds") as? String

		let units = cell.viewWithTag(unitsTag) as! UILabel
		units.text = fruit.value(forKeyPath: "units") as? String

		let image = cell.viewWithTag(imageTag) as! UIImageView
		image.image = UIImage(named: (fruit.value(forKeyPath: "title") as? String)!)
		image.layer.cornerRadius = 5

		let addButton = cell.deleteButton

		addButton!.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
		addButton!.tag = indexPath.row

		let type = fruit.value(forKeyPath: "type") as? String
		if(adds.text != "Adicionais: Sem  adicionais" && type == "Lanches" ) {

			print("New  Cell")
			var sumAdditionals = 0
			let additionalsString = fruit.value(forKeyPath: "adds") as? String
			let additionals = additionalsString?.replacingOccurrences(of: "Adicionais: ", with: "")
			let arrayAdd = additionals!.components(separatedBy: " • ")

			for add in  arrayAdd {
				let teste = additionalsPriceDict[add]
				print(teste!)
				sumAdditionals += teste!
			}

			let price = cell.viewWithTag(priceTag) as! UILabel
			price.text = "R$ " + String((dictPrice[title.text!]! + sumAdditionals) * Int(units.text!)!)
			cell.priceUnit = dictPrice[title.text!]! + sumAdditionals
		}
		else {
			let price = cell.viewWithTag(priceTag) as! UILabel
			price.text = "R$ " + String(dictPrice[title.text!]! * Int(units.text!)!)
			cell.priceUnit = dictPrice[title.text!]!
		}

		return cell
	}

	@objc func connected(sender: UIButton){
		let buttonTag = sender.tag
		print(buttonTag)

		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrentPurchase")
		if let result = try? managedContext.fetch(fetchRequest) {
			managedContext.delete(result[buttonTag])
		}

		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		itemsProduct.remove(at: buttonTag)
		tableItens.reloadData()
		updateTotalValue()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numberOfRows = itemsProduct.count
		return numberOfRows
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemsProduct.count
	}

	//	MARK: - Textfield
	//IBOutlet
	@IBOutlet weak var nameText: UITextField!
	@IBOutlet weak var endressText: UITextField!
	@IBOutlet weak var payformText: UITextField!
	@IBOutlet weak var obsText: UITextField!
	@IBOutlet weak var returnPaymentText: UITextField!

	func setupTextFields() {
		nameText.text = UserDefaults.standard.string(forKey: "nameText")
		endressText.text = UserDefaults.standard.string(forKey: "endressText")
		payformText.text = "Cartão"
		obsText.text = UserDefaults.standard.string(forKey: "obsText")
	}

	func updateTextFields() {
		UserDefaults.standard.set(nameText.text, forKey: "nameText")
		UserDefaults.standard.set(endressText.text, forKey: "endressText")
		UserDefaults.standard.set(payformText.text, forKey: "payformText")
		UserDefaults.standard.set(obsText.text, forKey: "obsText")
	}


	//	MARK:  - Keyboard

	func setepKeyboard() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		view.addGestureRecognizer(tap)

		//keyboard
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);

		nameText.delegate = self
		endressText.delegate = self
		payformText.delegate = self
		obsText.delegate = self
		returnPaymentText.delegate = self

		nameText.autocapitalizationType = .words
		endressText.autocapitalizationType = .words
		payformText.autocapitalizationType = .words
		obsText.autocapitalizationType = .sentences
	}

	@objc func dismissKeyboard() {
		view.endEditing(true)
	}

	@objc func keyboardWillShow(sender: NSNotification) {
		print("keyboard was shown")
		let info = sender.userInfo
		let keyboardSize: CGRect = (info![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

		tableItens.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
		tableItens.scrollIndicatorInsets = tableItens.contentInset
	}

	@objc func keyboardWillHide(sender: NSNotification) {
		print("keyboard will be hidden")
		tableItens.contentInset = UIEdgeInsets.zero
		tableItens.scrollIndicatorInsets = UIEdgeInsets.zero
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

	//	MARK: - COREDATA
	var itemsProduct: [NSManagedObject] = []

	func updateData() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CurrentPurchase")

		do {
			itemsProduct = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		do {
			itemsProduct = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
}
