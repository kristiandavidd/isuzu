import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isuzu/services/crud.dart';
import 'package:isuzu/ui/shared/theme.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kategori Service'),
          bottom: TabBar(
            indicatorColor: isuzu500,
            labelColor: isuzu500,
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            tabs: const [
              Tab(text: 'Pengecekan Oli'),
              Tab(text: 'Pengecekan Sparepart'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildCategoryList('Pengecekan Oli'),
            buildCategoryList('Pengecekan Sparepart'),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryList(String categoryTitle) {
    Future<List<dynamic>> fetchData;
    if (categoryTitle == 'Pengecekan Oli') {
      fetchData = fetchOilData();
    } else {
      fetchData = fetchSparepartData();
    }

    return FutureBuilder<List<dynamic>>(
      future: fetchData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<dynamic> data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final name = data[index]['name'];
              final phone = data[index]['phone'];
              final lastService = data[index]['last_service'];
              String lastServiceText;

              if (lastService != null && lastService != '2000-01-01 00:00:00') {
                lastServiceText = DateFormat('d MMM yyyy')
                    .format(DateTime.parse(lastService));
              } else {
                lastServiceText = 'Belum pernah service.';
              }

              return ListTile(
                title: Text(
                  name.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
                subtitle:
                    Text(lastServiceText, style: const TextStyle(fontSize: 16)),
                trailing: ElevatedButton(
                  onPressed: () {
                    launchWhatsAppUri(name, phone, lastServiceText);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isuzu500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  child: const Text('Chat',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              );
            },
          );
        }
      },
    );
  }
}
