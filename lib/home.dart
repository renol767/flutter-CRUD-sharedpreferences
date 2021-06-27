import 'package:flutter/material.dart';
import 'data.dart';
import 'insert.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // data customer yang akan ditampilkan di list view
  // beri nilai awal berupa list kosong agar tidak error
  // nantinya akan diisi data dari Shared Preferences
  var savedData = [];

  // method untuk mengambil data Shared Preferences
  getSavedData() async {
    var data = await Data.getData();
    // setelah data didapat panggil setState agar data segera dirender
    setState(() {
      savedData = data;
    });
  }

  // init state ini dipanggil pertama kali oleh flutter
  @override
  initState() {
    super.initState();
    // baca Shared Preferences
    getSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Catatan Utang'),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                // action tombol ADD untuk proses insert
                // nilai yang dikirim diisi null
                // agar di halaman insert tahu jika null berarti operasi insert data
                // jika tidak null maka update data
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Insert(index: null, value: null))).then((value) {
                  // jika halaman insert ditutup ambil kembali Shared Preferences
                  // untuk mendapatkan data terbaru dan segera ditampilkan ke user
                  // misal jika ada data customer yang ditambahkan
                  getSavedData();
                });
              },
              child: Text(
                'TAMBAH',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: ListView.builder(
              itemCount: savedData.length,
              itemBuilder: (context, index) {
                return Align(
                    child: GestureDetector(
                  onTap: () {
                    // aksi saat user klik pada item customer pada list view
                    // nilai diisi selain null menandakan di halaman insert operasi yang berjalan adalah update atau delete
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Insert(
                                index: index,
                                value: savedData[index]))).then((value) {
                      // jika halaman insert ditutup ambil kembali Shared Preferences
                      // untuk mendapatkan data terbaru dan segera ditampilkan ke user
                      // misal jika ada data customer yang diedit atau dihapus
                      getSavedData();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 15),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 3,
                              blurRadius: 15,
                              color: Colors.black12)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          savedData[index]['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(savedData[index]['address']),
                        Text(savedData[index]['phone']),
                        Text(
                            NumberFormat.currency(
                                    symbol: "RP. ",
                                    decimalDigits: 0,
                                    locale: "id-ID")
                                .format(int.parse(savedData[index]['hutang'])),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ));
                // return ListTile(
                //   title: Text(savedData[index]['name']),
                //   subtitle: Text(savedData[index]['address'] +
                //       ' ' +
                //       savedData[index]['phone'] +
                //       ' ' +
                //       savedData[index]['hutang']),
                //   contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                //   onTap: () {
                //     // aksi saat user klik pada item customer pada list view
                //     // nilai diisi selain null menandakan di halaman insert operasi yang berjalan adalah update atau delete
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => Insert(
                //                 index: index,
                //                 value: savedData[index]))).then((value) {
                //       // jika halaman insert ditutup ambil kembali Shared Preferences
                //       // untuk mendapatkan data terbaru dan segera ditampilkan ke user
                //       // misal jika ada data customer yang diedit atau dihapus
                //       getSavedData();
                //     });
                //   },
                // );
              }),
        ));
  }
}
