import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:like_button/like_button.dart';
import 'package:novel/models/comment.dart';
import 'package:novel/globals.dart' as globals;
import 'package:novel/models/like.dart';
import 'package:novel/widgets/peoplesCard.dart';
import 'package:intl/intl.dart';
class ProfileCommentCard extends StatefulWidget {
  Comment comment;
  bool isReply=false;
  ProfileCommentCard({Key key,@required this.comment,this.isReply}) : super(key: key);

  @override
  _ProfileCommentCardState createState() => _ProfileCommentCardState();
}

class _ProfileCommentCardState extends State<ProfileCommentCard> {
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String dateAndTime = widget.comment.timestamp!=null?widget.comment.timestamp.substring(4).replaceAll(' GMT', ''):'';
    // print(DateTime.utc(int.parse(dateAndTime[3].toString().replaceAll(' ', '')),int.parse(dateAndTime[1].toString().replaceAll(' ', ''))));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: globals.primary),
            borderRadius: BorderRadius.circular(0.02.sh)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 10,),
            Container(
              child: CircleAvatar(
                radius: 0.03.sh,
                backgroundImage: NetworkImage(
                  widget.comment.userimage,
                  // width: 240,
                ),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // height: ScreenUtil().setHeight(300.0),
                      width: ScreenUtil().setWidth(250),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                widget.comment.name,
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellow[900]),
                            ),
                            Text(
                              dateAndTime,
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      )
                  ),
                  Container(
                      width: ScreenUtil().setWidth(250),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Text(
                              widget.comment.comment
                          ),
                        ),
                      )
                  ),
                  SizedBox(height: 10,),
                  FutureBuilder(
                    future: Comment().getCommentLikeAndReplyCount(widget.comment.commentId),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.done){
                        return Row(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  LikeButton(
                                    // size: 0.02.sh,
                                    circleColor:
                                    CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                    bubblesColor: BubblesColor(
                                      dotPrimaryColor: Color(0xff33b5e5),
                                      dotSecondaryColor: Color(0xff0099cc),
                                    ),
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.thumb_up,
                                        color: isLiked ? Colors.yellow[900] : Colors.black,
                                        size: 0.02.sh,
                                      );
                                    },
                                    onTap: onLikeButtonTapped,
                                    likeCount: snapshot.data['num_of_likes'][0]['likes'],
                                    countBuilder: (int count, bool isLiked, String text) {
                                      var color = isLiked ? Colors.yellow[900] : Colors.black;
                                      Widget result;
                                      if (count == 0) {
                                        result = Text(
                                          "Like",
                                          style: TextStyle(color: color),
                                        );
                                      } else
                                        result = GestureDetector(
                                          onTap: ()async{
                                            List likerList = await Comment().getCommentLikersList(widget.comment.commentId);
                                            myModalBottomSheetForLikerList(likerList);
                                          },
                                          child: Text(
                                            text,
                                            style: TextStyle(color: color),
                                          ),
                                        );
                                      return result;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 25,),
                            widget.isReply==false?
                            GestureDetector(
                              onTap: (){
                                myModalBottomSheet(snapshot.data['num_of_reply'][0]['reply'].toString(),snapshot.data['num_of_likes'][0]['likes'].toString());
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(FontAwesomeIcons.comment),
                                    SizedBox(width: 0.02.sw,),
                                    Text(snapshot.data['num_of_reply'][0]['reply']==0?'Reply':snapshot.data['num_of_reply'][0]['reply'].toString()),
                                  ],
                                ),
                              ),
                            ):Container(),
                            globals.logedInUser.userId==widget.comment.userId?
                            Container(
                              child: IconButton(
                                icon: Icon(Icons.delete,color: Colors.black,),
                                onPressed: ()async{
                                  dynamic data;
                                  print(widget.isReply);
                                  if(widget.isReply==true) {
                                    data = await Comment().replyDelete(widget.comment.replyId);
                                  }
                                  else
                                    data = await Comment().commentDelete(widget.comment.commentId);
                                  data = jsonDecode(data);
                                  print(data);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(data['msg']),
                                    duration: Duration(milliseconds: 3000),
                                  ));
                                },
                              ),
                            ):Container(),
                          ],
                        );
                      }
                      else{
                        return GFLoader();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void myModalBottomSheet(String replyCount,String commentCount){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: 0.8.sh,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(icon: Icon(Icons.arrow_back_ios ), onPressed: (){Navigator.pop(context);}),
                    Text(replyCount,style: TextStyle(fontSize: 20.sp,color: Colors.yellow[900]),),
                    SizedBox(width: 0.03.sw,),
                    Text('Replies',style: TextStyle(fontSize: 20.sp),),
                  ],
                ),
                SizedBox(height: 0.01.sh,),
                ListView(
                  shrinkWrap: true,
                  children: [
                    ProfileCommentCard(comment: widget.comment),
                    Container(
                      height: 0.4.sh,
                      child: FutureBuilder(
                        future: Comment().listOfReplies(widget.comment.commentId),
                        builder: (context,snapshot){
                          // print(snapshot.data);
                          if(snapshot.connectionState==ConnectionState.done){
                            return Padding(
                              padding: EdgeInsets.fromLTRB(0.1.sw, 0.0, 0.0, 0.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context,index){
                                  return ProfileCommentCard(comment: snapshot.data[index],isReply: true,);
                                },
                              ),
                            );
                          }
                          else{
                            return GFLoader();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 0.01.sh,),
                    Center(
                      child: Container(
                          width: 0.9.sw,
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            elevation: 10.0,
                            shadowColor: Color(0xffDFB2A9),
                            child: TextFormField(
                              obscureText: false,
                              autofocus: false,
                              controller: commentController,
                              maxLength: 100,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.send,color: Color(0xffDFB2A9),),
                                  onPressed: ()async{
                                    // Comment().postComment(commentController.text);
                                    // print(widget.comment.commentId);
                                    await Comment().replyToAComment(commentController.text, widget.comment.commentId);
                                    Navigator.pop(context);
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
                    SizedBox(height: 0.01.sh,),
                  ],
                )
              ],
            ),
          );
        });
  }
  void myModalBottomSheetForLikerList(List likers){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: 0.8.sh,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(icon: Icon(Icons.arrow_back_ios ), onPressed: (){Navigator.pop(context);}),
                    Text(likers.length.toString(),style: TextStyle(fontSize: 20.sp,color: Colors.yellow[900]),),
                    SizedBox(width: 0.03.sw,),
                    Text('Likes',style: TextStyle(fontSize: 20.sp),),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: likers.length,
                  itemBuilder: (context,index){
                    return PeopleCard(user: likers[index]);
                  },
                ),
              ],
            )
          );
        });
  }
  Future<bool> onLikeButtonTapped(bool isLiked) async{
    /// send your request here
    await Like().likeOrDislikeComment(widget.comment.commentId);
    await Like().getLikerList(widget.comment.commentId);
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }
}
