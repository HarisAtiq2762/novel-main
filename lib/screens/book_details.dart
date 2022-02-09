import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:novel/models/book.dart';
import 'package:novel/models/chapter.dart';
import 'package:novel/models/review.dart';
import 'package:novel/models/user.dart';
import 'package:novel/screens/chapters_screen.dart';
import 'package:novel/screens/user_book_libaray.dart';
import 'package:novel/screens/view_user_profile_screen.dart';
import 'package:novel/widgets/myTags.dart';
import 'package:novel/widgets/profileCommentCard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:novel/models/comment.dart';
import 'package:novel/globals.dart' as globals;
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class BookDetails extends StatefulWidget {

  Book book;
  BookDetails({@required this.book});
  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  // dynamic bookmarkIcon = Icon(Icons.bookmark_border,size: 0.05.sh,color: HexColor('#cc7471,);

  TextEditingController commentController = TextEditingController();
  List<Comment> newComments = [];

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
        return data;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    final styleOfTexts = GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 25.sp);
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    globals.bookId = widget.book.bookId;
    return SafeArea(
      child: Scaffold(
        backgroundColor: globals.primary,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: globals.primary,
          title: Text('Book Details',style: styleOfTexts,),
          leading: IconButton(
            icon:Icon(Icons.arrow_back_ios),
            color: globals.primaryTextColor, onPressed: () { Navigator.pop(context); },
          ),
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            // height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(0.040.sh))
            ),
            child: Column(
              children: [
                SizedBox(height: 0.05.sh,),
                Container(
                  width: 0.4.sw,
                  height: 0.25.sh,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(0.020.sh)
                  ),
                  child: ClipRRect(
                    // borderRadius: BorderRadius.vertical(top: Radius.circular(0.020.sh),bottom: Radius.circular(0.020.sh)),
                    child: Image.network(
                      widget.book.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 0.05.sh,),
                    Center(
                      child: Container(
                        // color: Colors.black.withOpacity(0.1),
                        width: 0.9.sw,
                        child: Center(
                          child: Text(
                            widget.book.bookTitle,
                            style: GoogleFonts.aladin(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0.sp,
                                  letterSpacing: 1
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.020.sh,),
                    Center(
                      child: GestureDetector(
                        onTap: ()async{
                          User user = await User().getUserDetails(widget.book.authorId);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewUserProfileScreen(user: user)));
                        },
                        child: Container(
                          color: globals.primary.withOpacity(0.5),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '  '+widget.book.author+'  ',
                              style: GoogleFonts.aladin(
                                textStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15.0.sp,
                                    letterSpacing: 1
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.020.sh,),
                    FutureBuilder(
                      future: getBookViewsVotesTotalChapters(),
                      builder: (context,snapshot){
                        if(snapshot.connectionState==ConnectionState.done) {
                          var views = snapshot.data['total_views'][0]['views'];
                          var votes = snapshot.data['total_votes'][0]['votes'];
                          var totalChapters = snapshot
                              .data['total_chapters'][0]['chapters'];
                          return Container(
                            width: 1.0.sw,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(CupertinoIcons.eye),
                                      SizedBox(width: 0.02.sw,),
                                      Text(views.toString() + ' Reads'),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(CupertinoIcons.star_fill),
                                      SizedBox(width: 0.02.sw,),
                                      Text(votes.toString() + ' Votes'),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(
                                          CupertinoIcons.list_bullet_below_rectangle),
                                      SizedBox(width: 0.02.sw,),
                                      Text(widget.book.chapterList.length.toString() +
                                          ' Parts'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        else return GFLoader();
                      },
                    ),
                    SizedBox(height: 0.030.sh,),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        child: Text(
                          widget.book.description,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0.sp,
                                letterSpacing: 1
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.030.sh,),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        child: Text(
                          'Genre: '+widget.book.genre,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0.sp,
                                letterSpacing: 1
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.030.sh,),
                    Container(
                      width: 1.0.sw,
                      height: 0.05.sh,
                      child: ListView.builder(
                        itemCount: widget.book.tags.split('#').length-1,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context,index){
                          return Padding(
                            padding: EdgeInsets.fromLTRB(0.02.sw, 0.0, 0.0, 0.0),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: globals.primary,
                                ),
                                child: Text('#'+widget.book.tags.split('#')[index+1],style: GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5 ,color: globals.primaryTextColor),),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 30,),
                    Center(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GFButton(
                                shape: GFButtonShape.pills,
                                icon: Icon(CupertinoIcons.book_fill,color: globals.primary,),
                                type: GFButtonType.outline2x,
                                color: globals.primary,
                                text: 'Read Now',
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChaptersScreen(book: widget.book)));
                              }
                            ),
                            globals.addToLibrary,
                            GFButton(
                              onPressed: ()async{
                                myModalBottomSheetForReview(widget.book.bookId);
                                // await Book().addBookToLibrary(widget.book.bookId);
                              },
                              shape: GFButtonShape.pills,
                              icon: Icon(CupertinoIcons.star_fill,color: globals.primary,),
                              type: GFButtonType.outline2x,
                              color: globals.primary,
                              text: 'Add Review',
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 0.01.sh,),
                    GFAccordion(
                        title: 'Chapters',
                        textStyle: GoogleFonts.roboto(color: Colors.black,fontSize: 18.sp),
                        contentChild: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.book.chapterList.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChaptersScreen(book: widget.book,chapterListIndex:index,chapterId:widget.book.chapterList[index]['chapter_id'],fromList: true,)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        widget.book.chapterList[index]['publish_status']=='unpublished'?Container():
                                        Text(widget.book.chapterList[index]['title'],style: GoogleFonts.roboto(color: Colors.black,fontSize: 15.sp)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ),
                    SizedBox(height: 0.01.sh,),
                    Row(
                      children: [
                        StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setState) =>
                              Checkbox(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  checkColor: Colors.white,
                                  activeColor: globals.primary,
                                  value: widget.book.mature=='true'?true:false,
                                  onChanged: (val) {}),
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
                                  checkColor: Colors.white,
                                  activeColor: globals.primary,
                                  value: widget.book.complete=='true'?true:false,
                                  onChanged: (val) {}),
                        ),

                        Text('  Completed   ',style: GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5 ),)
                      ],
                    ),
                    SizedBox(height: 0.01.sh,),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('Reviews',style: GoogleFonts.roboto(color: Colors.black,fontSize: 18.sp),),
                          SizedBox(width: 0.01.sw,),
                          Consumer<Review>(
                            builder: (context,review,child){
                              return FutureBuilder(
                                future: getReviewAvg(),
                                builder: (context,snapshot){
                                  if(snapshot.connectionState==ConnectionState.done){
                                    dynamic rating = snapshot.data;
                                    return Row(
                                      children: [
                                        SmoothStarRating(
                                          starCount: 5,
                                          isReadOnly: true,
                                          spacing: 0.01.sw,
                                          rating: double.parse(rating!=null?rating.toString():'0.0'),
                                          color: Colors.yellow,
                                        ),
                                        Text(rating!=null?rating.toString():'0.0',style: GoogleFonts.roboto(color: Colors.black,fontSize: 14.sp)),
                                      ],
                                    );
                                  }
                                  else{
                                    return Container();
                                  }
                                },
                              );
                            },
                          ),

                        ],
                      ),
                    ),
                    Divider(thickness: 2.0,indent: 60.0,endIndent: 60.0,color: globals.primary,),
                    Container(
                      height: 0.3.sh,
                      child: Consumer<Review>(
                        builder: (context,review,child){
                          return FutureBuilder(
                            future: Book().getBookReviews(widget.book.bookId),
                            builder: (context,snapshot){
                              if(snapshot.connectionState==ConnectionState.done){
                                List _reviews = snapshot.data;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _reviews.length,
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder: (context,index){
                                      Review tempReview = _reviews[index];
                                      return FutureBuilder(
                                        future: User().getUserDetails(tempReview.userId),
                                        builder: (context,snapshot){
                                          User userData = snapshot.data;
                                          if(snapshot.connectionState==ConnectionState.done){
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: globals.primary,
                                                    ),
                                                    borderRadius: BorderRadius.circular(10.0)
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width:0.2.sw,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 0.03.sh,
                                                            backgroundImage: NetworkImage(userData.image),
                                                          ),
                                                          Text(userData.name,style: TextStyle(color: Colors.blueGrey,fontSize: 14.sp)),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 0.57.sw,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SmoothStarRating(
                                                            starCount: tempReview.rating,
                                                            isReadOnly: true,
                                                            spacing: 0.01.sw,
                                                            rating: tempReview.rating.toDouble(),
                                                            color: Colors.yellow,
                                                          ),
                                                          SizedBox(height: 0.005.sh),
                                                          Text(tempReview.text!=null?tempReview.text:'',style: TextStyle(color: Colors.blueGrey,fontSize: 16.sp),),
                                                          SizedBox(height: 0.005.sh),
                                                          Text(tempReview.timestamp.substring(0,16),style: TextStyle(color: Colors.blueGrey,fontSize: 10.sp),),
                                                        ],
                                                      ),
                                                    ),
                                                    IconButton(icon: Icon(Icons.delete_outline_outlined), onPressed: (){
                                                      review.deleteReview(widget.book.bookId);
                                                    })
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          return Container();
                                        },
                                      );
                                    },
                                  ),
                                );
                              }
                              else{
                                return GFLoader();
                              }
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 0.01.sh,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void myModalBottomSheetForReview(int bookId){
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
                      Text('Rate Book',style: TextStyle(fontSize: 20.sp),),
                    ],
                  ),
                  SmoothStarRating(
                    color: Colors.yellow,
                      borderColor: Colors.yellow,
                      allowHalfRating: false,
                      onRated: (v) {
                        rating = int.parse(v.toString()[0]);
                      },
                      starCount: 5,
                      rating: 3,
                      size: 40.0,
                      isReadOnly:false,
                      filledIconData: Icons.star,
                      spacing:1.0
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
                          hintText: 'Enter review',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none
                        ),
                      ),
                    ),
                  ),
                  GFButton(
                    onPressed: ()async{
                      if(review.text!=null&&review.text!=''&&review.text!=' '){
                        dynamic data = await Book().giveRating(widget.book.bookId.toString(), rating,review.text);
                        data = jsonDecode(data);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(data['msg']!=null?data['msg']:data['error']),
                          backgroundColor: globals.primary,
                          duration: Duration(seconds: 3),
                        ));
                      }
                      else{
                        // Navigator.pop(context);
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

  Future getReviewAvg()async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'book_avg_rating_api'));
    request.body = json.encode({
      "book_id": widget.book.bookId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      return data['rating']['rating'];
    }
    else {
      print(response.reasonPhrase);
    }
  }

}
