//
//  SpeedHistoryVC.swift
//  WiFiProvider
//
//  Created by gautam  on 16/05/23.
//

import UIKit

class SpeedHistoryVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var averagePing:UILabel!
    @IBOutlet weak var averageDownloadSpeed:UILabel!
    @IBOutlet weak var averageUploadSpeed:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func back(_ sender:UIButton){
        navigationController?.popViewController(animated: true)
    }

}

extension SpeedHistoryVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpeedHistoryCell", for: indexPath) as! SpeedHistoryCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}
