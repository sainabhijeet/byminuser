import 'package:flutter/material.dart';

import '../app_config.dart';
import '../my_theme.dart';
import '../screens/product_details.dart';


class ProductCard extends StatefulWidget {

  int? id;
  String? image;
  String? name;
  String? price;

  ProductCard({Key? key,this.id, this.image, this.name, this.price}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    print((MediaQuery.of(context).size.width - 48 ) / 2);
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(id: widget.id,);
        }));
      },
      child: Card(
         //clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  //height: 158,
                  height: (( MediaQuery.of(context).size.width - 28 ) / 2) + 2,
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16), bottom: Radius.zero),
                      child: 
                      Image.asset('assets/headphone.png')
                      /*FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.foodiesfeed.com%2F&psig=AOvVaw2Gs3wWJ38cLTe4x3VWoJUs&ust=1697879913741000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCOiEldulhIIDFQAAAAAdAAAAABAI",
                        // image: AppConfig.BASE_PATH + widget.image,
                        fit: BoxFit.cover,
                      )*/
                  )),
              Container(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Text(
                        widget.name.toString(),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: Text(
                        widget.price.toString(),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
