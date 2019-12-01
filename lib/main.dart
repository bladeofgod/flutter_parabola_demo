import 'package:flutter/material.dart';
import 'package:flutter_parabola_demo/parabola_animation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  GlobalKey floatBtnKey = GlobalKey();
  FloatingActionButton floatButton ;

  double fbPx;
  double fbPy;

  GlobalKey stackKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    floatButton = FloatingActionButton(
      key: floatBtnKey,
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
    WidgetsBinding.instance.addPostFrameCallback((_){
      RenderBox renderBox = floatBtnKey.currentContext.findRenderObject();
      Offset offset = renderBox.localToGlobal(Offset.zero);
      fbPx = offset.dx;
      fbPy = offset.dy;
      
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Stack(
        key: stackKey,
        children: <Widget>[
          Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: ListView(
              children: List.generate(40, (index){
                return itemWidget(index);
              }).toList(),
            ),
          ),

//          Offstage(
//            offstage: isOffstage,
//            child: new ParabolaAnimation(Offset(clickPx, clickPy),Offset(fbPx, fbPy)),
//          ),
          //new ParabolaAnimation(Offset(clickPx, clickPy),Offset(fbPx, fbPy)),
          
//          Positioned(
//            left: dotPositionX,
//            top: dotPositionY,
//            width: dotWidth,
//            height: dotHeight,
//            child: ,)
        ],
      ),
      floatingActionButton: floatButton, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
  bool isOffstage = true;
  double dotPositionX;
  double dotPositionY;
  double dotWidth;
  double dotHeight;


  double clickPx;
  double clickPy;

  Widget itemWidget(index){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onPanDown: (DragDownDetails details){
            clickPx = details.globalPosition.dx;
            clickPy = details.globalPosition.dy;
          },
          onTap: (){
            print("fb position  $fbPx --- $fbPy");
            print("click position  $clickPx   ____ $clickPy");
            setState(() {
//              isOffstage = ! isOffstage;
            OverlayEntry o = OverlayEntry(builder: (ctx){
              return new ParabolaAnimation(Offset(clickPx, clickPy),Offset(fbPx, fbPy));
            });
            Overlay.of(context).insert(o);
            });
          },
          child: Text("item $index"),
        ),

        RaisedButton(
          onPressed: (){},
          color: Colors.blue,
          child: Text("item $index"),
        ),
      ],
    );
  }




}






















