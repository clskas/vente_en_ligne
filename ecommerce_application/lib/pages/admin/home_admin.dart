import 'package:ecommerce_application/pages/admin/add_product.dart';
import 'package:ecommerce_application/pages/admin/all_orders.dart';
import 'package:ecommerce_application/pages/widget/widget_support.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
        title: Text("Home Admin", style: Appwidget.boldTextFieldStyle()),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            SizedBox(height: 50.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProduct()),
                );
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, right: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 50.0),
                      SizedBox(width: 30.0),
                      Text(
                        "Add Product",
                        style: Appwidget.boldTextFieldStyle(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 80.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllOrders()),
                );
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, right: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 50.0),
                      SizedBox(width: 30.0),
                      Text("All Orders", style: Appwidget.boldTextFieldStyle()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
