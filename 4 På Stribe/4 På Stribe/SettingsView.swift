//
//  SettingsView.swift
//  4 På Stribe
//
//  Created by Developer on 31/05/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("win") var win = 0
    @AppStorage("lose") var lose = 0
    @AppStorage("tie") var tie = 0
    
    @AppStorage("playerPiecesColor") var playerPiecesColor = Color.red
    @AppStorage("computerPiecesColor") var computerPiecesColor = Color.yellow
    
    var body: some View {
        List {
            Section(header: Text("Vælge Farve")) {
                ColorPicker("Spiller Farve", selection: $playerPiecesColor)
                ColorPicker("Computer Farve", selection: $computerPiecesColor)
            }
            
            Section(header: Text("Score")) {
                Text("Total Vundet: \(win)")
                Text("Total Tabte: \(lose)")
                Text("Total Uafgjordte: \(tie)")
            }
            
            Section(header: Text("Nulstil Score")) {
                Button {
                    win = 0
                    lose = 0
                    tie = 0
                } label: {
                    HStack {
                        Text("Slet Score Data")
                            Spacer()
                        Image(systemName: "arrow.triangle.2.circlepath.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(width: 25, height: 25)
                    }
                }
            }
            Section(header: Text("Version: 1.0.0")) {}
        }
        .listStyle(.grouped)
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
