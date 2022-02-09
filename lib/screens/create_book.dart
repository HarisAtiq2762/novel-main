import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import "package:http/http.dart" as http;
import 'package:novel/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert' as convert;

class CreateBook extends StatefulWidget {
  const CreateBook({Key key}) : super(key: key);

  @override
  _CreateBookState createState() => _CreateBookState();
}

class _CreateBookState extends State<CreateBook> {

  final styleOfTexts = GoogleFonts.roboto(color: Colors.white,fontSize: 25);
  final styleOfWorks = GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.bold);
  bool mature = false;
  bool completed= false;

  File imageProfile;
  Future _imgFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      imageProfile = File(pickedFile.path);
    });
  }
  Future _imgFromGallery() async {
    final pickedFile =
    await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      imageProfile = File(pickedFile.path);
    });
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library_outlined),
                  title: Text('Photo Gallery'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera_outlined),
                  title: Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  TextEditingController name = new TextEditingController();
  TextEditingController summary = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController genre = new TextEditingController();
  TextEditingController tags = new TextEditingController();

  String result = '';

  Future addBook() async {
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data'
    };
    var request = http.MultipartRequest('POST', Uri.parse(globals.baseUrl+'books_add_api'));
    request.fields.addAll({
      'name': name.text,
      'genre': _selectedItem.value.toString(),
      'complete': completed.toString(),
      'mature': mature.toString(),
      'copyrights': selectedActivity.title,
      'tags': tags.text,
      'description': description.text,
      'user_id': globals.logedInUser.userId.toString()
    });
    if(imageProfile==null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Book picture can not be empty'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
    }
    else{
      request.files
          .add(await http.MultipartFile.fromPath('image', imageProfile.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Your book has been created successfully. Now add your chapters'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 3000),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.reasonPhrase),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 3000),
        ));
      }
    }
  }
  List datalist = [];
  ListItem _selectedItem ;

  Future<String> getgenre() async {
    var response = await http.get(Uri.parse(globals.baseUrl+"book_genre_api"));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var resBody = jsonResponse;
        for (var i in resBody["data"]) {
          _dropdownItems.add(ListItem(i["genre_id"], i["genre_name"]));
          _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
          // _selectedItem = _dropdownMenuItems[0].value;
        }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  List<ListItem> _dropdownItems = [
    ListItem(0, "Select Genre"),
  ];
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = [];
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              listItem.name,
              softWrap: true,
              textScaleFactor: 1,
              style: TextStyle(fontSize: 14),
            ),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
  }

  List<Copyrights> _copyrights = [];
  List<DropdownMenuItem<Copyrights>> activityListDropDownItems = [];
  Copyrights selectedActivity;
  int selectedActivityId = 0;
  String selectedActivityTitle = '';

  List<DropdownMenuItem<Copyrights>> buildActivityList(List copyrights) {
    List<DropdownMenuItem<Copyrights>> items = [];
    for (Copyrights activity in copyrights) {
      items.add(
        DropdownMenuItem(
          value: activity,
          child: ListTile(
            title:  Text(
                '${activity.title}',
                style: TextStyle(
                  // color: Colors.bla,
                ),
              ),
             subtitle: Text( '${activity.subtitle}'),

          ),
        ),
      );
    }
    return items;
  }

  // VOID
  void onChangeActivityListDropDownItem(Copyrights selected) {
    setState(() {
      selectedActivity = selected;
      selectedActivityId = selected.id;
      selectedActivityTitle = selected.title;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.primary,
        title: Text('Create Your Book',style: styleOfTexts,),
        leading: IconButton(
          icon:Icon(Icons.arrow_back_ios,color: Colors.white,),
          color: Colors.black, onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: MediaQuery.of(context).size.height*0.4,
                    child: GestureDetector(
                      onTap: (){
                        _showPicker(context);
                      },
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:  imageProfile == null
                                ? AssetImage('asset/addpic.png')
                                : Image.file(
                              imageProfile,
                              fit: BoxFit.fill,
                            ).image,
                            fit: BoxFit.fill)),
                  ),
                ),
              Divider(thickness: 2.0,indent: 20.0,endIndent: 20.0,color: globals.primary,),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: globals.primary,
                    ),
                    child: Text('  Story Title   ',style: GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor ),),
                  ),
                ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                  child: TextField(
                    minLines: 1,
                    maxLines: 2,
                    style: GoogleFonts.roboto(fontSize: 15.0),
                    decoration: InputDecoration(
                      // labelText: "description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    controller: name,
                  ),
                ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: globals.primary,
                    ),
                    child: Text('  Description   ',style: GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor ),),
                  ),
                ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                  child: TextField(
                    maxLength: 2000,
                    minLines: 3,
                    maxLines: 100,
                    style: GoogleFonts.roboto(fontSize: 15.0),
                    decoration: InputDecoration(
                      // labelText: "description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    controller: description,
                  ),
                ),
              Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: globals.primary,
                        ),
                        child: Text('  Story Genre   ',style: GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor),),
                      ),
                    ),
                    FutureBuilder(
                      future: getgenre(),
                      builder: (context,snapshot){
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              height: 40,
                              child: DropdownButton<ListItem>(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  isExpanded: true,
                                  hint: Text('Genre'),
                                  value: _selectedItem,
                                  items: _dropdownMenuItems,
                                  onChanged: (value) {
                                    // print(value.value);
                                    setState(() {
                                      _selectedItem = value;
                                    });
                                  }),
                            ),
                          ),);
                      },
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: globals.primary,
                        ),
                        child: Text('  Copyright    ',style: GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor),),
                      ),
                    ),
                  FutureBuilder(
                    future: getCopyrights(),
                    builder: (context,snapshot){
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            height: 40,
                            child: DropdownButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                isExpanded: true,
                                hint: Text('Copyrights'),
                                value: selectedActivity,
                                items: activityListDropDownItems,
                                onChanged: onChangeActivityListDropDownItem
                                ),
                          ),
                        ),);
                    },
                  ),
                  // FutureBuilder(
                  //   future: getCopyrights(),
                  //   builder: (context,snapshot){
                  //     if(snapshot.connectionState==ConnectionState.done) {
                  //       activityListDropDownItems = buildActivityList(_copyrights);
                  //       return Container(
                  //         height: MediaQuery.of(context).size.height * 0.1,
                  //         width: MediaQuery.of(context).size.width * 0.5,
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             MyDropDown(
                  //               icon: Icons.keyboard_arrow_down,
                  //               hintText: 'Set Copyrights',
                  //               // icon: selectedActivityIcon,
                  //               value: selectedActivity,
                  //               items: activityListDropDownItems,
                  //               onChanged: onChangeActivityListDropDownItem,
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     }
                  //     return GFLoader();
                  //   },
                  // ),
                ],
              ),
              Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: globals.primary,
                        ),
                        child: Text('  Language    ',style: GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor),),
                      ),
                    ),
                    Text('  English   ',style: GoogleFonts.roboto(fontSize: 18.0,fontWeight: FontWeight.w400,wordSpacing: 0.5 ),)

                  ],
                ),
              Row(
                  children: [
                    StatefulBuilder(
                      builder: (BuildContext context,
                          StateSetter setState) =>
                          Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              checkColor: Colors.black,
                              activeColor: globals.primary,
                              value: mature,
                              onChanged: (val) {

                                setState(() {
                                  mature = !mature;
                                  print("value of check : " + mature.toString());
                                });

                              }),
                    ),

                    Text('  Mature   ',style: GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5 ),)
                  ],
                ),
              Row(
                  children: [
                    StatefulBuilder(
                      builder: (BuildContext context,
                          StateSetter setState) =>
                          Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              checkColor: Colors.black,
                              activeColor: globals.primary,
                              value: completed,
                              onChanged: (val) {

                                setState(() {
                                  completed = !completed;
                                  print("value of check : " + completed.toString());
                                });

                              }),
                    ),

                    Text('  Completed   ',style: GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5 ),)
                  ],
                ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: globals.primary,
                    ),
                    child: Text('  Add Tags   ',style: GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor ),),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                child: TextField(
                  minLines: 3,
                  maxLines: 100,
                  style: GoogleFonts.roboto(fontSize: 15.0),
                  decoration: InputDecoration(
                    // labelText: "description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  controller: tags,
                ),
              ),
              SizedBox(height: 50,),
              Center(
                child: Container(
                  width: 0.500.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: globals.primary,
                    border: Border.all(color: Colors.black),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.5, 10.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: GFButton(
                    text: 'Create Book',
                    textStyle: GoogleFonts.aladin(fontSize: 15.sp,color: globals.primaryTextColor),
                    color: globals.primary,
                    onPressed: (){
                      addBook();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Adding book please wait'),
                        backgroundColor: Colors.green,
                        duration: Duration(milliseconds: 3000),
                      ));
                    },
                  ),
                ),
              ),
              SizedBox(height: 0.1.sh,),
            ],
          ),
        ),
      ),
    );
  }

  Future getCopyrights()async{
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'copyrights_api'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = convert.jsonDecode(data);
      int i=0;
      if(_copyrights.isEmpty) {
        for (var copyright in data['data']) {
          _copyrights.add(Copyrights(
              id: i++,
              title: copyright['title'],
              subtitle: copyright['copyrights']));
        }
      }
      activityListDropDownItems = buildActivityList(_copyrights);
    }
    else {
      print(response.reasonPhrase);
    }
  }
}

class ListItem {
  int value;
  String name;
  ListItem(this.value, this.name);
}

class MyDropDown<T> extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final IconData icon;
  final T value;
  final String hintText;
  final ValueChanged<T> onChanged;

  const MyDropDown(
      {Key key,
        @required this.items,
        this.icon,
        this.value,
        this.hintText,
        this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border.all(
      //     color: Colors.grey,
      //     width: 0,
      //   ),
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(
      //       8.0,
      //     ),
      //   ),
      // ),
      child: Row(
        children: [
                   SizedBox(width: 10.0),
          Expanded(
            // T
            child: DropdownButton<T>(
              icon: Icon(Icons.keyboard_arrow_down,  color: Colors.black,
                size: 20,),
              hint: Text(
                hintText,
                style: TextStyle(),
              ),
              isExpanded: true,
              value: value,
              items: items,
              onChanged: onChanged,
              underline: Container(),
            ),
          )
        ],
      ),
    );
  }
}

class Copyrights {
  final int id;
  final String title;
  final String subtitle;

  Copyrights({@required this.id, @required this.title, @required this.subtitle});
}
