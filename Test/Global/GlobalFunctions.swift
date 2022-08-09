//
//  GlobalFunctions.swift
//  OneTouch
//
//  Created by Kartum Infotech on 20/05/19.
//  Copyright © 2019 Kartum Infotech. All rights reserved.
//

import Foundation
import AVKit

func delay(time: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
        closure()
    }
}

func DLog(_ items: Any?..., function: String = #function, file: String = #file, line: Int = #line) {
    if Application.debug {
        print("\n🟢 🟢 🟢 S T A R T 🟢 🟢 🟢")
        let url = NSURL(fileURLWithPath: file)
        print("\n 💬 Message = ", items, "\n\n( 📁 File: ", url.lastPathComponent ?? "nil", ", Function: ", function, ", Line: ", line, ")")
        print("⛔️ ⛔️ ⛔️ ⛔️ E N D ⛔️ ⛔️ ⛔️ ⛔️\n")
    }
}

func performOn(_ queueType: QueueType, closure: @escaping () -> Void) {
    queueType.queue.async(execute: closure)
}

// MARK: - QueueType
public enum QueueType {
    case Main
    case Background
    case LowPriority
    case HighPriority
    
    var queue: DispatchQueue {
        switch self {
        case .Main:
            return DispatchQueue.main
        case .Background:
            return DispatchQueue(label: "com.app.queue",
                                 qos: .background,
                                 target: nil)
        case .LowPriority:
            return DispatchQueue.global(qos: .userInitiated)
        case .HighPriority:
            return DispatchQueue.global(qos: .userInitiated)
        }
    }
}
