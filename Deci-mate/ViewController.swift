//
//  ViewController.swift
//  Deci-mate
//
//  Created by Wilson Zhao on 7/11/15.
//  Copyright (c) 2015 Innogen. All rights reserved.
//

import UIKit
import BEMSimpleLineGraph

class ViewController: UIViewController, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate, AudioMeterDelegate {

    @IBOutlet weak var graph: BEMSimpleLineGraphView!
    var graphArray: NSMutableArray = []
    var startTime: NSDate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTime = NSDate()
        
        // setup meter
        let meter: AudioMeter = AudioMeter()
        meter.initAudioMeter()
        meter.delegate = self
        meter.changeAccumulatorTo(131072)  //16384; //32768; 65536; 131072;
        
        let value = AudioValue()
        value.decibels = 60.0
        graphArray.addObject(value)
        
        // setup graph
        graph.animationGraphStyle = BEMLineAnimation.None
        graph.enableReferenceAxisFrame = true
        graph.enableReferenceXAxisLines = true
        graph.enableReferenceYAxisLines = true
        graph.averageLine.enableAverageLine = true
        graph.averageLine.color = UIColor.redColor()
        graph.autoScaleYAxis = true
        graph.enableRightReferenceAxisFrameLine = true
        graph.enableTopReferenceAxisFrameLine = true
        graph.enableXAxisLabel = true
        graph.enableYAxisLabel = true
        //var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "addValueToGraphArray", userInfo: nil, repeats: true)

        
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        let num = 20
        if (graphArray.count < num) {
            return graphArray.count
        } else {
            return num
        }
    }
    
    //y values
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        let i = graphArray.count + index - self.numberOfPointsInLineGraph(graph)
        let value: AudioValue = graphArray[i] as! AudioValue
        if value.decibels > 120 {
            return 120.0
        } else {
        return CGFloat(value.decibels)
        }
    }
    
    //x axis labels
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        let i = graphArray.count + index - self.numberOfPointsInLineGraph(graph)
        let value: AudioValue = graphArray[i] as! AudioValue
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = .MediumStyle
        return formatter.stringFromDate(value.time)
    }
    
    func numberOfGapsBetweenLabelsOnLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return 4
    }
    
    func numberOfYAxisLabelsOnLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return 10
    }

    func newDataValue(value: Float32) {
        let newValue = AudioValue()
        newValue.power = value
        newValue.decibels = 20.0 * log10(value) + 150;
        graphArray.addObject(newValue)
        graph.reloadGraph()
        graph.averageLine.yValue = CGFloat(graph.calculatePointValueAverage().floatValue)
        
        
        
        // Check the avg from the last 10 seconds

    }

}

