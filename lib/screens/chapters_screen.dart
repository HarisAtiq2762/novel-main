import 'dart:async';
import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:novel/models/comment.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quill_format/quill_format.dart' as qf;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:novel/models/book.dart';
import 'package:novel/models/chapter.dart';
import 'package:novel/widgets/chaptersBookCard.dart';
import 'package:novel/widgets/profileCommentCard.dart';
import 'package:http/http.dart' as http;
import 'package:novel/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:like_button/like_button.dart';

class ChaptersScreen extends StatefulWidget {

  final Book book;
  final chapterId;
  final chapterListIndex;
  bool fromList=false;
  ChaptersScreen({this.book,this.chapterId,this.chapterListIndex,this.fromList});
  @override
  _ChaptersScreenState createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  var fontSize=20.0;
  var backgroundColor = Colors.white;
  var chapterTextColor = Colors.black;
  var widthOfExpandableFont = 100.0;
  var chapTitle = 'Chapter 1';
  String details = '';
  ZefyrController _controller;
  FocusNode _focusNode;
  SharedPreferences prefs;
  TextEditingController commentController = TextEditingController();
  int indexOfChap=0;
  String chapterId='';
  int scrollIndex=0;
  bool scrollIndexChanged=false;
  void initSharedPrefs()async{
    prefs = await SharedPreferences.getInstance();
  }
  Future<NotusDocument> _loadDocument(String link) async {
    prefs = await SharedPreferences.getInstance();
    int chapIndex=0;
    List memory = [];
    if(prefs.containsKey('memoryOf'+widget.book.bookId.toString())){
      List memory = prefs.get('memoryOf' + widget.book.bookId.toString());
      chapIndex=int.parse(memory[1]);
    }
    if(link==''){
      if(widget.fromList==true){
        Chapter chap = await Chapter().getChapterDetails(widget.book.chapterList[widget.chapterListIndex]['chapter_id']);
        chapterId = widget.book.chapterList[widget.chapterListIndex]['chapter_id'].toString();
        final mydata = await http.get(Uri.parse(chap.description));
        await Chapter().incrementChapterViewCount(widget.book.chapterList[widget.chapterListIndex]['chapter_id'],widget.book.bookId);
        chapTitle = 'Chapter '+widget.chapterListIndex.toString();
        return NotusDocument.fromJson(jsonDecode(mydata.body.toString()));
      }
      Chapter chap = await Chapter().getChapterDetails(widget.book.chapterList[memory.length==2?chapIndex:0]['chapter_id']);
      final mydata = await http.get(Uri.parse(chap.description));
      await Chapter().incrementChapterViewCount(widget.book.chapterList[memory.length==2?chapIndex:0]['chapter_id'],widget.book.bookId);
      chapterId = await widget.book.chapterList[memory.length==2?chapIndex:0]['chapter_id'].toString();
      return NotusDocument.fromJson(jsonDecode(mydata.body.toString()));
    }
    final mydata = await http.get(Uri.parse(link));
    return NotusDocument.fromJson(jsonDecode(mydata.body.toString()));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPrefs();
    _loadDocument('').then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
    _focusNode = FocusNode();
  }
  Future<bool> onLikeButtonTapped(bool isLiked) async{
    await Chapter().voteChapter(widget.book.chapterList[indexOfChap]['chapter_id'],widget.book.bookId);
    return !isLiked;
  }
  Future getBookViewsVotesTotalChapters()async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'book_views_votes_total_chapters'));
    request.body = json.encode({
      "book_id": widget.book.bookId
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      if(data['success']==true){
        return data['total_votes'][0]['votes'];
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onLoading()async{
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _myScrollController.animateTo(
          _myScrollController.position.minScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn
      );
    });
    Timer(Duration(milliseconds: 500), () {
      _myScrollController2.jumpTo(_myScrollController2.position.minScrollExtent);
      _myScrollController.jumpTo(_myScrollController.position.minScrollExtent);
    });
    // SchedulerBinding.instance?.addPostFrameCallback((_) {
    //   _myScrollController2.animateTo(
    //       _myScrollController2.position.minScrollExtent,
    //       duration: Duration(milliseconds: 50),
    //       curve: Curves.fastOutSlowIn);
    // });
    if(scrollIndexChanged==false){
      print('in if');
      scrollIndex = scrollIndex+1;
      scrollIndexChanged=true;
    }
    int index = scrollIndex;
    Chapter chap = await Chapter().getChapterDetails(widget.book.chapterList[index]['chapter_id']);
    chapterId = widget.book.chapterList[index]['chapter_id'].toString();
    Chapter().incrementChapterViewCount(widget.book.chapterList[index]['chapter_id'],widget.book.bookId);
    _loadDocument(chap.description).then((document) {
      setState(() {
        _controller = ZefyrController(document);
        indexOfChap = index;
        chapTitle = chap.title;
        if(scrollIndex!=widget.book.chapterList.length-1){
          scrollIndex++;
        }
      });
    });
    prefs.setStringList('memoryOf'+widget.book.bookId.toString(), [widget.book.bookId.toString(),index.toString()]);
    _refreshController.loadComplete();
  }

  void _onRefresh()async{
    int index = scrollIndex;
    Chapter chap = await Chapter().getChapterDetails(widget.book.chapterList[index]['chapter_id']);
    Chapter().incrementChapterViewCount(widget.book.chapterList[index]['chapter_id'],widget.book.bookId);
    _loadDocument(chap.description).then((document) {
      setState(() {
        _controller = ZefyrController(document);
        indexOfChap = index;
        chapTitle = chap.title;
        if(scrollIndex!=0){
          scrollIndex--;
        }
      });
    });
    prefs.setStringList('memoryOf'+widget.book.bookId.toString(), [widget.book.bookId.toString(),index.toString()]);
    _refreshController.refreshCompleted();
  }
  ScrollController _myScrollController = ScrollController();
  ScrollController _myScrollController2 = ScrollController();
  @override
  Widget build(BuildContext context) {
    initSharedPrefs();
    final styleOfTexts = GoogleFonts.roboto(color: Colors.black,fontSize: 18.sp);
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    final Widget body = (_controller == null)
        ? Center(child: CircularProgressIndicator())
        :  ZefyrEditor(
      readOnly: true,
      scrollPhysics: NeverScrollableScrollPhysics(),
      showCursor: false,
      padding: EdgeInsets.all(16),
      controller: _controller,
      focusNode: _focusNode,
      enableInteractiveSelection: false,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: globals.primary,
        title: Text('Chapters',style: GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 18.sp),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: globals.primaryTextColor,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context){
                return GestureDetector(
                    onTap: (){
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: Icon(Icons.menu,color: globals.primaryTextColor,size: 30,)
                );
              },
            ),
          ),
        ],
      ),
      endDrawer:
      Container(
        width: MediaQuery.of(context).size.width*0.8,
        child: Drawer(
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.book.bookTitle,style: styleOfTexts,),
                    ),
                    ChaptersBookCard(book: widget.book,),
                    Divider(thickness: 2.0,indent: 60.0,endIndent: 60.0,color: globals.primary,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Chapters',style: styleOfTexts,),
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.book.chapterList.length,
                      itemBuilder: (context,index){
                        if(widget.book.chapterList[index]['publish_status']=='published'){
                          return GestureDetector(
                            onTap: ()async{
                              Chapter chap = await Chapter().getChapterDetails(widget.book.chapterList[index]['chapter_id']);
                              chapterId = widget.book.chapterList[index]['chapter_id'].toString();
                              Chapter().incrementChapterViewCount(widget.book.chapterList[index]['chapter_id'],widget.book.bookId);
                              _loadDocument(chap.description).then((document) {
                                setState(() {
                                  _controller = ZefyrController(document);
                                  indexOfChap = index;
                                  chapTitle = chap.title;
                                });
                              });
                              prefs.setStringList('memoryOf'+widget.book.bookId.toString(), [widget.book.bookId.toString(),index.toString()]);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.star,size: 30.0,color: Colors.black,),
                                      SizedBox(width: 10.0,),
                                      Text(widget.book.chapterList[index]['title'],style: GoogleFonts.roboto(fontSize: 18.sp),)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }else{
                          return Container();
                        }
                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: widget.book.chapterList.isNotEmpty?
      SmartRefresher(
        physics: ClampingScrollPhysics(),
        scrollController: _myScrollController,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          controller: _myScrollController2,
          scrollDirection: Axis.vertical,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment:MainAxisAlignment.start,
                children: [
                  Text(chapTitle,style: GoogleFonts.roboto(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: body
                  ),
                  SizedBox(height: 30,),
                  Container(
                    color: globals.primary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widthOfExpandableFont<=100.0?
                        FutureBuilder(
                          future: Chapter().getChapterVotes(int.parse(chapterId)),
                          builder: (context,snapshot){
                            if(snapshot.connectionState==ConnectionState.done){
                              return LikeButton(
                                // size: 0.02.sh,
                                circleColor:
                                CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                bubblesColor: BubblesColor(
                                  dotPrimaryColor: Color(0xff33b5e5),
                                  dotSecondaryColor: Color(0xff0099cc),
                                ),
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    Icons.star,
                                    color: isLiked ? Colors.yellow[200] :globals.primaryTextColor,
                                    size: 0.04.sh,
                                  );
                                },
                                onTap: onLikeButtonTapped,
                                likeCount: snapshot.data,
                                countBuilder: (int count, bool isLiked, String text) {
                                  var color = isLiked ? Colors.yellow[200] : globals.primaryTextColor;
                                  Widget result;
                                  if (count == 0) {
                                    result = Text(
                                      "Vote",
                                      style: TextStyle(color: color),
                                    );
                                  } else
                                    result = Text(
                                      ' '+text,
                                      style: TextStyle(color: color),
                                    );
                                  return result;
                                },
                              );
                            }
                            else{
                              return Container();
                            }
                          },
                        )
                            :Container(),
                        widthOfExpandableFont<=100.0?
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.share,size: 25.0,color: globals.primaryTextColor,),
                              Text('Share',style: TextStyle(color: globals.primaryTextColor,),),
                            ],
                          ),
                        ):Container(),
                        Container(
                          color: Colors.transparent,
                          width: widthOfExpandableFont,
                          child: GFAccordion(
                            collapsedTitleBackgroundColor: globals.primary,
                            onToggleCollapsed: (value){
                              if(value==true){
                                setState(() {
                                  widthOfExpandableFont=MediaQuery.of(context).size.width*0.95;
                                });
                              }
                              else{
                                setState(() {
                                  widthOfExpandableFont=100.0;
                                });
                              }
                            },
                            titleChild: Container(
                              child: Column(
                                children: [
                                  Icon(FontAwesomeIcons.font,size: 25.0,color: globals.primaryTextColor,),
                                  Text('View',style: TextStyle(color: globals.primaryTextColor,),),
                                ],
                              ),
                            ),
                            contentChild: Column(
                              children: [
                                Container(
                                  color: Colors.white60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Page Color : '),
                                      SizedBox(width: 10,),
                                      GFButton(onPressed: (){
                                        setState(() {
                                          backgroundColor = Colors.blueGrey;
                                          chapterTextColor = Colors.white;
                                        });
                                      },
                                        color: Colors.blueGrey,text: 'Blue Grey',textStyle: TextStyle(color: Colors.white),),
                                      SizedBox(width: 5,),
                                      GFButton(onPressed: (){
                                        setState(() {
                                          backgroundColor = Colors.white;
                                          chapterTextColor = Colors.black;
                                        });
                                      },
                                        type: GFButtonType.outline2x,
                                        color: Colors.black54,text: 'White',textStyle: TextStyle(color: Colors.black),),
                                      SizedBox(width: 5,),
                                      GFButton(onPressed: (){
                                        setState(() {
                                          backgroundColor = globals.primary;
                                          chapterTextColor = Colors.black;
                                        });
                                      },
                                        color: globals.primary,text: 'Custom',textStyle: TextStyle(color: Colors.black),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40,),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Comments',style: GoogleFonts.roboto(color: Colors.black,fontSize: 18.sp),),
                        Divider(thickness: 2.0,indent: 60.0,endIndent: 60.0,color: globals.primary,),
                        FutureBuilder(
                          future: Comment().getChapterComments(widget.book.chapterList[indexOfChap]['chapter_id']),
                          builder: (context,snapshot){
                            if(snapshot.connectionState==ConnectionState.done){
                              return Container(
                                height: snapshot.data.length!=0?0.3.sh:0.0.sh,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context,index){
                                      return ProfileCommentCard(comment: snapshot.data[index],isReply: false);
                                    }),
                              );
                            }
                            else{
                              return GFLoader();
                            }
                          },
                        ),
                        SizedBox(height: 0.05.sh,),
                        Center(
                          child: Container(
                              width: 0.9.sw,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                elevation: 0.0,
                                shadowColor: globals.primary,
                                child: TextFormField(
                                  obscureText: false,
                                  autofocus: false,
                                  controller: commentController,
                                  maxLength: 100,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.send,color: globals.primary,),
                                      onPressed: ()async{
                                        await Comment().postChapterComment(widget.book.chapterList[indexOfChap]['chapter_id'],commentController.text);
                                        setState(() {});
                                        commentController.text='';
                                      },
                                    ),
                                    icon: Padding(
                                      padding: EdgeInsets.fromLTRB(0.01.sw, 0.025.sh, 0.0, 0.0),
                                      child: CircleAvatar(
                                        radius: 0.025.sh,
                                        backgroundImage: NetworkImage(globals.logedInUser.image),
                                      ),
                                    ),
                                    labelText: 'Comment',
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              )
                          ),
                        ),
                        SizedBox(height: 0.02.sh,),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.7.sh,),
                ],
              ),
            ),
          ),
        ),
        enablePullDown: false,
        enablePullUp: true,
        header: WaterDropHeader(waterDropColor: Colors.transparent,),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
      ):Center(
        child: Container(
          child: Text('This book has 0 chapters yet.'),
        ),
      ),
    );
  }
}
