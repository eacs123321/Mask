//
//  MainViewController.swift
//  Mask
//
//  Created by 何安竺 on 2022/10/5.
//

import UIKit
import CoreData
import Kanna

class MainViewController: BaseViewController {
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var townPickerView: UIPickerView!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var apiActivityIndicator: UIActivityIndicatorView!
    
    
    var taichungData : [PharmacyInfo] = []
    var townList = Set<String>()
    var selectTown = ""
    var fetchResultController: NSFetchedResultsController<PharmaciesTable>!
    let context = CoreDataConnect.share.context
    
    //取得資料ID
    var cellPrimaryKey: String = ""
    //取得某行列的cell
    var cellIndexPath: Int = 0
    //tableview
    let cellNib = UINib(nibName:"TableViewCell", bundle:nil)
    let cellID = String(describing: TableViewCell.self)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupFetchResultController()
        fetchPharmacyInfo()
        parseHTML()
        initSetting()
        
    }
    @IBAction func okAction(_ sender: Any) {
        selectView.isHidden = true
        selectArea()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        selectView.isHidden = true
        tableview.isUserInteractionEnabled = true


    }
    //MARK: -初始化
    func initSetting(){
        overrideUserInterfaceStyle = .light
        tableview.backgroundColor = TDefind.s_tablebackGroundColor
        selectView.isHidden = true

        townPickerView.delegate = self
        townPickerView.dataSource = self
        tableview.delegate = self
        tableview.dataSource = self
        editBtnAction()
        
        //註冊Cell
        tableview.register(cellNib, forCellReuseIdentifier: cellID)

    }
    
    //MARK: - 按下編輯按鈕時執行動作的方法
    @objc func editBtnAction() {
        self.navigationItem.rightBarButtonItem =
        UIBarButtonItem(title: "篩選",
                        style: .plain,
                        target: self,
                        action: #selector(popPickView))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "全區", style: .plain, target: self, action: #selector(fetchDataFromDatabase))
                        
                        
    }
    //MARK: - 按下新增按鈕時執行動作的方法
    @objc func popPickView() {
        selectView.isHidden = false
        tableview.isUserInteractionEnabled = false
    }
    //MARK: -刷新資料到全區域
    @objc func fetchDataFromDatabase(){
        fetchResultController.fetchRequest.predicate = nil
        do {
            try fetchResultController.performFetch()
        }
        catch {
            print("error: \(error)")
        }
        DispatchQueue.main.async { [self] in
            townPickerView.selectRow(0, inComponent: 0, animated: false)
            title = "台中市 全區"
            tableview.reloadData()
        }
    }
    //MARK: - 刷新成選擇區域
    @objc func selectArea(){
        fetchResultController.fetchRequest.predicate = NSPredicate(format: "town == %@", selectTown)
        do{
            try fetchResultController.performFetch()
        }catch{
            print(error)
        }
        let fetchResultCount = fetchResultController.fetchedObjects!.count
        if fetchResultCount <= 0 {
            let alert = UIAlertController(title: "此區域資料已完全刪除或不存在",
                                          message: "即將返回全區域",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定",
                                          style: .default,
                                          handler: { _ in
                self.fetchDataFromDatabase()
                self.title = "台中市全區"
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        DispatchQueue.main.async { [self] in
            self.title = "台中市 " + selectTown
            tableview.reloadData()
            tableview.isUserInteractionEnabled = true
        }
    }
    
    //MARK: - 取得maskAPI提供的id作為primaryKey
    func getCellPrimaryKey() {
        let frc = fetchResultController.fetchedObjects?[self.cellIndexPath]
        print("cellIndexPath in Getcell primary key: \(cellIndexPath)")
        if !fetchResultController.fetchedObjects!.isEmpty {
            cellPrimaryKey = (frc?.id)!
        }
        print(cellPrimaryKey)
    }
    
    //MARK: -設置fetchResultController
    func setupFetchResultController() {
        fetchResultController = CoreDataConnect.share.createMaskInfoTableFetchResultController(sorter: "town")
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
        }
        catch {
            print("error: \(error)")
        }
    }
    
    //MARK: - 導入並存入CoreData
    func fetchPharmacyInfo(){
        NetworkManager.share.api_get {[self] pharmacyData, error in
            DispatchQueue.main.async { [self] in
                view.addSubview(apiActivityIndicator)
                view.isUserInteractionEnabled = false
                apiActivityIndicator.startAnimating()
            }
            guard let featureCount = pharmacyData?.features.count else {return}
            //資料庫有資料
            if self.fetchResultController.fetchedObjects?.count ?? 0 > 0{
                for i in 0 ..< featureCount{
                    guard let id = pharmacyData?.features[i].properties.id else {return}
                    guard let name = pharmacyData?.features[i].properties.name else {return}
                    guard let mask_adult = pharmacyData?.features[i].properties.mask_adult else {return}
                    guard let mask_child = pharmacyData?.features[i].properties.mask_child else {return}
                    guard let county = pharmacyData?.features[i].properties.county else {return}
                    guard let town = pharmacyData?.features[i].properties.town else {return}
                    
                    //篩選台中市
                    if county == "臺中市"{
                        taichungData.append(PharmacyInfo(id: id, name: name, mask_adult: mask_adult, mask_child: mask_child, county: county, town: town))
                    }
                    
                }
                
                
                
            }//資料庫吳資料
            else{
                for i in 0 ..< featureCount{
                    guard let id = pharmacyData?.features[i].properties.id else {return}
                    guard let name = pharmacyData?.features[i].properties.name else {return}
                    guard let mask_adult = pharmacyData?.features[i].properties.mask_adult else {return}
                    guard let mask_child = pharmacyData?.features[i].properties.mask_child else {return}
                    guard let county = pharmacyData?.features[i].properties.county else {return}
                    guard let town = pharmacyData?.features[i].properties.town else {return}
                    if county == "臺中市"{
                        taichungData.append(PharmacyInfo(id: id, name: name, mask_adult: mask_adult, mask_child: mask_child, county: county, town: town))
                        
                        let infoData = PharmacyInfo(id: id, name: name, mask_adult: mask_adult, mask_child: mask_child, county: county, town: town)
                        //存入Core Data
                        print(infoData.name)
                        CoreDataConnect.share.insertData(info: infoData)
                    }
                }
                
            }
            //取得所有地區
            for i in taichungData{
                townList.insert(i.town)
            }
            print(townList.count)
            
            DispatchQueue.main.async { [self] in
                apiActivityIndicator.removeFromSuperview()
                apiActivityIndicator.stopAnimating()
                view.isUserInteractionEnabled = true
                townPickerView.reloadAllComponents()
            }
            
        }
        
    }
    //MARK: - 解碼html並分割
    func parseHTML(){
        NetworkManager.share.dailyData { sentence, error in
            if let doc = try? HTML(html: sentence!, encoding: .utf8){
                let oneDaySentence = doc.xpath("/html/body/div[@class='wrapper']/article/div/div/div[@class='rwdfix']").first!.text
                let str1 = oneDaySentence?.replacingOccurrences(of: "\n", with: "")
                let str2 = str1?.replacingOccurrences(of: "\t", with: "")
                var str3 = str2?.trimmingCharacters(in: .whitespacesAndNewlines)
                let startIndex = str3?.startIndex
                let endIndex = str3?.endIndex
                let subIndex:String.Index = str3!.index(startIndex!, offsetBy: 97)
                let resultStringForAuthor = str3?.substring(from: subIndex)
                let stringRemoveAuthor = str3?.removeSubrange(subIndex..<endIndex!)
                let resultStringForOneDaySentence = str3?.trimmingCharacters(in: .whitespacesAndNewlines)
                DispatchQueue.main.async { [self] in
                    sentenceLabel.text =  resultStringForOneDaySentence
                    sentenceLabel.textColor = TDefind.s_grayColor
                    sentenceLabel.numberOfLines = 0
                    sentenceLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                    authorLabel.text = resultStringForAuthor
                    authorLabel.textColor = TDefind.s_grayColor
                    authorLabel.numberOfLines = 0
                    authorLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                    
                }
            }
        }
    }
    
}
//MARK: - tableview
extension MainViewController: UITableViewDelegate,UITableViewDataSource{
   
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let pharmacyInfo = fetchResultController.sections![section]
        return pharmacyInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell  = tableview.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TableViewCell
        let pharmacyData = fetchResultController.object(at: indexPath)
        
        cell.pharmacyLabel?.text = "藥局：" + (pharmacyData.name ?? "")
        cell.areaLabel?.text = "地區：" + (pharmacyData.town ?? "")
        cell.adultLabel?.text = "成人口罩：" + "\(pharmacyData.mask_adult )"
        cell.childLabel?.text = "兒童口罩：" + "\(pharmacyData.mask_child)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableview.frame.size.height / 10
    }
    // 各 cell 是否可以進入編輯狀態 及 左滑刪除
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pharmacyData = fetchResultController.object(at: indexPath)
        tableview.deselectRow(at: indexPath, animated: true)
        alert(title:"請問確定刪除該筆資料？",ok: "確定",cancel: "取消") { [self] in
            print(fetchResultController.fetchRequest.predicate)
            cellIndexPath = indexPath.row
            getCellPrimaryKey()
            if pharmacyData.id == cellPrimaryKey{
                CoreDataConnect.share.deletData(info: pharmacyData)
            }
            let fetchCount = fetchResultController.fetchedObjects?.count
            if fetchCount! <= 0 {
                fetchDataFromDatabase()
            }
            print("已刪除")
        } cancelHandler: {
            print("未刪除")
        }
    }
    
}
//MARK: - PickerView
extension MainViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(townList.count)
        return townList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(townList)[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if townList.count > 0 {
            selectTown = Array(townList)[row]
            print(selectTown)
        }
    }
}
//MARK:- FetchedResultsControllerDelegate
extension MainViewController : NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .move:
            tableview.deleteRows(at: [indexPath!], with: .fade)
            tableview.insertRows(at: [newIndexPath!], with: .fade)
        case .insert:
            print("這是新的indexpath : \(newIndexPath)")
            tableview.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            print("這是舊的indexpath : \(indexPath)")
            tableview.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableview.reloadRows(at: [indexPath!], with: .fade)
        default:
            tableview.reloadData()
        }
        
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.endUpdates()
    }
}
