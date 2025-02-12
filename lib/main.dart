import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: ThemeData.dark(),
      home: const NewsScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> articles = [];
  String category = 'business';

  final List<Map<String, dynamic>> categories = [
    {'name': 'Business', 'icon': FontAwesomeIcons.briefcase},
    {'name': 'Sports', 'icon': FontAwesomeIcons.football},
    {'name': 'Science', 'icon': FontAwesomeIcons.flask},
    {'name': 'Technology', 'icon': FontAwesomeIcons.microchip},
    {'name': 'Health', 'icon': FontAwesomeIcons.heartPulse},
  ];

  @override
  void initState() {
    super.initState();
    fetchNewsData();
  }

  Future<void> fetchNewsData() async {
    final url = 'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=aa96022d386e44dc8dfedbc88789678d';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        articles = data['articles'];
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Headlines USA')),
      body: articles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                article['urlToImage'] != null
                    ? Image.network(article['urlToImage'], height: 200, width: double.infinity, fit: BoxFit.cover)
                    : Container(height: 200, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    article['title'] ?? 'No Title',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white,
        items: categories
            .map((cat) => BottomNavigationBarItem(
          icon: Icon(cat['icon']),
          label: cat['name'],
        ))
            .toList(),
        currentIndex: categories.indexWhere((cat) => cat['name'].toLowerCase() == category),
        onTap: (index) {
          setState(() {
            category = categories[index]['name'].toLowerCase();
            fetchNewsData();
          });
        },
      ),
    );
  }
}
