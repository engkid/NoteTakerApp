//
//  NoteTakerAppApp.swift
//  NoteTakerApp
//
//  Created by Engkit Riswara on 04/11/25.
//

import SwiftUI
import Factory
import Domain
import DI

@main
struct NoteTakerAppApp: App {
  @Injected(\.backgroundScheduler) private var bg
  @Injected(\.notificationScheduler) private var notifier

  init() { bg.registerHandlers() }

  var body: some Scene {
      WindowGroup {
          ReminderListScreen()
              .task {
                  try? await notifier.requestAuthorizationIfNeeded()
                  bg.scheduleDailyMaintenance()
              }
      }
  }
}
