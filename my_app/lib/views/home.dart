import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/model/categories_model.dart';
import 'package:my_app/model/wallpaper_model.dart';
import 'package:my_app/package/data.dart';
import 'package:my_app/views/categories.dart';
import 'package:my_app/views/image_view.dart';
import 'package:my_app/views/search.dart';
import 'package:my_app/widgets/widget.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoriesModel> categories = new List();
  List<WallpaperModel> wallpapers = new List();

  TextEditingController searchController = new TextEditingController();

  getTrendingWallpapers() async{

    var response = await http.get("https://api.pexels.com/v1/curated?per_page=15", 
    headers:{
      "Authorization" : apiKey
    });

    Map<String,dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element){

      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {
      
    });
  }

  @override
  void initState() {
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
        centerTitle: true,
        ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
          children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Row(children: <Widget>[
                    Expanded(child:
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "search",
                        border: InputBorder.none
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Search(
                        searchQuery: searchController.text,
                      )
                    ));
                  },
                  child: Container(
                    child: Icon(Icons.search)
                    ),
                )
              ],),
            ),

        SizedBox(height: 16,
        ),
          Container(
            height: 80,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 25),
              itemCount: categories.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index){
                return CategoriesTitle(
                  title: categories[index].categoriesName,
                  imgUrl: categories[index].imgUrl,
                );
              }),
          ),
           wallpaperList(wallpapers, context)

        ],),),
      ),
    );
  }
}

class CategoriesTitle extends StatelessWidget {

  final String imgUrl, title;
  CategoriesTitle({@required this.title, @required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Categories(
            categoryName: title.toLowerCase(),
           )
          ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 5),
        child: Stack(
         children: <Widget>[
          GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8) ,
                child: Image.network(imgUrl, height: 50, width: 100, fit: BoxFit.cover)
                ),
            ),
          Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8)
            ),
            height: 50,
            width: 100,
            alignment: Alignment.center,
            child: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),),
            )  
        ],),
      ),
    );
  }
}
