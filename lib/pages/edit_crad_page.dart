
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crad1/presentation/theme_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon_broken/icon_broken.dart';

class EditCradPage extends StatefulWidget {
  const EditCradPage({Key? key,
    required this.avatar,
    required this.name,
    required this.phone,
    required this.email,
    required this.id
  }) : super(key: key);
  final String avatar;
  final String name;
  final String phone;
  final String email;
  final String id;

  @override
  _EditCradPageState createState() => _EditCradPageState();
}

class _EditCradPageState extends State<EditCradPage> {
  final _formkey =GlobalKey<FormState>();
  late TextEditingController nameControler;
  late TextEditingController phoneControler;
  late TextEditingController emailControler;

 void editCard()async{
   if(_formkey.currentState!.validate()){
     try{
       await FirebaseFirestore.instance.collection('crad').doc(widget.id).update(
           {
             "name": nameControler.text.trim(),
             "phone":phoneControler.text.trim(),
             "email":emailControler.text.trim(),
           });
      if(mounted){
        Navigator.pop(context);
      }
     }on FirebaseException{
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Faild edit crad"),));

     }
   }

 }

 @override
  void initState() {
   nameControler =TextEditingController(
     text: widget.name
   );
   phoneControler =TextEditingController(
       text: widget.phone
   );
   emailControler =TextEditingController(
       text: widget.email
   );
    super.initState();
  }
  @override
  void dispose() {
    nameControler.dispose();
    phoneControler.dispose();
    emailControler.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Crad"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14.0),
        children: [
          Form(
            key: _formkey,
            child: Column(
              children: [
                Hero(
                  tag: widget.id,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(widget.avatar),
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  keyboardType: TextInputType.name,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: nameControler,
                  textInputAction: TextInputAction.next,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please enter name";
                    }
                    return null;
                  },
                  decoration:const InputDecoration(
                      hintText: "Name",
                      contentPadding: inputPadding
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: phoneControler,
                  textInputAction: TextInputAction.next,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please enter phone number";
                    }
                    return null;
                  },
                  decoration:const InputDecoration(
                      hintText: "Phone",
                      contentPadding: inputPadding
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailControler,
                  textInputAction: TextInputAction.next,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please enter email";
                    }
                    return null;
                  },
                  decoration:const InputDecoration(
                      hintText: "Email",
                      contentPadding: inputPadding
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        onPressed: editCard,
                        icon: Icon(IconBroken.Edit_Square),
                        label: Text("Edit card"))
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
