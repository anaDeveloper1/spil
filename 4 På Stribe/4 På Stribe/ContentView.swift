//
//  ContentView.swift
//  4 På Stribe
//
//  Created by Developer on 31/05/2022.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("Vind") var vind = 0
    @AppStorage("Tabe") var tabe = 0
    @AppStorage("Uafgjordt") var uafgjordt = 0
    
    @AppStorage("playerPiecesColor") var playerPiecesColor = Color.red
    @AppStorage("computerPiecesColor") var computerPiecesColor = Color.yellow
    
    @State private var usrPieces = 21
    @State private var computerPieces = 21
    @State private var hul = Array(repeating: Hul.blank, count: 42)
    @State private var skift = Skift.user
    @State private var connectIdx: [Int] = []
    @State private var selectTab = 0
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    HStack {
                        Circle()
                            .frame(width: geometry.size.width / 9, height: geometry.size.width / 9)
                            .foregroundColor(playerPiecesColor)
                        
                        VStack {
                            HStack {
                                Text("Dig")
                                Spacer()
                                Text("Computer")
                            }
                            .font(.title3.bold())
                            
                            HStack {
                                Text("\(usrPieces)")
                                Spacer()
                                Text("vs")
                                Spacer()
                                Text("\(computerPieces)")
                            }
                        }
                        
                        Circle()
                            .frame(width: geometry.size.width / 9, height: geometry.size.width / 9)
                            .foregroundColor(computerPiecesColor)
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                        ForEach(0..<42) { index in
                            switch hul[index] {
                            case .blank:
                                Circle()
                                    .frame(width: geometry.size.width / 9, height: geometry.size.width / 9)
                                    .foregroundColor(.black.opacity(0.5))
                                    .onTapGesture {
                                        if skift == .user {
                                            playerTurn(index: index)
                                        }
                                    }
                                
                            case .user:
                                if connectIdx.contains(index) {
                                    Circle()
                                        .strokeBorder(Color.white, lineWidth: 4)
                                        .background(Circle().fill(playerPiecesColor))
                                        .frame(width: geometry.size.width / 9, height: geometry.size.width / 9)
                                } else {
                                    Circle()
                                        .frame(width: geometry.size.width / 9, height: geometry.size.width / 9)
                                        .foregroundColor(playerPiecesColor)
                                        .onTapGesture {
                                            if skift == .user && hul[index % 7] == .blank {
                                               playerTurn(index: index)
                                            }
                                        }
                                }
                                
                            case .computer:
                                if connectIdx.contains(index) {
                                    Circle()
                                        .strokeBorder(Color.white, lineWidth: 4)
                                        .background(Circle()
                                            .fill(computerPiecesColor))
                                        .frame(width: geometry.size.width / 9, height: geometry.size.width / 9)
                                } else {
                                    Circle()
                                        .frame(width: geometry.size.width / 9, height: geometry.size.width / 9)
                                        .foregroundColor(computerPiecesColor)
                                        .onTapGesture {
                                            if skift == .user && hul[index % 7] == .blank {
                                                playerTurn(index: index)
                                            }
                                        }
                                }
                            }
                            
                        }
                    }
                    .padding()
                    .background(.blue.opacity(0.6))
                    .cornerRadius(15)
                    .padding(.bottom, 10)
                    
                    HStack {
                        Spacer()
                        switch skift {
                        case .user:
                            Text("Din tur")
                                .bold()
                                .font(.title)
                        case .computer:
                            Text("Computer's tur")
                                .bold()
                                .font(.title)
                        case .userWin:
                            Text("*** Du Vandt! ***")
                                .bold()
                                .font(.title)
                        case .computerWin:
                            Text("*** Computer Vandt! ***")
                                .bold()
                                .font(.title)
                        case .tie:
                            Text("Det blev Uafgjordt.")
                                .bold()
                                .font(.title)
                            
                        }
                        Spacer()
                    }
                    .padding(8)
                    .background(.blue.opacity(0.7))
                    .cornerRadius(15)
                    .padding(.bottom, 10)
                    
                    if (skift != .user && skift != .computer) {
                        HStack {
                            Spacer()
                            Button {
                                usrPieces = 21
                                computerPieces = 21
                                hul = Array(repeating: .blank, count: 42)
                                skift = .user
                                connectIdx = []
                            } label: {
                                Text("Start Næste Runde")
                                    .bold()
                                    .font(.title)
                            }
                            Spacer()
                        }
                        .padding(8)
                        .background(.blue.opacity(0.7))
                        .cornerRadius(15)
                    }
                    Spacer()
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("4 På Stribe")
                            .bold()
                            .font(.largeTitle)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button {
                                if(skift != .computer) {
                                    usrPieces = 21
                                    computerPieces = 21
                                    hul = Array(repeating: .blank, count: 42)
                                    skift = .user
                                    connectIdx = []
                                }
                            } label: {
                                Image(systemName: "arrow.counterclockwise.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width / 15, height: geometry.size.width / 15)
                                    .padding(8.5)
                                    .background(.quaternary)
                                    .cornerRadius(15)
                            }
                            
                            NavigationLink {
                                SettingsView()
                            } label: {
                                Image(systemName: "gear")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width / 15, height: geometry.size.width / 15)
                                    .padding(8.5)
                                    .background(.quaternary)
                                    .cornerRadius(15)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func playerTurn(index: Int) {
        skift = .computer
        usrPieces -= 1
        var topIdx = index % 7
        var blankNum = 0
        while (hul[topIdx] == .blank && topIdx+7 <= 41 && hul[topIdx+7] == .blank) {
            blankNum += 1
            topIdx += 7
        }
        var idx = index % 7
        for i in 0...blankNum {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12*Double(i)) {
                if(idx>6) {
                    self.hul[idx-7] = .blank
                }
                self.hul[idx] = .user
                idx += 7
                if(i == blankNum) {
                    checkFinish()
                    if(skift == .computer) {
                        computerTurn()
                    }
                }
            }
        }
    }
    
    func computerTurn() {
        computerPieces -= 1
        // check "|"
        for row in 0...2 {
            for col in 0...6 {
                if (self.hul[7*row+col] == .blank
                    && self.hul[7*row+col+7] != .blank
                    && self.hul[7*row+col+7] == self.hul[7*row+col+14]
                    && self.hul[7*row+col+14] == self.hul[7*row+col+21]) {
                    computerDrop(col: col, row: row)
                    return
                }
            }
        }
        // check "\" and drop at left
        for row in 0...2 {
            for col in 0...3 {
                if (self.hul[7*row+col] == .blank
                    && self.hul[7*row+col+7] != .blank
                    && self.hul[7*row+col+8] != .blank
                    && self.hul[7*row+col+8] == self.hul[7*row+col+16]
                    && self.hul[7*row+col+16] == self.hul[7*row+col+24]) {
                    computerDrop(col: col, row: row)
                    return
                }
            }
        }
        // check "\" and drop at right
        for row in 0...2 {
            for col in 0...3 {
                if (self.hul[7*row+col] != .blank
                    && self.hul[7*row+col] == self.hul[7*row+col+8]
                    && self.hul[7*row+col+8] == self.hul[7*row+col+16]
                    && self.hul[7*row+col+24] == .blank) {
                    if(7*row+col+31<=41 && self.hul[7*row+col+31] != .blank) {
                        computerDrop(col: col+24, row: row+3)
                        return
                    } else if(7*row+col+31>41) {
                        computerDrop(col: col+24, row: row+3)
                        return
                    }
                }
            }
        }
        // check "/" and drop at left
        for row in 0...2 {
            for col in 3...6 {
                if (self.hul[7*row+col] != .blank
                    && self.hul[7*row+col] == self.hul[7*row+col+6]
                    && self.hul[7*row+col+6] == self.hul[7*row+col+12]
                    && self.hul[7*row+col+18] == .blank) {
                    if(7*row+col+25<=41 && self.hul[7*row+col+25] != .blank) {
                        computerDrop(col: col+18, row: row+3)
                        return
                    } else if(7*row+col+25>41) {
                        computerDrop(col: col+18, row: row+3)
                        return
                    }
                }
            }
        }
        // check "/" and drop at right
        for row in 0...2 {
            for col in 3...6 {
                if (self.hul[7*row+col] == .blank
                    && self.hul[7*row+col+6] != .blank
                    && self.hul[7*row+col+7] != .blank
                    && self.hul[7*row+col+6] == self.hul[7*row+col+12]
                    && self.hul[7*row+col+12] == self.hul[7*row+col+18]) {
                    computerDrop(col: col, row: row)
                    return
                }
            }
        }
        // check "-" and drop at left to win
        for row in 0...5 {
            for col in 0...3 {
                if (self.hul[7*row+col] == .blank
                    && self.hul[7*row+col+1] == .computer
                    && self.hul[7*row+col+1] == self.hul[7*row+col+2]
                    && self.hul[7*row+col+2] == self.hul[7*row+col+3]) {
                    if(7*row+col+7<=41 && self.hul[7*row+col+7] != .blank) {
                        computerDrop(col: col, row: row)
                        return
                    } else if(7*row+col+7>41) {
                        computerDrop(col: col, row: row)
                        return
                    }
                }
            }
        }
        // check "-" and drop at right to win
        for row in 0...5 {
            for col in 3...6 {
                if (self.hul[7*row+col] == .blank
                    && self.hul[7*row+col-1] == .computer
                    && self.hul[7*row+col-1] == self.hul[7*row+col-2]
                    && self.hul[7*row+col-2] == self.hul[7*row+col-3]) {
                    if(7*row+col+7<=41 && self.hul[7*row+col+7] != .blank) {
                        computerDrop(col: col, row: row)
                        return
                    } else if(7*row+col+7>41) {
                        computerDrop(col: col, row: row)
                        return
                    }
                }
            }
        }
        // check "-" and drop at left to prevent user win
        for row in 0...5 {
            for col in 0...4 {
                if (self.hul[7*row+col] == .blank
                    && self.hul[7*row+col+1] == .user
                    && self.hul[7*row+col+1] == self.hul[7*row+col+2]) {
                    if(7*row+col+7<=41 && self.hul[7*row+col+7] != .blank) {
                        computerDrop(col: col, row: row)
                        return
                    } else if(7*row+col+7>41) {
                        computerDrop(col: col, row: row)
                        return
                    }
                }
            }
        }
        // check "-" and drop at right to prevent user win
        for row in 0...5 {
            for col in 2...6 {
                if (self.hul[7*row+col] == .blank
                    && self.hul[7*row+col-1] == .user
                    && self.hul[7*row+col-1] == self.hul[7*row+col-2]) {
                    if(7*row+col+7<=41 && self.hul[7*row+col+7] != .blank) {
                        computerDrop(col: col, row: row)
                        return
                    } else if(7*row+col+7>41) {
                        computerDrop(col: col, row: row)
                        return
                    }
                }
            }
        }
        
        var col = Int.random(in: 0...6)
        while (self.hul[col] != .blank) {
            col = Int.random(in: 0...6)
        }
        var blankNum = 0
        while (hul[col] == .blank && col+7 <= 41 && hul[col+7] == .blank) {
            blankNum += 1
            col += 7
        }
        computerDrop(col: col, row: blankNum)
    }
    
    func computerDrop(col: Int, row: Int) {
        var idx = col % 7
        for i in 0...row {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12*Double(i)) {
                if(idx>6) {
                    self.hul[idx-7] = .blank
                }
                self.hul[idx] = .computer
                idx += 7
                if(i == row) {
                    checkFinish()
                    if(skift == .computer) {
                        if(computerPieces == 0) {
                            skift = .tie
                            uafgjordt += 1
                        } else {
                            skift = .user
                        }
                    }
                }
            }
        }
    }
    
    func checkFinish() {
        // check "|"
        for row in 0...2 {
            for col in 0...6 {
                if (self.hul[7*row+col] != .blank
                    && self.hul[7*row+col] == self.hul[7*row+col+7]
                    && self.hul[7*row+col+7] == self.hul[7*row+col+14]
                    && self.hul[7*row+col+14] == self.hul[7*row+col+21]) {
                    connectIdx.append(7*row+col)
                    connectIdx.append(7*row+col+7)
                    connectIdx.append(7*row+col+14)
                    connectIdx.append(7*row+col+21)
                    if(self.hul[7*row+col] == .user) {
                        skift = .userWin
                        vind += 1
                    } else {
                        skift = .computerWin
                        tabe += 1
                    }
                    return
                }
            }
        }
        // check "-"
        for row in 0...5 {
            for col in 0...3 {
                if (self.hul[7*row+col] != .blank
                    && self.hul[7*row+col] == self.hul[7*row+col+1]
                    && self.hul[7*row+col+1] == self.hul[7*row+col+2]
                    && self.hul[7*row+col+2] == self.hul[7*row+col+3]) {
                    connectIdx.append(7*row+col)
                    connectIdx.append(7*row+col+1)
                    connectIdx.append(7*row+col+2)
                    connectIdx.append(7*row+col+3)
                    if(self.hul[7*row+col] == .user) {
                        skift = .userWin
                        vind += 1
                    } else {
                        skift = .computerWin
                        tabe += 1
                    }
                    return
                }
            }
        }
        // check "\"
        for row in 0...2 {
            for col in 0...3 {
                if (self.hul[7*row+col] != .blank
                    && self.hul[7*row+col] == self.hul[7*row+col+8]
                    && self.hul[7*row+col+8] == self.hul[7*row+col+16]
                    && self.hul[7*row+col+16] == self.hul[7*row+col+24]) {
                    connectIdx.append(7*row+col)
                    connectIdx.append(7*row+col+8)
                    connectIdx.append(7*row+col+16)
                    connectIdx.append(7*row+col+24)
                    if(self.hul[7*row+col] == .user) {
                        skift = .userWin
                        vind += 1
                    } else {
                        skift = .computerWin
                        tabe += 1
                    }
                    return
                }
            }
        }
        // check "/"
        for row in 0...2 {
            for col in 3...6 {
                if (self.hul[7*row+col] != .blank
                    && self.hul[7*row+col] == self.hul[7*row+col+6]
                    && self.hul[7*row+col+6] == self.hul[7*row+col+12]
                    && self.hul[7*row+col+12] == self.hul[7*row+col+18]) {
                    connectIdx.append(7*row+col)
                    connectIdx.append(7*row+col+6)
                    connectIdx.append(7*row+col+12)
                    connectIdx.append(7*row+col+18)
                    if(self.hul[7*row+col] == .user) {
                        skift = .userWin
                        vind += 1
                    } else {
                        skift = .computerWin
                        tabe += 1
                    }
                    return
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
