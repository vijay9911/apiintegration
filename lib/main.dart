
import 'package:apiintegration/catresponse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApiIntegrationWidget extends StatefulWidget {
  @override
  _MyApiIntegrationWidgetState createState() => _MyApiIntegrationWidgetState();
}

class _MyApiIntegrationWidgetState extends State<MyApiIntegrationWidget> {
  // Define variables to hold API data
  List<CategoriesDataList> getCategoriy= [];
  bool _isLoading = false;

  // Function to fetch data from API
  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.get(Uri.parse('https://direct2home.shop/admin/api/v2/categories'));
    if (response.statusCode == 200) {

      final Map<String, dynamic> jsonData = json.decode(response.body);
      // Assuming your data is nested under a key, replace 'data' with the actual key
      final List<dynamic> dataList = jsonData['data'];
      setState(() {
        getCategoriy = dataList
            .map<CategoriesDataList>((data) => CategoriesDataList.fromJson(data))
            .toList();
        _isLoading = false;
        print("Data : ${response.body}");
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data from API');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Integration Example'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: getCategoriy.length,
        itemBuilder: (context, index) {
          // You can customize this according to your API response structure
          return ListTile(
            title: Text(getCategoriy[index].name.toString()),
            subtitle: Text(getCategoriy[index].name.toString()),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyApiIntegrationWidget(),
  ));
}
