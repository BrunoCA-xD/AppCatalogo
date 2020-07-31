//
//  RepeatViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 31/07/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import CoreData

class RepeatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

	//  MARK: - IBAction
	@IBOutlet weak var buttonSend: UIButton!
	@IBOutlet weak var tableItens: UITableView!

	//  MARK: - IBAction
	@IBAction func sendCarrinho(_ sender: Any) {

		updateTextFields()

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
		RepeatCoreDataManager().deleteAllRecords()
		updateData()
		tableItens.reloadData()
	}

	//  MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()

		buttonSend.layer.cornerRadius = 10
		setepKeyboard()
		dataTableview()
	}

	override func viewWillAppear(_ animated: Bool) {
		setupTextFields()
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
		let fruit = people[indexPath.row]

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
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RepeatPurchase")
		if let result = try? managedContext.fetch(fetchRequest) {
			managedContext.delete(result[buttonTag])
		}

		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		people.remove(at: buttonTag)
		tableItens.reloadData()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numberOfRows = people.count
		return numberOfRows
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return people.count
	}

	//	MARK: - Textfield
	//IBOutlet
	@IBOutlet weak var nameText: UITextField!
	@IBOutlet weak var cellphoneText: UITextField!
	@IBOutlet weak var endressText: UITextField!
	@IBOutlet weak var payformText: UITextField!
	@IBOutlet weak var obsText: UITextField!

	func setupTextFields() {
		nameText.text = UserDefaults.standard.string(forKey: "nameText")
		cellphoneText.text = UserDefaults.standard.string(forKey: "cellphoneText")
		endressText.text = UserDefaults.standard.string(forKey: "endressText")
		payformText.text = UserDefaults.standard.string(forKey: "payformText")
		obsText.text = UserDefaults.standard.string(forKey: "obsText")

		print("setupTextFields")
	}

	func updateTextFields() {
		UserDefaults.standard.set(nameText.text, forKey: "nameText")
		UserDefaults.standard.set(cellphoneText.text, forKey: "cellphoneText")
		UserDefaults.standard.set(endressText.text, forKey: "endressText")
		UserDefaults.standard.set(payformText.text, forKey: "payformText")
		UserDefaults.standard.set(obsText.text, forKey: "obsText")

		print("updateTextFields")
	}


	//	MARK:  - Keyboard

	func setepKeyboard() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
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
	var people: [NSManagedObject] = []

	func updateData() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RepeatPurchase")

		do {
			people = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		do {
			people = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
}
