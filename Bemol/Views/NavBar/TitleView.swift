///
/// TitleView.swift
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

final class TitleView: UIView {
  // MARK: - Subviews

  private lazy var label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .boldFootnote
    label.textAlignment = .center
    label.textColor = .buttonForeground
    label.adjustsFontForContentSizeCategory = true
    label.adjustsFontSizeToFitWidth = true
    label.setContentHuggingPriority(.required, for: .horizontal)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)

    return label
  }()

  // MARK: - Sizing

  override var intrinsicContentSize: CGSize {
    CGSize(
      width: .spacingSm + label.intrinsicContentSize.width + .spacingSm,
      height: .spacingXs + label.intrinsicContentSize.height + .spacingXs
    )
  }

  // MARK: - API

  var title: AttributedString? {
    didSet {
      label.attributedText = title.flatMap { NSAttributedString($0) }
      accessibilityLabel = title?.description
    }
  }

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: .zero)
    setUpViewHierarchy()
    setUpAppearance()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private

  private func setUpAppearance() {
    layer.cornerRadius = .cornerRadiusSm
    backgroundColor = .dark
    accessibilityTraits = .staticText
  }

  private func setUpViewHierarchy() {
    addSubview(label)

    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingSm),
      label.centerXAnchor.constraint(equalTo: centerXAnchor),
      label.centerYAnchor.constraint(equalTo: centerYAnchor),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingSm),
      label.topAnchor.constraint(lessThanOrEqualTo: topAnchor, constant: .spacingXxs),
      label.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -.spacingXxs),
    ])
  }
}
