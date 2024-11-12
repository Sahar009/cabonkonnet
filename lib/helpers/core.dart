
import 'package:timeago/timeago.dart' as timeago;

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
    return join(separator);
  }
}




extension CustomTimeAgo on DateTime {
  String toCustomTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    // If the date is less than or equal to 4 days ago, use 'time ago' format
    if (difference.inDays <= 4) {
      return timeago.format(this);
    }

    // If more than 4 days ago, use specific date formatting
    if (now.year == year) {
      return "$day-$month"; // day-month for same year
    } else {
      return "$day-$month-$year"; // day-month-year for different year
    }
  }
}
