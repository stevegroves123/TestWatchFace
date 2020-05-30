//
//  ComplcationController.swift
//  TestWatchFace WatchKit Extension
//
//  Created by steve groves on 29/05/2020.
//  Copyright © 2020 steve groves. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {

func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
    handler([])
}

func getCurrentTimelineEntry(
    for complication: CLKComplication,
    withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void)
{
    let entry: CLKComplicationTimelineEntry
 
    switch complication.family {
    case .modularSmall:
        let template = CLKComplicationTemplateModularSmallStackText()
        template.line1TextProvider = CLKSimpleTextProvider(text: "WF12")
        template.line2TextProvider = CLKSimpleTextProvider(text: "AM")
        entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
 
    case .circularSmall:
        let template = CLKComplicationTemplateCircularSmallStackText()
        template.line1TextProvider = CLKSimpleTextProvider(text: "12")
        template.line2TextProvider = CLKSimpleTextProvider(text: "PM")
        entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
 
    default:
        preconditionFailure("Complication family not supported")
    }
 
    handler(entry)
}

    func getLocalizableSampleTemplate(
        for complication: CLKComplication,
        withHandler handler: @escaping (CLKComplicationTemplate?) -> Void)
    {
        switch complication.family {
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: "PM10")
            template.line2TextProvider = CLKSimpleTextProvider(text: "50")
            handler(template)
     
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: "PM")
            template.line2TextProvider = CLKSimpleTextProvider(text: "50")
            handler(template)
     
        default:
            preconditionFailure("Complication family not supported")
        }
    }
}
