
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crad1/presentation/theme_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon_broken/icon_broken.dart';

class AddCradPage extends StatefulWidget {
  const AddCradPage({Key? key}) : super(key: key);

  @override
  _AddCradPageState createState() => _AddCradPageState();
}

class _AddCradPageState extends State<AddCradPage> {
  final _formkey =GlobalKey<FormState>();
  final nameControler =TextEditingController();
  final phoneControler =TextEditingController();
  final emailControler =TextEditingController();

  void addCrad ()async{
    if(_formkey.currentState!.validate()){
      try{
        await FirebaseFirestore.instance.collection("crad").add({
          "name": nameControler.text.trim(),
          "phone":phoneControler.text.trim(),
          "email":emailControler.text.trim(),
        });
        if(mounted){
          Navigator.pop(context);
        }
      }on FirebaseException{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add crad"),));
      }

    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all the feilds"),));
    }
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
        title: const Text("Add Crad"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14.0),
        children: [
          Form(
            key: _formkey,
            child: Column(
              children: [
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
                    onPressed: addCrad,
                    icon: Icon(IconBroken.AddUser),
                    label: Text("Add card"))
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
