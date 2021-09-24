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

}

// MARK: - Extension NotificationsPermissionDelegate

extension NotificationsPermissionViewController: NotificationsPermissionDelegate {
    
    func didSelectNotificationPermission() {
        print("Usuário clicou em Dar permissão")
        
    }
}
