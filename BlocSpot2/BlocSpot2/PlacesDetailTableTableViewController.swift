//
//  PlacesDetailTableTableViewController.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/6/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

import UIKit
import CoreData


class PlacesDetailTableTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate {

    
    var places: [Places]!
    
    let sortKeyName   = "name"
    let sortKeyRating = "beerDetails.rating"
    let wbSortKey     = "wbSortKey"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllPlaces()
        
        tableView.reloadData()
    }
    
    func fetchAllPlaces() {
        
        // Retrieve the current sort key.
        let sortKey = NSUserDefaults.standardUserDefaults().objectForKey(wbSortKey) as? String
        
        // Do not sort in ascending order if sorting by rating (i.e., sort descending).
        // Otherwise (i.e. sorting alphabetically), sort in ascending order.
        let ascending = (sortKey == sortKeyRating) ? false : true
        
        // Fetch records from Entity Beer using a MagicalRecord method.
        places = Places.MR_findAllSortedBy(sortKey, ascending: ascending) as! [Places]
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        //possibly default this to show the various locations automatically based on valley?
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return vcPlaces.count
        return places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("placeCell", forIndexPath: indexPath) as? UITableViewCell ?? UITableViewCell(style: .Subtitle,
            reuseIdentifier: "placeCell")
        
        
        
        let currentplace = places[indexPath.row]
        cell.textLabel?.text = currentplace.name
        cell.detailTextLabel?.text = currentplace.location
        
       
        
        return cell

    }
    
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
