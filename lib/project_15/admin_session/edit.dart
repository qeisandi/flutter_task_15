import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futsal_56/project_15/Helper/model/model_get.dart';
import 'package:futsal_56/project_15/Helper/servis/main_servis.dart';
import 'package:futsal_56/project_15/admin_session/add.dart';
import 'package:futsal_56/project_15/admin_session/add_sc.dart';
import 'package:futsal_56/project_15/admin_session/detail_dua.dart';
import 'package:futsal_56/project_15/main/profile.dart';
import 'package:futsal_56/project_15/src2/source/circular_menu.dart';
import 'package:futsal_56/project_15/src2/source/circular_menu_item.dart';

class EditScreen extends StatefulWidget {
  static const String id = "/home_screen";
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  UserServis userServis = UserServis();
  late Future<List<GetL>> _futureLapangan;
  final TextEditingController _searchController = TextEditingController();
  String searchKeyword = '';
  String _colorName = 'No';
  Color _color = Colors.black;

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
    final TextEditingController nameController = TextEditingController(
      text: lapangan.name,
    );
    final TextEditingController priceController = TextEditingController(
      text: lapangan.pricePerHour?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              'Edit Lapangan',
              style: TextStyle(fontFamily: 'Gilroy'),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Lapangan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Harga per Jam',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                  backgroundColor: Color(0xff437057),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  try {
                    await userServis.updateLapangan(
                      id: lapangan.id!,
                      name: nameController.text,
                      price: int.tryParse(priceController.text) ?? 0,
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      refreshData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lapangan berhasil diperbarui")),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Gagal update: $e")),
                      );
                    }
                  }
                },
                child: Text('Simpan', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(GetL lapangan) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Hapus Lapangan"),
            content: Text(
              "Apakah Anda yakin ingin menghapus lapangan '${lapangan.name}'?",
            ),
            actions: [
              TextButton(
                child: Text(
                  "Batal",
                  style: TextStyle(color: Color(0xff039EFD)),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Hapus", style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  try {
                    await userServis.deleteLapangan(lapangan.id!);
                    if (mounted) {
                      Navigator.pop(context);
                      refreshData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lapangan berhasil dihapus")),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Gagal menghapus: $e")),
                      );
                    }
                  }
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff2F5249),
        title: Text(
          'Edit Lapangan',
          style: TextStyle(fontFamily: 'Gilroy', color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Fitur Settings belum tersedia")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Tidak ada lapangan",
                              style: TextStyle(
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
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Tidak ada lapangan yang dicari."),
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: lapanganList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.64,
                      ),
                      itemBuilder: (context, index) {
                        final lapangan = lapanganList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DetailLapanganPageDua(
                                      lapangan: lapangan,
                                    ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child:
                                      lapangan.imageUrl != null
                                          ? Image.network(
                                            lapangan.imageUrl!,
                                            height: 100,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                                      Icons.broken_image,
                                                      size: 80,
                                                    ),
                                          )
                                          : Container(
                                            height: 100,
                                            width: double.infinity,
                                            color: Colors.grey[300],
                                            child: Icon(Icons.image, size: 40),
                                          ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    lapangan.name ?? 'Tanpa Nama',
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    'Rp ${lapangan.pricePerHour ?? '-'} / jam',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Color(0xff437057),
                                      ),
                                      onPressed:
                                          () => _showUpdateDialog(lapangan),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          () => _showDeleteDialog(lapangan),
                                    ),
                                  ],
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
      floatingActionButton: CircularMenu(
        alignment: Alignment.bottomRight,
        toggleButtonColor: Color(0xff73946B),
        items: [
          CircularMenuItem(
            icon: Icons.schedule,
            color: Colors.green,
            onTap: () {
              setState(() {
                _color = Colors.green;
                _colorName = 'Green';
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddSc()),
                );
              });
            },
          ),
          CircularMenuItem(
            icon: Icons.add_box,
            color: Colors.blue,
            onTap: () {
              setState(() {
                _color = Colors.blue;
                _colorName = 'Blue';
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Add()),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
