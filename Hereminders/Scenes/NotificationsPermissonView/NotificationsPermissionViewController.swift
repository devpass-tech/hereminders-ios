//
//  NotificationsPermissionViewController.swift
//  Hereminders
//
//  Created by Hellen on 22/09/21.
//  Copyright © 2021 Rodrigo Borges. All rights reserved.
//

import UIKit

class NotificationsPermissionViewController: UIViewController {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        permissionDenied()
    }
    
    override func loadView() {
        configureView()
    }
    
    // MARK: - Private Functions
    
    private func configureView() {
        let view = NotificationsPermissionView(self)
        
        let buttonViewModel = ButtonViewModel(titleButton: "Dar permissão à notificações")
        
        let viewModel = NotificationsPermissonViewModel(title: "Notificações",
                                                        subtitle: "O Hereminders precisa da permissão à notificações para funcionar. Vamos avisar você sobre os seus lembretes sempre que sair ou entrar em algum local.",
                                                        button: buttonViewModel)
        
        view.configure(with: viewModel)
        self.view = view
    }
    
    private func permissionDenied() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.permissionDenied { result, _ in
            print("DEBUG: \(result)")
            guard result else { return }
            print("DEBUG: Permissao negada")
            self.proceedToAppPrivacySettings()
        }
    }
    
    private func proceedToAppPrivacySettings() {
        guard let url = URL(
                string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(url)
        else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - Extension NotificationsPermissionDelegate

extension NotificationsPermissionViewController: NotificationsPermissionDelegate {
    
    func didSelectNotificationPermission() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.requestNotificationsAuthorization()
    }
}
