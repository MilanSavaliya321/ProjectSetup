//
//  ViewController.swift
//  Test
//
//  Created by PC on 05/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tblTest: UITableView!
    
    var arrNames = ["aa","bb","cc","dd","ee","ff","gg"]
    var arrSelectedIndex = [Int]()
    
    //    override var shouldAutorotate: Bool {
    //        return true
    //    }
    //
    //    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //        return UIInterfaceOrientationMask.portrait
    //    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
    //            appDelegate.allowLandscape = false
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblTest.dataSource = self
        tblTest.delegate = self
        tblTest.reloadData()
    }
    

    func updateValue(index: Int) {
        if arrSelectedIndex.contains(index) {
            if let index = arrSelectedIndex.firstIndex(where: {$0 == index}) {
                arrSelectedIndex.remove(at: index)
            }
        } else {
            arrSelectedIndex.append(index)
        }
        tblTest.reloadData()
    }
    
    @objc func btnPressed(sender: UIButton) {
        updateValue(index: sender.tag)
    }
    
    @IBAction func onBtnNames(_ sender: Any) {
        let arr = arrSelectedIndex.map { index in
            return arrNames[index]
        }
        print(arr)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell else { return .init() }
        cell.lblTitle.text = arrNames[indexPath.row]
        if arrSelectedIndex.contains(indexPath.row) {
            cell.btnCheck.isSelected = true
        } else {
            cell.btnCheck.isSelected = false
        }
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self, action: #selector(btnPressed(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateValue(index: indexPath.row)
    }
}
