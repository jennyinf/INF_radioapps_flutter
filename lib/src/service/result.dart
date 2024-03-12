/// Base Result class
/// [S] represents the type of the success value
/// [E] should be [Exception] or a subclass of it
sealed class Result<S, E extends Exception> {
  const Result();

  /// map a result class to another type
  ///
  /// throwOnFailure is an exception to throw if the mapping fails - it is not required but it MUST be set if
  /// the mapping is parsing json or performing some other operation that can return an error.  
  Result<M,E> map<M>( M Function(S) mapper, { E Function(String) ? throwOnFailure } ) {
    // if the mapper throws an exception return that as a failure
    try {
      return switch(this) {
        Success(value: final value) => Success(mapper(value)),
        Failure(exception: final e) => Failure(e)
      };

    } on E catch (e) {
      return Failure(e);
    } catch (e) {
      // an unknown exception has occurred - probably in parsing JSON.  Throw it back as a failure
      // it a programmer error to get a null exception from here
      return Failure(throwOnFailure!(e.toString()));
    }
  }

  Result<S,NE> mapError<NE extends Exception>( {NE Function(E)? mapper} ) {
    return switch(this) {
        Success(value: final value) => Success(value),
        //  cast ignored - it is necessary - app wont run on ios without it
        // ignore: unnecessary_cast
        Failure(exception: final e) => Failure( (e is NE) ? e as NE: mapper!(e) )
      };

  }
  // check whether a result failed with a specific type
  bool failed<EType extends E>() {
    return switch(this) {
        Success(value: final _) => false,
        Failure(exception: final e) => e is EType
    };
  }

  // check whether a result succeeded
  bool get succeeded {
    return switch(this) {
        Success(value: final _) => true,
        Failure(exception: final _) => false
    };
  }

  /// extract the success value if it exists
  S? get success {
    return switch(this) {
        Success(value: final value) => value,
        Failure(exception: final _) => null
      };

  }

  /// extract the failure value if it exists
  E? get failure {
    return switch(this) {
        Success(value: final _) => null,
        Failure(exception: final e) => e
      };

  }

}

final class Success<S, E extends Exception> extends Result<S, E> {
  const Success(this.value);
  final S value;
}

final class Failure<S, E extends Exception> extends Result<S, E> {
  const Failure(this.exception);
  final E exception;
}
