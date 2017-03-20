//
//  ViewController.swift
//  MAPD124-ShoppingList
//
//  Created by Reza on 2017-03-03.
//  Copyright © 2017 Reza. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var tname: UITextField!
    
    @IBOutlet weak var tqty: UITextField!
    
    
    fileprivate var myItems:[ItemList] = []
    
    var theSpot = 0
    
    
    
    @IBAction func addData(_ sender: AnyObject) {
        AddDataToDatabase()
    }
    
    @IBAction func updateData(_ sender: AnyObject) {
        update()
    }
    
    //Update Data
    func update(){
        // Load menu items from database
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            
            let itemList = myItems[theSpot] as NSManagedObject
            
            itemList.setValue(tqty.text, forKey: "qty")//update quantity
            itemList.setValue(tname.text, forKey: "name")//update name
            
            do {
                try itemList.managedObjectContext?.save()
                self.tableView.reloadData()
                tqty.text="";
                tname.text="";
                
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
            
        }
    }
    
    
    @IBAction func deleteData(_ sender: AnyObject) {
        deleteData()
    }
    
    //Delete-Cancel Data
    func deleteData(){
        // Load menu items from database
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            
            let itemList = myItems[theSpot] as NSManagedObject
            
            managedObjectContext.delete(itemList)
            
            do {
                try itemList.managedObjectContext?.save()
                getData()
                tqty.text="";
                tname.text="";
                
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
            
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //Create-Save Data
    func AddDataToDatabase(){
        // Preload the menu items
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            
            let myItem = NSEntityDescription.insertNewObject(forEntityName: "ItemList", into: managedObjectContext) as! ItemList
            
            myItem.name = tname.text;
            myItem.qty = tqty.text
            
            
            do {
                try managedObjectContext.save()
                
            } catch {
                // abort() causes the application to generate a crash log and terminate.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
        }//end of check for managed object
        self.getData()
    }
    
    
    //Retrieve Data
    func getData(){
        // Load menu items from database
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemList")
            
            // Add Sort Descriptor
            let sortDescriptor = NSSortDescriptor(key: "qty", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            
            do {
                myItems = try managedObjectContext.fetch(fetchRequest) as! [ItemList]
                print( myItems.count)
                self.tableView.reloadData()
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
    }
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        return myItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as UITableViewCell
        
        DispatchQueue.main.async(execute: { () -> Void in
            //as! MenuTableViewCell
            
            cell.textLabel?.text = self.myItems[indexPath.row].name;
            cell.detailTextLabel?.text = self.myItems[indexPath.row].qty;
            
          
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        print( "Row: \(indexPath.row)");
        theSpot=indexPath.row;
        
        tqty.text=myItems[theSpot].qty;
        tname.text=myItems[theSpot].name;
        
    }

}

