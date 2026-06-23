//
//  PermissionUtil.swift
//  MLBaseTool
//
//  系统权限检查与申请：相机、相册、定位、麦克风、通知。
//  宿主 App 需在 Info.plist 配置对应 Usage Description。
//

import UIKit
import AVFoundation
import Photos
import CoreLocation
import UserNotifications

/// 权限类型
public enum MLPermissionType {
    case camera
    case photoLibrary
    case location
    case microphone
    case notification
}

/// 权限状态
public enum MLPermissionStatus {
    case authorized
    case denied
    case notDetermined
    case restricted
}

/// 权限工具
public final class PermissionUtil: NSObject {

    private static let locationManager = CLLocationManager()
    private static var locationCompletion: ((MLPermissionStatus) -> Void)?

    // MARK: - 查询状态

    public static func status(for type: MLPermissionType) -> MLPermissionStatus {
        switch type {
        case .camera:
            return mapAVStatus(AVCaptureDevice.authorizationStatus(for: .video))
        case .photoLibrary:
            return mapPHStatus(PHPhotoLibrary.authorizationStatus())
        case .microphone:
            return mapAVStatus(AVCaptureDevice.authorizationStatus(for: .audio))
        case .location:
            return mapCLStatus(CLLocationManager.authorizationStatus())
        case .notification:
            return .notDetermined
        }
    }

    // MARK: - 申请权限

    public static func request(_ type: MLPermissionType, completion: @escaping (MLPermissionStatus) -> Void) {
        switch type {
        case .camera:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted ? .authorized : .denied)
                }
            }
        case .photoLibrary:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(mapPHStatus(status))
                }
            }
        case .microphone:
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                DispatchQueue.main.async {
                    completion(granted ? .authorized : .denied)
                }
            }
        case .location:
            locationCompletion = completion
            locationManager.delegate = shared
            locationManager.requestWhenInUseAuthorization()
        case .notification:
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                DispatchQueue.main.async {
                    completion(granted ? .authorized : .denied)
                }
            }
        }
    }

    /// 跳转到系统设置页
    public static func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private static let shared = PermissionUtil()

    private static func mapAVStatus(_ status: AVAuthorizationStatus) -> MLPermissionStatus {
        switch status {
        case .authorized: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        case .notDetermined: return .notDetermined
        @unknown default: return .denied
        }
    }

    private static func mapPHStatus(_ status: PHAuthorizationStatus) -> MLPermissionStatus {
        switch status {
        case .authorized, .limited: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        case .notDetermined: return .notDetermined
        @unknown default: return .denied
        }
    }

    private static func mapCLStatus(_ status: CLAuthorizationStatus) -> MLPermissionStatus {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        case .notDetermined: return .notDetermined
        @unknown default: return .denied
        }
    }
}

extension PermissionUtil: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorization(status)
    }

    @available(iOS 14.0, *)
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleLocationAuthorization(manager.authorizationStatus)
    }

    private func handleLocationAuthorization(_ status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        PermissionUtil.locationCompletion?(PermissionUtil.mapCLStatus(status))
        PermissionUtil.locationCompletion = nil
    }
}
