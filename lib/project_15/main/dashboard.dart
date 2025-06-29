import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_15/project_15/Helper/api.dart';
import 'package:flutter_task_15/project_15/Helper/model/model_get.dart';
import 'package:flutter_task_15/project_15/Helper/prefrs/pref_api.dart';
import 'package:flutter_task_15/project_15/login_regis/login.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "/home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserServis userServis = UserServis();
  late Future<List<GetL>> _futureLapangan;
  TextEditingController _searchController = TextEditingController();
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

  void _showUpdateDialog(GetL lapangan) {
    final TextEditingController nameController = TextEditingController(text: lapangan.name);
    final TextEditingController priceController = TextEditingController(text: lapangan.pricePerHour?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Edit Lapangan', style: TextStyle(fontFamily: 'Gilroy')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lapangan',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Harga per Jam',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff039EFD),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
             onPressed: () async {
  try {
    await userServis.updateProfile(
      name: nameController.text,
      price: int.tryParse(priceController.text) ?? 0,
    );
    Navigator.pop(context);
    refreshData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Lapangan berhasil diperbarui")),
    );
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal update: $e")),
    );
  }
},

              child: Text('Simpan',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
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
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Image.asset('assets/image/logo2.png', scale: 5),
                  SizedBox(height: 24),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Profile'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Apakah anda yakin ingin\nlogout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Tidak", style: TextStyle(color: Color(0xff039EFD))),
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
                              child: Text("Iya", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                items: [
                  'assets/image/banner1.jpg',
                  'assets/image/banner2.jpg',
                  'assets/image/banner3.jpg',
                  'assets/image/banner4.jpg',
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
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(fontSize: 24, fontFamily: 'Gilroy'),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Lapangan tidak ditemukan"));
                  }

                  final lapanganList = snapshot.data!
                      .where((lap) => lap.name?.toLowerCase().contains(searchKeyword) ?? false)
                      .toList();

                  if (lapanganList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
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
                        return Card(
                          color: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                          child: Icon(Icons.image, size: 40),
                                        ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lapangan.name ?? 'Tanpa Nama',
                                        style: const TextStyle(
                                          fontFamily: 'Gilroy',
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4),
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
                              IconButton(
                                icon: Icon(Icons.edit, color: Color(0xff039EFD)),
                                onPressed: () => _showUpdateDialog(lapangan),
                              ),
                            ],
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
}
