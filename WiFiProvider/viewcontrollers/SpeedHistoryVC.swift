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
    var speedDataList = [String:[SpeedTestData]]()
    var speedDetailData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
      
        
       
       
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchFavouriteList()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpeedHistoryCell", for: indexPath) as! SpeedHistoryCell
        cell.ping.text = String(data!.ping).maxLength(length: 4)
        cell.upload.text = String(data!.uploadSpeed).maxLength(length: 4)
        cell.download.text = String(data!.downloadSpeed).maxLength(length: 4)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}


