//
//  ContentView.swift
//  VideoCallAgora
//
//  Created by Nurzhan Ababakirov on 4/4/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedChannel: String?
    @State private var channels: [String] = UserDefaults.standard.stringArray(forKey: "channels") ?? []
    @State private var newChannelName = ""

    var body: some View {
        VStack {
            if let channel = selectedChannel {
                VideoCallView(channel: channel, onDisconnect: {
                    selectedChannel = nil
                })
            } else {
                List {
                    ForEach(channels, id: \.self) { channel in
                        Text(channel).onTapGesture {
                            selectedChannel = channel
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                channels.removeAll(where: { $0 == channel })
                                UserDefaults.standard.setValue(channels, forKey: "channels")
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    HStack {
                        TextField("New channel name", text: $newChannelName)
                        Button("Add") {
                            if !newChannelName.isEmpty {
                                channels.append(newChannelName)
                                UserDefaults.standard.setValue(channels, forKey: "channels")
                                newChannelName = ""
                            }
                        }
                        .disabled(newChannelName.isEmpty)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
