///
/// MainScreen.swift
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
protocol MainScreenDelegate: AnyObject {
  func didPressHomeButton()
  func didPressRandomButton()
  func didPressStartStopButton()
  func didPressRepeatButton()
  func didPressNextButton()
  func didPressPreviousButton()
  func didPressProgressButton()
  func didPressConfigureButton()
  func didPressNote(_ note: Note)
  func didReleaseNote(_ note: Note)
}

@MainActor
final class MainScreen {
  // MARK: - Views

  private lazy var keyboardView: KeyboardView = {
    let keyboard = KeyboardView(range: 1...2)
    keyboard.translatesAutoresizingMaskIntoConstraints = false
    keyboard.setEnabledForAllKeys(false)
    keyboard.setTintForAllNotes(nil)
    keyboard.isScrollEnabled = false

    keyboard.delegate = self

    return keyboard
  }()

  private lazy var navBar: NavBar = {
    let bar = NavBar()
    bar.translatesAutoresizingMaskIntoConstraints = false
    bar.delegate = self

    return bar
  }()

  lazy var view: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(navBar)
    view.addSubview(keyboardView)

    NSLayoutConstraint.activate([
      navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      navBar.topAnchor.constraint(equalTo: view.topAnchor),
      navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      navBar.heightAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.heightAnchor,
        multiplier: 0.20
      ),

      keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      keyboardView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
      keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    return view
  }()

  // MARK: - API

  weak var delegate: MainScreenDelegate?

  var state: MainScreenState? = nil {
    didSet {
      let key = state?.key ?? .c
      let activeNotes = state?.activeNotes ?? []

      navBar.state = state?.navBarState
      keyboardView.scrollTo(note: Note(name: key, octave: 1), animated: true)
      keyboardView.setEnabledForAllKeys(false)
      keyboardView.setLabelForAllNotes(nil)
      keyboardView.setEnabled(true, for: activeNotes)
      keyboardView.setLabels(activeNotes.map { $0.name.solfege(inKey: key) }, for: activeNotes)
      keyboardView.setTintForAllNotes(nil)
      keyboardView.isUserInteractionEnabled = state?.isKeyboardEnabled ?? true

      if let highlightedNote = state?.highlightedNote {
        keyboardView.setTint(highlightedNote.1, for: [highlightedNote.0])
      }
    }
  }
}

// MARK: - KeyboardDelegate

extension MainScreen: KeyboardViewDelegate {
  func didPressNote(_ note: Note) {
    delegate?.didPressNote(note)
  }

  func didReleaseNote(_ note: Note) {
    delegate?.didReleaseNote(note)
  }
}

// MARK: - NavBarDelegate

extension MainScreen: NavBarDelegate {
  func didPressHomeButton() {
    delegate?.didPressHomeButton()
  }

  func didPressRandomButton() {
    delegate?.didPressRandomButton()
  }

  func didPressStartStopButton() {
    delegate?.didPressStartStopButton()
  }

  func didPressRepeatButton() {
    delegate?.didPressRepeatButton()
  }

  func didPressNextButton() {
    delegate?.didPressNextButton()
  }

  func didPressPreviousButton() {
    delegate?.didPressPreviousButton()
  }

  func didPressProgressButton() {
    delegate?.didPressProgressButton()
  }

  func didPressConfigureButton() {
    delegate?.didPressConfigureButton()
  }
}
