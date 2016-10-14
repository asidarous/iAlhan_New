//
//  Season.swift
//  iAlhanNew
//
//  Created by Sidarous, Arsani on 10/7/16.
//  Copyright © 2016 alhan.org. All rights reserved.
//

import Foundation

public struct SeasonKeys
{
    static let title = "title"
    static let seasonImage = "seasonImage"
    static let seasonSections = "seasonSections"
}


class Season
{
    var title: String?
    var seasonImage: String?
    var seasonSections: [String]?
    
    // initialize the season
    init(index: Int)
    {
        // make sure is a valid index
        
        if index >= 0  //&& index < SeasonLibrary().seasonAlbums.count
        {
            //let seasonAlbum = SeasonLibrary().seasonAlbums[index]
            
            // get the season ID to use in the following query to retrieve the events of the selected season
            
            let seasonSections = DBManager.shared.loadSeasonHymns(WithID: index)
            //seasonSections = seasonAlbum[SeasonKeys.seasonSections] as? [String: [String]]
            print ("*** Season section \(seasonSections)")
            
            // start initialization of album
            /*title = seasonAlbum[SeasonKeys.title] as? String
            seasonImage = seasonAlbum[SeasonKeys.seasonImage] as? String
            seasonSections = seasonAlbum[SeasonKeys.seasonSections] as? [String: [String]]
 */
            //seasonSections = seasonAlbum[SeasonKeys.seasonSections] as? [String: [String]]
        
        }
        
    }
    
    // Original init
    /*
 init(index: Int)
 {
 // make sure is a valid index
 
 if index >= 0  && index < SeasonLibrary().seasonAlbums.count
 {
 let seasonAlbum = SeasonLibrary().seasonAlbums[index]
 
 // start initialization of album
 title = seasonAlbum[SeasonKeys.title] as? String
 seasonImage = seasonAlbum[SeasonKeys.seasonImage] as? String
 seasonSections = seasonAlbum[SeasonKeys.seasonSections] as? [String: [String]]
 
 
 }
 
 }*/
    
}