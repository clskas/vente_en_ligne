import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/category_products.dart';
import 'package:ecommerce_application/pages/product_detail.dart';
import 'package:ecommerce_application/pages/services/database.dart';
import 'package:ecommerce_application/pages/services/shared_pref.dart';
import 'package:ecommerce_application/pages/widget/widget_support.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool searchproduct = false;

  List categories = [
    "assets/images/headphone_icon.png",
    "assets/images/laptop.png",
    "assets/images/watch.png",
    "assets/images/TV.png",
  ];

  List categoryname = ["Headphones", "Laptop", "Watch", "TV"];

  var queryResultSet = [];
  var tempSearchStore = [];
  TextEditingController searchcontroller = TextEditingController();

  initiateSearch(value) {
    if (value == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      searchproduct = true;
    });

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; i++) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];

      for (var element in queryResultSet) {
        if (element["Updatedname"].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      }
    }
  }

  String? name, image;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hey,${name!}",
                              style: Appwidget.boldTextFieldStyle(),
                            ),
                            Text(
                              "Good Morning",
                              style: Appwidget.lightTextFieldStyle(),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(60.0),
                          child: Image.asset(
                            "assets/images/clskas.jpg",
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    // Search bar
                    Container(
                      padding: EdgeInsets.only(left: 20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: TextField(
                        
                        //controller: searchcontroller,
                        onChanged: (value) {

                          initiateSearch(value.toUpperCase());
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Products",
                          hintStyle: Appwidget.lightTextFieldStyle(),
                          prefixIcon: searchproduct
                              ? GestureDetector(
                                  onTap: () {
                                    searchproduct = false;
                                    tempSearchStore = [];
                                    queryResultSet = [];
                                    searchcontroller.text = "";
                                    setState(() {});
                                  },
                                  child: Icon(Icons.close, color: Colors.red),
                                )
                              : Icon(Icons.search, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    //Partie categorie et See all
                    searchproduct
                        ? ListView(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            primary: false,
                            shrinkWrap: true,
                            children: tempSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList(),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Categories",
                                      style: Appwidget.semiboldTextFieldStyle(),
                                    ),
                                    SizedBox(height: 20.0),
                                    Text(
                                      "See all",
                                      style: TextStyle(
                                        color: Color(0xfffd6f3e),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20.0),
                              Row(
                                children: [
                                  Container(
                                    height: 130,
                                    padding: EdgeInsets.all(20.0),
                                    margin: EdgeInsets.only(right: 20.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xfffd6f3e),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      "All",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 130,
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: categories.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return CategoryTile(
                                            image: categories[index],
                                            name: categoryname[index],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "All Products",
                                    style: Appwidget.semiboldTextFieldStyle(),
                                  ),
                                  SizedBox(height: 20.0),
                                  Text(
                                    "See all",
                                    style: TextStyle(
                                      color: Color(0xfffd6f3e),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              SizedBox(
                                height: 240,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 20.0),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/headphone2.png",
                                            height: 150.0,
                                            width: 150.0,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            "Headphone",
                                            style:
                                                Appwidget.semiboldTextFieldStyle(),
                                          ),
                                          SizedBox(height: 20.0),
                                          Row(
                                            children: [
                                              Text(
                                                "\$100",
                                                style: TextStyle(
                                                  color: Color(0xfffd6f3e),
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 50.0),
                                              Container(
                                                padding: EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xfffd6f3e),
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 20.0),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/watch2.png",
                                            height: 150.0,
                                            width: 150.0,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            "Apple Watch",
                                            style:
                                                Appwidget.semiboldTextFieldStyle(),
                                          ),
                                          SizedBox(height: 20.0),
                                          Row(
                                            children: [
                                              Text(
                                                "\$300",
                                                style: TextStyle(
                                                  color: Color(0xfffd6f3e),
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 50.0),
                                              Container(
                                                padding: EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xfffd6f3e),
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/laptop2.png",
                                            height: 150.0,
                                            width: 150.0,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            "Laptop",
                                            style:
                                                Appwidget.semiboldTextFieldStyle(),
                                          ),
                                          SizedBox(height: 20.0),
                                          Row(
                                            children: [
                                              Text(
                                                "\$1000",
                                                style: TextStyle(
                                                  color: Color(0xfffd6f3e),
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 50.0),
                                              Container(
                                                padding: EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xfffd6f3e),
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(
              detail: data["Detail"],
              image: data["Image"],
              name: data["name"],
              price: data["Price"],
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusGeometry.circular(10.0),
        ),
        height: 100,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10.0),
              child: Image.network(
                data["Image"],
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 20.0),
            Text(data["name"], style: Appwidget.semiboldTextFieldStyle()),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  String image, name;
  CategoryTile({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProducts(category: name),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(image, height: 50.0, width: 50.0, fit: BoxFit.cover),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
