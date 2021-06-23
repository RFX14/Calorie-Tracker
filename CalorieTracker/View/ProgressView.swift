//
//  ProgressView.swift
//  CalorieTracker
//
//  Created by Josue Rosales on 6/22/21.
//

import SwiftUI

extension Notification.Name {
    static var progress: Notification.Name { return .init("progress") }
}

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}

extension CGFloat {
    var clean: String {
        return String(format: "%.0f", self)
    }
}


struct ProgressView: View {
    @State var progress: CGFloat = 0
    @State var totalCalories = UserDefaults.standard.float(forKey: "goalCalories")
    
    var notifictionChanged = NotificationCenter.default.publisher(for: .progress)
    var body: some View {
        ZStack {
            Circle()
                .trim(from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, to: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 35, lineCap: .round))
                .frame(width: 290, height: 290)
            
            Text("\((progress * CGFloat(totalCalories)).clean) / \(totalCalories.clean)")
            
            Circle()
                .trim(from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, to: progress)
                .stroke(Color.red, style: StrokeStyle(lineWidth: 35, lineCap: .round))
                .frame(width: 290, height: 290)
                .rotationEffect(.init(degrees: -90))
                .animation(.easeIn)
                .onReceive(notifictionChanged) { note in
                    self.progress = note.userInfo!["progress"]! as! CGFloat
                }
        }
    }
}
