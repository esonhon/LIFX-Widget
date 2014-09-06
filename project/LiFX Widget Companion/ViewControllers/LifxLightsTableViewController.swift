//
//  LifxLightsTableViewController.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 03/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import UIKit

var LifxLightsTableViewCellIdentifier = "LifxLightTableViewCell"

class LifxLightsTableViewController : GenericTableViewController,
LFXLightCollectionObserver, LFXLightObserver
{
    
    // MARK: Properties
    var lights: [LFXLight] = []
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyImage = UIImage(named: "no-lifx")
        emptyTitle = "Can't find any LIFX on the network"
        emptyDescription = "Are you on the same WiFi network ?"
        tintColor = UIColor(red: 132/CGFloat(255), green: 235/CGFloat(255), blue: 147/CGFloat(255), alpha: 1)
        startMonitoringLights()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        saveLightAtIndexPath(indexPath)
        dismiss()
    }
    
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lights.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LifxLightsTableViewCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        let light = lights[indexPath.row]
        configureCell(cell, withLight:light)
        return cell
    }
    
    
    // MARK: LFXLightCollectionObserver
    func lightCollection(lightCollection: LFXLightCollection!, didAddLight light: LFXLight!) {
        if (SettingsPersistanceManager.hasLightForLifxLight(light) == false) {
            lights.append(light)
            tableView.reloadData()
        }
    }
    
    func lightCollection(lightCollection: LFXLightCollection!, didRemoveLight light: LFXLight!)  {
        lights.remove(light!)
        tableView.reloadData()
    }
    
    
    // MARK: Convenience methods
    func startMonitoringLights() {
        var context = LFXClient.sharedClient().localNetworkContext
        var lifxLights = context.allLightsCollection
        lifxLights.addLightCollectionObserver(self)
        
        for lifxLight in lifxLights.lights as [LFXLight] {
            self.lightCollection(lifxLights, didAddLight: lifxLight as LFXLight)
        }
    }
    
    func saveLightAtIndexPath(indexPath: NSIndexPath) {
        let light = lights[indexPath.row]
        SettingsPersistanceManager.addLight(Light(friendlyName: light.label(), deviceID: light.deviceID))
    }
    
    func dismiss() {
        navigationController?.popViewControllerAnimated(true)
    }

    func configureCell(cell: UITableViewCell, withLight light: LFXLight) {
        cell.textLabel?.text = light.label()
    }

}
