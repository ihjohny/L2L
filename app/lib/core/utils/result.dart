/// A sealed class representing the result of an operation.
///
/// Use [Success] for successful results and [Failure] for errors.
/// This forces explicit error handling at call sites.
abstract class Result<T> {
  const Result();

  /// Returns true if this is a [Success].
  bool get isSuccess;

  /// Returns true if this is a [Failure].
  bool get isFailure => !isSuccess;

  /// Gets the data if this is a [Success], throws if [Failure].
  T get data;

  /// Gets the error message if this is a [Failure], returns null if [Success].
  String? get error;

  /// Transforms the success value using [mapper].
  Result<R> map<R>(R Function(T) mapper) {
    if (isSuccess) {
      return Success<R>(mapper(data));
    } else {
      return Failure<R>(error!);
    }
  }

  /// Maps to either a value using [onSuccess] or [onFailure].
  R fold<R>(R Function(T) onSuccess, R Function(String) onFailure) {
    if (isSuccess) {
      return onSuccess(data);
    } else {
      return onFailure(error!);
    }
  }

  /// Returns [onSuccess] if this is a [Success], [onFailure] otherwise.
  Result<R> flatMap<R>(Result<R> Function(T) mapper) {
    if (isSuccess) {
      return mapper(data);
    } else {
      return Failure<R>(error!);
    }
  }
}

/// A successful result with data.
class Success<T> extends Result<T> {
  final T _data;

  const Success(this._data);

  @override
  bool get isSuccess => true;

  @override
  T get data => _data;

  @override
  String? get error => null;

  @override
  String toString() => 'Success($data)';
}

/// A failed result with an error message.
class Failure<T> extends Result<T> {
  final String _error;

  const Failure(this._error);

  @override
  bool get isSuccess => false;

  @override
  T get data => throw StateError('Cannot get data from a Failure: $_error');

  @override
  String get error => _error;

  @override
  String toString() => 'Failure($_error)';
}

/// Extension methods for Result types.
extension ResultX<T> on Result<T> {
  /// Returns [value] if this is a [Success], [defaultValue] otherwise.
  T getOrElse(T defaultValue()) {
    if (isSuccess) {
      return data;
    } else {
      return defaultValue();
    }
  }

  /// Executes [action] if this is a [Success], returns this otherwise.
  Result<T> onTap(void Function(T) action) {
    if (isSuccess) {
      action(data);
    }
    return this;
  }

  /// Executes [action] if this is a [Failure], returns this otherwise.
  Result<T> onError(void Function(String) action) {
    if (isFailure) {
      action(error!);
    }
    return this;
  }

  /// Converts this Result to an Option type.
  Option<T> get option {
    if (isSuccess) {
      return Some(data);
    } else {
      return None();
    }
  }
}

/// A sealed class representing an optional value.
abstract class Option<T> {
  const Option();

  bool get isDefined;
  bool get isEmpty => !isDefined;
  T get value;
  T getOrElse(T defaultValue());
}

class Some<T> extends Option<T> {
  final T _value;

  const Some(this._value);

  @override
  bool get isDefined => true;

  @override
  T get value => _value;

  @override
  T getOrElse(T defaultValue()) => _value;

  @override
  String toString() => 'Some($_value)';
}

class None<T> extends Option<T> {
  const None();

  @override
  bool get isDefined => false;

  @override
  T get value => throw StateError('Cannot get value from None');

  @override
  T getOrElse(T defaultValue()) => defaultValue();

  @override
  String toString() => 'None';
}
