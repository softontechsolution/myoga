import 'package:flutter/material.dart';
import 'package:myoga/utils/themes/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyOgaTheme.lightTheme,
      darkTheme: MyOgaTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("My OGA"),leading: Icon(Icons.ondemand_video_rounded),),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: Icon(Icons.add_shopping_cart_rounded),),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text("Welcome", style: Theme.of(context).textTheme.headline2,),
            Text("My Oga", style: Theme.of(context).textTheme.subtitle1,),
            Text("I'm Available, Send Me", style: Theme.of(context).textTheme.bodyText1,),
            ElevatedButton(onPressed: () {}, child: Text("Book Now"),),
            OutlinedButton(onPressed: () {}, child: Text("Book Later"),),
            Padding(padding: EdgeInsets.all(20.0),
              child: Image(image: AssetImage("assets/images/myogaIcon3.png"),),
            )
          ],
        ),
      ),
    );
  }

}