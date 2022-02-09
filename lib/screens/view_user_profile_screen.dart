import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:novel/models/announcement.dart';
import 'package:novel/models/book.dart';
import 'package:novel/models/chat.dart';
import 'package:novel/models/comment.dart';
import 'package:novel/models/user.dart';
import 'package:novel/screens/book_details.dart';
import 'package:novel/screens/view_followers_screen.dart';
import 'package:novel/widgets/profileBookCard.dart';
import 'package:novel/widgets/profileCommentCard.dart';
import 'package:novel/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'chatScreenSocket.dart';
import 'create_book.dart';
class ViewUserProfileScreen extends StatefulWidget {
  User user;
  ViewUserProfileScreen({Key key,@required this.user}) : super(key: key);

  @override
  _ViewUserProfileScreenState createState() => _ViewUserProfileScreenState();
}

class _ViewUserProfileScreenState extends State<ViewUserProfileScreen> {

  TextEditingController commentController = TextEditingController();

  bool isFollowing=false;

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
  bool isLoaded=false;
  @override
  Widget build(BuildContext context) {
    // print(isLoaded);
    final styleOfTexts = GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 15.sp);
    final styleOfWorks = GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.bold);
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    Chat(messages: []).createRoom(widget.user.userId.toString());
    String dateOfJoining = globals.logedInUser.timestamp.split(' ')[1]+' '+globals.logedInUser.timestamp.split(' ')[2]+' '+globals.logedInUser.timestamp.split(' ')[3];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.primary,
        title: Text(widget.user.name,style: styleOfTexts,),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: globals.primaryTextColor,), onPressed: (){Navigator.pop(context);}),
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
                          backgroundImage: NetworkImage(widget.user.image),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text('Works : '+widget.user.totalBooks.toString(),style: styleOfWorks,),
                              SizedBox(height: 10,),
                              GestureDetector(
                                onTap: ()async{
                                  List followers = await User().getFollowingList(widget.user.userId);
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewFollowersScreen(followers: followers,title: 'Followers',)));
                                },
                                child: Text('Followers : '+widget.user.followers.toString(),style: styleOfWorks)),
                              SizedBox(height: 10,),
                              GestureDetector(
                                onTap: ()async{
                                  List followers = await User().getFollowersList(widget.user.userId);
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewFollowersScreen(followers: followers,title: 'Following',)));
                                },
                                child: Text('Following : '+widget.user.following.toString(),style: styleOfWorks)),
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
                    child: Text('  Bio   ',style: GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor ),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                  child: Container(
                    height: 0.1.sh,
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Text(
                        widget.user.bio==null?
                        '':widget.user.bio,
                        style: GoogleFonts.roboto(fontSize: 15.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                  child: Text(
                    'Joined On: '+dateOfJoining,
                    style: GoogleFonts.roboto(fontSize: 15.0),
                  ),
                ),
                FutureBuilder(
                  future: User().getFollowingList(widget.user.userId),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.done) {
                      for (var user in snapshot.data) {
                        if (user.userId.toString() ==
                            globals.logedInUser.userId.toString()) {
                          isFollowing = true;
                        }
                        else {
                          isFollowing = false;
                        }
                      }
                      if(widget.user.userId!=globals.logedInUser.userId){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isFollowing == false ?
                              Container(
                                width: 0.45.sw,
                                child: GFButton(
                                  onPressed: () async {
                                    await User().followUser(widget.user.userId);
                                    setState(() {
                                      isFollowing = true;
                                      widget.user.followers++;
                                    });
                                  },
                                  color: globals.primary,
                                  text: 'Follow',
                                  fullWidthButton: true,
                                  type: GFButtonType.outline,
                                  textStyle: TextStyle(
                                    fontSize: 15.0.sp, color: globals.primary,),
                                ),
                              ) : Container(
                                width: 0.45.sw,
                                child: GFButton(
                                  onPressed: () async {
                                    await User().unFollowUser(widget.user.userId);
                                    setState(() {
                                      isFollowing = false;
                                      if (widget.user.followers > 0) {
                                        widget.user.followers--;
                                      }
                                    });
                                  },
                                  color: globals.primary,
                                  text: 'Un Follow',
                                  fullWidthButton: true,
                                  type: GFButtonType.outline,
                                  textStyle: TextStyle(
                                    fontSize: 15.0.sp, color: globals.primary,),
                                ),
                              ),
                              SizedBox(width: 0.06.sw,),
                              Container(
                                width: 0.45.sw,
                                child: GFButton(
                                  onPressed: () async {
                                    var messageHistory = await Chat(messages: []).getAllChatFromUser(widget.user.userId.toString());
                                    dynamic data = await Chat(messages: []).createRoom(widget.user.userId.toString());
                                    // print(widget.user.userId);
                                    // print(data['roomname']);
                                    // print(messageHistory);
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>BuildWithSocketStream(pastMessages: messageHistory, roomName: data!=null?data['roomname']:'',)));
                                  },
                                  color: globals.primary,
                                  fullWidthButton: true,
                                  text: 'Message',
                                  textStyle: TextStyle(
                                    fontSize: 15.0.sp, color: globals.primary,),
                                  type: GFButtonType.outline,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else{
                        return Container();
                      }
                    }
                    return GFLoader();
                  },
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
                        child: Text('  Stories By ${widget.user.name}   ',style: GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor ),),
                      ),
                    ),
                    globals.logedInUser.userId==widget.user.userId?
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
                    ):Container(),
                  ],
                ),
                Container(
                  height: 0.3.sh,
                  child: FutureBuilder(
                    future: Book().getBooks(widget.user.userId),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.done) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              if(snapshot.data[index].bookStatusPublish!='unpublished') {
                                return GestureDetector(
                                  child: ProfileBookCard(
                                    book: snapshot.data[index],),
                                  onTap: () {
                                    snapshot.data[index].bookStatusActive !=
                                        'active' ? null :
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            BookDetails(
                                              book: snapshot.data[index],)));
                                  },
                                );
                              }
                              return Container();
                            });
                      }
                      else{
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
                    child: Text('  Announcements By ${widget.user.name}   ',style: GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor ),),
                  ),
                ),
                Container(
                  height: 0.3.sh,
                  child: FutureBuilder(
                    future: Announcement().getAnnouncements(widget.user.userId),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.done){
                        return ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
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
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(ann.announcement),
                                        IconButton(icon: Icon(Icons.notifications_none_outlined), onPressed: null),
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
                    child: Text('  Message Board   ',style: GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor ),),
                  ),
                ),
                // isLoaded==false?
                Container(
                  height: 0.3.sh,
                  child: FutureBuilder(
                    future: Comment().getProfileComments(widget.user.userId),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.done) {
                        isLoaded = true;
                        return ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return ProfileCommentCard(comment: snapshot.data[index], isReply: false);
                            });
                      }
                      else{
                        return GFLoader();
                      }
                    },
                  ),
                ),
                // ListView.builder(
                //     physics: NeverScrollableScrollPhysics(),
                //     shrinkWrap: true,
                //     itemCount: globals.profileComments.length,
                //     itemBuilder: (context, index) {
                //       return ProfileCommentCard(comment: globals.profileComments[index], isReply: true);
                //     }),
                SizedBox(height: 0.01.sh,),
                Center(
                  child: Container(
                      width: 0.9.sw,
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        elevation: 5.0,
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
                                await Comment().postComment(commentController.text,widget.user.userId);
                                setState(() {});
                                commentController.text='';
                                // print('post comment');
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

}
