import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:novel/globals.dart' as globals;
import 'package:novel/models/auth.dart';
import 'package:novel/models/search.dart';
import 'package:novel/screens/searchResults.dart';
import 'package:novel/widgets/categories_widget.dart';
import 'package:novel/widgets/see_all.dart';
class SearchScreen extends StatelessWidget {
  SearchScreen({Key key}) : super(key: key);

  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final styleOfTexts = GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 18.sp);
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.primary,
        title: Text('Search',style: styleOfTexts,),
        leading: IconButton(
          icon:Icon(Icons.arrow_back_ios),
          color: globals.primaryTextColor, onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                decoration: BoxDecoration(
                  border: Border.all(color: globals.primary),
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: TextField(
                  controller: searchController,
                  onEditingComplete: ()async{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Searching Please Wait"),
                      duration: Duration(milliseconds: 2500),
                    ));
                    Search search = await Search().getSearchResult(searchController.text,context);
                    // print(search.genre);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchResults(search: search,)));
                    Search().saveHistory(searchController.text,context);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search stories, peoples or genres',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 140,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: globals.primary),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.history),
                    Text('  History   ',style: GoogleFonts.roboto(fontSize: 16.0.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5 ),),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: Search().getHistory(),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.done) {
                  return Container(
                    width: 1.0.sw,
                    height: 0.06.sh,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: ()async{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Searching Please Wait"),
                              duration: Duration(milliseconds: 2500),
                            ));
                            Search search = await Search().getSearchResult(snapshot.data[index]['keyword'],context);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchResults(search: search,)));
                            Search().saveHistory(snapshot.data[index]['keyword'],context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: globals.primary,
                              ),
                              child: Center(
                                child: Text(
                                  '  ${snapshot.data[index]['keyword']}   ',
                                  style: GoogleFonts.roboto(fontSize: 15.0.sp,
                                      fontWeight: FontWeight.w500,
                                      wordSpacing: 0.5,
                                    color: globals.primaryTextColor
                                  ),),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                else{
                  return GFLoader();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 137,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: globals.primary),
                ),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.magento),
                    Text('  Genre   ',style: GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5 ),),
                  ],
                ),
              ),
            ),
            Container(
              height: 0.15.sh,
              width: MediaQuery.of(context).size.width,
                child: Categories()
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 157,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: globals.primary),

                ),
                child: Row(
                  children: [
                    Icon(Icons.tag),
                    Text('  Top Tags   ',style: GoogleFonts.roboto(fontSize: 15.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5 ),),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: Search().getTopTags(),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.done){
                  return Tags(
                    itemCount: snapshot.data.length,
                    itemBuilder: (int index){
                      return Tooltip(
                        decoration: BoxDecoration(
                          color: globals.primary
                        ),
                          message: '  #'+snapshot.data[index]+'   ',
                          child:ItemTags(
                            activeColor: globals.primary,
                            title:'  #'+snapshot.data[index]+'   ', index: index,
                            color: globals.primary,
                            textColor: globals.primaryTextColor,
                            onPressed: (val)async{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Searching Please Wait"),
                                duration: Duration(milliseconds: 2500),
                              ));
                              List books = await Search().getTagSearchResults(snapshot.data[index]);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "#"+snapshot.data[index],booksList: books,)));
                            },
                          )
                      );
                    },
                  );
                  return Container(
                    width: 1.0.sw,
                    height: 0.06.sh,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: ()async{
                              List books = await Search().getTagSearchResults(snapshot.data[index]);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "#"+snapshot.data[index],booksList: books,)));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: globals.primary,
                              ),
                              child: Center(child: Text('  #'+snapshot.data[index]+'   ',style: GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.w500,color: globals.primaryTextColor),softWrap: true,)),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) => new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: ()async{
                          List books = await Search().getTagSearchResults(snapshot.data[index]);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "#"+snapshot.data[index],booksList: books,)));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: globals.primary,
                          ),
                          child: Center(child: Text('  #'+snapshot.data[index]+'   ',style: GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.w500,color: globals.primaryTextColor),softWrap: true,)),
                        ),
                      ),
                    ),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 0.17.sh,
                        crossAxisSpacing: 0.008.sw,
                        mainAxisSpacing: 0.008.sh,
                      // childAspectRatio: 0.0025.sh
                  ),
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 3,
                  //     crossAxisSpacing: 0.008.sw,
                  //     mainAxisSpacing: 0.008.sh,
                  //     childAspectRatio: 0.0025.sh
                  // ),
                  );
                }else{
                  return GFLoader();
                }
              },
            ),
            SizedBox(height: 0.2.sh,)
          ],
        ),
      ),
    );
  }
}
