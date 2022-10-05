//
//  BaseViewController.swift
//  Mask
//
//  Created by 何安竺 on 2022/10/5.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // 設定 NavigationBar
        setNavigationBarStyle()
        
        self.view.backgroundColor = TDefind.s_backGroundColor
   
        
    }
    
    
    //MARK: - 設定 NavigationBarStyle
    public func setNavigationBarStyle(){
        let appearance = UINavigationBarAppearance()
        //底色
        appearance.backgroundColor = TDefind.s_mainColor
        //tinit Color
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 1)
        //title Color
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        appearance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        //title
        self.title = "台中市 全區"
        
    }
    

}
extension String{
    func replacing(str: String)-> String{
        var newStr = str.replacingOccurrences(of: "\n", with: "")
        newStr = newStr.replacingOccurrences(of: "\t", with: "")
        newStr = newStr.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return newStr
    }
}
