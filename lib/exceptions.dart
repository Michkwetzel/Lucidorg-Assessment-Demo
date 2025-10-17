class SurveyException implements Exception {
  final String message;
  final String title;

  SurveyException(this.message, this.title);

  @override
  String toString() => message;
}

class MissingTokenException extends SurveyException {
  MissingTokenException() : super('Required tokens are missing from the URL', 'Invalid URL');
}

class Error extends SurveyException {
  Error() : super('Problem starting survey', 'Problem starting survey');
}

class CompanyNotFoundException extends SurveyException {
  CompanyNotFoundException() : super('Incorrect Assessment link. Survey', 'Invalid Company');
}

class NoActiveSurveyException extends SurveyException {
  NoActiveSurveyException() : super('Incorrect Assessment link. Token', 'No Active Survey');
}

class InvalidSurveyTokenException extends SurveyException {
  InvalidSurveyTokenException() : super('Incorrect Assessment link. Token', 'Invalid Survey Token');
}

class InvalidTokensException extends SurveyException {
  InvalidTokensException() : super('Incorrect Assessment link.', 'Result Doc does not exist');
}

class SurveyAlreadyCompletedException extends SurveyException {
  SurveyAlreadyCompletedException() : super('Oops, This survey has already been completed', 'Survey Completed');
}
