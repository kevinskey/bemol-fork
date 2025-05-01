///
/// AppEffect.swift
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

struct AppEffect<T> {
  private let effect: () async throws -> T

  init(effect: @escaping () async throws -> T) {
    self.effect = effect
  }

  func mapTo<U>(
    _ transform: @escaping (Result<T, any Error>) -> U
  ) -> AppEffect<U> {
    AppEffect<U> {
      do {
        let result = try await effect()
        return transform(.success(result))
      } catch {
        return transform(.failure(error))
      }
    }
  }

  func run() async throws -> T {
    try await effect()
  }
}
