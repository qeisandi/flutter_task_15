import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:futsal_56/project_15/Helper/model/model_get.dart';
import 'package:futsal_56/project_15/Helper/prefrs/pref_api.dart';
import 'package:futsal_56/project_15/Helper/servis/main_servis.dart';
import 'package:futsal_56/project_15/login_regis/login.dart';
import 'package:futsal_56/project_15/main/detail.dart';
import 'package:futsal_56/project_15/main/my_booking.dart';
import 'package:futsal_56/project_15/main/profile.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "/home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserServis userServis = UserServis();
  late Future<List<GetL>> _futureLapangan;
  final TextEditingController _searchController = TextEditingController();
  String searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _futureLapangan = userServis.getLapangan();
  }

  Future<void> refreshData() async {
    setState(() {
      _futureLapangan = userServis.getLapangan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff2F5249),
        centerTitle: true,
        title:  Text(
          'Home',
          style: TextStyle(
            fontFamily: 'Gilroy',
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            icon:  Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text("Fitur Settings belum tersedia")),
              );
            },
          ),
          IconButton(
            icon:  Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration:  BoxDecoration(color: Color(0xff2F5249)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 36, color: Color(0xff2F5249)),
                  ),
                   SizedBox(height: 12),
                   Text(
                    'Selamat Datang!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   Text(
                    'Pengguna Futsal',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading:  Icon(Icons.home, color: Colors.black87),
              title:  Text('Home', style: TextStyle(fontFamily: 'Gilroy')),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading:  Icon(Icons.person, color: Colors.black87),
              title:  Text('Profile', style: TextStyle(fontFamily: 'Gilroy')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => Profile()));
              },
            ),
            ListTile(
              leading:  Icon(Icons.history, color: Colors.black87),
              title:  Text('My Bookings', style: TextStyle(fontFamily: 'Gilroy')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => MyBookingsPage()));
              },
            ),
             Divider(thickness: 1),
            ListTile(
              leading:  Icon(Icons.settings, color: Colors.black87),
              title:  Text('Pengaturan', style: TextStyle(fontFamily: 'Gilroy')),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text("Fitur Settings belum tersedia")),
                );
              },
            ),
            ListTile(
              leading:  Icon(Icons.logout, color: Colors.red),
              title:  Text('Logout',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontFamily: 'Gilroy')),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title:  Text('Apakah anda yakin ingin\nlogout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Tidak"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await SharedPref.removeToken();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                            (route) => false,
                          );
                        },
                        child:  Text("Iya", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
             Spacer(),
             Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Center(
                child: Text(
                  'Futsal 56 © 2025',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),

      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.85,
                  aspectRatio: 16 / 9,
                  autoPlayInterval:  Duration(seconds: 3),
                ),
                items: [
                  'assets/image/banner1.jpg',
                  'assets/image/banner5.jpg',
                  'assets/image/banner6.jpg',
                  'assets/image/banner4.jpg',
                  'assets/image/banner7.jpg',
                ].map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
               SizedBox(height: 16),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      searchKeyword = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari nama lapangan...',
                    prefixIcon:  Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding:  EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
               SizedBox(height: 16),
              FutureBuilder<List<GetL>>(
                future: _futureLapangan,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _emptyWidget("Tidak ada lapangan");
                  }

                  final lapanganList = snapshot.data!
                      .where((lap) => lap.name?.toLowerCase().contains(searchKeyword) ?? false)
                      .toList();

                  if (lapanganList.isEmpty) {
                    return _emptyWidget("Lapangan tidak ditemukan");
                  }

                  return Padding(
                    padding:  EdgeInsets.all(12),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics:  NeverScrollableScrollPhysics(),
                      itemCount: lapanganList.length,
                      itemBuilder: (context, index) {
                        final lapangan = lapanganList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => DetailLapanganPage(lapangan: lapangan)),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin:  EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Padding(
                                  padding:  EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: lapangan.imageUrl != null
                                        ? Image.network(
                                            lapangan.imageUrl!,
                                            height: 120,
                                            width: 90,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                 Icon(Icons.broken_image, size: 90),
                                          )
                                        : Container(
                                            height: 120,
                                            width: 90,
                                            color: Colors.grey[300],
                                            child:  Icon(Icons.image, size: 40),
                                          ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lapangan.name ?? 'Tanpa Nama',
                                          style:  TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                         SizedBox(height: 4),
                                        Text(
                                          'Rp ${lapangan.pricePerHour ?? '-'} / jam',
                                          style:  TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyWidget(String message) {
    return Center(
      child: Padding(
        padding:  EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
             Icon(Icons.hourglass_empty_outlined, size: 64, color: Colors.grey),
             SizedBox(height: 8),
            Text(
              message,
              style:  TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
