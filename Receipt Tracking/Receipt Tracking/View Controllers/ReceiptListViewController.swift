//
//  ViewController.swift
//  Receipt Tracking
//
//  Created by Jake Connerly on 8/23/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import CoreData

class ReceiptListViewController: UIViewController {
    
    // MARK: - IBOutlets & Properties

    @IBOutlet weak var tableView: UITableView!
    
	var viewDetails = AddView()
	let receiptController = ReceiptController.shared
    var receipts: [ReceiptRepresentation] = []
    var user: UserRepresentation {
        let moc = CoreDataStack.shared.mainContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try moc.fetch(request)
            if let user = users.first {
                return user.userRepresentation
            }
        } catch {
            fatalError("Error performing fetch for user: \(error)")
        }
        return UserRepresentation()
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Receipt> = {
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        
        // FRCs need at least one sort descriptor. If you are using "sectionNameKeyPath", the first sort descriptor must be the same attribute
        let categoryDescriptor = NSSortDescriptor(key: "category", ascending: false)
        let dateDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [categoryDescriptor, dateDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "category", cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    
    let token: String? = KeychainWrapper.standard.string(forKey: "token")
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print("\(token ?? "")")
        // check if first launch or not logged in
        if UserDefaults.isFirstLaunch() && token == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else if token == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else if user.username == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }

		// Change the background color of the table view
		setupViews()
		self.tableView.backgroundColor = UIColor.lightGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if token != nil {
            receiptController.fetchReceiptsFromServer() {
            }
        }
        tableView.reloadData()
        tableView.reloadInputViews()
    }


	private func setupViews() {

		// Formats navigation bar and view background
		viewDetails.navBarConfiguration2(navBar: navigationController!.navigationBar)
		viewDetails.viewConfiguration(view: view)
		viewDetails.navBarConfiguration(navBar: navigationController!.navigationBar)



	}
    
    

}

// MARK: - Extensions

extension ReceiptListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let sectionName = fetchedResultsController.sections?[section].name,
            let items = fetchedResultsController.fetchedObjects else { return ""}
        var total: Double = 0
        for item in items {
            if item.category == sectionName {
                total += item.amountSpent
            } else {
                continue
            }
        }
        return "\(sectionName) Total $\(total)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as? ReceiptTableViewCell else { return UITableViewCell() }
        let receipt      = fetchedResultsController.object(at: indexPath)
        cell.receipt     = receipt
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let receiptToDelete = fetchedResultsController.object(at: indexPath)
            receiptController.deleteReceipt(receipt: receiptToDelete)
        }
    }
}

extension ReceiptListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let sectionIndexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(sectionIndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(sectionIndexSet, with: .automatic)
        default:
            break
        }
    }
}
