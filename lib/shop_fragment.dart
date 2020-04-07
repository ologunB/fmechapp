import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mechapp/each_product.dart';
import 'package:mechapp/utils/my_models.dart';
import 'package:mechapp/utils/type_constants.dart';

import 'main_cart.dart';

class ShopF extends StatefulWidget {
  @override
  _ShopFState createState() => _ShopFState();
}

class _ShopFState extends State<ShopF> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<ShopItem> list = [];

  Future<List<ShopItem>> _getItems() async {
    DatabaseReference dataRef =
        FirebaseDatabase.instance.reference().child("Shop Collection");

    await dataRef.once().then((snapshot) {
      var KEYS = snapshot.value.keys;
      Map DATA = snapshot.value;

      list.clear();
      for (var index in KEYS) {
        for (var index2 in DATA[index].keys) {
          String tempName = DATA[index][index2]['shop_item_name'];
          String tempPrice = DATA[index][index2]['shop_item_price'].toString();
          String tempSeller = DATA[index][index2]['shop_item_seller'];
          String tempEmail = DATA[index][index2]['shop_item_email'];
          String tempNumber = DATA[index][index2]['shop_item_phoneNo'];
          String tempDescript = DATA[index][index2]['shop_item_descrpt'];
          List tempImage = DATA[index][index2]['shop_item_images'];
          String tempID = DATA[index][index2]['shop_item_ID'];
          list.add(ShopItem(
              name: tempName,
              price: tempPrice,
              soldBy: tempSeller,
              images: tempImage,
              desc: tempDescript,
              email: tempEmail,
              number: tempNumber,
              itemID: tempID));
        }
      }
    });
    return list;
  }

  Widget _buildFutureBuilder() {
    return Center(
      child: FutureBuilder<List<ShopItem>>(
        future: _getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return list.length == 0
                ? emptyList("Shop Item")
                : Container(
                    color: Color(0xb090A1AE),
                    height: MediaQuery.of(context).size.height,
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => EachProduct(
                                  shopItem: list[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: CachedNetworkImage(
                                      imageUrl: list[index].images[0],
                                      height: 100,
                                      width: 100,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                  Text(
                                    list[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.deepPurple),
                                  ),
                                  Text(
                                    "\₦ " + list[index].price,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Sold By: ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    list[index].soldBy,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: .75),
                    ),
                  );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Color(0xb090A1AE),
        child: _buildFutureBuilder(),
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            color: primaryColor, borderRadius: BorderRadius.circular(30.0)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) {
                  return MainCart();
                },
              ),
            );
          },
          child: Icon(
            Icons.shopping_cart,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ShopContainer extends StatefulWidget {
  @override
  _ShopContainerState createState() => _ShopContainerState();
}

class _ShopContainerState extends State<ShopContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: primaryColor),
          backgroundColor: primaryColor,
          elevation: 0.0,
          title: TabBar(
              isScrollable: true,
              unselectedLabelColor: primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    primaryColor,
                    Colors.deepPurple,
                    Colors.blueAccent,
                  ]),
                  borderRadius: BorderRadius.circular(50),
                  color: primaryColor),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Tools",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Parts",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
              ]),
          centerTitle: true,
        ),
        floatingActionButton: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(30.0)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) {
                    return MainCart();
                  },
                ),
              );
            },
            child: Icon(
              Icons.shopping_cart,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: TabBarView(children: [ShopToolsFrag(), ShopPartsFrag()]),
        ),
      ),
    );
  }
}

class ShopToolsFrag extends StatefulWidget {
  @override
  _ShopToolsFragState createState() => _ShopToolsFragState();
}

class _ShopToolsFragState extends State<ShopToolsFrag>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Color(0xb090A1AE),
      child: _buildFutureBuilder("Tool"),
    );
  }
}

List<ShopItem> list = List();

Future<List<ShopItem>> _getItems(String type) async {
  DatabaseReference dataRef =
      FirebaseDatabase.instance.reference().child("Shop Collection");

  await dataRef.once().then((snapshot) {
    var kEYS = snapshot.value.keys;
    Map dATA = snapshot.value;

    list.clear();
    for (var index in kEYS) {
      for (var index2 in dATA[index].keys) {
        String tempName = dATA[index][index2]['shop_item_name'];
        String tempPrice = dATA[index][index2]['shop_item_price'].toString();
        String tempSeller = dATA[index][index2]['shop_item_seller'];
        String tempEmail = dATA[index][index2]['shop_item_email'];
        String tempNumber = dATA[index][index2]['shop_item_phoneNo'];
        String tempDescript = dATA[index][index2]['shop_item_descrpt'];
        List tempImage = dATA[index][index2]['shop_item_images'];
        String tempID = dATA[index][index2]['shop_item_ID'];
        String tempType = dATA[index][index2]['shop_item_type'];
        if (tempType == type) {
          list.add(ShopItem(
              name: tempName,
              price: tempPrice,
              soldBy: tempSeller,
              images: tempImage,
              desc: tempDescript,
              email: tempEmail,
              number: tempNumber,
              itemID: tempID));
        }
      }
    }
  });
  return list;
}

Widget _buildFutureBuilder(String type) {
  return Center(
    child: FutureBuilder<List<ShopItem>>(
      future: _getItems(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<ShopItem> myList = List();
          return myList.length == 0
              ? emptyList("Shop Item")
              : Container(
                  color: Color(0xb090A1AE),
                  height: MediaQuery.of(context).size.height,
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: myList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => EachProduct(
                                shopItem: myList[index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: CachedNetworkImage(
                                      imageUrl: myList[index].images[0],
                                      height: 100,
                                      width: 100,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )),
                                Text(myList[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.deepPurple)),
                                Text("\₦ " + myList[index].price,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  "Sold By: ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  myList[index].soldBy,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: .75),
                  ),
                );
        }
        return CircularProgressIndicator();
      },
    ),
  );
}

class ShopPartsFrag extends StatefulWidget {
  @override
  _ShopPartsFragState createState() => _ShopPartsFragState();
}

class _ShopPartsFragState extends State<ShopPartsFrag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Color(0xb090A1AE),
      child: _buildFutureBuilder("Part"),
    );
  }
}
