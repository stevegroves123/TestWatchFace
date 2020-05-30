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
        @State var myMonth = 1
        @State var myDay = 1
        @State var myHour = 0
        @State var myMinute = 0
        @State var mySecond = 0
        @State var myWeekday = 0
        @State var weekDayText = ""
        @State var myYear = 1970
        @State var components = Calendar.current.dateComponents([.day, .month, .hour, .minute, .second, .weekday, .year], from: Date())
        @State var scrollAmount = 0.0
        let colours: [Int: Color] = [
            0 : Color.red,
            1 : Color.blue,
            2 : Color.green,
            3 : Color.yellow,
            4 : Color.white,
            5 : Color.pink,
            6 : Color.gray,
            7 : Color.orange
        ]
 
// create the tick marks to show the edge of the clock
    func tick(at tick: Int) -> some View {
        VStack {
            Rectangle()
                .fill(Color.blue)
                .opacity(tick % 5 == 0 ? 1 : 0.4)
                .frame(width: 1, height: 10)
            Spacer()
            }
            .frame(width: nil, height: nil, alignment: .center)
            .rotationEffect(Angle.degrees(Double(tick)/60 * 360))
        }
        
// create the second hand
    struct secondHand: Shape {
        var circleRadius: CGFloat = 3
        func path(in rect: CGRect) -> Path {
            Path { p in
                // create long part of second hand
                p.move(to: CGPoint(x: rect.midX, y: rect.minY + 20))
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
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
            _ in self.components = Calendar.current.dateComponents([.day, .month, .hour, .minute, .second, .weekday, .year], from: Date())
            self.myHour = self.components.hour ?? 0
            self.mySecond = self.components.second ?? 0
            self.myMonth = self.components.month ?? 0
            self.myDay = self.components.day ?? 0
            self.myWeekday = self.components.weekday ?? 0
            self.myYear = self.components.year ?? 0
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
                return "Aug"
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
            case 1, 21, 31:
                return "st"
            case 2, 22:
                return "nd"
            case 3, 23:
                return "rd"
            default:
                return "th"
            }
        }
        
// create a look up for the month
        func lookupDayofWeek(myWeekday: Int) -> String {
            switch myWeekday {
            case 1:
                return "Sun"
            case 2:
                return "Mon"
            case 3:
                return "Tues"
            case 4:
                return "Wed"
            case 5:
                return "Thur"
            case 6:
                return "Fri"
            case 7:
                return "Sat"
            default:
                return "Day"
            }
        }
    
    var body: some View {
    GeometryReader { geo in
        ZStack {
            ForEach(0..<60) {tickMark in
                self.tick(at: tickMark)
                .padding()
            }
            secondHand()
                .stroke(lineWidth: 1)
                .rotationEffect(Angle.degrees(Double(self.mySecond) * 360 / 60))
            
            Text("\(self.myDay)\(self.lookupDay(myDay: self.myDay))")
                .offset(x:geo.size.width*0.38 ,y:-geo.size.height*0.45)
            Text("\(self.lookupMonth(myMonth: self.myMonth))")
                .offset(x:-geo.size.width*0.38, y:geo.size.height*0.45)
            Text("\(self.lookupDayofWeek(myWeekday: self.myWeekday))")
                .offset(x:-geo.size.width*0.38, y:-geo.size.height*0.45)
            Text("\(self.myYear.description)")
                .offset(x: geo.size.width*0.38, y:geo.size.height*0.45)
            Color.clear
            }
            
        .foregroundColor(self.colours[Int(self.scrollAmount)])
        .focusable(true)
        .digitalCrownRotation(self.$scrollAmount, from: 0, through: 8, by: 1, sensitivity: .low, isContinuous: true)
        .onAppear(perform: {let _ = self.updateTimer})
        .navigationBarTitle("WatchFace")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 190, height: 190))
    }
}
