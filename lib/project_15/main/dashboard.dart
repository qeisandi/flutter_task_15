import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:futsal_56/project_15/Helper/model/model_get.dart';
import 'package:futsal_56/project_15/Helper/prefrs/pref_api.dart';
import 'package:futsal_56/project_15/Helper/servis/main_servis.dart';
import 'package:futsal_56/project_15/login_regis/login.dart';
import 'package:futsal_56/project_15/main/detail.dart';
import 'package:futsal_56/project_15/main/my_booking.dart';

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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff039EFD),
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(
            fontFamily: 'Gilroy',
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset('assets/image/logo2.png', scale: 5),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Apakah anda yakin ingin\nlogout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Tidak",
                              style: TextStyle(color: Color(0xff039EFD)),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await SharedPref.removeToken();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              "Iya",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );
              },
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage('assets/image/profile.jpg'),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                        Text(
                          'user@email.com',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.85,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: Duration(seconds: 3),
                ),
                items:
                    [
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
              Center(
                child: Column(
                  children: const [
                    Text(
                      'WELCOME!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Mau main futsal dimana hari ini?\natau punya bookingan lapangan',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      searchKeyword = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari nama lapangan...',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: EdgeInsets.symmetric(
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
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Lapangan tidak ditemukan"));
                  }

                  final lapanganList =
                      snapshot.data!
                          .where(
                            (lap) =>
                                lap.name?.toLowerCase().contains(
                                  searchKeyword,
                                ) ??
                                false,
                          )
                          .toList();

                  if (lapanganList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Tidak ada lapangan yang dicari."),
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.all(12),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: lapanganList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final lapangan = lapanganList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        DetailLapanganPage(lapangan: lapangan),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child:
                                        lapangan.imageUrl != null
                                            ? Image.network(
                                              lapangan.imageUrl!,
                                              height: 120,
                                              width: 90,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Icon(
                                                    Icons.broken_image,
                                                    size: 90,
                                                  ),
                                            )
                                            : Container(
                                              height: 120,
                                              width: 90,
                                              color: Colors.grey[300],
                                              child: Icon(
                                                Icons.image,
                                                size: 40,
                                              ),
                                            ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lapangan.name ?? 'Tanpa Nama',
                                          style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Rp ${lapangan.pricePerHour ?? '-'} / jam',
                                          style: const TextStyle(
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

      // === FAB DITAMBAHKAN DI SINI ===
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyBookingsPage()),
          );
        },
        backgroundColor: Color(0xff039EFD),
        label: const Text(
          'MY BOOKINGS',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        icon: const Icon(Icons.schedule, color: Colors.white),
      ),
    );
  }
}
