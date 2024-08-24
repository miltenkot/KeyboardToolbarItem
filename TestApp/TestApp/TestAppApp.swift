//
//  TestAppApp.swift
//  TestApp
//
//  Created by Bartlomiej Lanczyk on 21/06/2024.
//

import SwiftUI

@main
struct TestAppApp: App {
    var body: some Scene {
        WindowGroup {
            BetterContentView()
        }
    }
}

enum FieldFocus {
    case email
    case password
    case repeatPassword
}

@Observable
final class ContentViewModel {
    var isFocused: FieldFocus? = .email
    
    func doneTapped() {
        isFocused = nil
    }
    
    func arrowDownTapped() {
        arrowTapped(direction: .down)
    }
    
    func arrowUpTapped() {
        arrowTapped(direction: .up)
    }
    
    private enum Direction {
        case up
        case down
    }

    private func arrowTapped(direction: Direction) {
        guard let isFocused else { return }
        
        switch (isFocused, direction) {
        case (.email, .down):
            self.isFocused = .password
        case (.password, .down):
            self.isFocused = .repeatPassword
        case (.repeatPassword, .down):
            self.isFocused = nil
        case (.email, .up):
            self.isFocused = nil
        case (.password, .up):
            self.isFocused = .email
        case (.repeatPassword, .up):
            self.isFocused = .password
        }
    }
}

import SwiftUINavigation
struct BetterContentView: View {
    @State var text1 = ""
    @State var text2 = ""
    @State var text3 = ""
    
    @State var vm = ContentViewModel()
    @FocusState var isFocused: FieldFocus?
    
    var body: some View {
        VStack {
            Group {
                TextField(text: $text1, prompt: Text("Enter your email here"), label: { Text("Email") })
                    .focused($isFocused, equals: .email)
                TextField(text: $text2, prompt: Text("Enter your password here"), label: { Text("Password") })
                    .focused($isFocused, equals: .password)
                TextField(text: $text3, prompt: Text("Repeat password here"), label: { Text("Repeat password") })
                    .focused($isFocused, equals: .repeatPassword)
            }
            .padding()
        }
        .padding()
        .toolbar {
            ToolbarItemKeyboard(arrowUpTapped: vm.arrowUpTapped, arrowDownTapped: vm.arrowDownTapped, doneTapped: vm.doneTapped)
            
        }
        .bind(self.$vm.isFocused, to: $isFocused)
    }
}

struct ContentView: View {
    @State var text1 = ""
    @State var text2 = ""
    @State var text3 = ""
    
    @FocusState var isFocused: FieldFocus?
    
    var body: some View {
        VStack {
            Group {
                TextField(text: $text1, prompt: Text("Enter your email here"), label: { Text("Email") })
                    .focused($isFocused, equals: .email)
                TextField(text: $text2, prompt: Text("Enter your password here"), label: { Text("Password") })
                    .focused($isFocused, equals: .password)
                TextField(text: $text3, prompt: Text("Repeat password here"), label: { Text("Repeat password") })
                    .focused($isFocused, equals: .repeatPassword)
            }
            .padding()
        }
        .padding()
        .toolbar {
            ToolbarItemKeyboard(arrowUpTapped: arrowUpTapped, arrowDownTapped: arrowDownTapped, doneTapped: doneTapped)
            
        }
        .onAppear {
            isFocused = .email
        }
    }
    
    private func doneTapped() {
        isFocused = nil
    }
    
    private func arrowDownTapped() {
        arrowTapped(direction: .down)
    }
    
    private func arrowUpTapped() {
        arrowTapped(direction: .up)
    }
    
    private enum Direction {
        case up
        case down
    }

    private func arrowTapped(direction: Direction) {
        guard let isFocused else { return }
        
        switch (isFocused, direction) {
        case (.email, .down):
            self.isFocused = .password
        case (.password, .down):
            self.isFocused = .repeatPassword
        case (.repeatPassword, .down):
            self.isFocused = nil
        case (.email, .up):
            self.isFocused = nil
        case (.password, .up):
            self.isFocused = .email
        case (.repeatPassword, .up):
            self.isFocused = .password
        }
    }
}

struct ToolbarItemKeyboard: ToolbarContent {
    let arrowUpTapped: () -> Void
    let arrowDownTapped: () -> Void
    let doneTapped: () -> Void
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: .keyboard) {
            HStack(spacing: 0) {
                Button(action: arrowUpTapped, label: {
                    Image("Arow-Up")
                })
                
                Button(action: arrowDownTapped, label: {
                    Image("Arrow-Down")
                })
                
                Spacer()
                
                Button(action: doneTapped, label: {
                    Text("Done")
                })
            }
            .foregroundStyle(Color.accentColor)
        }
    }
}

#Preview {
    ContentView()
}
