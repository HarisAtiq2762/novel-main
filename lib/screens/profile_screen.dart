import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:novel/main.dart';
import 'package:novel/models/announcement.dart';
import 'package:novel/models/book.dart';
import 'package:novel/models/comment.dart';
import 'package:novel/models/user.dart';
import 'package:novel/screens/AuthScreens/login.dart';
import 'package:novel/screens/book_details.dart';
import 'package:novel/screens/chat_list_screen.dart';
import 'package:novel/screens/create_book.dart';
import 'package:novel/screens/setting_screen.dart';
import 'package:novel/screens/view_followers_screen.dart';
import 'package:novel/screens/wallet_screen.dart';
import 'package:novel/screens/writerHub_screen.dart';
import 'package:novel/widgets/profileBookCard.dart';
import 'package:novel/widgets/profileCommentCard.dart';
import 'package:novel/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  TextEditingController commentController = TextEditingController();

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if(mounted)
    //   setState(() {
    //
    //   });
    setState(() {});
    _refreshController.refreshCompleted();
  }
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final styleOfTexts = GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 20.sp);
    final styleOfWorks = GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.bold);
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    String dateOfJoining = globals.logedInUser.timestamp.split(' ')[1]+' '+globals.logedInUser.timestamp.split(' ')[2]+' '+globals.logedInUser.timestamp.split(' ')[3];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.primary,
        title: Text('Profile',style: styleOfTexts,),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.facebookMessenger,color: globals.primaryTextColor,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatListScreen()));
          },
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(FontAwesomeIcons.ellipsisV,color:globals.primaryTextColor,),
            onSelected: (val){
              // print(val);
              if(val=='Wallet'){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>WalletScreen()));
              }
              else if(val=='Settings'){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingScreen()));
              }
              else if(val=='Writers Hub'){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>WriterHubScreen()));
              }
              else if(val=='Logout'){
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                main();
              }
              },
              color: Colors.white,
            itemBuilder: (context){
              return ['Settings','Logout'].map((choice) {
                return PopupMenuItem(
                    value: choice,
                    child: Text(choice)
                );
              }).toList();
            }
            ),
        ],
      ),
      body: SmartRefresher(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20.0, 10.0, 10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(globals.logedInUser.image),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Works : '+globals.logedInUser.totalBooks.toString(),style: styleOfWorks,),
                              SizedBox(height: 10,),
                              GestureDetector(
                                  onTap: ()async{
                                    List followers = await User().getFollowingList(globals.logedInUser.userId);
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewFollowersScreen(followers: followers,title: 'Followers',)));
                                  },
                                  child: Text('Followers : '+globals.logedInUser.followers.toString(),style: styleOfWorks)),
                              SizedBox(height: 10,),
                              GestureDetector(
                                  onTap: ()async{
                                    List followers = await User().getFollowersList(globals.logedInUser.userId);
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewFollowersScreen(followers: followers,title: 'Following',)));
                                  },
                                  child: Text('Following : '+globals.logedInUser.following.toString(),style: styleOfWorks)),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                    child: Text('  Bio   ',style: GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                  child: Text(
                    globals.logedInUser.bio==null?
                      '':globals.logedInUser.bio,
                    style: GoogleFonts.roboto(fontSize: 15.0.sp),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                  child: Text(
                    'Joined On: '+dateOfJoining,
                    style: GoogleFonts.roboto(fontSize: 15.0.sp),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 0.7.sw,
                        height: 0.045.sh,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: globals.primary,
                        ),
                        child: Text('  Announcements By ${globals.logedInUser.name}   ',style: GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor ),),
                      ),
                    ),
                    Container(
                      width: 0.1.sw,
                      height: 0.045.sh,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: globals.primary,
                      ),
                      child: IconButton(icon: Icon(Icons.add,color: globals.primaryTextColor,), onPressed: (){
                        myModalBottomSheetForReview();
                      }),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: Announcement().getAnnouncements(globals.logedInUser.userId),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.done){
                      return Container(
                        height: 0.2.sh,
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context,index){
                              Announcement ann = snapshot.data[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: globals.primary)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(0.01.sw),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Text('Announcement #'+(index+1).toString()),
                                            Text(ann.announcement),
                                            IconButton(icon: Icon(Icons.delete_outline_outlined), onPressed: ()async{
                                              dynamic data = await Announcement().deleteAnnouncement(ann.id);
                                              data = jsonDecode(data);
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text(data['msg']!=null?data['msg']:data['error']),
                                                backgroundColor: globals.primary,
                                                duration: Duration(seconds: 3),
                                              ));
                                            }),
                                          ],
                                        ),
                                        // Text(ann.announcement),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              return GestureDetector(
                                child: ProfileBookCard(book: snapshot.data[index],),
                                onTap: (){
                                  snapshot.data[index].bookStatusActive!='active'?null:
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDetails(book: snapshot.data[index],)));
                                },
                              );
                            }),
                      );
                    }else{
                      return GFLoader();
                    }
                  },
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 0.7.sw,
                        height: 0.045.sh,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: globals.primary,
                        ),
                        child: Text('  Stories By ${globals.logedInUser.name}   ',style: GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor ),),
                      ),
                    ),
                    Container(
                      width: 0.1.sw,
                      height: 0.045.sh,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: globals.primary,
                      ),
                      child: IconButton(icon: Icon(Icons.add,color: globals.primaryTextColor,), onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateBook()));
                      }),
                    ),
                  ],
                ),
                Container(
                  height: 0.3.sh,
                  child: FutureBuilder(
                    future: Book().getBooks(globals.logedInUser.userId),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.done){
                        return ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                child: Column(
                                  children: [
                                    ProfileBookCard(book: snapshot.data[index],),
                                    Divider(color: globals.primary,indent: 10.0,endIndent: 10.0,),
                                  ],
                                ),
                                onTap: (){
                                  snapshot.data[index].bookStatusActive!='active'?null:
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDetails(book: snapshot.data[index],)));
                                },
                              );
                            });
                      }else{
                        return GFLoader();
                      }
                    },
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
                    child: Text('  Message Board   ',style: GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor),),
                  ),
                ),
                Container(
                  height: 0.3.sh,
                  child: FutureBuilder(
                    future: Comment().getProfileComments(globals.logedInUser.userId),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.done) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return ProfileCommentCard(comment: snapshot
                                  .data[index], isReply: true);
                            });
                      }
                      else return GFLoader();
                    },
                  ),
                ),
                SizedBox(height: 0.01.sh,),
                // Center(
                //   child: Container(
                //       width: 0.9.sw,
                //       child: Material(
                //         borderRadius: BorderRadius.circular(10.0),
                //         elevation: 5.0,
                //         shadowColor: globals.primary,
                //         child: TextFormField(
                //           obscureText: false,
                //           autofocus: false,
                //           controller: commentController,
                //           maxLength: 100,
                //           decoration: InputDecoration(
                //             suffixIcon: IconButton(
                //               icon: Icon(Icons.send,color: globals.primary,),
                //               onPressed: ()async{
                //                 await Comment().postComment(commentController.text);
                //                 setState(() {});
                //                 commentController.text='';
                //                 // print('post comment');
                //               },
                //             ),
                //             icon: Padding(
                //               padding: EdgeInsets.fromLTRB(0.01.sw, 0.025.sh, 0.0, 0.0),
                //               child: CircleAvatar(
                //                 radius: 0.025.sh,
                //                 backgroundImage: NetworkImage(globals.logedInUser.image),
                //               ),
                //             ),
                //             labelText: 'Comment',
                //             fillColor: Colors.transparent,
                //             filled: true,
                //             contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                //             border: InputBorder.none,
                //             focusedBorder: InputBorder.none,
                //             enabledBorder: InputBorder.none,
                //             errorBorder: InputBorder.none,
                //             disabledBorder: InputBorder.none,
                //           ),
                //         ),
                //       )
                //   ),
                // ),
                SizedBox(height: 0.05.sh,),
              ],
            ),
          ),
        ),
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        // footer: CustomFooter(
        //   builder: (BuildContext context,LoadStatus mode){
        //     Widget body ;
        //     if(mode==LoadStatus.idle){
        //       body =  Text("pull up load");
        //     }
        //     else if(mode==LoadStatus.loading){
        //       body =  CupertinoActivityIndicator();
        //     }
        //     else if(mode == LoadStatus.failed){
        //       body = Text("Load Failed!Click retry!");
        //     }
        //     else if(mode == LoadStatus.canLoading){
        //       body = Text("release to load more");
        //     }
        //     else{
        //       body = Text("No more Data");
        //     }
        //     return Container(
        //       height: 55.0,
        //       child: Center(child:body),
        //     );
        //   },
        // ),
        controller: _refreshController,
        onRefresh: _onLoading,
        onLoading: _onLoading,
      ),
    );
  }

  void myModalBottomSheetForReview(){
    int rating=3;
    TextEditingController review = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
              height: 0.5.sh,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(icon: Icon(Icons.arrow_back_ios ), onPressed: (){Navigator.pop(context);}),
                      SizedBox(width: 0.03.sw,),
                      Text('Make Announcement',style: TextStyle(fontSize: 20.sp),),
                    ],
                  ),
                  SizedBox(height: 0.01.sh,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey.withOpacity(0.7))
                      ),
                      child: TextField(
                        controller: review,
                        maxLines: 4,
                        decoration: InputDecoration(
                            hintText: 'Announcement',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none
                        ),
                      ),
                    ),
                  ),
                  GFButton(
                    onPressed: ()async{
                      if(review.text!=null&&review.text!=''&&review.text!=' '){
                        dynamic data = await Announcement().makeAnnoucement(review.text);
                        data = jsonDecode(data);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(data['msg']!=null?data['msg']:data['error']),
                          backgroundColor: globals.primary,
                          duration: Duration(seconds: 3),
                        ));
                      }
                      else{
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('review can not be empty'),
                          duration: Duration(seconds: 3),
                        ));
                      }
                    },
                    text: 'Submit',
                    color: globals.primary,
                  ),
                ],
              )
          );
        });
  }


}
