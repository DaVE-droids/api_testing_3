import 'package:api_testing_3/pages/homepage.dart';
import 'package:api_testing_3/pages/models/country_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class CountryPage extends StatefulWidget{
  const CountryPage({super.key});
  @override
  State<CountryPage> createState() => _CountryPageState();
}
class _CountryPageState extends State <CountryPage> {
  List <String> countriesList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAfricanCountries();
    });
  }
  Future <List<String>> fetchAfricanCountries() async {
    print('eba');
    const url = 'https://api.first.org/data/v1/countries';

    try {
      print('garri');
      final response = await http.get(Uri.parse(url));
      print('fufu');
      if (response.statusCode == 200) {
     Countries countries = Countries.fromRawJson(response.body);
     List <String> countryNames = countries.data!.values.map((datum){
       return datum.country!.replaceAll('(the)', '').replaceAll('(the Democratic Republic of the)', '').replaceAll(', the United Republic of', '').replaceAll('*', '').replaceAll('(the Democratic Republic of)', '')..replaceAll("(the Democratic People's Republic of)", '').replaceAll('(the Republic of)', '').replaceAll('(Province of China)', '');
     }).toList();
     setState(() {
       isLoading = false;
       countriesList = countryNames;
       errorMessage = null;

     });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error ${response.statusCode}';
          print('error fetching data');
        });
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to load Countries $e';
    }throw Exception('can not load countries');
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                opacity: 0.6,
                  image: AssetImage('assets/images/background.jpg',),
                fit: BoxFit.fill
              )
            ),
            child: isLoading
                  ?const Center(
            child: CircularProgressIndicator(),
                  )
              : errorMessage!=null
              ? Center(
                  child: Text(errorMessage!),
                  )
              :ListView.builder(
              itemCount: countriesList.length,
              itemBuilder: (context, index){
                final allCountries = countriesList[index];
                return ListTile(
                  titleTextStyle:
                  TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,

                  ),
                  textColor: Colors.black,
              leading: const Icon(Icons.flag, color: Colors.red,),
              title: Text(allCountries, selectionColor: Colors.yellow,),
                  onTap: (){
                Navigator.pop(context, allCountries);
                print('Code is working');
                  },
              );
              }
              ),
          ),
        )
      );
  }

}