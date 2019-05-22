//
//  CommonManager.swift
//  App
//
//  Created by Pqt Dark on 5/22/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CommonManager {
    /// Open application settings.
    class func openApplicationSettings() {
        let settingsUrl = URL(string: UIApplication.openSettingsURLString)
        if let url = settingsUrl {
            CommonManager.openURL(url)
        }
    }
    class func openURL(_ url: URL) {
        CommonManager.handleTaskOnMainThreadIfNeeded {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
}

extension CommonManager {
    /// Execute task on main thread if needed.
    public class func handleTaskOnMainThreadIfNeeded(_ task: @escaping () -> Void) {
        if Thread.current.isMainThread == true {
            task()
        } else {
            // Current is not main thread
            DispatchQueue.main.sync(execute: task)
        }
    }
    
    /// Execute task on global thread.
    public class func handleTaskOnGlobalThread(_ task: @escaping () -> Void) {
        DispatchQueue.global().sync(execute: task)
    }
    
    /// Execute task on main thread with delay time.
    public class func handleTaskOnMainThread(afterDelay: TimeInterval, _ task: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + afterDelay, execute: task)
    }
    
    /// Execute task on global thread with delay time.
    public class func handleTaskOnGlobalThread(afterDelay: TimeInterval, _ task: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + afterDelay, execute: task)
    }
    
    /// Execute task on current thread with delay time.
    public class func handleTaskOnCurrentThread(afterDelay: TimeInterval, _ task: @escaping () -> Void) {
        if Thread.current.isMainThread == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + afterDelay, execute: task)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + afterDelay, execute: task)
        }
    }
    
    
}

// MARK: - UIImagePickerController + UIViewController
extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// Check permission and open camera picker.
    public func openCamera(allowsEditing: Bool = false, isSocialButtonCase: Bool = false, isReceiptButtonCase: Bool = false, animated: Bool = true, completion: ((_ imagePicker: UIImagePickerController) -> Swift.Void)? = nil) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraMediaType = AVMediaType.video
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
            
            switch cameraAuthorizationStatus {
            case .authorized:
                let imagePicker = self.cameraPicker(allowsEditing: allowsEditing)
                CommonManager.handleTaskOnMainThreadIfNeeded {
                    completion?(imagePicker)
                    self.present(imagePicker, animated: animated, completion: {
                        //completion?(imagePicker)
                    })
                }
                break
                
            case .restricted, .denied:
                self.showCameraAccessDeniedAlert()
                break
                
            case .notDetermined:
                // Prompting user for the permission to use the Camera.
                AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                    if granted {
                        let imagePicker = self.cameraPicker(allowsEditing: allowsEditing)
                        CommonManager.handleTaskOnMainThreadIfNeeded {
                            completion?(imagePicker)
                            self.present(imagePicker, animated: animated, completion: {
                                //completion?(imagePicker)
                            })
                        }
                    } else {
                        self.showCameraAccessDeniedAlert()
                    }
                }
            @unknown default:
                break
            }
        } else {
            self.showCameraUnavailableAlert()
        }
    }
    
    /// Check permission and request camera access.
    public func canOpenCamera(shouldShowError: Bool, completion: @escaping (Bool) -> Void) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraMediaType = AVMediaType.video
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
            
            switch cameraAuthorizationStatus {
            case .authorized:
                completion(true)
                
            case .restricted, .denied:
                if shouldShowError == true { self.showCameraAccessDeniedAlert() }
                completion(false)
                
            case .notDetermined:
                // Prompting user for the permission to use the Camera.
                AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                    
                    if granted == false { if shouldShowError == true { self.showCameraAccessDeniedAlert() } }
                    CommonManager.handleTaskOnMainThreadIfNeeded {
                        completion(granted)
                    }
                }
            @unknown default:
                // Handle unknown values using "@unknown default"
                if shouldShowError == true { }
                completion(false)
            }
        } else {
            if shouldShowError == true { self.showCameraUnavailableAlert() }
            completion(false)
        }
    }
    
    /// Check permission and open photo picker.
    public func openPhotoLibrary(allowsEditing: Bool = false, isSocialButtonCase: Bool = false, isReceiptButtonCase: Bool = false, animated: Bool = true, completion: ((_ imagePicker: UIImagePickerController) -> Swift.Void)? = nil) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            
            switch photoAuthorizationStatus {
            case .authorized:
                let imagePicker = self.photoLibraryPicker(allowsEditing: allowsEditing)
                CommonManager.handleTaskOnMainThreadIfNeeded {
                    completion?(imagePicker)
                    self.present(imagePicker, animated: animated, completion: {
                        //completion?(imagePicker)
                    })
                }
                break
                
            case .restricted, .denied:
                self.showPhotoLibraryAccessDeniedAlert()
                break
                
            case .notDetermined:
                // Prompting user for the permission to use the Photos.
                PHPhotoLibrary.requestAuthorization({ (authorizationStatus) in
                    if authorizationStatus == .authorized {
                        let imagePicker = self.photoLibraryPicker(allowsEditing: allowsEditing)
                        CommonManager.handleTaskOnMainThreadIfNeeded {
                            completion?(imagePicker)
                            self.present(imagePicker, animated: animated, completion: {
                                //completion?(imagePicker)
                            })
                        }
                    } else {
                        self.showPhotoLibraryAccessDeniedAlert()
                    }
                })
            @unknown default:
                break
            }
        } else {
            self.showPhotoLibraryUnavailableAlert()
        }
    }
    
    /// Show camera picker.
    private func presentCameraPicker(allowsEditing: Bool, animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        let imagePicker = self.cameraPicker(allowsEditing: allowsEditing)
        
        CommonManager.handleTaskOnMainThreadIfNeeded {
            self.present(imagePicker, animated: animated, completion: completion)
        }
    }
    
    /// Show photo picker.
    private func presentPhotoLibraryPicker(allowsEditing: Bool, animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        let imagePicker = self.photoLibraryPicker(allowsEditing: allowsEditing)
        
        CommonManager.handleTaskOnMainThreadIfNeeded {
            self.present(imagePicker, animated: animated, completion: completion)
        }
    }
    
    /// Create camera picker.
    private func cameraPicker(allowsEditing: Bool) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = allowsEditing
        
        return imagePicker
    }
    
    ///  Create photo picker.
    private func photoLibraryPicker(allowsEditing: Bool) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = allowsEditing
        
        return imagePicker
    }
}

extension UIViewController {
    /// Show camera Unavailable Alert.
    public func showCameraUnavailableAlert() {
        CommonManager.handleTaskOnMainThreadIfNeeded {
            self.showAlert(title: "Camera Unavailable", message: "Camera is not available. Please check your iPhone settings for this app and enable Camera.")
        }
    }
    
    /// Show Photo Library Unavailable Alert.
    public func showPhotoLibraryUnavailableAlert() {
        CommonManager.handleTaskOnMainThreadIfNeeded {
            self.showAlert(title: "Photo Library Unavailable", message: "Photo library is not available. Please check your iPhone settings for this app and enable Photos.")
        }
    }
    
    /// Show Camera Access Denied Alert.
    public func showCameraAccessDeniedAlert() {
        CommonManager.handleTaskOnMainThreadIfNeeded {
            self.showAlert(title: "Camera Access Denied",
                           message: "Finch does not have access to your camera. To enable access, tap Settings and turn on Camera.",
                           cancelButtonTitle: "Settings",
                           cancelHandler: { (_) in
                            
                            CommonManager.openApplicationSettings()
            },
                           otherButtonTitle: "OK",
                           otherHandler: nil)
        }
    }
    
    /// Show Photo Library Access Denied Alert.
    public func showPhotoLibraryAccessDeniedAlert() {
        CommonManager.handleTaskOnMainThreadIfNeeded {
            self.showAlert(title: "Photos Access Denied",
                           message: "Finch does not have access to your photos. To enable access, tap Settings and turn on Photos.",
                           cancelButtonTitle: "Settings",
                           cancelHandler: { (_) in
                            
                            CommonManager.openApplicationSettings()
            },
                           otherButtonTitle: "OK",
                           otherHandler: nil)
        }
    }
    
    /// Show Notification Disabled Alert.
    public func showNotificationDisabledAlert(completionClosure: (() -> Void)? = nil) {
        CommonManager.handleTaskOnMainThreadIfNeeded {
            self.showAlert(title: "Change notification settings",
                           message: "You need to allow notifications on your device to use this feature. Go to device settings?",
                           cancelButtonTitle: "Settings",
                           cancelHandler: { (_) in
                            
                            CommonManager.openApplicationSettings()
                            completionClosure?()
            },
                           otherButtonTitle: "OK",
                           otherHandler: { (_) in
                            
                            completionClosure?()
            })
        }
    }
    
    /// Show Contacts Access Denied Alert. Do not use now.
    public func showContactsAccessDeniedAlert() {
        CommonManager.handleTaskOnMainThreadIfNeeded {
            self.showAlert(title: "Contacts Access Denied",
                           message: "Finch does not have access to your contacts. To enable access, tap Settings and turn on Contacts.",
                           cancelButtonTitle: "Settings",
                           cancelHandler: { (_) in
                            
                            CommonManager.openApplicationSettings()
            },
                           otherButtonTitle: "OK",
                           otherHandler: nil)
        }
    }
    
    /// Show Contacts Access Just Denied Alert.
    public func showContactsAccessJustDeniedAlert() {
        CommonManager.handleTaskOnMainThreadIfNeeded {
            self.showAlert(title: "Are You Sure?",
                           message: "In order to pay friends or create a Group on Finch, you need to add your contacts. Without friends, you might feel a little lonely and nobody wants to feel lonely! To enable access, tap Settings and turn on Contacts.",
                           cancelButtonTitle: "Settings",
                           cancelHandler: { (_) in
                            
                            CommonManager.openApplicationSettings()
            },
                           otherButtonTitle: "OK",
                           otherHandler: nil)
        }
    }
    
    /// Show Contacts Synchronize Alert.
    public func showContactsSynchronizeAlert() {
        CommonManager.handleTaskOnMainThreadIfNeeded {
            self.showAlert(title: "Are You Sure?",
                           message: "In order to pay friends on Finch, please add your contacts. Without friends, you might feel a little lonely and we don’t want you to feel lonely.",
                           cancelButtonTitle: "OK")
        }
    }
    
    /// Show enable Bluetooth Alert.
    public func showEnableBluetoothAlert() {
        CommonManager.handleTaskOnMainThreadIfNeeded {
            self.showAlert(title: "Phone Settings",
                           message: "Please turn on Bluetooth and try again.")
        }
    }
    
    /// Show Bluetooth permission Alert.
    public func showBluetoothPermissionAlert() {
        CommonManager.handleTaskOnMainThreadIfNeeded {
            self.showAlert(title: "Phone Settings",
                           message: "Please check the permissions in your phone settings and try again.",
                           cancelButtonTitle: "Settings",
                           cancelHandler: { (_) in
                            CommonManager.openApplicationSettings()
            },
                           otherButtonTitle: "OK",
                           otherHandler: nil)
        }
    }
}

extension UIViewController {
    
    /// Show system alert with title, message, cancel button title.
    public func showAlert(title: String?,
                          message: String?,
                          cancelButtonTitle: String,
                          cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelHandler)
        showAlert(title: title, message: message, alertActions: [cancelAction])
    }
    
    /// Show system alert with title, message, cancel button title(preferredAction by default), other button title.
    public func showAlert(title: String?,
                          message: String?,
                          cancelButtonTitle: String,
                          cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                          otherButtonTitle: String,
                          otherHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelHandler)
        let otherAction = UIAlertAction(title: otherButtonTitle, style: .default, handler: otherHandler)
        showAlert(title: title, message: message, alertActions: [cancelAction, otherAction])
    }
    
    /// Show system alert with title, message, cancel button title, default button title(preferredAction).
    public func showAlert(title: String?,
                          message: String?,
                          cancelButtonTitle: String,
                          cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                          defaultButtonTitle: String,
                          defaultHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelHandler)
        let defaultAction = UIAlertAction(title: defaultButtonTitle, style: .default, handler: defaultHandler)
        showAlert(title, message: message, preferredStyle: .alert, alertActions: [cancelAction, defaultAction], preferredAction: defaultAction)
    }
    
    /// Show system alert with title, message, cancel button title, destructive button title.
    public func showAlert(title: String?,
                          message: String?,
                          cancelButtonTitle: String,
                          cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                          destructiveButtonTitle: String,
                          destructiveHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelHandler)
        let destructiveAction = UIAlertAction(title: destructiveButtonTitle, style: .destructive, handler: destructiveHandler)
        showAlert(title: title, message: message, alertActions: [cancelAction, destructiveAction])
    }
    
    /// Show system action sheet with title, message, button title, other button title.
    public func showActionSheet(title: String?,
                                message: String?,
                                buttonTitle: String,
                                buttonHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                                otherButtonTitle: String,
                                otherHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let buttonAction  = UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler)
        let otherAction  = UIAlertAction(title: otherButtonTitle, style: .default, handler: otherHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        showActionSheet(title: title, message: message, alertActions: [buttonAction, otherAction, cancelAction])
    }
    
    /// Show system action sheet with title, message, delete button title, other button title.
    public func showActionSheet(title: String?,
                                message: String?,
                                deleteButtonTitle: String,
                                deleteHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                                otherButtonTitle: String,
                                otherHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let deleteAction = UIAlertAction(title: deleteButtonTitle, style: .destructive, handler: deleteHandler)
        let otherAction  = UIAlertAction(title: otherButtonTitle, style: .default, handler: otherHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        showActionSheet(title: title, message: message, alertActions: [otherAction, deleteAction, cancelAction])
    }
    
    /// Show system action sheet with title, message, delete button title.
    public func showActionSheet(title: String?,
                                message: String?,
                                deleteButtonTitle: String,
                                deleteHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let deleteAction = UIAlertAction(title: deleteButtonTitle, style: .destructive, handler: deleteHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        showActionSheet(title: title, message: message, alertActions: [deleteAction, cancelAction])
    }
}

private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

extension UIViewController {
    
    // MARK: - Alert Style
    /**
     Present a title-only alert controller and an OK button to dissmiss the alert.
     - parameter title: The title of the alert.
     */
    func showAlertWithTitle(_ title: String?) {
        showAlert(title, message: nil, cancelButtonTitle: "OK")
    }
    
    /**
     Present a message-only alert controller and an OK button to dissmiss the alert.
     - parameter message: The message content of the alert.
     */
    func showAlertWithMessage(_ message: String?) {
        showAlert("", message: message, cancelButtonTitle: "OK")
    }
    
    /**
     Present an alert controller with a title, a message and an OK button. Tap the OK button will dissmiss the alert.
     - parameter title: The title of the alert.
     - parameter message: The message content of the alert.
     */
    func showAlert(title: String?, message: String?) {
        showAlert(title, message: message, cancelButtonTitle: "OK")
    }
    
    /**
     Present an alert controller with a title, a message and a cancel/dismiss button with a title of your choice.
     - parameter title: The title of the alert.
     - parameter message: The message content of the alert.
     - parameter cancelButtonTitle: Title of the cancel button of the alert.
     */
    func showAlert(_ title: String?, message: String?, cancelButtonTitle: String) {
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        showAlert(title: title, message: message, alertActions: [cancelAction])
    }
    
    /**
     Present an alert controller with a title, a message and an array of handler actions.
     - parameter title: The title of the alert.
     - parameter message: The message content of the alert.
     - parameter alertActions: An array of alert action in UIAlertAction class.
     */
    func showAlert(title: String?, message: String?, alertActions: [UIAlertAction]) {
        showAlert(title, message: message, preferredStyle: .alert, alertActions: alertActions)
    }
    
    // MARK: - Action Sheet Style
    /**
     Present a title-only action sheet and an OK button to dissmiss the alert.
     - parameter title: The title of the action sheet.
     */
    func showActionSheetWithTitle(_ title: String?) {
        showActionSheet(title, message: nil, cancelButtonTitle: "OK")
    }
    
    /**
     Present a message-only action sheet and an OK button to dissmiss the alert.
     - parameter message: The message content of the action sheet.
     */
    func showActionSheetWithMessage(_ message: String?) {
        showActionSheet(nil, message: message, cancelButtonTitle: "OK")
    }
    
    /**
     Present an action sheet with a title, a message and an OK button. Tap the OK button will dissmiss the alert.
     - parameter title: The title of the action sheet.
     - parameter message: The message content of the action sheet.
     */
    func showActionSheet(_ title: String?, message: String?) {
        showActionSheet(title, message: message, cancelButtonTitle: "OK")
    }
    
    /**
     Present an action sheet with a title, a message and a cancel/dismiss button with a title of your choice.
     - parameter title: The title of the action sheet.
     - parameter message: The message content of the action sheet.
     - parameter cancelButtonTitle: The title of the cancel button of the action sheet.
     */
    func showActionSheet(_ title: String?, message: String?, cancelButtonTitle: String) {
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        showActionSheet(title: title, message: message, alertActions: [cancelAction])
    }
    
    /**
     Present an action sheet with a title, a message and an array of handler actions.
     - parameter title: The title of the action sheet.
     - parameter message: The message content of the action sheet.
     - parameter alertActions: An array of alert actions in UIAlertAction class.
     */
    func showActionSheet(title: String?, message: String?, alertActions: [UIAlertAction]) {
        showAlert(title, message: message, preferredStyle: .actionSheet, alertActions: alertActions)
    }
    
    // MARK: - Common Methods
    /**
     Present an alert or action sheet with a title, a message and an array of handler actions.
     - parameter title: The title of the alert/action sheet.
     - parameter message: The message content of the alert/action sheet.
     - parameter alertActions: An array of alert action in UIAlertAction class.
     - parameter preferredAction: The preferred action for the user to take from an alert.
     */
    func showAlert(_ title: String?, message: String?, preferredStyle: UIAlertController.Style, alertActions: [UIAlertAction], preferredAction: UIAlertAction? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for alertAction in alertActions {
            alertController.addAction(alertAction)
        }
        
        // Set preferred action if needed
        if let preferredAction = preferredAction {
            alertController.preferredAction = preferredAction
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
