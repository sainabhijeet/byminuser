import 'package:flutter/material.dart';

import '../Widgets/localization_strings.dart';
import '../helpers/shimmer_helper.dart';
import '../my_theme.dart';
import '../repositories/product_repository.dart';
import '../ui_elements/product_card.dart';


class TodaysDealProducts extends StatefulWidget {

  @override
  _TodaysDealProductsState createState() => _TodaysDealProductsState();
}

class _TodaysDealProductsState extends State<TodaysDealProducts> {

  late ScrollController _scrollController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildProductList(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        LocalizationString.TodDeal,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildProductList(context) {
    return FutureBuilder(
        future: ProductRepository().getTodaysDealProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            /*print("product error");
            print(snapshot.error.toString());*/
          return Container();
          } else if (snapshot.hasData) {
            var productResponse = snapshot.data;
            return SingleChildScrollView(
              child: GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: productResponse!.products!.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.618),
                padding: EdgeInsets.all(16),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return ProductCard(
                    id: productResponse.products![index].id!,
                    image: productResponse.products![index].thumbnail_image!,
                    name: productResponse.products![index].name!,
                    price: productResponse.products![index].base_price!,
                  );
                },
              ),
            );
          } else {
            return ShimmerHelper()
                .buildProductGridShimmer(scontroller: _scrollController);
          }
        });
  }

}

