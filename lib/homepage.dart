import 'package:faker/faker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class User {
  final String name;
  final String phoneNumber;
  final String city;
  final String imageUrl;
  late final int rupee;

  User({
    required this.name,
    required this.phoneNumber,
    required this.city,
    required this.imageUrl,
    required this.rupee,
  });

  String get rupeeStatus => rupee > 50 ? 'High' : 'Low';
}

class Homescreen extends StatefulWidget {
  @override
  _Homescreenstate createState() => _Homescreenstate();
}

class _Homescreenstate extends State<Homescreen> {
  final int pageSize = 20;
  late List<User> allRecords;
  List<User> displayedRecords = [];
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int currentPage = 0;
  String searchquery = '';

  @override
  void initState() {
    super.initState();
    allRecords = generateFakeUsers(43);
    _loadMoreData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        _loadMoreData();
      }
    });
  }

  List<User> generateFakeUsers(int count) {
    return List.generate(count, (index) {
      return User(
        name: faker.person.name(),
        phoneNumber: faker.phoneNumber.us(),
        city: faker.address.city(),
        imageUrl: 'https://i.pravatar.cc/150?img=${index + 1}',
        rupee: faker.randomGenerator.integer(100),
      );
    });
  }

  void _loadMoreData() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        int nextPage = currentPage + 1;
        int startIndex = currentPage * pageSize;
        int endIndex = startIndex + pageSize;

        if (startIndex < allRecords.length) {
          displayedRecords.addAll(allRecords.sublist(startIndex,
              endIndex > allRecords.length ? allRecords.length : endIndex));
          currentPage = nextPage;
        }

        isLoading = false;
      });
    });
  }

  void filterRecords(String query) {
    setState(() {
      searchquery = query;
      displayedRecords = allRecords
          .where((user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.phoneNumber.contains(query) ||
              user.city.toLowerCase().contains(query.toLowerCase()))
          .take(currentPage * pageSize)
          .toList();
    });
  }

  void _showEditDialog(User user) {
    TextEditingController rupeeController =
        TextEditingController(text: user.rupee.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Rupee for ${user.name}'),
          content: TextField(
            controller: rupeeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Rupee',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  user.rupee = int.parse(rupeeController.text);
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homescreen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by name, phone, or city',
                border: OutlineInputBorder(),
              ),
              onChanged: filterRecords,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: displayedRecords.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == displayedRecords.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final user = displayedRecords[index];
                return ListTile(
                  onTap: () => _showEditDialog(user),
                  leading: CachedNetworkImage(
                    imageUrl: user.imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                  ),
                  title: Text(user.name),
                  subtitle: Text('${user.phoneNumber}, ${user.city}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('₹${user.rupee}'),
                      Text(
                        user.rupeeStatus,
                        style: TextStyle(
                          color: user.rupee > 50 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
