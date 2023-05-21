import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'search_photos.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<dynamic> _photos = [];
  int _page = 1;
  ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchPhotos();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMorePhotos();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchPhotos() async {
    final apiKey = 'Lvt62n1uYtlMDMANQskZs3hM4eEPk3DZgPy6UCcnqbySbf6ztfZxEQSc';
    final perPage = 40;
    final url = Uri.parse(
      'https://api.pexels.com/v1/curated?per_page=$perPage&page=$_page',
    );
    final response = await http.get(
      url,
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _photos.addAll(data['photos']);
      });
    } else {
      print('Failed to fetch photos');
    }
  }

  Future<void> _loadMorePhotos() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    setState(() {
      _page++;
    });
    await _fetchPhotos();

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final crossAxisCount = isMobile ? 2 : 4;
    final aspectRatio = isMobile ? 1.0 : 1.5;

    return Scaffold(
      backgroundColor: Color(0xFF3C2A21),
      body: Stack(
        children: [
          GridView.builder(
            padding: EdgeInsets.all(isMobile ? 4.0 : 10.0),
            controller: _scrollController,
            itemCount: _photos.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: isMobile ? 4.0 : 10.0,
              mainAxisSpacing: isMobile ? 4.0 : 10.0,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) {
              final photo = _photos[index];
              final photographer = photo['photographer'];
              final imageUrl = photo['src']['medium'];
              final photoUrl = photo['src']['large2x'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImagePage(
                        imageUrl: photoUrl,
                        photographer: photographer,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Color(0xffE5E5CB),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isMobile ? 8.0 : 12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(isMobile ? 6.0 : 8.0),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(isMobile ? 6.0 : 8.0),
                        child: Text(
                          '$photographer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_isLoadingMore)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(isMobile ? 10.0 : 16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
