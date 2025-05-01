///
/// App.swift
/// Bemol
///
/// Copyright 2025 Faiçal Tchirou
///
/// Bemol is free software: you can redistribute it and/or modify it under the terms of
/// the GNU General Public License as published by the Free Software Foundation, either version 3
/// of the License, or (at your option) any later version.
///
/// Bemol is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
/// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
/// See the GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License along with Foobar.
/// If not, see <https://www.gnu.org/licenses/>.
///

import Foundation
import UIKit

@MainActor
final class App {
  // MARK: - Screens

  private lazy var main: MainScreen = {
    let main = MainScreen()
    main.delegate = self

    return main
  }()

  private lazy var levelEditor: LevelEditorScreen = {
    let editor = LevelEditorScreen(notePlayer: notePlayer)
    editor.delegate = self

    return editor
  }()

  private lazy var accuracy: AccuracyScreen = {
    let progression = AccuracyScreen(notePlayer: notePlayer)
    progression.delegate = self
    
    return progression
  }()

  private lazy var errorScreen: ErrorScreen = {
    let screen = ErrorScreen(notePlayer: notePlayer)

    return screen
  }()

  // MARK: - Views

  private lazy var mainView: UIView = {
    let view = main.view
    view.translatesAutoresizingMaskIntoConstraints = false

    return view
  }()

  private lazy var levelEditorView: UIView = {
    let view = levelEditor.view
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isHidden = true

    return view
  }()

  private lazy var accuracyView: UIView = {
    let view = accuracy.view
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isHidden = true

    return view
  }()

  private lazy var errorView: UIView = {
    let view = errorScreen.view
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isHidden = true

    return view
  }()

  lazy var view: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(mainView)
    view.addSubview(levelEditorView)
    view.addSubview(accuracyView)
    view.addSubview(errorView)

    NSLayoutConstraint.activate([
      mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mainView.topAnchor.constraint(equalTo: view.topAnchor),
      mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      levelEditorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      levelEditorView.topAnchor.constraint(equalTo: view.topAnchor),
      levelEditorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      levelEditorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      accuracyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      accuracyView.topAnchor.constraint(equalTo: view.topAnchor),
      accuracyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      accuracyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      errorView.topAnchor.constraint(equalTo: view.topAnchor),
      errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

    ])

    return view
  }()

  // MARK: - Properties

  private let environment: AppEnvironment
  private let loop: AppLoop
  private var notePlayer: NotePlayer {
    environment.notePlayer
  }

  // MARK: - Initialization

  init(environment: AppEnvironment, loop: AppLoop) {
    self.environment = environment
    self.loop = loop
    self.loop.delegate = self
  }
}

// MARK: - MainScreenDelegate

extension App: MainScreenDelegate {
  func didPressHomeButton() {
    loop.dispatch(.didPressHomeButton)
  }

  func didPressRandomButton() {
    loop.dispatch(.didPressRandomButton)
  }

  func didPressStartStopButton() {
    loop.dispatch(.didPressStartStopLevelButton)
  }
  
  func didPressRepeatButton() {
    loop.dispatch(.didPressRepeatQuestionButton)
  }

  func didPressNextButton() {
    loop.dispatch(.didPressNextLevelButton)
  }
  
  func didPressPreviousButton() {
    loop.dispatch(.didPressPreviousLevelButton)
  }
  
  func didPressProgressButton() {
    loop.dispatch(.didPressAccuracyRing)
  }
  
  func didPressConfigureButton() {
    loop.dispatch(.didPressConfigureLevelButton)
  }
  
  func didPressNote(_ note: Note) {
    loop.dispatch(.didPressNote(note))
  }
  
  func didReleaseNote(_ note: Note) {
    loop.dispatch(.didReleaseNote(note))
  }
}

// MARK: - LevelEditorDelegate

extension App: LevelEditorScreenDelegate {
  func didSelectNotes(_ notes: [Note]) {
    loop.dispatch(.didSelectNotes(notes))
    loop.dispatch(.didDismissLevelEditor)
  }

  func didCancel() {
    loop.dispatch(.didDismissLevelEditor)
  }
}

// MARK: - AccuracyScreenDelegate

extension App: AccuracyScreenDelegate {
  func didPressDone() {
    loop.dispatch(.didDismissAccuracyScreen)
  }
}

// MARK: - AppLoopDelegate

extension App: AppLoopDelegate {
  func didUpdateState(_ state: AppState) {
    main.state = state.mainScreenState
    levelEditor.state = state.levelEditorScreenState
    accuracy.state = state.accuracyScreenState
    levelEditorView.isHidden = !state.isLevelEditorVisible
    accuracyView.isHidden = !state.isAccuracyScreenVisible
    mainView.isHidden = state.isLevelEditorVisible || state.isAccuracyScreenVisible || state.hasError
    errorView.isHidden = !state.hasError
    errorScreen.error = state.error
  }
}
