//
//  SeasonDetailViewController.swift
//  iAlhanNew
//
//  Created by Sidarous, Arsani on 10/7/16.
//  Copyright © 2016 alhan.org. All rights reserved.
//

import UIKit

public struct SeasonHymns {
    //var hymnName: String!
    var seasonSections: [String: [EventHymns]]!
}

struct EventHymns {
    var hymnName: String!
    var hymnID: Int!
    var hymnDescription: String!
    var hymnCoptic: String!
    var hymnEnglish: String!
    var hymnAudio: String!
}

class SeasonDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    // Model: an album
    //var album: Season?
    //var seasonHymnsStruct: SeasonHymns?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!

    @IBOutlet var tableView: UITableView!

    let textCellIdentifier = "TextCell"
    var labelText: String?
    
    var eventHymns:[EventHymns]?
    var seasonHymns: [SeasonHymns]?
    
    struct structureArray {
        var sectionName: String!
        var sectionDetails: [AnyObject]!
    }
    
    var objectArray = [structureArray]()

   
   
    func updateUI()
    {
        
        //print (album!.seasonSections?.count)
        
       
        tableView.delegate = self
        tableView.dataSource = self
        
        //print ("Array count \(arrayCount)")
        //print (hymnArray.description)
        
        //print("!!!! SeasonHymns Struct: \(seasonHymns)")
        //print("----------")
        
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        updateUI()
        //print ("Label Text \(labelText)")
        title = labelText
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // get rid of the background image from superview
        // backgroundImageView.removeFromSuperview()
        //visualEffectView.removeFromSuperview()

    }
    
 
    
    // MARK:  UITableViewDelegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (seasonHymns!.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsPerSection: Int!
        let tempDict = seasonHymns![section].seasonSections
        for (_, v) in tempDict!{
            //print ("k & V: \(k) -- > \(v) ")
            //hymnDetailTemp = v
            //print ("????? No of values for TEMP DICT: \(v.count)")
            rowsPerSection = v.count
        }

        return (rowsPerSection)!
    }
    
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //print ("header for section: \(section)")
    
        let tempDict = seasonHymns![section].seasonSections
    
        let description = tempDict?.keys.first
            //seasonHymns?[section].sectionName.description
    
        //let range = rawDescription.index(rawDescription.startIndex, offsetBy: 4)..<rawDescription.endIndex

        return description
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath as IndexPath)
        
        let row = indexPath.row
        let section = indexPath.section
        //cell.textLabel?.text = (hymnArray?[row].seasonSections)! as String
        /*print("++++++++++++++++++++")
        print(section)
        print((seasonHymns![section].seasonSections)) */
        let tempDict = seasonHymns![section].seasonSections
        //var hymnDetailTemp
        var hymnNameLabel: String!
        var hymnDescLabel: String!
        
        for (_, v) in tempDict!{
            //print ("k & V: \(k) -- > \(v) ")
            //hymnDetailTemp = v
            //print ("Number of hymns in section: \(v.count)")
            hymnNameLabel = v[row].hymnName
            hymnDescLabel = v[row].hymnDescription
            //print ("This is the row and hymn name \(row) -->> \(hymnNameLabel)")
            //print(hymnDetailTemp[row].hymnName)
        }
        //cell.textLabel?.text = (objectArray[section].sectionDetails[row].hymnDescription) as String
        cell.textLabel?.text = hymnNameLabel
        cell.detailTextLabel?.text = hymnDescLabel
        return cell
    }
    
    
//   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//    
//    let row = indexPath.row
//    let section = indexPath.section
//    
//    let tempDict = seasonHymns![section].seasonSections
//    
//    for (_, v) in tempDict!{
//        //print ("k & V: \(k) -- > \(v) ")
//        //hymnDetailTemp = v
//        //print ("Number of hymns in section: \(v.count)")
//        print("+++++ hymn ID \(v[row].hymnID)")
//        print(v[row])
//        
//    }
//
//    
//    }
    
    
    // MARK: - Target/Action
    
    @IBAction func showHymn(_ sender: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "Show Hymn Detail", sender: sender.view)
        
    }
    
    // MARK: - Navigation
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case "Show Hymn Detail":
                //print ("I'm here")
                let hymnDetailVC = segue.destination as! HymnDetailViewController
                let indexPath = tableView.indexPathForSelectedRow
                
                let row = indexPath?.row
                let section = indexPath?.section
                
                let tempDict = seasonHymns![section!].seasonSections
                
                for (_, v) in tempDict!{
                    //print ("k & V: \(k) -- > \(v) ")
                    //hymnDetailTemp = v
                    //print ("Number of hymns in section: \(v.count)")
                    print("+++++ hymn ID \(v[row!].hymnID)")
                    print(v[row!])
                    
                    hymnDetailVC.hymnDetail = [v[row!]]
                }
                
                
                    //print ("Index: ")
                    //print (index)
                    //hymnDetailVC.hymnDetail =
                
            default:
                break
                
                
            }
        }
    }

   
    
}
