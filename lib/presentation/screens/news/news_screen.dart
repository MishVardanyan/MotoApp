import 'package:flutter/material.dart';
import 'package:yandex_mapkit_demo/data/models/news_model.dart';
import 'package:yandex_mapkit_demo/presentation/navigation/bottom_nav_bar.dart';

class NewsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewsScreen();
}

class _NewsScreen extends State<NewsScreen> {
  final List<NewsModel> newsList = [
  NewsModel(
    id: "1a2b3c4d-5678-9101-1121-314151617181",
    title: "Новая модель Ducati",
    content: "Компания Ducati представила новую модель мотоцикла, которая обещает стать революционной в мире двухколесных транспортных средств.",
    imageUrl: "https://dicas.olx.com.br/wp-content/uploads/2024/06/moto-barata.jpg",
    createdAt: "2024-02-01T12:00:00Z",
  ),
  NewsModel(
    id: "2b3c4d5e-6789-1011-1213-415161718192",
    title: "Tesla анонсировала новый Cybertruck",
    content: "Компания Tesla официально представила новую версию Cybertruck с улучшенными характеристиками и повышенной автономностью.",
    imageUrl: "https://dicas.olx.com.br/wp-content/uploads/2024/06/moto-barata.jpg",
    createdAt: "2024-02-10T15:30:00Z",
  ),
  NewsModel(
    id: "3c4d5e6f-7891-0111-1213-516171819203",
    title: "Apple готовит к выпуску iPhone 16",
    content: "Apple планирует представить iPhone 16 с революционными возможностями камеры и новым дизайном.",
    imageUrl: "https://dicas.olx.com.br/wp-content/uploads/2024/06/moto-barata.jpg",
    createdAt: "2024-03-05T09:45:00Z",
  ),
  NewsModel(
    id: "4d5e6f7g-8910-1112-1314-617181920314",
    title: "Samsung представил Galaxy S24 Ultra",
    content: "Samsung анонсировал Galaxy S24 Ultra, который получит инновационные AI-функции и мощный процессор нового поколения.",
    imageUrl: "https://dicas.olx.com.br/wp-content/uploads/2024/06/moto-barata.jpg",
    createdAt: "2024-01-22T18:20:00Z",
  ),
  NewsModel(
    id: "5e6f7g8h-9101-1121-3141-718192031415",
    title: "SpaceX успешно запустил Starship",
    content: "SpaceX провела успешный запуск космического корабля Starship, который станет ключевым элементом будущих миссий на Марс.",
    imageUrl: "https://dicas.olx.com.br/wp-content/uploads/2024/06/moto-barata.jpg",
    createdAt: "2024-04-12T06:10:00Z",
  ),
];


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
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFF333333)),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavScreen()),
                      );
                    },
                  ),
                  SizedBox(width: 8),
                  Text(
                    "НОВОСТИ И СТАТЬИ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                child: ListView.builder(
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25),
                              ),
                              child: Image.network(
                                newsList[index].imageUrl,
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    newsList[index].title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    newsList[index].createdAt,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    newsList[index].content,
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
