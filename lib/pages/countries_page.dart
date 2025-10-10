import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class CountryPage extends StatefulWidget{
  const CountryPage({super.key});
  @override
  State<CountryPage> createState() => _CountryPageState();
}
class _CountryPageState extends State <CountryPage> {
  List <String> countries = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAfricanCountries();
  }

  Future<void> fetchAfricanCountries() async {
    const url = 'http://worldtimeapi.org/api/timezone/Africa';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<String> newName = data.map((item) {
          final n = item.toString();
          return n.replaceFirst('Africa', '');
        }).toList();
        setState(() {
          isLoading = false;
          errorMessage = null;
          countries = newName;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error ${response.statusCode}';
        });
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to load Countries $e';
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
      ?const Center(
        child: CircularProgressIndicator(),
      )
  : errorMessage!=null
  ? Center(
      child: Text(errorMessage!),
      )
  :ListView.builder(
  itemCount: countries.length,
  itemBuilder: (context, index){
    final name = countries[index];
    return ListTile(
  leading: const Icon(Icons.flag),
  title: Text(name),
      onTap: (){
    Navigator.pop(context, name);
      },
  );
  }
  )
      );
  }

}