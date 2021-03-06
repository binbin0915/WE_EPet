//
//  HomeIndexViewController.swift
//  WE_EPet
//
//  Created by 姚凤 on 16/9/17.
//  Copyright © 2016年 姚凤. All rights reserved.
//

import UIKit
import Alamofire

let URL_Dog = "http://cdnapi.epet.com/appmall/main.html?do=index201602&appname=epetmall&duuid=AAEEDCD1-8804-45FA-B058-3526E1557649&iphone_model=iphone5&my_placeid=24&passkey=891bcda0bc55f0717607c5928b917ad5&pet_type=dog&postsubmit=r9b8s7m4&system=ios&version=3.400000"

let URL_Dog_Worth = "http://api.epet.com/appmall/v3/main.html?do=getDynamic&appname=epetmall&duuid=AAEEDCD1-8804-45FA-B058-3526E1557649&iphone_model=iphone5&my_placeid=24&passkey=00bb2c9bba1c8d213e16f042bb1a56db&pet_type=cat&postsubmit=r9b8s7m4&system=ios&version=3.400000"

let URL_Cat = "http://api.epet.com/appmall/v3/main.html?do=getDynamic&appname=epetmall&duuid=AAEEDCD1-8804-45FA-B058-3526E1557649&iphone_model=iphone5&my_placeid=24&passkey=891bcda0bc55f0717607c5928b917ad5&pet_type=dog&postsubmit=r9b8s7m4&system=ios&version=3.400000"

let ImageURL = "http://i.epetbar.com/2015-12/07/16/21064d11879da67623737d891691ee5b.jpg-222-226.png"

let cellID = "cellID"
let recommondCellID = "recomdCell"
let buttonListCellID = "buttonCell"
let goodCellID = "goodCell"

class HomeIndexViewController: RootViewController,UISearchBarDelegate {

    
    var areaButton : UIButton?
    var textField : UISearchBar?
    var messageButton : UIButton?
    lazy var tabView : UITableView = {
      let tab = UITableView(frame: CGRect(x: 0, y: 70, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-120), style: .plain)
        tab.separatorStyle = .none
        tab.delegate = self
        tab.dataSource = self
        tab.register(AutoScrollTableViewCell.self, forCellReuseIdentifier: cellID)
        tab.register(UINib.init(nibName: "RecommondTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: recommondCellID)
        tab.register(UINib.init(nibName: "ButtonListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: buttonListCellID)
        tab.register(UINib.init(nibName: "GoodCommondTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: goodCellID)
        return tab
    }()
    
    //数据源
    var model : AutoScrollModel?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGB(r: 223.0/255.0, g: 223.0/255.0, b: 223.0/255.0)
        self.topInputView()
        self.requstData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //顶部输入框
    func topInputView() {
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 70))
        topView.backgroundColor = UIColor.white
        self.view.addSubview(topView)
        
        areaButton = UIButton.init(frame: CGRect(x: 0, y: 20, width: 70, height: 50))
        areaButton?.setTitleColor(RGB(r: 50.0/255.0, g: 193.0/255.0, b: 108.0/255.0), for: .normal)
        areaButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        areaButton?.setTitle("江苏", for: .normal)
        areaButton?.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, -40)
        areaButton?.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20)
        areaButton?.setImage(UIImage(named: "downarrow"), for: .normal)
        areaButton?.addTarget(self, action: #selector(HomeIndexViewController.areaSelect), for: .touchUpInside)
        topView.addSubview(areaButton!)
        
        textField = UISearchBar.init(frame: CGRect(x: 70, y: 25, width: SCREEN_WIDTH-120, height: 40))
        textField?.backgroundColor = UIColor.white
        textField?.delegate = self
        textField?.placeholder = "搜索宝贝"
        topView.addSubview(textField!)
        let seachTextFeild:UITextField = textField?.subviews.first?.subviews.last as! UITextField
        seachTextFeild.backgroundColor = RGB(r: 220.0/255.0, g: 220.0/255.0, b: 220.0/255.0)
        seachTextFeild.textColor = UIColor.lightGray
        let searchBarBg: UIImage = UIImage.getImageWithColor(color: RGB(r: 255.0, g: 255.0, b: 255.0))
        textField?.setBackgroundImage(searchBarBg, for: .any, barMetrics: .default)
        textField?.backgroundColor = UIColor.clear
        
        
        messageButton = UIButton.init(frame: CGRect(x: SCREEN_WIDTH-50, y: 20, width: 50, height: 50))
        messageButton?.setImage(UIImage(named: "user_mesage"), for: .normal)
        topView.addSubview(messageButton!)
        
        let view = UIView.init(frame: CGRect(x: 0, y: 69.5, width: SCREEN_WIDTH, height: 0.5))
        view.backgroundColor = UIColor.lightGray
        topView.addSubview(view)
    }
    
    func getImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //区域选择
    func areaSelect() {
        AreaSelectViewController.ShowAreaSelectView { (dict) in
            
            let result : [String : String] = dict as! [String : String]
            self.areaButton?.setTitle(result["set_name"], for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
}


//网络请求
extension HomeIndexViewController{
    func requstData() {
        Alamofire.request(URL_Dog).responseJSON { response1 in
            
            Alamofire.request(URL_Dog_Worth).responseJSON { response2 in
                
                let dict1 : Any? = response1.result.value as Any?
                let dict2 : Any? = response2.result.value as Any?
                if let resultDict1 :Dictionary = dict1 as? Dictionary<String, AnyObject>{
                    let resultDict2 :Dictionary = (dict2 as? Dictionary<String, AnyObject>)!
                    self.model = AutoScrollModel.modelWithDict(dict: resultDict1)
                    self.model?.worthbuyList = resultDict2["worthbuy"] as! [NSDictionary]?
                    self.view.addSubview(self.tabView)
                    self.tabView.reloadData()
                }
            }
        }
    }
}

//代理方法
extension HomeIndexViewController: UITableViewDelegate,UITableViewDataSource{
    @available(iOS 2.0, *)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            //轮播图
            return 1
        case 1:
            //特卖按钮
            return 1
        case 2:
            //物品列表
            let array = self.model?.worthbuyList
            return (array?.count)!/2
        case 3:
            //口碑评价
            let array = self.model?.hotComments
            return (array?.count)!
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            //轮播图
            return 215
        case 1:
            //特卖按钮
            return 80
        case 2:
            //物品列表
            return 255
        case 3:
            //口碑评价
            return 154
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section==0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! AutoScrollTableViewCell
            cell.configData(model: self.model!)
            return cell
        }else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: buttonListCellID) as! ButtonListTableViewCell
            return cell
            
        }else if indexPath.section == 2 {
            
            let worthBuyList = self.model?.worthbuyList
            let leftDict = worthBuyList?[indexPath.row*2]
            let rightDict = worthBuyList?[indexPath.row*2+1]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: recommondCellID) as! RecommondTableViewCell
            cell.configData(leftDict: leftDict!, rightDict: rightDict!)
            return cell
            
        }else{
            let goodsList = self.model?.hotComments
            let cell = tableView.dequeueReusableCell(withIdentifier: goodCellID) as! GoodCommondTableViewCell
            cell.configData(dict: (goodsList?[indexPath.row])! as NSDictionary)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

