//
//  UserSettings.swift
//  widgettest
//
//  Created by Jonn Alves on 22/02/23.
//

import Foundation
import Combine
import WidgetKit

private let group = "group.com.quanticheart.widgettest"
class UserSettings: ObservableObject {
    @Published var username: String {
        didSet {
            UserDefaults(suiteName:group)?.set(username, forKey: "username")
        }
    }
    
    @Published var isPrivate: Bool {
        didSet {
            UserDefaults(suiteName:group)?.set(isPrivate, forKey: "isAccountPrivate")
        }
    }
    
    @Published var ringtone: String {
        didSet {
            UserDefaults(suiteName:group)?.set(ringtone, forKey: "ringtone")
        }
    }
    
    public var ringtones = ["Chimes", "Signal", "Waves"]
    
    init() {
        self.username =  UserDefaults(suiteName:group)?.object(forKey: "username") as? String ?? ""
        self.isPrivate = UserDefaults(suiteName:group)?.object(forKey: "isAccountPrivate") as? Bool ?? true
        self.ringtone =  UserDefaults(suiteName:group)?.object(forKey: "ringtone") as? String ?? "Chimes"
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func reload(){
        save()
        WidgetCenter.shared.reloadAllTimelines()
//        WidgetCenter.shared.reloadTimelines(ofKind: ofKind)
    }
    
    struct User: Codable {
        var username: String
        var isPrivate: Bool
        var ringtone: String
    }

    private func save(){
        let user = User(username:username,isPrivate: isPrivate, ringtone: ringtone)
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(user)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            UserDefaults(suiteName:group)?.set(json, forKey: "user")
        } catch {
            print(error)
        }
    }
}
