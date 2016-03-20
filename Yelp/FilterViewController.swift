//
//  FilterViewController.swift
//  Yelp
//
//  Created by Nhat Truong on 3/16/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate{
    optional func filterViewController(filterViewController: FilterViewController, didUpdateFilters filters: [String:AnyObject])
}

class FilterViewController: UIViewController {

    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearch(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
        var filters = [String:AnyObject]()
        var selectedCategories = [String]()
        
        for (row, isSelected) in flagsCategory {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        if distance >= 0 {
            filters["distances"] = distance
        }
        
        for (row, isSelected) in flagsSort {
            if isSelected{
                filters["sort"] = row
            }
        }
        
        for (row, isSelected) in flags {
            if row == 0 {
                filters["deals"] = isSelected
            }
        }
        
        delegate?.filterViewController?(self, didUpdateFilters: filters)

    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let sectionHeaders = ["","Distance","Sort By", "Category"]
    let distanceChose = [1,2,3,4,5]
    var flags = [Int:Bool]()
    var flagsDistance = [Int:Bool]()
    var flagsSort = [Int:Bool]()
    var flagsCategory = [Int:Bool]()
    var distance = 0
    
    var distanceExpanded = false
    var sortExpanded = false
    var categoryExpanded = false
    var categories: [[String:String]]!
    var distances: [String]!
    var sortBy: [String]!
    weak var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        categories = yelpCategories()
        distances = yelpDistances()
        sortBy = yelpSort()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension FilterViewController: UITableViewDataSource, UITableViewDelegate, FilterCellDelegate {
    
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0: return 1
        case 1: return 5
        case 2: return 3
        case 3: return categories.count
        default: return 5
        }
    }
    
   
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 1:
            if indexPath.row == 0 {
                return 44
            }
            else {
                if distanceExpanded == true{
                    return 44
                }
                else {
                    return 0
                }
            
            }
        case 2:
            if indexPath.row == 0 {
                return 44
            }
            else {
                if sortExpanded == true{
                    return 44
                }
                else {
                    return 0
                }
            }
           
        case 3:
            if indexPath.row == 0 {
                return 44
            } else {
                if categoryExpanded == true{
                    return 44
                }
                else {
                    return 0
                }

            }
        default: return 44
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCell
            cell.delegate = self
            cell.onSwitch.on = flagsDistance[indexPath.row] ?? false
            cell.filterLabel.text = distances[indexPath.row]
            let tapGesture = UITapGestureRecognizer(target: self, action: "onDistanceCellTapped:")
            cell.addGestureRecognizer(tapGesture)

            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCell
            cell.delegate = self
            cell.onSwitch.on = flagsSort[indexPath.row] ?? false
            cell.filterLabel.text = sortBy[indexPath.row]
            let tapGesture = UITapGestureRecognizer(target: self, action: "onSortCellTapped:")
            cell.addGestureRecognizer(tapGesture)
            return cell

        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCell

            cell.delegate = self
            cell.onSwitch.on = flagsCategory[indexPath.row] ?? false
            cell.filterLabel.text = categories[indexPath.row]["name"]
            let tapGesture = UITapGestureRecognizer(target: self, action: "onCategoryCellTapped:")
            cell.addGestureRecognizer(tapGesture)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCell
            cell.delegate = self
            cell.filterLabel.text = "Offering a Deal"

            cell.onSwitch.on = flags[indexPath.row] ?? false
            
            return cell

        }
        
    }
    
    func onDistanceCellTapped(sender: UITapGestureRecognizer) {
        distanceExpanded = !distanceExpanded
        tableView.reloadData()
    }
    
    func onSortCellTapped(sender: UITapGestureRecognizer) {
        sortExpanded = !sortExpanded
        tableView.reloadData()

    }
    
    func onCategoryCellTapped(sender: UITapGestureRecognizer) {
        categoryExpanded = !categoryExpanded
        tableView.reloadData()

    }
    
    
    func filterCell(filterCell: FilterCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(filterCell)!
        switch indexPath.section {
        case 0:
            flags[indexPath.row] = value
        case 1:
            for i in 0..<flagsDistance.count {
                flagsDistance[i] = false
                }
            flagsDistance[indexPath.row] = value
            distance = distanceChose[indexPath.row]
            print(distance)
        case 2:
            flagsSort[indexPath.row] = value
        case 3:
            flagsCategory[indexPath.row] = value
        default:
            flags[indexPath.row] = value

        }
    }
    
    func yelpSort() -> [String]{
        return ["Best Matched", "Distance","Highest Rated"]
    }
    func yelpDistances() -> [String]{
        return ["1 mile","2 mile","3 mile", "4 mile", "5 mile"]
    }
    
    func yelpCategories() -> [[String:String]]{
        return [
            
            ["name" : "American, New", "code": "newamerican"],
            ["name" : "American, Traditional", "code": "tradamerican"],
            
            ["name" : "Argentine", "code": "argentine"],
            ["name" : "Asian Fusion", "code": "asianfusion"],
            ["name" : "Australian", "code": "australian"],
            ["name" : "Austrian", "code": "austrian"],
            ["name" : "Baguettes", "code": "baguettes"],
            ["name" : "Barbeque", "code": "bbq"],
            ["name" : "Basque", "code": "basque"],
            ["name" : "Beer Garden", "code": "beergarden"],
            ["name" : "Brazilian", "code": "brazilian"],
            ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
            ["name" : "British", "code": "british"],
            ["name" : "Buffets", "code": "buffets"],
            ["name" : "Bulgarian", "code": "bulgarian"],
            ["name" : "Burgers", "code": "burgers"],
            ["name" : "Burmese", "code": "burmese"],
            ["name" : "Cafes", "code": "cafes"],
            ["name" : "Cafeteria", "code": "cafeteria"],
            ["name" : "Cajun/Creole", "code": "cajun"],
            ["name" : "Cambodian", "code": "cambodian"],
            ["name" : "Canadian", "code": "New)"],
            ["name" : "Canteen", "code": "canteen"],
            ["name" : "Caribbean", "code": "caribbean"],
            ["name" : "Catalan", "code": "catalan"],
            ["name" : "Chech", "code": "chech"],
            ["name" : "Cheesesteaks", "code": "cheesesteaks"],
            ["name" : "Chicken Shop", "code": "chickenshop"],
            ["name" : "Chicken Wings", "code": "chicken_wings"],
            ["name" : "Chilean", "code": "chilean"],
            ["name" : "Chinese", "code": "chinese"],
            ["name" : "Comfort Food", "code": "comfortfood"],
            ["name" : "Corsican", "code": "corsican"],
            ["name" : "Creperies", "code": "creperies"],
            ["name" : "Cuban", "code": "cuban"],
            ["name" : "Curry Sausage", "code": "currysausage"],
            ["name" : "Cypriot", "code": "cypriot"],
            ["name" : "Czech", "code": "czech"],
            ["name" : "Czech/Slovakian", "code": "czechslovakian"],
            ["name" : "Danish", "code": "danish"],
            ["name" : "Delis", "code": "delis"],
            ["name" : "Diners", "code": "diners"],
            ["name" : "Dumplings", "code": "dumplings"],
            ["name" : "Eastern European", "code": "eastern_european"],
            ["name" : "Ethiopian", "code": "ethiopian"],
            ["name" : "Fast Food", "code": "hotdogs"],
            ["name" : "Filipino", "code": "filipino"],
            ["name" : "Fish & Chips", "code": "fishnchips"],
            ["name" : "Fondue", "code": "fondue"],
            ["name" : "Food Court", "code": "food_court"],
            ["name" : "Food Stands", "code": "foodstands"],
            ["name" : "French", "code": "french"],
            ["name" : "French Southwest", "code": "sud_ouest"],
            ["name" : "Galician", "code": "galician"],
            ["name" : "Gastropubs", "code": "gastropubs"],
            ["name" : "Georgian", "code": "georgian"],
            ["name" : "German", "code": "german"],
            ["name" : "Giblets", "code": "giblets"],
            ["name" : "Gluten-Free", "code": "gluten_free"],
            ["name" : "Greek", "code": "greek"],
            ["name" : "Halal", "code": "halal"],
            ["name" : "Hawaiian", "code": "hawaiian"],
            ["name" : "Heuriger", "code": "heuriger"],
            ["name" : "Himalayan/Nepalese", "code": "himalayan"],
            ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
            ["name" : "Hot Dogs", "code": "hotdog"],
            ["name" : "Hot Pot", "code": "hotpot"],
            ["name" : "Hungarian", "code": "hungarian"],
            ["name" : "Iberian", "code": "iberian"],
            ["name" : "Indian", "code": "indpak"],
            ["name" : "Indonesian", "code": "indonesian"],
            ["name" : "International", "code": "international"],
            ["name" : "Irish", "code": "irish"],
            ["name" : "Island Pub", "code": "island_pub"],
            ["name" : "Israeli", "code": "israeli"],
            ["name" : "Italian", "code": "italian"],
            ["name" : "Japanese", "code": "japanese"],
            ["name" : "Jewish", "code": "jewish"],
            ["name" : "Kebab", "code": "kebab"],
            ["name" : "Korean", "code": "korean"],
            ["name" : "Kosher", "code": "kosher"],
            ["name" : "Kurdish", "code": "kurdish"],
            ["name" : "Laos", "code": "laos"],
            ["name" : "Laotian", "code": "laotian"],
            ["name" : "Latin American", "code": "latin"],
            ["name" : "Live/Raw Food", "code": "raw_food"],
            ["name" : "Lyonnais", "code": "lyonnais"],
            ["name" : "Malaysian", "code": "malaysian"],
            ["name" : "Meatballs", "code": "meatballs"],
            ["name" : "Mediterranean", "code": "mediterranean"],
            ["name" : "Mexican", "code": "mexican"],
            ["name" : "Middle Eastern", "code": "mideastern"],
            ["name" : "Milk Bars", "code": "milkbars"],
            ["name" : "Modern Australian", "code": "modern_australian"],
            ["name" : "Modern European", "code": "modern_european"],
            ["name" : "Mongolian", "code": "mongolian"],
            ["name" : "Moroccan", "code": "moroccan"],
            ["name" : "New Zealand", "code": "newzealand"],
            ["name" : "Night Food", "code": "nightfood"],
            ["name" : "Norcinerie", "code": "norcinerie"],
            ["name" : "Open Sandwiches", "code": "opensandwiches"],
            ["name" : "Oriental", "code": "oriental"],
            ["name" : "Pakistani", "code": "pakistani"],
            ["name" : "Parent Cafes", "code": "eltern_cafes"],
            ["name" : "Parma", "code": "parma"],
            ["name" : "Persian/Iranian", "code": "persian"],
            ["name" : "Peruvian", "code": "peruvian"],
            ["name" : "Pita", "code": "pita"],
            ["name" : "Pizza", "code": "pizza"],
            ["name" : "Polish", "code": "polish"],
            ["name" : "Portuguese", "code": "portuguese"],
            ["name" : "Potatoes", "code": "potatoes"],
            ["name" : "Poutineries", "code": "poutineries"],
            ["name" : "Pub Food", "code": "pubfood"],
            ["name" : "Rice", "code": "riceshop"],
            ["name" : "Romanian", "code": "romanian"],
            ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
            ["name" : "Rumanian", "code": "rumanian"],
            ["name" : "Russian", "code": "russian"],
            ["name" : "Salad", "code": "salad"],
            ["name" : "Sandwiches", "code": "sandwiches"],
            ["name" : "Scandinavian", "code": "scandinavian"],
            ["name" : "Scottish", "code": "scottish"],
            ["name" : "Seafood", "code": "seafood"],
            ["name" : "Serbo Croatian", "code": "serbocroatian"],
            ["name" : "Signature Cuisine", "code": "signature_cuisine"],
            ["name" : "Singaporean", "code": "singaporean"],
            ["name" : "Slovakian", "code": "slovakian"],
            ["name" : "Soul Food", "code": "soulfood"],
            ["name" : "Soup", "code": "soup"],
            ["name" : "Southern", "code": "southern"],
            ["name" : "Spanish", "code": "spanish"],
            ["name" : "Steakhouses", "code": "steak"],
            ["name" : "Sushi Bars", "code": "sushi"],
            ["name" : "Swabian", "code": "swabian"],
            ["name" : "Swedish", "code": "swedish"],
            ["name" : "Swiss Food", "code": "swissfood"],
            ["name" : "Tabernas", "code": "tabernas"],
            ["name" : "Taiwanese", "code": "taiwanese"],
            ["name" : "Tapas Bars", "code": "tapas"],
            ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
            ["name" : "Tex-Mex", "code": "tex-mex"],
            ["name" : "Thai", "code": "thai"],
            ["name" : "Traditional Norwegian", "code": "norwegian"],
            ["name" : "Traditional Swedish", "code": "traditional_swedish"],
            ["name" : "Trattorie", "code": "trattorie"],
            ["name" : "Turkish", "code": "turkish"],
            ["name" : "Ukrainian", "code": "ukrainian"],
            ["name" : "Uzbek", "code": "uzbek"],
            ["name" : "Vegan", "code": "vegan"],
            ["name" : "Vegetarian", "code": "vegetarian"],
            ["name" : "Venison", "code": "venison"],
            ["name" : "Vietnamese", "code": "vietnamese"],
            ["name" : "Wok", "code": "wok"],
            ["name" : "Wraps", "code": "wraps"],
            ["name" : "Yugoslav", "code": "yugoslav"]]
    }

    
   
}

