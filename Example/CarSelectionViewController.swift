//
//  CarSelectionViewController.swift
//  Example
//
//  Created by Aaron Welborn on 4/9/18.
//  Copyright © 2018 Aaron Welborn. All rights reserved.
//

import UIKit

class CarSelectionViewController: UITableViewController {

    let CellIdentifier = "vehicleIdentifier"
    let SegueVehiclesViewController = "VehicleDetailsViewController"
    
    var vehicles = [Dictionary<String,Any>]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "Vehicles"
        
        tableView.register(UINib(nibName: "VehicleTableCellView", bundle: nil), forCellReuseIdentifier: CellIdentifier)
        self.tableView.separatorStyle = .none
        
        let filePath = Bundle.main.path(forResource: "mocks", ofType: "plist")
        
        if let path = filePath {
            vehicles = NSArray(contentsOfFile: path)! as! [Dictionary<String, String>]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Resuable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! VehicleCellViewController
        let vehicle = vehicles[indexPath.row]
        
        if let year = vehicle["year"] as? String,
            let make = vehicle["make"] as? String,
            let model = vehicle["model"] as? String,
            let url = URL(string: vehicle["imageUrl"] as! String) {
            // Configure Cell
            cell.vehicleYear?.text = "\(year)"
            cell.vehicleMake?.text = "\(make.uppercased())"
            cell.vehicleModel?.text = "\(model.uppercased())"
            cell.vehicleImage?.downloadedFrom(url: url)
        }
        return cell;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueVehiclesViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let vehicle = vehicles[indexPath.row]
                let destinationViewController = segue.destination as! VehicleDetailsViewController
                destinationViewController.vehicle = vehicle
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueVehiclesViewController, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func viewWillLayoutSubviews() {
//        updateTableViewContentInset()
//    }
//
//    func updateTableViewContentInset() {
//        let viewHeight: CGFloat = view.frame.size.height
//        let tableViewContentHeight: CGFloat = tableView.contentSize.height
//        let marginHeight: CGFloat = ((viewHeight - tableViewContentHeight) / 2.0)
//
//        self.tableView.contentInset = UIEdgeInsets(top: marginHeight, left: 0, bottom:  -marginHeight, right: 0)
//    }
}

extension UIImageView {
    func downloadedFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url)
    }
}
