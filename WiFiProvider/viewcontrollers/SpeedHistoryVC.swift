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
    var avgPing:Double = 0.0
    var avgDownloadSpeed:Double = 0.0
    var avgUploadSpeed:Double = 0.0
    var speedDataList = [String:[SpeedTestData]]()
  
    var speedDetailData = [String]()
    var uploadSpeed = [Double]()
    var downloadSpeed = [Double]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
       
        
       
       
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchFavouriteList()
       
        if avgPing != nil && avgDownloadSpeed != nil && avgDownloadSpeed != nil {
            averagePing.text = String(avgPing).maxLength(length: 4)
            averageDownloadSpeed.text = String(avgDownloadSpeed).maxLength(length: 4)
            averageUploadSpeed.text = String(avgUploadSpeed).maxLength(length: 4)
        }
    }
    
    func fetchFavouriteList(){
        var speedTestList  = [String:[SpeedTestData]]()
        if let savedData = UserDefaults.standard.data(forKey: MyConstant.SPEED_LIST) {
            do {
              
                speedTestList = try JSONDecoder().decode([String:[SpeedTestData]].self, from: savedData)
                print("speedList \(speedTestList)")
                speedDataList = speedTestList
                for (key,data) in speedTestList{
                    print("speedListData= \(key) \(data)")
                    speedDetailData.append(key)
                    
                    
                }
               
            }catch{
                
            }
            tableView.reloadData()
        }
                
    }

    @IBAction func back(_ sender:UIButton){
        navigationController?.popViewController(animated: true)
    }

}

extension SpeedHistoryVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        // This changes the header background
        view.tintColor = UIColor.clear
        view.backgroundColor = UIColor.clear

        // Gets the header view as a UITableViewHeaderFooterView and changes the text colour
        var headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.white

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        print("speedDetailData22\(speedDetailData.count)")
        return speedDetailData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("speedDetailData33\(speedDataList[speedDetailData[section]]!.count)")
        return speedDataList[speedDetailData[section]]!.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return speedDetailData[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = speedDataList[speedDetailData[indexPath.section]]?[indexPath.row]
        avgPing += Double(data!.ping)!
        avgDownloadSpeed += data!.downloadSpeed
        avgUploadSpeed  += data!.uploadSpeed
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpeedHistoryCell", for: indexPath) as! SpeedHistoryCell
        cell.timeLabel.text = data?.time
        cell.ping.text = data?.ping
        cell.upload.text = String(data!.uploadSpeed).maxLength(length: 4)
        cell.download.text = String(data!.downloadSpeed).maxLength(length: 4)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
     
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = speedDataList[speedDetailData[indexPath.section]]?[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "SpeedTestDetailVC") as! SpeedTestDetailVC
        vc.isFrom = "SpeedHistory"
        vc.ping = data!.ping
        vc.uploadSpeed = data!.uploadSpeed
        vc.downloadSpeed = data!.downloadSpeed
        vc.ipAddressData = data!.ipAddress
        vc.connectiontype = data!.connectionType
        vc.providername = data!.providerName
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//       
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self]  _, _, complete in
//                 let data = speedDataList[speedDetailData[indexPath.section]]?[indexPath.row]
//                     data.remove(at: indexPath.row)
//                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
//                    complete(true)
//                }
//                
//                deleteAction.backgroundColor = UIColor.red
//                
//                let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//                configuration.performsFirstActionWithFullSwipe = true
//                return configuration
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [self] _, _ in
            //let data = speedDataList[speedDetailData[indexPath.section]]?[indexPath.row]
            self.speedDataList[speedDetailData[indexPath.section]]!.remove(at: indexPath.row)
                   self.tableView.deleteRows(at: [indexPath], with: .automatic)
                UserDefaults.standard.removeObject(forKey:MyConstant.SPEED_LIST)
               }
       
        
        deleteAction.backgroundColor = UIColor.red
               return [deleteAction]
    }
    
    
}


