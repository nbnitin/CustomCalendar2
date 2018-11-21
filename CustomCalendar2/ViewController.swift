//
//  ViewController.swift
//  CustomCalendar2
//
//  Created by Nitin Bhatia on 21/11/18.
//  Copyright © 2018 Nitin Bhatia. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var openCalenderBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 2.0, bottom: 5.0, right: 2.0)
    let itemsPerRow: CGFloat = 1

    
    let FIRST_DAY_INDEX = 0
    let NUMBER_OF_DAYS_INDEX = 1
    let DATE_SELECTED_INDEX = 2
    var nDays = Int()
    var monthsdays:[String]=[]
    var selectedDate : Date = Date()
    var monthInfo : [Int:[Int]] = [Int:[Int]]()
    var datePicker : UIDatePicker!
    var selectedIndexPath : IndexPath!
    fileprivate var startOfMonthCache : Date = Date()
    var didselectClick = false
    var veryfirstCome = true
    var iscolenderOpen = false
    var toolBar = UIToolbar()
    var dateselectClick = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let currentDate=Date()
        let currentDatecalendar = Calendar.current
        let components = (currentDatecalendar as NSCalendar).components([.day , .month , .year], from:currentDate)
        let currentday = components.day
        let calendar = Calendar.current
        let components1 = (calendar as NSCalendar).components([.day , .month , .year], from: currentDate)
        self.createCalendar(components1.month!,year: components1.year!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createCalendar( _ month: Int, year: Int)
    {
        var monthOffsetComponents = DateComponents()
        monthOffsetComponents.month = month;
        monthOffsetComponents.year = year;
        let dayArr = NSMutableArray(array: ["SUN","MON","TUE", "WED","THU","FRI","SAT","SUN","MON","TUE", "WED","THU","FRI","SAT","SUN","MON","TUE", "WED","THU","FRI","SAT","SUN","MON","TUE", "WED","THU","FRI","SAT","SUN","MON","TUE", "WED","THU","FRI","SAT","SUN","MON","TUE", "WED",])
        
        let dateFormatter = DateFormatter()
        // convert to required string
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var somedateString: String;
        if datePicker==nil
        {
            if UserDefaults.standard.object(forKey: "selectedDate") != nil
            {
                let newDate = UserDefaults.standard.object(forKey: "selectedDate") as! Date
                let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
                var components = (gregorian as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: newDate)
                components.day=1
                components.hour = 9
                components.minute = 30
                components.second = 0
                let updatedDate = gregorian.date(from: components)!
                somedateString = dateFormatter.string(from: updatedDate)
            }
            else
            {
                let date = Date()
                let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
                var components = (gregorian as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: date)
                components.day=1
                components.hour = 9
                components.minute = 30
                components.second = 0
                let updatedDate = gregorian.date(from: components)!
                somedateString = dateFormatter.string(from: updatedDate)
            }
            
            
        }
        else
        {
            let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
            var components = (gregorian as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: datePicker.date)
            components.day=1
            components.hour = 9
            components.minute = 30
            components.second = 0
            let updatedDate = gregorian.date(from: components)!
            somedateString = dateFormatter.string(from: updatedDate)
        }
        
        let fdIndex = getDateOfMonth(somedateString)
        let calendar = Calendar.current
        let date = calendar.date(from: monthOffsetComponents)!
        let range = (calendar as NSCalendar).range(of: .day, in: .month, for: date)
        nDays = range.length
        var count = Int()
        count=(fdIndex)!
        count=count-1
        monthsdays.removeAll()
        for _ in 0...nDays{
            monthsdays.append(dayArr[count] as! String)
            count += 1
        }
        //didselectClick=true
        collectionView.reloadData()
        
        
        
    }
    func getDateOfMonth(_ today:String)->Int?
    {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.date(from: today) {
            let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let myComponents = (myCalendar as NSCalendar).components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        }
        else
        {
            return nil
        }
        
    }
    
    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return nDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath)
        
        let backgroundView=cell.viewWithTag(1)
        
        backgroundView!.layer.shadowColor = UIColor.gray.cgColor
        backgroundView!.layer.shadowOffset = CGSize(width: 0, height: 1)
        backgroundView!.layer.shadowOpacity = 0.5
        backgroundView!.clipsToBounds = false
        backgroundView!.layer.masksToBounds = false
        let modelName = UIDevice.current.model
        var wholeStr: String = ""
        let DayLabel=cell.viewWithTag(2) as! UILabel
        let DateLabel=cell.viewWithTag(3) as! UILabel
        //        print(cell.frame)
        //        print(DayLabel.frame)
        
        if modelName=="iPhone 4s"
        {
            wholeStr="    \(monthsdays[indexPath.item])      \(indexPath.item+1)"
        }
        else
        {
            wholeStr="\(monthsdays[indexPath.item])         \(indexPath.item+1)"
        }
        let date = Date()
        DayLabel.text=monthsdays[indexPath.item]
        DayLabel.textAlignment=NSTextAlignment.center
        DateLabel.text=String(indexPath.item+1)
        DateLabel.textAlignment=NSTextAlignment.center
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from:date)
        let currentday = components.day
        let currentMonth=components.month
        let currentYear=components.year;
        if datePicker==nil
        {
            let components2 = (calendar as NSCalendar).components([.day , .month , .year], from:date)
            let selectedMonth=components2.month
            let selectedYear=components2.year;
            
            if currentday==indexPath.row+1 && currentMonth==selectedMonth && currentYear==selectedYear
            {
                DayLabel.textColor = UIColor(red: 80/255, green: 129/255, blue: 219/255, alpha: 1)
                DateLabel.textColor = UIColor(red: 80/255, green: 129/255, blue: 219/255, alpha: 1)
            }
            else
            {
                DayLabel.textColor = UIColor.gray
                DateLabel.textColor = UIColor.gray
            }
        }
        else
        {
            let components2 = (calendar as NSCalendar).components([.day , .month , .year], from:datePicker.date)
            let selectedMonth=components2.month
            let selectedYear=components2.year;
            
            if currentday==indexPath.row+1 && currentMonth==selectedMonth && currentYear==selectedYear
            {
                DayLabel.textColor = UIColor(red: 80/255, green: 129/255, blue: 219/255, alpha: 1)
                DateLabel.textColor = UIColor(red: 80/255, green: 129/255, blue: 219/255, alpha: 1)
            }
            else
            {
                DayLabel.textColor = UIColor.gray
                DateLabel.textColor = UIColor.gray
            }
        }
        
        let  selectedindex=UserDefaults.standard.integer(forKey: "selectedIndex")
        let indexPath1 = IndexPath(row: selectedindex, section: 0)
        selectedIndexPath=indexPath1;
        
        
        if (DayLabel.text == "SUN"){
            DayLabel.textColor = UIColor.red
            DateLabel.textColor = UIColor.red
        }
        
        configure(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configure(_ cell: UICollectionViewCell, forRowAtIndexPath indexPath: IndexPath) {
        if selectedIndexPath == indexPath {
            // selected
            //cell.backgroundColor = UIColor.redColor()
            let label = cell.viewWithTag(2) as? UILabel
            let date = Date()
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components([.day , .month , .year], from:date)
            let currentday = components.day
            let currentMonth=components.month
            let currentYear=components.year;
            if datePicker==nil
            {
                let components2 = (calendar as NSCalendar).components([.day , .month , .year], from:date)
                let selectedMonth=components2.month
                let selectedYear=components2.year;
                
                if currentday==indexPath.row+1 && currentMonth==selectedMonth && currentYear==selectedYear
                {
                    label!.textColor = UIColor(red: 80/255, green: 129/255, blue: 219/255, alpha: 1)
                }
                else
                {
                    label!.textColor = UIColor.black
                }
                
                if (label?.text == "SUN"){
                    label?.textColor = UIColor.red
                    
                }
                
            }
            else
            {
                let components2 = (calendar as NSCalendar).components([.day , .month , .year], from:datePicker.date)
                let selectedMonth=components2.month
                let selectedYear=components2.year;
                
                if currentday==indexPath.row+1 && currentMonth==selectedMonth && currentYear==selectedYear
                {
                    label!.textColor = UIColor(red: 80/255, green: 129/255, blue: 219/255, alpha: 1)
                }
                else
                {
                    label!.textColor = UIColor.black
                }
                if (label?.text == "SUN"){
                    label?.textColor = UIColor.red
                    
                }
            }
            if didselectClick
            {
                cell.frame.origin.y = cell.frame.origin.y
                cell.frame.origin.x = cell.frame.origin.x+2
                cell.frame.size.width = cell.frame.size.width-4
                cell.frame.size.height = cell.frame.size.height-2
            }
            if veryfirstCome
            {
                let  selectedindex=UserDefaults.standard.integer(forKey: "selectedIndex")
                if selectedindex as Int == indexPath.row {
                    veryfirstCome=false;
                    cell.frame.origin.y = cell.frame.origin.y
                    cell.frame.origin.x = cell.frame.origin.x+2
                    cell.frame.size.width = cell.frame.size.width-4
                    cell.frame.size.height = cell.frame.size.height-2

                }
            }
            
            
        }
        else {
            // not selected
            //cell.backgroundColor = UIColor.whiteColor()
            let label = cell.viewWithTag(2) as? UILabel
            let calendar = Calendar.current
            let date = Date()
            let components = (calendar as NSCalendar).components([.day , .month , .year], from:date)
            let currentday = components.day
            let currentMonth=components.month
            let currentYear=components.year;
            if datePicker==nil
            {
                let components2 = (calendar as NSCalendar).components([.day , .month , .year], from:date)
                let selectedMonth=components2.month
                let selectedYear=components2.year;
                
                if currentday==indexPath.row+1 && currentMonth==selectedMonth && currentYear==selectedYear
                {
                    label!.textColor = UIColor(red: 80/255, green: 129/255, blue: 219/255, alpha: 1)
                }
                else
                {
                    label!.textColor = UIColor.gray
                }
                if (label?.text == "SUN"){
                    label?.textColor = UIColor.red
                    
                }
            }
            else
            {
                let components2 = (calendar as NSCalendar).components([.day , .month , .year], from:datePicker.date)
                let selectedMonth=components2.month
                let selectedYear=components2.year;
                
                if currentday==indexPath.row+1 && currentMonth==selectedMonth && currentYear==selectedYear
                {
                    label!.textColor = UIColor(red: 80/255, green: 129/255, blue: 219/255, alpha: 1)
                }
                else
                {
                    label!.textColor = UIColor.gray
                }
                if (label?.text == "SUN"){
                    label?.textColor = UIColor.red
                    
                }
            }
//            if collectionscroll
//            {
//                if collectionFirstLaunch
//                {
//
//                    cell.frame.origin.y = cell.frame.origin.y
//                    cell.frame.origin.x = cell.frame.origin.x-2
//                    cell.frame.size.width = cell.frame.size.width+4
//                    cell.frame.size.height = cell.frame.size.height+2
//
//                }
//
//            }
           
           
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
        let dateformatter  = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        var components1 = (gregorian as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: startOfMonthCache)
        components1.day=indexPath.row+1
        
      //  let updatedDate = gregorian.date(from: components1)!

//
//        if checkSynchFound != 0
//        {
//
//
//
//            let rowdaat = schiduleCoredataList[0];
//            let dateFormatter1 = DateFormatter()
//            dateFormatter1.dateFormat = "yyyy-MM-dd"
//            let str = rowdaat.value(forKey: "date") as! String
//            let strDate = dateFormatter1.date(from: str)
//            dateFormatter1.dateFormat = "EE, MMM d, yyyy"
//            //  currentdayLbl.text="\(dateFormatter1.string(from: strDate!))"
//
//        }
//        else
//        {
//
//
////            let dateFormatter1 = DateFormatter()
////            dateFormatter1.dateFormat = "EE, MMM d, yyyy"
////            currentdayLbl.text = "\(dateFormatter1.string(from: updatedDate))"
////            dateFormatter1.dateFormat = "MMMM yyyy"
////            openCalenderBtn.setTitle(dateFormatter1.string(from: updatedDate), for: UIControlState())
////
//
//
//
//
//
//        }
       // collectionViewSelectedPath = indexPath;
        
       // collectionFirstLaunch=true;
        if selectedIndexPath == indexPath {
            // selected same cell -> deselect all
            selectedIndexPath = nil
            didselectClick = false
        }
        else {
            // select different cell
            let oldSelectedIndexPath = selectedIndexPath
            selectedIndexPath = indexPath
            didselectClick = true
            
            // refresh old cell to clear old selection indicators
            
            if let previousSelectedIndexPath = oldSelectedIndexPath {
                if let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath)
                {
                    configure(previousSelectedCell, forRowAtIndexPath: previousSelectedIndexPath)
                }
            }
        }
        
        let selectedCel = collectionView.cellForItem(at: indexPath)
        
        
        
        configure(selectedCel!, forRowAtIndexPath: indexPath)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let paddingSpace = sectionInsets.left
        let availableWidth = view.frame.width - paddingSpace
        _ = availableWidth / itemsPerRow
        
        return CGSize(width: 70, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return sectionInsets
    }
    
    // MARK: - Datepicker
    
    func adddatepicker()
    {
        if !iscolenderOpen
        {
            self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: view.frame.size.height-216, width: self.view.frame.size.width, height: 216))
            self.datePicker.backgroundColor = UIColor.white
            self.datePicker.datePickerMode = UIDatePickerMode.date
            view.addSubview( self.datePicker)
            
            //            let dateformatter  = NSDateFormatter()
            //            dateformatter.dateFormat = "EE, MMM d, yyyy"
            //            let date1=dateformatter.dateFromString(currentdayLbl.text!)
            
                self.datePicker.setDate(selectedDate, animated: false)
            
            
            // ToolBar
            self.toolBar = UIToolbar()
            self.toolBar.frame = CGRect(x: 0, y: view.frame.size.height-260, width: self.view.frame.size.width, height: 46)
            self.toolBar.barStyle = .default
            self.toolBar.isTranslucent = true
            self.toolBar.backgroundColor = UIColor.gray
            self.toolBar.tintColor = UIColor(red: 80/255, green: 129/255, blue: 219/255, alpha: 1)
            self.toolBar.sizeToFit()
            view.addSubview(toolBar)
            // Adding Button ToolBar
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
            self.toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            self.toolBar.isUserInteractionEnabled = true
            iscolenderOpen = true;
        }
        
    }
    @objc func doneClick() {
        let calendar = Calendar.current
        let components1 = (calendar as NSCalendar).components([.day , .month , .year], from: datePicker.date)
        self.createCalendar(components1.month!,year: components1.year!)
       // collectionscroll=false
        selectedIndexPath = nil
        didselectClick = false
        dateselectClick = true
        let dateFormatter1 = DateFormatter()
//        if isNotdownload
//        {
//            selectedDate=datePicker.date;
//            UserDefaults.standard.set(components1.day!-1, forKey: "selectedIndex")
//            UserDefaults.standard.set(selectedDate, forKey:"selectedDate")
//            veryfirstCome=true;
//            let indexPath1 = IndexPath(row: components1.day!-1, section: 0)
//            self.collectionView.scrollToItem(at: indexPath1, at: .centeredHorizontally, animated: true)
//            dateFormatter1.dateFormat = "EE, MMM d, yyyy"
//            currentdayLbl.text = "\(dateFormatter1.string(from: datePicker.date))"
//            downloadschedule(datePicker.date)
//
//        }
        
//            let rowdaat = schiduleCoredataList[0];
//            dateFormatter1.dateFormat = "yyyy-MM-dd"
//            let str = rowdaat.value(forKey: "date") as! String
//            let strDate = dateFormatter1.date(from: str)
//            dateFormatter1.dateFormat = "EE, MMM d, yyyy"
//            currentdayLbl.text="\(dateFormatter1.string(from: strDate!))"
        
        
        
        
        dateFormatter1.dateFormat = "MMMM yyyy"
        openCalenderBtn.setTitle(dateFormatter1.string(from: datePicker.date), for: UIControlState())
        startOfMonthCache = datePicker.date;
        self.datePicker.resignFirstResponder()
        datePicker.isHidden=true;
        toolBar.isHidden=true;
        iscolenderOpen = false;
    }
    @objc func cancelClick() {
        self.datePicker.resignFirstResponder()
        self.datePicker.isHidden=true;
        self.toolBar.isHidden=true;
        iscolenderOpen = false
    }
    func datePickerValueChanged(_ sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
    }

    @IBAction func btnOpenCalendarAction(_ sender: Any) {
        self.adddatepicker()
    }
}

