import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

import 'messagesScreen.dart';

void main()=>runApp(new MyApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AG Bot",
      theme: ThemeData(
        brightness: Brightness.dark
      ), home: Home(),

    );
  }
}
 class Home extends StatefulWidget {
   const Home({super.key});
 
   @override
   State<Home> createState() => _HomeState();
 }
 
 class _HomeState extends State<Home> {


   late DialogFlowtter dialogFlotter;

   final TextEditingController controller= TextEditingController();
   List<Map<String,dynamic>> messages=[];
   @override
  void initState() {
     DialogFlowtter.fromFile().then((instance)=>dialogFlotter= instance);


    super.initState();
  }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('AG, Bot'),

       ),
       body: Container(
         child: Column(
           children: [
             Expanded(child: Messagesscreen(messages: messages)),
             Container(
               padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
               color: Colors.deepPurple,
               child: Row(
                 children: [Expanded(child: TextField(
                   controller: controller,
                   style: TextStyle(color: Colors.white),

                 )),
                   IconButton(onPressed: (){
                     SendMessages(controller.text);
                     controller.clear();

                   }, icon: Icon(Icons.send) )
                 ],
               ),
             )
           ],

         ),
       ),
     );
   }
   SendMessages(String text)async{
     if(text.isEmpty){
       print('Text is empty');

     }
     else{
       setState(() {
         addMessage(Message(text: DialogText(text: [text])), true);

       });
       DetectIntentResponse response= await dialogFlotter.detectIntent(queryInput:
       QueryInput(text: TextInput(text: text)));
       if(response.message==null) return;
       setState(() {
         addMessage(response.message!);
       });
     }
   }
   addMessage(Message message, [bool isUserMessage=false]){
     messages.add({ 'message': message, 'isUserMessage': isUserMessage});
   }
 }
 