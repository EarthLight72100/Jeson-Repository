import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SmartText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;
  final int maxLines;

  const SmartText({
    Key? key,
    required this.text,
    this.textStyle,
    this.linkStyle,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the regular expression to match URLs
    final RegExp linkRegExp =
        RegExp(r'\bhttps?:\/\/\S+\b', caseSensitive: false);

    // Split the text into parts
    List<InlineSpan> spanList = [];
    int start = 0;

    // Find all the matches for URLs in the text
    for (final Match match in linkRegExp.allMatches(text)) {
      final String beforeLink = text.substring(start, match.start);
      final String linkText = match.group(0)!;

      // Add non-link text
      if (beforeLink.isNotEmpty) {
        spanList.add(TextSpan(text: beforeLink, style: textStyle));
      }

      // Add link text
      spanList.add(TextSpan(
        text: linkText,
        style: linkStyle ?? textStyle?.copyWith(color: Colors.blue),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _launchURL(linkText);
          },
      ));

      start = match.end;
    }

    // Add any remaining text that isn't a link
    if (start < text.length) {
      spanList.add(
          TextSpan(text: text.substring(start, text.length), style: textStyle));
    }

    return RichText(
      maxLines: maxLines,
      text: TextSpan(
        style: textStyle,
        children: spanList,
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
    } else {
      throw 'Could not launch $url';
    }
  }
}
