import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore/ui/update_firestore.dart';
import 'package:firestore/widget/customButton.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final Firestore = FirebaseFirestore.instance.collection('user');
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
                CustomButton(loading: loading,title: 'Add', onTap: () {
                  setState(() {
                    loading = true;
                  });
                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  Firestore.doc(id).set({
                    'name':postController.text.toString(),
                    'id':id
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User Added')));
                    postController.clear();
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                  });
                }),
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
              child: StreamBuilder(stream: Firestore.snapshots(), builder: (context, snapshot) {
                if(ConnectionState.waiting == snapshot.connectionState){
                  return const Center(child: CircularProgressIndicator());
                }
                if(snapshot.hasError){
                  return const Center(child: Text('somethings is wrong'));
                }
                if(snapshot.hasData){
                  var user_data = snapshot.data!.docs.length;
                  return ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.5,
                        child: user_data > 0 ? ListView.builder(
                          itemCount: user_data,
                          itemBuilder: (context, index) {
                            var user_name = snapshot.data!.docs[index]['name'];
                            var user_id = snapshot.data!.docs[index].id;
                            return ListTile(
                              title: Text(user_name),
                              subtitle: Text(user_id),
                              trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (BuildContext context) =>[
                                  PopupMenuItem(
                                    child: ListTile(
                                      leading: const Icon(Icons.edit),
                                      title: const Text('Edit'),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateUser(
                                          id: user_id,
                                          name: user_name,
                                        ),)).then((_) {
                                          Navigator.pop(context); // Hides the popup when returning from UpdateUser screen
                                        });
                                      },
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                      leading: const Icon(Icons.delete),
                                      title: const Text('Delete'),
                                      onTap: () {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.rightSlide,
                                          title: 'Delete',
                                          desc: 'Are you sure',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            Firestore.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                            Navigator.pop(context);
                                          },
                                        ).show();
                                      },
                                    ),
                                  ),
                                  // Add more PopupMenuItems as needed
                                ],
                              ),
                            );
                          },
                        ) : const Column(
                          children: [
                            Text('No Data Found'),
                          ],
                        ),
                      )
                    ],
                  );
                }
                return Container();
              },),
            )
          ],
        ),
      ),
    );
  }
}
