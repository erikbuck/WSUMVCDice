//
//  AppDelegate.swift
//  WSUMVC
//
//  Created by Erik Buck on 9/9/19.
//  Copyright © 2019 WSU. All rights reserved.
//

import UIKit
import AppIntents

@available(iOS 16.0, *)
struct RollDice : AppIntent {
   static var title : LocalizedStringResource = "Roll Dice"
   
   @MainActor
   func perform() async throws -> some IntentResult {
      Model.shared.roll()
      return .result()
   }
   
   static var openAppWhenRun: Bool = true
}

@available(iOS 16.0, *)
struct RollDiceAutoShortcuts: AppShortcutsProvider {
   static var appShortcuts: [AppShortcut] {
      AppShortcut(intent: RollDice(), phrases: ["Roll Dice in \(.applicationName)"],
                  systemImageName: "RollDice")
   }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   var window: UIWindow?
}
