import 'package:firestore/widget/customButton.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        title: const Text(
          'Firestore',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              children: [
                TextFormField(
                  maxLines: 4,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write something ...'),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(title: 'Add', onTap: () {}),
                const SizedBox(
                  height: 30,
                ),
                const Center(
                    child: Text(
                      'All Records',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    )),
              ],
            )),
            Expanded(
                child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.5,
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return const ListTile(
                        title: Text('Aamir'),
                        subtitle: Text('this is desc'),
                        trailing: Icon(Icons.more_vert),
                      );
                    },
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
