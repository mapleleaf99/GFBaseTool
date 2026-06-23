//
//  MLAlertManager.swift
//  MLBaseTool
//
//  弹窗队列管理：优先级、等待队列、叠加展示、push/pop。
//

import UIKit

protocol MLAlertManagerDelegate: AnyObject {
    func requestShowAlertObject(_ alertObject: MLAlertObject?, _ view: UIView?)
    func requestCloseAlertObject(_ alertObject: MLAlertObject?)
    func requestCloseAllAlertObject()
}

/// 弹窗管理器（单例）
@objcMembers
public class MLAlertManager: NSObject, MLAlertManagerDelegate {

    public static let shared = MLAlertManager()

    private var showingAlertObjectQueue: [MLAlertObject] = []
    private var waitingAlertObjectQueue: [MLAlertObject] = []
    private var navigators: [MLAlertObject] = []
    private lazy var serialQueue = DispatchQueue(label: "com.mlbasetool.alertManager")

    private override init() {
        super.init()
    }

    public func requestShowAlertObject(_ alertObject: MLAlertObject?, _ view: UIView?) {
        guard let object = alertObject else { return }
        if let inView = view {
            object.previousView = inView
        }
        serialQueue.async { [weak self] in
            self?.addAlertObjectToQueue(object)
        }
    }

    public func requestCloseAlertObject(_ alertObject: MLAlertObject?) {
        guard let object = alertObject else { return }
        if navigators.contains(where: { $0 === object }) {
            closeNavigatorsAlertObject()
        } else {
            closeAlertObject(object)
        }
    }

    public func requestCloseAllAlertObject() {
        let showingQueue = showingAlertObjectQueue
        for object in showingQueue {
            showingAlertObjectQueue.removeAll { $0 === object }
            removeAlertObjectFromWindow(object)
        }
    }

    // MARK: - Private

    private func closeAlertObject(_ alertObject: MLAlertObject) {
        waitingAlertObjectQueue.removeAll { $0 === alertObject }
        showingAlertObjectQueue.removeAll { $0 === alertObject }
        removeAlertObjectFromWindow(alertObject)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.tryDequeueWaitingToShowing()
        }
    }

    private func tryDequeueWaitingToShowing() {
        guard !waitingAlertObjectQueue.isEmpty, showingAlertObjectQueue.isEmpty else { return }
        let next = waitingAlertObjectQueue.removeFirst()
        showingAlertObjectQueue.append(next)
        showAlertInWindow(next)
    }

    private func closeNavigatorsAlertObject() {
        navigators.forEach { closeAlertObject($0) }
    }

    private func addAlertObjectToQueue(_ alertObject: MLAlertObject) {
        if !addAlertToShowingQueue(alertObject) {
            addAlertToWaitingQueue(alertObject)
        }
    }

    private func addAlertToShowingQueue(_ object: MLAlertObject) -> Bool {
        switch object.priority {
        case .max:
            if !showingAlertObjectQueue.isEmpty {
                showingAlertObjectQueue.forEach { resetAlertObjectToWaiting($0) }
            }
            showingAlertObjectQueue.append(object)
            showAlertInWindow(object)
            return true
        case .over:
            if !showingAlertObjectQueue.isEmpty {
                showingAlertObjectQueue.append(object)
            } else {
                showingAlertObjectQueue.insert(object, at: 0)
            }
            showAlertInWindow(object)
            return true
        default:
            if showingAlertObjectQueue.isEmpty {
                showingAlertObjectQueue.append(object)
                showAlertInWindow(object)
                return true
            }
            return false
        }
    }

    private func addAlertToWaitingQueue(_ object: MLAlertObject) {
        waitingAlertObjectQueue.append(object)
        waitingAlertObjectQueue.sort { $0.priority.rawValue > $1.priority.rawValue }
    }

    private func resetAlertObjectToWaiting(_ alertObject: MLAlertObject?, duration: CGFloat = 0.25) {
        guard let object = alertObject else { return }
        removeAlertObjectFromWindow(object, duration: duration)
        showingAlertObjectQueue.removeAll { $0 === object }
        addAlertObjectToQueue(object)
    }

    private func showAlertInWindow(_ object: MLAlertObject, duration: CGFloat = 0.25) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if object.previousView != nil, object.alertView != nil {
                self.showAlertView(object: object, duration: duration)
            } else if let window = UIWindow.ml_keyWindow(), object.alertView != nil {
                object.previousView = window
                self.showAlertView(object: object, duration: duration)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showAlertInWindow(object)
                }
            }
        }
    }

    private func showAlertView(object: MLAlertObject, duration: CGFloat = 0.25) {
        guard let container = object.previousView, let view = object.alertView else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        view.alpha = 0
        UIView.animate(withDuration: duration) {
            view.alpha = 1
        } completion: { _ in
            object.didAppearInWindow?()
        }
    }

    private func removeAlertObjectFromWindow(_ object: MLAlertObject, duration: CGFloat = 0.25) {
        DispatchQueue.main.async {
            guard let view = object.alertView else { return }
            object.previousView = nil
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 0
            }, completion: { _ in
                view.removeFromSuperview()
                object.didDisappearFromWindow?()
            })
        }
    }
}

// MARK: - Push / Pop

extension MLAlertManager {
    public func requestPushAlertObject(from fromObject: MLAlertObject?, to toObject: MLAlertObject?) {
        if let from = fromObject {
            removeAlertObjectFromWindow(from, duration: 0)
            navigators.append(from)
        }
        if let to = toObject {
            showAlertInWindow(to, duration: 0)
            navigators.append(to)
        }
    }

    public func requestPopAlertObject() {
        if let object = navigators.popLast() {
            removeAlertObjectFromWindow(object, duration: 0)
        }
        if let object = navigators.popLast() {
            showAlertInWindow(object, duration: 0)
        }
    }
}
