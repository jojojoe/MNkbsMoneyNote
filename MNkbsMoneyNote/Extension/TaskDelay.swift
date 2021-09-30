//
//  TaskDelay.swift
//  Adjust
//
//  Created by JOJO on 2019/11/21.
//

import Foundation


public class TaskDelay {
    
    public init() {}
    public static var `default` = TaskDelay()
    var taskBlock: ((_ cancel: Bool)->Void)?
    var actionBlock: (()->Void)?
    
    public func taskDelay(afterTime: TimeInterval, task:@escaping ()->Void) {
        actionBlock = task
        taskBlock = { cancel in
            if let actionBlock = TaskDelay.default.actionBlock {
                if !cancel {
                    DispatchQueue.main.async {
                        actionBlock()
                    }
                    
                }
            }
            TaskDelay.default.taskBlock = nil
            TaskDelay.default.actionBlock = nil
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + afterTime) {
            if let taskBlock = TaskDelay.default.taskBlock {
                taskBlock(false)
            }
        }
        
    }
    
    public func taskCancel() {
        DispatchQueue.main.async {
            if let taskBlock = TaskDelay.default.taskBlock {
                taskBlock(true)
            }
        }
    }
    
    
    
    
}
