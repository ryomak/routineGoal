//
//  ViewController.swift
//  routineGOAL
//
//  Created by 栗栖遼馬 on 2018/06/01.
//  Copyright © 2018年 Ryoma. All rights reserved.
//
import UIKit
import FSCalendar
import CalculateCalendarLogic
import FanMenu
import Macaw

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    
    @IBOutlet weak var fanMenu: FanMenu!
    
    @IBOutlet weak var calender: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // デリゲートの設定
        self.calender = FSCalendar()
        fanMenu.button = FanMenuButton(
            id: "main",
            image:"",
            color: Color(val: 0x7C93FE)
        )
        fanMenu.items = [
            FanMenuButton(
                id: "setting",
                image:"",
                color: Color(val: 0xCECBCB)
            ),
            FanMenuButton(
                id: "date",
                image:"",
                color: Color(val: 0xCECBCB)
            ),
            
        ]
        fanMenu.menuRadius = 100.0
        fanMenu.duration = 0.2
        fanMenu.interval = (Double.pi + Double.pi/4, Double.pi + 3 * Double.pi/4)
        fanMenu.radius = 25.0
        fanMenu.delay = 0.0
        fanMenu.onItemWillClick = { button in
            print(button.id)
            self.showView(id: button.id)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func showView(id :String) {
        if (id=="main"){
            return
        }
        UIView.animate(withDuration: 0.35, animations: {
           self.performSegue(withIdentifier: id, sender: nil)
        })
    }
    
    @IBAction func returnToModal(segue: UIStoryboardSegue){
        self.dismiss(animated: true, completion: nil)
    }
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        return nil
    }
    
}
