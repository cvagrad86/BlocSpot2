//
//  PlacesDetailTableTableViewController.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/6/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

import UIKit
import CoreData
import MapKit


class PlacesDetailTableTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
  
    @IBOutlet weak var searchBar: UISearchBar!
    
    var places: [Places]!
    
    
    let sortKeyName   = "name"
    let sortKeyRating = "beerDetails.rating"
    let wbSortKey     = "wbSortKey"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllPlaces()
        
        tableView.reloadData()
    }
    
    func saveContext() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    func fetchAllPlaces() {
        
        let sortKey = NSUserDefaults.standardUserDefaults().objectForKey(wbSortKey) as? String
        
        let ascending = (sortKey == sortKeyRating) ? false : true
        
        places = Places.MR_findAllSortedBy(sortKey, ascending: ascending) as! [Places]
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        //possibly default this to show the various locations automatically based on valley
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

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

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("viewPlace", sender: self)
        
    }
    
   
    //Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == .Delete) {

            places.removeAtIndex(indexPath.row).MR_deleteEntity()
            saveContext()
            
            let indexPaths = [indexPath]
            
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            
            tableView.reloadData()
        }    
    
    }
    
    // MARK: - Navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let nav = segue.destinationViewController as! UINavigationController
        let controller = nav.topViewController as! PlacesDetailNotesViewController
        
        
        //let addEventViewController = nav.topViewController as! AddEventViewController
        
        if segue.identifier == "viewPlace" {
            
            let indexPath = tableView.indexPathForSelectedRow
            
            let placeSelected = places[indexPath!.row].name
            let placeLocation = places[indexPath!.row].location
            let placeLong = places[indexPath!.row].longitude
           let placeLat = places[indexPath!.row].latitude
            
            controller.placeSelected = placeSelected
            controller.placeLocation = placeLocation
            controller.placeLongitude = placeLong?.doubleValue
            controller.placeLatitude = placeLat?.doubleValue

            
        
        }
    }
    

}

extension PlacesDetailTableTableViewController: UISearchBarDelegate {
    
    // MARK: Editing Text
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text != "" {
            performSearch()
            
        } else {
            fetchAllPlaces()
            tableView.reloadData()
        }
    }
    //#####################################################################
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    //#####################################################################
    // MARK: Clicking Buttons
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.showsCancelButton = false
        fetchAllPlaces()
        tableView.reloadData()
    }
    //#####################################################################
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // This method is invoked when the user taps the Search button on the keyboard.
        
        searchBar.resignFirstResponder()
        performSearch()
    }
    //#####################################################################
    // MARK: Helper Methods
    
    func performSearch() {
        
        let searchText = searchBar.text
        let filterCriteria = NSPredicate(format: "name contains[c] %@", searchText!)
        
        places = Places.MR_findAllSortedBy(sortKeyName, ascending: true,
            withPredicate: filterCriteria,
            inContext: NSManagedObjectContext.MR_defaultContext()) as? [Places]
        tableView.reloadData()
}
}