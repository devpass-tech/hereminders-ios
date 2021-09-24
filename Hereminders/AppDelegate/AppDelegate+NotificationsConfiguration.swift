//
//  AppDelegate+NotificationsConfiguration.swift
//  Hereminders
//
//  Created by Rodrigo Borges on 9/8/18.
//  Copyright © 2018 Rodrigo Borges. All rights reserved.
//

import UserNotifications

extension AppDelegate {

    func requestNotificationsAuthorization() {

        self.notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        self.notificationCenter.requestAuthorization(options: options) { granted, error in }
    }

    func configureNotifications() {

        let doneAction = UNNotificationAction(identifier: "com.hereminders.local-notification.done",
                                              title: L10n.Notification.done,
                                              options: [])

        let category = UNNotificationCategory(identifier: "com.hereminders.local-notification",
                                              actions: [doneAction],
                                              intentIdentifiers: [],
                                              hiddenPreviewsBodyPlaceholder: L10n.Notification.hereminderForYou,
                                              options: [])

        let categories = Set(arrayLiteral: category)
        self.notificationCenter.setNotificationCategories(categories)

//        self.requestNotificationsAuthorization()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.list, .banner, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        switch response.actionIdentifier {
        case "com.hereminders.local-notification.done":

            let identifier = response.notification.request.identifier
            if let reminder = self.reminderController.reminderWithNotificationIdentifier(identifier) {
                self.reminderController.removeReminder(reminder)
                self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
            }
        default:
            break
        }

        completionHandler()
    }
}
