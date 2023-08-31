
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum AppState
{
  free,
  cropped,
  picked
}






void main() {












  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'IMAGE CAPTURE APP TSK-000-176'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late AppState state;
  File ? image;



  final picker = ImagePicker();

  Widget buildiconbutton()
  {
    if(state==AppState.free)
      {
        return const Icon(Icons.add);
      }

    else if(state==AppState.picked)
    {
      return const Icon(Icons.crop);
    }

    else if(state==AppState.cropped)
    {
      return const Icon(Icons.clear);
    }

    else
      {
        return const SizedBox();
      }
  }


  Future getImage() async
  {
    final pickerImage=await picker.pickImage(source: ImageSource.camera);
    image=pickerImage!=null? File(pickerImage.path) : null;

      if(image!=null)
        {


         setState(() {
           state=AppState.picked;
         });
        }


  }

  Future croppedimage() async {
    CroppedFile? croppedfile=await ImageCropper().cropImage(

      sourcePath: image!.path,
      aspectRatioPresets:
      [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),

      ],


    );




    if(croppedfile!=null)
      {
image=File(croppedfile.path);

        setState(() {
          state=AppState.cropped;
        });

      }



  }


  void clearimage()
  {
    image=null;
    setState(() {
      state=AppState.free;
    });
  }









  @override

  void initState()
  {
    super.initState();
    state=AppState.free;


  }
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(
      home:Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
    floatingActionButton: FloatingActionButton(onPressed: () { if(state==AppState.free){getImage();}
    else if(state==AppState.picked){croppedimage();}
    else if(state==AppState.cropped){clearimage();}


    },
    child: buildiconbutton()
    ,

    ),
      
      
      
      
      
      
      
      body:  Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          
          children: [
            Container(width:1000,height:350,child:image != null?  Image.file(image!): const SizedBox()),
            ElevatedButton(onPressed: () async{ XFile? shareimage=await picker.pickImage(source: ImageSource.gallery);


              if (shareimage==null)return;
              Share.shareXFiles([shareimage]);
              }, child: Text("SHARE IMAGE"),)
          ],
          
        )



          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
    ),
        
        
      ),
    );



      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.


  }
}
