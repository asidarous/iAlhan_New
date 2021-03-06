//
//  DBManager.swift
//  iAlhanNew
//
//  Created by Sidarous, Arsani on 10/13/16.
//  Copyright © 2016 alhan.org. All rights reserved.
//

import UIKit



class DBManager: NSObject {
    
    // declare fields in Season table
    let field_Season_Season = "season"
    let field_Season_SeasonID = "season_id"
    let field_Season_SeasonImage = "season_image"
    
    // declare fields in Event table
    let field_Event_EventName = "event_name"
    let field_Event_EventID = "event_id"
    let field_Event_EventSeasonFK = "event_season_fk"
    

    static let shared: DBManager = DBManager()
    let databaseFileName = "AlhanSQL"
    var pathToDatabase: String!
    var database: FMDatabase!
    var pl_database: FMDatabase!
    
    var pl_databaseFileName = "AlhanPL"
    var pl_pathToDatabase: String!
    
    let doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    
    
    override init() {
        super.init()
        
        pathToDatabase = Bundle.main.path(forResource: databaseFileName, ofType: "sqlite")
        pl_pathToDatabase = doumentDirectoryPath.appendingPathComponent("LocalAlhanPL.sqlite")


    }
    
    
    // Open DB Funtion
    func openDatabase() -> Bool {
        if database == nil {
            
            print("***** Path to Db \(pathToDatabase)")
            
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                //print("Horray found file")
                database = FMDatabase(path: pathToDatabase)
            } else
            {
                print ("Cen't find file \(pathToDatabase)")
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    // Open DB Funtion
    func pl_openDatabase() -> Bool {
        if pl_database == nil {
            
            print("***** Path to Db \(pl_pathToDatabase)")
            
            if FileManager.default.fileExists(atPath: pl_pathToDatabase) {
                print("Horray found file")
                pl_database = FMDatabase(path: pl_pathToDatabase)
            } else
            {
                print ("Cen't find file \(pl_pathToDatabase)")
            }
        }
        
        if pl_database != nil {
            if pl_database.open() {
                return true
            }
        }
        
        return false
    }
    
    
    
    // Load Seasons
    func loadSeasons() -> [SeasonData]! {
        var seasons: [SeasonData]!
        
        if openDatabase() {
            let query = "select * from season"
            
            do {
                //print(database)
                let results = try database.executeQuery(query, values: nil)
                //print("Query result \(results)")
                while results.next() {
                    let season = SeasonData(title: results.string(forColumn: field_Season_Season),
                                          seasonImage: results.string(forColumn: field_Season_SeasonImage),
                                          seasonID: Int (results.int(forColumn: field_Season_SeasonID))
                                          )
                   
                    //print ("+++ Here is the season \(season)")
                    if seasons == nil {
                        seasons = [SeasonData]()
                    }
                    
                    seasons.append(season)
                }
                //print (seasons.count)
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
            
        }
        
        return seasons
    
    }
  
    
    // Load Season Events and Hymns in a dictionary

    func loadSeasonHymns(WithID ID: Int) -> [SeasonHymns]{
        var seasonHymns = [SeasonHymns]()
        
        if openDatabase() {
            // this query will return all events for that season
            let query = "select * from event where event_season_fk=? order by event_id asc"
            
            //print("Here is the event_season_fk \(ID)")
            
            do {
                //print(database)
                let results = try database.executeQuery(query, values: [ID])
                //print("Query result \(results)")
               
                while results.next() {
                    let event = results.string(forColumn: "event_name")
                    let eventID = Int (results.int(forColumn: "event_id"))
                    
                    let eventHymns = loadHymnsForEvent(WithID: eventID)
                    
                    // print ("**** returned Event Hymns \(eventHymns.description)")
                    
                    let seasonSection = SeasonHymns(seasonSections: [(event?.description)!: eventHymns])
                    
                    
                   // print ("$$$ seasonSection \(seasonSection.seasonSections)")

//                    if seasonHymns == nil {
//                        seasonHymns = [String: [String]]()
//                    }
                   
                    seasonHymns.append(seasonSection)
                    
                }
                // print (seasonHymns.count)
                 //print ("+++ From outside the while loop : \(seasonHymns)")
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
            
        }
        
        return seasonHymns
        
    }
    
    
    func loadHymnsForEvent(WithID ID: Int) -> [EventHymns]{
        var eventHymns: [EventHymns]!
        var dbOpen: Bool?
        
        
        // Due to the fact that we're making this call inside another DB connection
        // let's check if a connection exists, otherwise initiate it
        
        if !database.goodConnection() {
            
            if  openDatabase() {
            dbOpen = true
            }
        }
       
            // this query will return all hymns for that event
            let query = "select * from hymn where hymn_event_id_fk=? order by hymn_order asc"
            
            do {
                //print(database)
                let results = try database.executeQuery(query, values: [ID])
                //print("Query result \(results)")
                while results.next() {
                    
                    let hymn = EventHymns(hymnName: results.string(forColumn: "hymn_name"),
                                          hymnID: Int(results.int(forColumn: "hymn_id")),
                                          hymnDescription: results.string(forColumn: "hymn_desc"),
                                          hymnCoptic: results.string(forColumn: "hymn_coptic"),
                                          hymnEnglish: results.string(forColumn: "hymn_english"),
                                          hymnAudio: results.string(forColumn: "hymn_audio")
                        
                    )
                    //print ("$-$-$ Hymn \(hymn.hymnName)")
                    if eventHymns == nil {
                        eventHymns = [EventHymns]()
                    }
                    
                    eventHymns.append(hymn)
                }
                // print (seasonHymns.count)
                // print ("///// Event hymns: \(eventHymns.description)")
                results.close()
            }
            catch {
                print(error.localizedDescription)
            }
            
            if dbOpen == true {
            database.close()
            }
            
        
        
        return eventHymns
        
    }
    
    func loadHymnsURLS (hymnIDs: [Int]) -> [URL]{
        var hymnURLS: [URL] = []
        
        if openDatabase() {
            for hymnID in hymnIDs{
            let query = "select hymn_audio from hymn where hymn_id = \(hymnID)"
            
            do {
                //print(database)
                let results = try database.executeQuery(query, values: nil)
                //print("Query result \(results)")
                while results.next() {
                    let hymnURL = results.string(forColumn: "hymn_audio")
                    
                    
                    hymnURLS.append(URL(string: hymnURL!)!)
                    }
                }
            catch {
                print(error.localizedDescription)
                }
            }
            database.close()
            
        }
        
        return hymnURLS
        

    
    
    }

} // EOF
