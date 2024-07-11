// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Utility class to wrap result data
///
/// Evaluate the result using a switch statement:
/// ```dart
/// switch (result) {
///   case Ok(): {
///     debugPrint(result.value);
///   }
///   case Error(): {
///     debugPrint(result.error);
///   }
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// Creates an instance of Result containing a value
  factory Result.ok(T value) => Ok(value);

  /// Create an instance of Result containing an error
  factory Result.error(Exception error) => Error(error);

  /// Convenience method to cast to Ok
  Ok<T> get asOk => this as Ok<T>;

  /// Convenience method to cast to Error
  Error get asError => this as Error<T>;
}

/// Subclass of Result for values
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  /// Returned value in result
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

/// Subclass of Result for errors
final class Error<T> extends Result<T> {
  const Error(this.error);

  /// Returned error in result
  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}
