import 'package:flutter/material.dart';
import 'package:my_app/model/wallpaper_model.dart';
import 'package:my_app/views/image_view.dart';

Widget brandName(){
  return RichText(
    text: TextSpan(
    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
    children: <TextSpan>[
      TextSpan(text: 'Wallpaper', style: TextStyle(color: Colors.black87)),
      TextSpan(text: 'App', style: TextStyle(color: Colors.orange)),
     ],
   ),
 );
}

Widget wallpaperList(List<WallpaperModel> wallpapers, context){
  return Container(
    padding: EdgeInsets.symmetric(horizontal:16),
    child: GridView.count(
    shrinkWrap: true,
    physics: ClampingScrollPhysics(),
    crossAxisCount: 2,
    childAspectRatio: 0.6,
    mainAxisSpacing: 6.0 ,
    crossAxisSpacing: 6.0,
    children: wallpapers.map((wallpaper){
        return GridTile(
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ImageView(
                  ImgUrl: wallpaper.src.portrait,
                )
                ));
            },
            child: Hero(
              tag: wallpaper.src.portrait,
              child: Container(
                child: ClipRRect (
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(wallpaper.src.portrait, fit: BoxFit.cover)),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}