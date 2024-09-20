//
//  TabBar.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 09/09/2024.
//

import Foundation


@objc func logsTabTapped(_ gesture: UITapGestureRecognizer) {
    logsView.image.image = UIImage(named: "logs")?.withTintColor(.black)
    logsView.label.textColor = .black
    guard let currentViewController = self.navigationController?.topViewController as? ObjectIDProviding else {
        return
    }
    let objectID = currentViewController.objectID
    let image = currentViewController.image
    let cost = currentViewController.cost
    let maintain = currentViewController.maintainCost
    let fix = currentViewController.fixCost
    let date = currentViewController.date
    logsView.image.image = UIImage(named: "logs")?.withTintColor(.systemBlue)
    logsView.label.textColor = .systemBlue
    if !(self.navigationController?.topViewController is FuelLogsViewController) {
        let logsVC = FuelLogsViewController(objectID: objectID, image: image, maintainCost: maintain, fixCost: fix, date: date)
        self.navigationController?.pushViewController(logsVC, animated: false)
    } else {
        print("ObjectID is not available")
    }
}
@objc func MaintenanceTabTapped(_ gesture: UITapGestureRecognizer) {
    maintenanceView.image.image = UIImage(named: "logs")?.withTintColor(.black)
    maintenanceView.label.textColor = .black
    guard let currentViewController = self.navigationController?.topViewController as? ObjectIDProviding else {
        return
    }
    let objectID = currentViewController.objectID
    let image = currentViewController.image
    let cost = currentViewController.cost
    let date = currentViewController.date
    maintenanceView.image.image = UIImage(named: "logs")?.withTintColor(.systemBlue)
    maintenanceView.label.textColor = .systemBlue
    
    if !(self.navigationController?.topViewController is MaintainLogsViewController) {
        let logsVC = MaintainLogsViewController(objectID: objectID, image: image, cost: cost, date: date)
        self.navigationController?.pushViewController(logsVC, animated: false)
    }
    else {
        print("Object ID is not availablde")
    }
}

@objc func ExpenseTabTapped(_ gesture: UITapGestureRecognizer) {
    expenseView.image.image = UIImage(named: "logs")?.withTintColor(.black)
    expenseView.label.textColor = .black
    guard let currentViewController = self.navigationController?.topViewController as? ObjectIDProviding else {
        return
    }
    let objectID = currentViewController.objectID
    let image = currentViewController.image
    let cost = currentViewController.cost
    let maintain = currentViewController.maintainCost
    let fix = currentViewController.fixCost
    let date = currentViewController.date
    expenseView.image.image = UIImage(named: "logs")?.withTintColor(.systemBlue)
    expenseView.label.textColor = .systemBlue
    if !(self.navigationController?.topViewController is ExpenseViewController) {
        let logsVC = ExpenseViewController(objectID: objectID, image: image, cost: cost, maintenanceCost: maintain, repairCost: fix, date: date)
        self.navigationController?.pushViewController(logsVC, animated: false)
    }
    else {
        print("Object ID is not available")
    }
}




let logsTap = UITapGestureRecognizer(target: self, action: #selector(logsTabTapped(_:)))
logsView.addGestureRecognizer(logsTap)
let maintenanceTap = UITapGestureRecognizer(target: self, action: #selector(MaintenanceTabTapped(_:)))
maintenanceView.addGestureRecognizer(maintenanceTap)
let expenseTap = UITapGestureRecognizer(target: self, action: #selector(ExpenseTabTapped(_:)))
expenseView.addGestureRecognizer(expenseTap)




tabbarView.heightAnchor.constraint(equalToConstant: 70.autoSized),
tabbarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.autoSized),
tabbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.widthRatio),
tabbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.widthRatio),

logsView.centerYAnchor.constraint(equalTo: tabbarView.centerYAnchor),
logsView.leadingAnchor.constraint(equalTo: tabbarView.leadingAnchor, constant: 25.widthRatio),

maintenanceView.centerYAnchor.constraint(equalTo: tabbarView.centerYAnchor),
maintenanceView.centerXAnchor.constraint(equalTo: tabbarView.centerXAnchor),

expenseView.centerYAnchor.constraint(equalTo: tabbarView.centerYAnchor),
expenseView.trailingAnchor.constraint(equalTo: tabbarView.trailingAnchor, constant: -25.widthRatio),



view.addSubview(tabbarView)
//        tabbarView.addSubview(vehicleView)
tabbarView.addSubview(logsView)
tabbarView.addSubview(maintenanceView)
tabbarView.addSubview(expenseView)


let tabbarView = View(backgroundColor: .gray, cornerRadius: 30)
private let vehicleView = TabBarView(title: "Vehicle", imageName: "car")
private let logsView = TabBarView(title: "Logs", imageName: "logs")
private let maintenanceView = TabBarView(title: "Maintain", imageName: "maintenance")
private let expenseView = TabBarView(title: "Expense", imageName: "expense")




protocol ObjectIDProviding {
    var objectID: NSManagedObjectID { get }
    var image: Data { get }
    var cost: String { get }
    var maintainCost: String { get }
    var fixCost: String { get }
    var date: String { get }
}




private let deleteButton = SystemImageButton(image: UIImage(systemName: "trash.fill"),size: UIImage.SymbolConfiguration(pointSize: 25), tintColor: .red)



deleteButton.topAnchor.constraint(equalTo: vehicleImage.bottomAnchor, constant: 10),
deleteButton.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -25),
deleteButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10)


private func deleteItem(item: Vehicle) {
    DataBaseHandler.context.delete(item)
    do {
        try DataBaseHandler.context.save()
    } catch {
        print("Error While Deleting Object: \(error.localizedDescription)")
    }
}
cell.didTapDeleteButton = {
    guard let indexPath = tableView.indexPath(for: cell) else {
        print("Error While Deleting Vehicle Record")
        return
    }
    let vehicle = self.vehicle[indexPath.row]
    DataBaseHandler.context.delete(vehicle)
    do {
        try DataBaseHandler.context.save()
        print("Successfully Delete Vehicle From DB")
    } catch {
        print("Error While Deleting Vehicle from DB \(error)")
    }
    self.vehicle.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
}


//    func fetchFuelDetails(objectID: NSManagedObjectID, station: String, date: UILabel, quantity: UILabel, cost: UILabel, mileage: UILabel, price: UILabel, willMove: UILabel, emptyLogs: () -> Void)  -> String {
//        var vehicle: Vehicle?
//        do {
//            vehicle = try DataBaseHandler.context.existingObject(with: objectID) as? Vehicle
//            let fuelRecords = vehicle?.fuel?.allObjects as? [Fuel] ?? []
//            self.fuel = fuelRecords
//            if fuelRecords.isEmpty {
//                emptyLogs()
//            } else {
//                for record in fuelRecords {
//                    "Gas Station \n \t \(record.refillStation ?? "")"
//                    date.text = "Date \n \t \(record.refillDate ?? "")"
//                    quantity.text = "Filled Leters \n \t \(record.refillQuantity ?? "")"
//                    cost.text = "Fuel Economy \n \t \(record.refillCost ?? "")"
//                    mileage.text = "Vehicle Average L/km \n \t \(record.refillReading ?? "")"
//                    if let quantity = Int(record.refillQuantity ?? ""), let cost = Int(record.refillCost ?? ""), let average = Int(record.refillReading ?? "") {
//                        let totalPrice = quantity * cost
//                        let willRun = average * quantity
//                        price.text = "Total Price \n \t \(totalPrice)"
//                        willMove.text = "Will Move \n \t \(willRun) KM"
//                    }
//                }
//            }
//        } catch {
//            print("Error fetching vehicle: \(error)")
//        }
//        return
//    }



//emailTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
//emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
//emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
//emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25.autoSized),
