import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recovery/data/models/quote.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class QuoteData extends StatefulWidget {
  @override
  _QuoteDataState createState() => _QuoteDataState();
}

// call the API and fetch the response
Future<Quote> fetchQuote() async {
  final response = await http.get('https://favqs.com/api/qotd');
  if (response.statusCode == 200) {
    return Quote.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Quote');
  }
}

class _QuoteDataState extends State<QuoteData>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<Quote> quote;
  var dbHelper;
  Future<List<Quote>> wholeQuotes;
  @override
  void initState() {
    super.initState();
    quote = fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<Quote>(
      future: quote,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(
                    snapshot.data.quoteText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontFamily: 'quoteScript'),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  '~ ${snapshot.data.quoteAuthor} ~',
                  style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.black,
                      fontFamily: 'quoteScript'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        Share.share(
                            '${snapshot.data.quoteText}--${snapshot.data.quoteAuthor}');
                      },
                    ),
                    IconButton(
                      icon: Image.asset('assets/images/fb.png'),
                      onPressed: () {
                        _launchURL(
                            "https://www.facebook.com/camileonit.ididit/");
                      },
                    ),
                    IconButton(
                      icon: Image.asset('assets/images/insta.png'),
                      onPressed: () {
                        _launchURL(
                            "https://www.instagram.com/ididit.official/");
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
