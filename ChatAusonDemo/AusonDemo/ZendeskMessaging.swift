//
//  ZendeskMessaging.swift
//  UnifiedSDK
//
//  Created by Zendesk on 17/04/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import Foundation
import MessagingSDK
import MessagingAPI
import CommonUISDK
import ChatSDK
import ChatProvidersSDK

import SDKConfigurations

final class ZendeskMessaging: NSObject, JWTAuthenticator {

    static let instance = ZendeskMessaging()

    let accountKey = "VujaUKe7FbT54z0hZwHIe9SOmIbfT1RZ"

    var authToken: String = "" {
        didSet {
            guard !authToken.isEmpty else {
                resetVisitorIdentity()
                return
            }
            
            Chat.instance?.setIdentity(authenticator: self)
        }
    }

    // MARK: Configurations
    var messagingConfiguration: MessagingConfiguration {
        let messagingConfiguration = MessagingConfiguration()
        messagingConfiguration.name = "Auson"
        return messagingConfiguration
    }

    var chatConfiguration: ChatConfiguration {
        let chatConfiguration = ChatConfiguration()
        chatConfiguration.isAgentAvailabilityEnabled = true
        chatConfiguration.isPreChatFormEnabled = false
        chatConfiguration.isOfflineFormEnabled = true
        return chatConfiguration
    }

    var chatAPIConfig: ChatAPIConfiguration {
        let chatAPIConfig = ChatAPIConfiguration()
    
        chatAPIConfig.department = "Auson"
        chatAPIConfig.visitorInfo = VisitorInfo(name: "LiveChatTest", email: "iyouqiang@iclouc.om", phoneNumber: "18566775007")
        chatAPIConfig.tags = ["iOS", "chat_v2"]
        return chatAPIConfig
    }

    // MARK: Chat
    func initialize() {
        setChatLogging(isEnabled: true, logLevel: .verbose)
        Chat.initialize(accountKey: accountKey)
    }

    func setChatLogging(isEnabled: Bool, logLevel: LogLevel) {
        Logger.isEnabled = isEnabled
        Logger.defaultLevel = logLevel
    }

    func resetVisitorIdentity() {
        Chat.instance?.resetIdentity(nil)
    }

    func getToken(_ completion: @escaping (String?, Error?) -> Void) {
        completion(authToken, nil)
    }

    // MARK: View Controller
    func buildMessagingViewController() throws -> UIViewController {
        Chat.instance?.configuration = chatAPIConfig

        return try Messaging.instance.buildUI(engines: engines,
                                              configs: [messagingConfiguration, chatConfiguration])
    }

}

extension ZendeskMessaging {
    // MARK: Engines
    var engines: [Engine] {
        let engineTypes: [Engine.Type] = [ChatEngine.self]
        return engines(from: engineTypes)
    }

    func engines(from engineTypes: [Engine.Type]) -> [Engine] {
        engineTypes.compactMap { type -> Engine? in
            switch type {
            case is ChatEngine.Type:
                return try? ChatEngine.engine()
            default:
                fatalError("Unhandled engine of type: \(type)")
            }
        }
    }
}
