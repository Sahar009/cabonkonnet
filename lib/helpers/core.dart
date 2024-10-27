String getUserTitle(String value) {
  return value == "product_owner"
      ? "Founder"
      : value == "investor"
          ? "Investor"
          : "";
}

extension HashtagExtractor on String {
  List<String> extractHashtags() {
    // Regular expression to match hashtags
    final RegExp hashtagRegExp = RegExp(r'#\w+');

    // Find all matches in the string
    final matches = hashtagRegExp.allMatches(this);

    // Extract the matched hashtags and convert them to a list
    return matches.map((match) => match.group(0)!).toList();
  }
}

extension ListToString on List<String> {
  /// Converts the list of strings to a single string with an optional separator.
  String toSingleString({String separator = ', '}) {
    return this.join(separator);
  }
}
