import 'dart:convert';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:novel/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';
import "package:http/http.dart" as http;
import 'package:novel/models/book.dart';
import 'package:novel/models/chapter.dart';
import 'package:novel/screens/setting_screen.dart';
import 'package:novel/screens/wallet_screen.dart';
import 'package:novel/screens/writerHub_screen.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:quill_format/quill_format.dart' as qf;
import 'package:zefyrka/zefyrka.dart';

import 'chapters_screen.dart';

class EditChapter extends StatefulWidget {
  Book book;
  int chapterId;
  String chapterTitle;
  int index;
  EditChapter({Key key,@required this.book,@required this.chapterId,@required this.chapterTitle,@required this.index}) : super(key: key);

  @override
  _EditChapterState createState() => _EditChapterState();
}

class _EditChapterState extends State<EditChapter> {

  final styleOfTexts = GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 18.sp);
  final styleOfWorks = GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.bold);
  bool mature = false;
  bool completed= false;
  bool _isHidden = true;
  int decriptionwcount;

  File imageProfile;

  TextEditingController name = new TextEditingController();
  TextEditingController summary = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController genre = new TextEditingController();

  Future<NotusDocument> _loadDocument(String link) async {
    if(link==''){
      Chapter chap = await Chapter().getChapterDetails(widget.book.chapterList[widget.index]['chapter_id']);
      final mydata = await http.get(Uri.parse(chap.description));
      Chapter().incrementChapterViewCount(widget.book.chapterList[widget.index]['chapter_id'],widget.book.bookId);
      // print(mydata.body);
      return NotusDocument.fromJson(jsonDecode(mydata.body.toString()));
    }
    await Chapter().getChapterDetails(widget.chapterId);
    final mydata = await http.get(Uri.parse(link));
    // print(mydata.body);
    return NotusDocument.fromJson(jsonDecode(mydata.body.toString()));
  }
  Future addChapters(File file) async {
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse(globals.baseUrl+'chapter_edit_api'));
    request.fields.addAll({
      "title": name.text,
      "chapter_id":widget.chapterId.toString()
    });
    request.files.add(await http.MultipartFile.fromPath('description', file.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }
  void _saveDocument(BuildContext context) {
    final contents = jsonEncode(_controller.document);
    final file = File(Directory.systemTemp.path + getRandomString(100)+".json");
    file.writeAsString(contents).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saved.")));
      addChapters(file);
    });
  }
  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDocument('').then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // print(getRandomString(100));
    // print(widget.book.bookId);
    final Widget body = (_controller == null)
        ? Center(child: CircularProgressIndicator())
        :  ZefyrEditor(
      padding: EdgeInsets.all(16),
      controller: _controller,
      focusNode: _focusNode,
    );
    name.text = widget.chapterTitle;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.primary,
        title: Text('Edit Chapter',style: styleOfTexts,),
        leading: IconButton(
          icon:Icon(Icons.arrow_back_ios,color: globals.primaryTextColor),
          color: Colors.black, onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      child: Text('  Chapter Title   ',style: GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor ),),
                    ),
                  ),
                  Container(
                      width: 200,
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
                      child: Builder(
                        builder: (context){
                          return GFButton(
                            text: 'Update Chapter',
                            textStyle: GoogleFonts.aladin(fontSize: 15.sp,color: globals.primaryTextColor),
                            color: globals.primary,
                            onPressed: ()async{
                              print(_controller.document);
                              _saveDocument(context);
                              // addChapters();
                            },
                          );
                        },
                      )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                child: TextField(
                  minLines: 1,
                  maxLines: 2,
                  style: GoogleFonts.roboto(fontSize: 15.sp),
                  showCursor: true,
                  decoration: InputDecoration(
                    // labelText: "description",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
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
                  child: Text('  Description   ',style: GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor),),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.6,
                child: ListView(
                  children: [
                    body,
                    ZefyrToolbar.basic(controller: _controller),
                    // Expanded(
                    //   child: ZefyrEditor(
                    //     controller: _controller,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
