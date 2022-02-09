import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:novel/models/book.dart';
import 'package:novel/models/news.dart';
import 'package:novel/screens/user_book_libaray.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/see_all.dart';
import 'package:novel/widgets/bookCard.dart';
import 'package:novel/widgets/myappbar.dart';
import 'package:novel/globals.dart' as globals;
class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final styleOfTexts = GoogleFonts.roboto(color: Colors.black,fontSize: 25);
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);



  void _onLoading()async{
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      globals.homeWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: News().getTopNews(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done) {
                return CarouselSlider.builder(
                    options: CarouselOptions(
                      // height: 200,
                      aspectRatio: 2.0,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index,
                        int pageViewIndex) {
                      News news = snapshot.data[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return WebView(
                                    initialUrl: news.url,
                                    javascriptMode: JavascriptMode
                                        .unrestricted,
                                  );
                                }));
                          },
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            margin: EdgeInsets.symmetric(horizontal: 0),
                            // decoration: BoxDecoration(
                            //     color: HexColor('#ffebe7')
                            // ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                  bottom: Radius.circular(20.0)),
                              child: Image.network(
                                news.image,
                                // height: MediaQuery.of(context).size.height * 0.23,
                                // alignment: Alignment(-offset.abs(), 0),
                                fit: BoxFit.cover,
                                // width: 240,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                );
              }else{
                return GFLoader();
              }
            },
          ),
          FutureBuilder(
            future: Book().getEditorsPick(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done){
                return Column(
                  children: [
                    Container(
                      color: globals.primary,//HexColor('#ffebe7'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Editor\'s Pick',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: 'Editor\'s Pick',booksList: snapshot.data,)));
                                },

                                child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 0.3.sh,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount:  snapshot.data.length,
                          itemBuilder: (context,index){
                            return BookCard(book: snapshot.data[index],);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              else{
                return GFLoader();
              }
            },
          ),
          FutureBuilder(
            future: Book().getTopStories(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done){
                return Column(
                  children: [
                    Container(
                      color: globals.primary,//HexColor('#ffebe7'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Top Stories',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Top Stories",booksList: snapshot.data,)));
                                },

                                child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 0.3.sh,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context,index){
                            return BookCard(book: snapshot.data[index],);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              else{
                return GFLoader();
              }
            },
          ),
          FutureBuilder(
            future: Book().getNewReleases(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done){
                return Column(
                  children: [
                    Container(
                      color: globals.primary,//HexColor('#ffebe7'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('New Releases',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "New Releases",booksList: snapshot.data,)));
                                },
                                child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 0.3.sh,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context,index){
                            return BookCard(book: snapshot.data[index],);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              else{
                return GFLoader();
              }
            },
          ),
          FutureBuilder(
            future: Book().getTopRomance(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done) {
                return Column(
                  children: [
                    Container(
                      color: globals.primary,//HexColor('#ffebe7'),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Top Romance',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Top Romance",booksList: snapshot.data,)));
                                },
                                child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 0.3.sh,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return BookCard(book: snapshot.data[index],);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              else{
                return GFLoader();
              }
            },
          ),
          FutureBuilder(
            future: Book().getBestWerewolf(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done){
                return Column(
                  children: [
                    Container(
                      color: globals.primary,//HexColor('#ffebe7'),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Best werewolf',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Best werewolf",booksList: snapshot.data,)));
                                },
                                child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 0.3.sh,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context,index){
                            return BookCard(book: snapshot.data[index],);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              else{
                return GFLoader();
              }
            },
          ),
          FutureBuilder(
            future: Book().getNewAdult(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done) {
                return Column(
                  children: [
                    Container(
                      color: globals.primary,//HexColor('#ffebe7'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('New Adult',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "New Adult",booksList: snapshot.data,)));
                            },

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 0.3.sh,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return BookCard(book: snapshot.data[index],);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              else{
                return GFLoader();
              }
            },
          ),
          FutureBuilder(
            future: Book().getBillionaire(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done) {
                return Column(
                  children: [
                    Container(
                      color: globals.primary,//HexColor('#ffebe7'),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Billionaire',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Billionaire",booksList:snapshot.data,)));
                                },
                                child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 0.3.sh,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return BookCard(book: snapshot.data[index],);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              else{
                return GFLoader();
              }
            },
          ),
          FutureBuilder(
            future: Book().getLiterature(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done) {
                return Column(
                  children: [
                    Container(
                      color: globals.primary,//HexColor('#ffebe7'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Literature',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Literature",booksList: snapshot.data,)));
                                },
                                child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 0.3.sh,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return BookCard(book: snapshot.data[index],);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }else return GFLoader();
            },
          ),
          FutureBuilder(
            future: Book().getHistorical(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done) {
                return Column(
                  children: [
                    Container(
                      color: globals.primary,//HexColor('#ffebe7'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Historical Fiction',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Historical Fiction",booksList: snapshot.data,)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 0.3.sh,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return BookCard(book: snapshot.data[index],);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              else return GFLoader();
            },
          ),
          SizedBox(height: 20,),
        ],
      );
    });
    _refreshController.refreshCompleted();
  }
  @override
  void initState() {
    super.initState();
  }
  Widget tempWidget = GFLoader();
  @override
  Widget build(BuildContext context) {
    Widget userbooklib = UserBookLibrary();
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    // print('building home screen');
    return Stack(
      children: [
        userbooklib,
        Scaffold(
          // backgroundColor: Colors.black,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: MyAppBar(title: 'Home',)
          ),
          // drawer: MyDrawer(),
          body: SmartRefresher(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: globals.homeWidget,
            ),
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onLoading,
            onLoading: _onLoading,
          ),
        ),
        FutureBuilder(
          future: timeLoading(),
          builder: (context,snap){
            if(snap.connectionState==ConnectionState.done){
              return Container();
            }
            else{
              return Container(
                height: 1.0.sh,
                width: 1.0.sw,
                color: Colors.white,
                child: Center(
                    child: Lottie.asset(
                        'asset/homeLoading.json',width: 0.7.sw,
                        height: 0.3.sh,
                        fit: BoxFit.fill,
                        repeat: true
                    )
                )
              );
            }
          },
        ),
      ],
    );
  }

  Future timeLoading()async{
    await Future.delayed(const Duration(seconds: 7), () {
      return Container();
    });
  }

  Widget loadData(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
          future: News().getTopNews(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done) {
              return CarouselSlider.builder(
                  options: CarouselOptions(
                    // height: 200,
                    aspectRatio: 2.0,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index,
                      int pageViewIndex) {
                    News news = snapshot.data[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(
                          0.0, 10.0, 0.0, 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return WebView(
                                  initialUrl: news.url,
                                  javascriptMode: JavascriptMode
                                      .unrestricted,
                                );
                              }));
                        },
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          // decoration: BoxDecoration(
                          //     color: HexColor('#ffebe7')
                          // ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                                bottom: Radius.circular(20.0)),
                            child: Image.network(
                              news.image,
                              // height: MediaQuery.of(context).size.height * 0.23,
                              // alignment: Alignment(-offset.abs(), 0),
                              fit: BoxFit.cover,
                              // width: 240,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              );
            }else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getEditorsPick(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Editor\'s Pick',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: 'Editor\'s Pick',booksList: snapshot.data,)));
                              },

                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount:  snapshot.data.length,
                        itemBuilder: (context,index){
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getTopStories(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Top Stories',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Top Stories",booksList: snapshot.data,)));
                              },

                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context,index){
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getNewReleases(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('New Releases',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "New Releases",booksList: snapshot.data,)));
                              },
                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context,index){
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getTopRomance(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done) {
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Top Romance',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Top Romance",booksList: snapshot.data,)));
                              },
                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getBestWerewolf(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Best werewolf',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Best werewolf",booksList: snapshot.data,)));
                              },
                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context,index){
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getNewAdult(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done) {
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('New Adult',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "New Adult",booksList: snapshot.data,)));
                          },

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getBillionaire(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done) {
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Billionaire',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Billionaire",booksList:snapshot.data,)));
                              },
                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getLiterature(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done) {
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Literature',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Literature",booksList: snapshot.data,)));
                              },
                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }else return GFLoader();
          },
        ),
        FutureBuilder(
          future: Book().getHistorical(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done) {
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Historical Fiction',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Historical Fiction",booksList: snapshot.data,)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else return GFLoader();
          },
        ),
        SizedBox(height: 20,),
      ],
    );
  }
}
