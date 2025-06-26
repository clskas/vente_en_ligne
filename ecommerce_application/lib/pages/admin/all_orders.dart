import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_application/pages/services/database.dart';
import 'package:ecommerce_application/pages/widget/widget_support.dart';
import 'package:flutter/material.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  Stream? orderStream;

  getontheload() async {
    orderStream = await DatabaseMethods().allOrders();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 20.0,
                          top: 20.0,
                          bottom: 20.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              ds["ProductImage"],
                              height: 100.0,
                              width: 100.0,
                              fit: BoxFit.cover,
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    "Name : " + ds["Name"],
                                    style: Appwidget.semiboldTextFieldStyle(),
                                  ),
                                  SizedBox(height: 2.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    child: Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      "Email : " + ds["Email"],
                                      style: Appwidget.lightTextFieldStyle(),
                                    ),
                                  ),
                                  SizedBox(height: 2.0),
                                  Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    ds["Product"],
                                    style: Appwidget.semiboldTextFieldStyle(),
                                  ),
                                  SizedBox(height: 2.0),
                                  Text(
                                    "\$${ds["Price"]}",
                                    style: TextStyle(
                                      color: Color(0xfffd6f3e),
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  GestureDetector(
                                    onTap: () async {
                                      await DatabaseMethods().upDateStatus(
                                        ds.id,
                                      );
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        color: Color(0xfffd6f3e),
                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Done",
                                          style:
                                              Appwidget.semiboldTextFieldStyle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
      appBar: AppBar(
        title: Text("All Orders", style: Appwidget.boldTextFieldStyle()),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: Column(children: [Expanded(child: allOrders())]),
      ),
    );
  }
}
