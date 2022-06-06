import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sqlite.dart';
import 'globals.dart' as globals;

const darkBlueColor = Color(0xff486579);

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: MyDrawerPage(),
    );
  }
}

class MyDrawerPage extends StatefulWidget {
  const MyDrawerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyDrawerPageState();
}

class _MyDrawerPageState extends State<MyDrawerPage> {
  List<Map<String, dynamic>> _cities = [];
  final _formKey = GlobalKey<FormState>();
  final _cityNameController = TextEditingController();

  void _refresh() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _cities = data.cast<Map<String, dynamic>>();
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh(); // Loading the diary when the app starts
  }

  Future<void> _addCity(String name) async {
    var response = await SQLHelper.checkItem(_cityNameController.text);
    if (response.isEmpty) {
      await SQLHelper.createItem(name);
      _refresh();
    }
  }

  Future<void> _deleteCity(int id) async {
    await SQLHelper.deleteItem(id);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.red,
              leading: const Icon(Icons.location_city),
              title: const Text('Mes villes'),
            ),
            _form(),
            _list(),
            _background()
          ],
        ),
      ),
    );
  }

  _list() => (Expanded(
      child: Center(
          child: SizedBox(
              height: 540,
              child: SingleChildScrollView(
                  child: ListView.builder(
                itemCount: _cities.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      _cities[index]['name'],
                      style: GoogleFonts.vt323(fontSize: 23),
                    ),
                    onTap: () {
                      globals.cityGlobal.text = _cities[index]['name'];
                      globals.toRefresh = true;
                      globals.toRefresh == false;
                      Navigator.pop(context);
                    },
                    trailing: IconButton(
                        icon: const Icon(Icons.delete_forever_rounded),
                        color: Colors.red,
                        onPressed: () {
                          _deleteCity(_cities[index]['id']);
                          _refresh();
                        }),
                  );
                },
              ))))));

  _form() => Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextField(
                  controller: _cityNameController,
                  decoration: const InputDecoration(
                    labelText: 'Ajouter une ville',
                    labelStyle: TextStyle(color: Colors.red),
                    hintText: 'Entrer la ville',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                  ),
                  textAlign: TextAlign.center,
                  cursorColor: Colors.red),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_checkempty()) {
                      _addCity(_cityNameController.text);
                      _refresh();
                    }
                  },
                  child: const Text('Ajouter'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  _background() => Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
          height: 248,
          width: double.maxFinite,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/list.png'),
                  fit: BoxFit.cover))));

  bool _checkempty() {
    if (_cityNameController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
