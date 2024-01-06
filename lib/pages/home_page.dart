import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crad1/pages/add_crad_page.dart';
import 'package:crad1/pages/edit_crad_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon_broken/icon_broken.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cradCollection = FirebaseFirestore.instance.collection("crad").snapshots();
  void deleteCrad(String id)async{
    await FirebaseFirestore.instance.collection("crad").doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(" Crad deleted") ,));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CARD App"),
      ),
      body: StreamBuilder(
        stream: cradCollection,
          builder:
              (context,snapshot){
         if(snapshot.hasData){
           final List<QueryDocumentSnapshot>documents = snapshot.data!.docs;
           if(documents.isEmpty){
             return Center(
               child: Text(
                 "No document yet",
               style: Theme.of(context).textTheme.headlineMedium,),
             );
           }
           return ListView.builder(
              itemCount: documents.length,
               itemBuilder: (context,index){
                final crad =documents[index].data() as Map<String,dynamic>;
                final cradId=documents[index].id;
                final String name = crad['name'];
                final String email = crad['email'];
                final String phone = crad['phone'];
                //https://api.multiavatar.com/Binx%20$name.svg
                final String avatar = 'https://api.multiavatar.com/Binx $name.png';
                return ListTile(
                  title: Text(name),
                  subtitle:Text("$phone \n $email"),
                  leading: Hero(
                    tag: cradId,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(avatar),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context)=> EditCradPage(
                                  avatar: avatar,
                                  name: name,
                                  phone: phone,
                                  email: email,
                                  id: cradId,
                                )));
                      },
                        icon: Icon(IconBroken.Edit),splashRadius: 24,),

                      IconButton(onPressed: (){
                        deleteCrad(cradId);
                      },
                        icon: Icon(IconBroken.Delete),splashRadius: 24,),
                    ],
                  ),
                );
           });
         }else if(snapshot.hasError){
           return Center(
             child: Text("thier was an error"),
           );
         }
         return Center(
           child: CircularProgressIndicator.adaptive(),//////render view /////
         );
      }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddCradPage(),));
          },
          label: const Text("Add new CRAD"),
          icon:const Icon(IconBroken.Document) ,
      ),

    );
  }
}
