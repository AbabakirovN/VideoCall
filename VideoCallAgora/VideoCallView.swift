//
//  VideoCallView.swift
//  VideoCallAgora
//
//  Created by Nurzhan Ababakirov on 4/4/23.
//

import SwiftUI
import AgoraRtcKit
import AgoraUIKit

struct VideoCallView: View {
    @State private var connectedToChannel = false
    
    let channel: String
    let onDisconnect: () -> Void

    static var agview = AgoraViewer(
        connectionData: AgoraConnectionData(
            appId: "3910e12736e04eff9bfb357221654bec",
            rtcToken: nil
        ),
        style: .floating
    )

    @State private var agoraViewerStyle = 0
    var body: some View {
        ZStack {
            VideoCallView.agview
            VStack {
                Picker("Format", selection: $agoraViewerStyle) {
                    Text("Floating").tag(0)
                    Text("Grid").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(
                    minWidth: 0, idealWidth: 100, maxWidth: 200,
                    minHeight: 0, idealHeight: 40, maxHeight: .infinity, alignment: .topTrailing
                ).onChange(
                    of: agoraViewerStyle,
                    perform: {
                        VideoCallView.agview.viewer.style = $0 == 0 ? .floating : .grid
                    }
                )
                Spacer()
                HStack {
                    Spacer()
                    Button(
                        action: { connectToAgora() },
                        label: {
                            if connectedToChannel {
                                Text("Disconnect").padding(3.0).background(Color.red).cornerRadius(3.0)
                            } else {
                                Text("Connect").padding(3.0).background(Color.green).cornerRadius(3.0)
                            }
                        }
                    )
                    Spacer()
                }
                Spacer()
            }
        }
    }

    func connectToAgora() {
        connectedToChannel.toggle()
        if connectedToChannel {
            VideoCallView.agview.join(channel: channel, with: "8fc5dde7d41b436ab976150cef31249e", as: .broadcaster)
        } else {
            VideoCallView.agview.viewer.leaveChannel()
            onDisconnect()
        }
    }
}

