//
//  ViewController.swift
//  AusonDemo
//
//  Created by Yochi on 2021/4/9.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: (self.view.frame.width - 100)/2.0, y: 100, width: 100, height: 100)
        btn.setTitle("Chat", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(startChatMessage), for: .touchUpInside);
        view.addSubview(btn)
    }

   @objc func startChatMessage (){
        
    do {
        try presentModally()
    } catch {
        print(error)
    }

    }

    private func presentModally() throws {
        
        let viewController = try ZendeskMessaging.instance.buildMessagingViewController()
        
        let button = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissView))
        viewController.navigationItem.leftBarButtonItem = button

        let chatController = UINavigationController(rootViewController: viewController)
        chatController.modalPresentationStyle = .fullScreen
        present(chatController, animated: true)
    }

    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}

