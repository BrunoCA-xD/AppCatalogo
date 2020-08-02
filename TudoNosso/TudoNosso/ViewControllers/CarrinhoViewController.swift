//
//  CarrinhoViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 20/07/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import CoreData

class CarrinhoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

	//  MARK: - IBAction
	@IBOutlet weak var buttonSend: UIButton!
	@IBOutlet weak var tableItens: UITableView!

	//  MARK: - IBAction
	func saveInRepeatPurchase() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RepeatPurchase")

		do {
			itemsProduct = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		RepeatCoreDataManager().deleteAllRecords()

		let managedContext2 = appDelegate.persistentContainer.viewContext
		let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "CurrentPurchase")

		do {
			itemsProduct = try managedContext2.fetch(fetchRequest2)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		for person in itemsProduct {
			RepeatCoreDataManager().save(title: (person.value(forKeyPath: "title") as? String)!, units: (person.value(forKeyPath: "units") as? String)!, adds: (person.value(forKeyPath: "adds") as? String)!)
		}
	}

	@IBAction func sendCarrinho(_ sender: Any) {

		updateTextFields()
		saveInRepeatPurchase()


		var productsArray = [String]()
		var totalPrice = 0

		for x in 0...(tableItens.numberOfRows(inSection: 0)-1) {
			let cell = tableItens.cellForRow(at: IndexPath(row: x, section: 0)) as! CellPurchase

			let units = (cell.unitsItem.text ?? "1") + "x "
			let title = cell.titleLabel.text! + " "
			var price = cell.priceLabel.text!
			price = price.replacingOccurrences(of: "R$ ", with: "")
			let adds = cell.additionalsLabel.text!
			let aditionals = "_" + adds + "_"
			let product = units + title + "R$ " + price  + "\n" + aditionals

			productsArray.append(product)

			print(price)
			totalPrice += Int(price)!
		}

		let productsList = productsArray.joined(separator:" \n\n ") + "\n\n"
		let name = nameText.text ?? "Não registrado"
		let obs = obsText.text ?? "Sem observações"

		let payform = payformText.text ?? "Não registrado"
		let endress = endressText.text ?? "Não registrado"
		let price = String(totalPrice)
		var str =
			"*Nome:* " + name +
			"\n*Endereço:* " + endress +
			"\n\n*Pedido* \n" + productsList +
			"*Observações:* " + obs +
			"\n*Pagamento:* " + payform +
			"\n\n*Total:* " + price

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
		CoreDataManager().deleteAllRecords()
		updateData()
		tableItens.reloadData()
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

	override func viewWillAppear(_ animated: Bool) {
		setupTextFields()
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

		let price = cell.viewWithTag(priceTag) as! UILabel
		price.text = "R$ 25"

		let units = cell.viewWithTag(unitsTag) as! UILabel
		units.text = fruit.value(forKeyPath: "units") as? String

		let image = cell.viewWithTag(imageTag) as! UIImageView
		image.image = UIImage(named: (fruit.value(forKeyPath: "title") as? String)!)
		image.layer.cornerRadius = 5

		let addButton = cell.deleteButton

		addButton!.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
		addButton!.tag = indexPath.row

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

	func setupTextFields() {
		nameText.text = UserDefaults.standard.string(forKey: "nameText")
		endressText.text = UserDefaults.standard.string(forKey: "endressText")
		payformText.text = UserDefaults.standard.string(forKey: "payformText")
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
	}

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
