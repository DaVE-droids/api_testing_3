
import 'package:api_testing_3/pages/countries_page.dart';
import 'package:flutter/material.dart';
class MyDrawer extends StatelessWidget {
  final Function(String)?
  onCountrySelected;
  const MyDrawer({super.key, this.onCountrySelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.grey,
        child: ListView(
          padding: const EdgeInsets.all(1),
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black12,
                ),
                child:
                 Text('AFRICA')
            ),
            ListTile(
              leading: Icon(Icons.flag, size: 40,),
              title: const Text('Countries',),
              titleTextStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 20
              ),
              onTap: () async{
                Navigator.pop(context,);
                final onMenuTapped = await Navigator.push(context, MaterialPageRoute(builder: (context) => CountryPage()));
                if (onMenuTapped != null && onCountrySelected!= null) {
                  print('I selected: $onMenuTapped');
                  onCountrySelected!(onMenuTapped);

                }
              }
            )
          ],
        )
    );
  }
}