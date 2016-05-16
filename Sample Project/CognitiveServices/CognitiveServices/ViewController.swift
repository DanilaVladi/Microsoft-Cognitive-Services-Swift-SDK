//
//  ViewController.swift
//  CognitiveServices
//
//  Created by Vladimir Danila on 13/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cognitiveServices = CognitiveServices.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - UITableView Delegate
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(tableView.cellForRowAtIndexPath(indexPath)!.textLabel!.text!, sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = demos[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDataSource Delegate
    
    
    let demos = ["Analyze Image","Describe Image","Get Thumbnail","List Domain Specific Model","OCR","Recognize Domain Specfic Content","Tag Image"]
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.destinationViewController.navigationItem.title = demos[tableView.indexPathForSelectedRow!.row]
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
    }

}

