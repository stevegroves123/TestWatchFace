//
//  ContentView.swift
//  TestWatchFace WatchKit Extension
//
//  Created by steve groves on 04/04/2020.
//  Copyright © 2020 steve groves. All rights reserved.
//

import SwiftUI
 
// create extention to the CGRect library to use center and radius
    extension CGRect {
        var center: CGPoint {
            CGPoint(x: midX, y: midY)
            }
        init(center: CGPoint, radius: CGFloat) {
            self = CGRect(
                x: center.x - radius,
                y: center.y - radius,
                width: radius * 2,
                height: radius * 2
                )
            }
        }
// create the various variables
    struct ContentView: View {
        @State var degreesPointedTo = 0
        @State var myMonth = 0
        @State var myDay = 0
        @State var myHour = 0
        @State var myMinute = 0
        @State var mySecond = 0
        @State var components = Calendar.current.dateComponents([.day, .month, .hour, .minute, .second], from: Date())
 
// create the tick marks to show the edge of the clock
        func tick(at tick: Int) -> some View {
            VStack {
                Rectangle()
                    .fill(Color.blue)
                    .opacity(tick % 5 == 0 ? 1 : 0.4)
                    .frame(width: 2, height: 8)
                Spacer()
                }
                .frame(width: 150, height: 150, alignment: .center)
                .rotationEffect(Angle.degrees(Double(tick)/60 * 360))
            }
// create the second hand
    struct secondHand: Shape {
        var circleRadius: CGFloat = 3
        func path(in rect: CGRect) -> Path {
            Path { p in
                // create long part of second hand
                p.move(to: CGPoint(x: rect.midX, y: rect.minY
                 + 20))
                p.addLine(to: CGPoint(x: rect.midX, y: rect.midY - circleRadius))
                // create center circle
                p.addEllipse(in: CGRect(center: rect.center, radius: circleRadius))
                // create tail of second hand
                p.move(to: CGPoint(x: rect.midX, y: rect.midY + circleRadius))
                p.addLine(to: CGPoint(x: rect.midX, y: rect.midY + rect.height / 10))
                }
            }
        }
        
// timer to update dispaly
    var updateTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {
            _ in self.components = Calendar.current.dateComponents([.day, .month, .hour, .minute, .second], from: Date())
            self.myHour = self.components.hour ?? 0
            self.mySecond = self.components.second ?? 0
            self.myMonth = self.components.month ?? 0
            self.myDay = self.components.day ?? 0
        })
    }

// create a look up for the month
        func lookupMonth(myMonth: Int) -> String {
            switch myMonth {
            case 1:
                return "Jan"
            case 2:
                return "Feb"
            case 3:
                return "March"
            case 4:
                return "April"
            case 5:
                return "May"
            case 6:
                return "June"
            case 7:
                return "July"
            case 8:
                return "August"
            case 9:
                return "Sept"
            case 10:
                return "Oct"
            case 11:
                return "Nov"
            case 12:
                return "Dec"
            default:
                return "unknown"
            }
        }
        
// create lookup for the day - change for an if else statement
        func lookupDay(myDay: Int) -> String {
            switch myDay {
            case 1:
                return "st"
            case 2:
                return "nd"
            case 3:
                return "rd"
            default:
                return "th"
            }
        }
    
    var body: some View {
        ZStack {
            ForEach(0..<60) {tickMark in
                self.tick(at: tickMark)
            }
            secondHand()
                .stroke(Color.orange, lineWidth: 2)
                .rotationEffect(Angle.degrees(Double(mySecond) * 360 / 60))
            
            Text("\(self.myDay)\(lookupDay(myDay: self.myDay))")  //need to change the th so it matches the day
                .offset(x: -60, y:78)
            Text("\(lookupMonth(myMonth: myMonth))")
                .offset(x:60, y:78)
            Color.clear
            }
            .onAppear(perform: {let _ = self.updateTimer})
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 170, height: 170))
    }
}
