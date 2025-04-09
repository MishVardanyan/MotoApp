import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_mapkit_demo/data/models/news_model.dart';
import 'package:yandex_mapkit_demo/data/repositories/news_repo.dart';
import 'package:yandex_mapkit_demo/presentation/navigation/bottom_nav_bar.dart';

class NewsScreen extends StatefulWidget {
     final VoidCallback? onBack;

  const NewsScreen({Key? key, this.onBack}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NewsScreen();
}

class _NewsScreen extends State<NewsScreen> {
  List<NewsModel>? newsList;
  bool isLoading = true;

  void getNews() async {
    final data = await fetchNews();
    setState(() {
      newsList = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF3D34C),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8),
                  Text(
                    "НОВОСТИ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    " И СТАТЬИ",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Magistral",
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : newsList == null || newsList!.isEmpty
                        ? Center(child: Text('Նորություններ չեն գտնվել։'))
                        : ListView.builder(
                            itemCount: newsList!.length,
                            itemBuilder: (context, index) {
                              final news = newsList![index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        spreadRadius: 2,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (news.image.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(25),
                                            topLeft: Radius.circular(25),
                                          ),
                                          child: Image.network(
                                            news.image,
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              news.label,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              news.date,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              news.text,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}