//
//  ContentView.swift
//  widgettest
//
//  Created by Jonn Alves on 22/02/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userSettings = UserSettings()

    var body: some View {
          NavigationView {
              Form {
                  Section(header: Text("PROFILE")) {
                      TextField("Username", text: $userSettings.username)
                      Toggle(isOn: $userSettings.isPrivate) {
                                 Text("Private Account")
                             }
                      Picker(selection: $userSettings.ringtone, label: Text("Ringtone")) {
                                             ForEach(userSettings.ringtones, id: \.self) { ringtone in
                                                 Text(ringtone)
                                             }
                                         }
                  }
                  
                  Button("reload widget"){
                      userSettings.reload()
                  }
                 
              }
              .navigationBarTitle("Settings")
          }
      }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
