import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore/widget/customButton.dart';
import 'package:flutter/material.dart';

class UpdateUser extends StatefulWidget {
  String name;
  String id = '';

  UpdateUser({required this.name,required this.id});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final postController = TextEditingController();
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postController.text = widget.name;
  }
  void editUser() async {
    setState(() {
      loading = true;
    });
    Map<String, dynamic> data = {
      'name': postController.text.toString(),
    };

    try {
      await FirebaseFirestore.instance.collection('user').doc(widget.id).update(data);
      Navigator.pop(context);
      setState(() {
        loading = false;
      });
    } catch (e) {
      print('Error updating user: $e');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        title: const Text(
          'Edit User',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      maxLines: 4,
                      controller: postController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Write something ...'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(loading: loading,title: 'Update', onTap: () {
                      editUser();
                    }),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
