import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty2/data/models/gift.dart';
import 'package:hedieaty2/data/repositories/gifts_db.dart';
import 'package:hedieaty2/services/auth/auth.dart';

class MyPledgedGiftsScreen extends StatefulWidget {
  const MyPledgedGiftsScreen({super.key});

  @override
  State<MyPledgedGiftsScreen> createState() => _MyPledgedGiftsScreenState();
}

class _MyPledgedGiftsScreenState extends State<MyPledgedGiftsScreen> {
  late Future<List<Map<String, dynamic>>> _pledgedGifts;

  @override
  void initState() {
    super.initState();
    _pledgedGifts = GiftsDB().getPledgedGifts(Auth().currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Pledged Gifts',
          style: TextStyle(fontSize: 30),
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _pledgedGifts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No pledged gifts found.'),
            );
          } else {
            final pledgedGifts = snapshot.data!;
            return ListView.builder(
              itemCount: pledgedGifts.length,
              itemBuilder: (context, index) {
                final gift = pledgedGifts[index]['gift'] as Gift;
                final eventName = pledgedGifts[index]['eventName'] as String;

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: gift.imageUrl!,
                          placeholder: (context, url) => Container(
                            color: Colors.transparent,
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/imageFailed.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        title: Text(
                          gift.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Event: $eventName'),
                            Text('Price: \$${gift.price.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
