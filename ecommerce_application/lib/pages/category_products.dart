import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/product_detail.dart';
import 'package:ecommerce_application/pages/services/database.dart';
import 'package:ecommerce_application/pages/widget/widget_support.dart';
import 'package:flutter/material.dart';

class CategoryProducts extends StatefulWidget {
  String category;
  CategoryProducts({super.key, required this.category});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  Stream? categoryStream;
  getontheload() async {
    categoryStream = await DatabaseMethods().getProducts(widget.category);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allProducts() {
    return StreamBuilder(
      stream: categoryStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10.0),
                        Image.network(
                          ds["Image"],
                          height: 120.0,
                          width: 150.0,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                        Text(
                          ds["name"],
                          style: Appwidget.semiboldTextFieldStyle(),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              "\$" + ds["Price"],
                              style: TextStyle(
                                color: Color(0xfffd6f3e),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 30.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetail(
                                      detail: ds["Detail"],
                                      image: ds["Image"],
                                      name: ds["name"],
                                      price: ds["Price"],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Color(0xfffd6f3e),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(backgroundColor: Color(0xfff2f2f2)),
      body: Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(children: [Expanded(child: allProducts())]),
      ),
    );
  }
}
