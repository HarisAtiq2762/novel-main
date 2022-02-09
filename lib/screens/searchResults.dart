import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:novel/models/search.dart';
import 'package:novel/models/user.dart';
import 'package:novel/widgets/peoplesCard.dart';
import 'package:novel/widgets/profileBookCard.dart';
import 'package:novel/globals.dart' as globals;
import 'book_details.dart';

class SearchResults extends StatefulWidget {
  static const routeName = '/SearchResults';
  Search search;
  SearchResults({@required this.search});
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    final styleOfTexts = GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 18.sp);
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon:Icon(Icons.arrow_back_ios),
              color: globals.primaryTextColor, onPressed: () { Navigator.pop(context); },
            ),
            backgroundColor: globals.primary,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              child: Text("Search Results",style: styleOfTexts,),
            ),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  child: Text('Books',style: TextStyle(color: globals.primaryTextColor)),
                ),
                Tab(
                  child: Text('Peoples',style: TextStyle(color: globals.primaryTextColor)),
                ),
                Tab(
                  child: Text('Genre/Tags',style: TextStyle(color: globals.primaryTextColor)),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.search.data.length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      child: Stack(
                        children: [
                          ProfileBookCard(book: widget.search.data[index],),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 0.09.sw,
                                height: 0.04.sh,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: globals.primary.withOpacity(0.9),
                                ),
                                child: Center(child: Text('# '+ '${index+1}',style: GoogleFonts.montserrat(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500),))),
                          ),
                        ],
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDetails(book: widget.search.data[index],)));
                      },
                    );
                  }),
              widget.search.peoples.length>0?
              ListView.builder(
                itemCount: widget.search.peoples.length,
                itemBuilder: (context,index){
                  User user = widget.search.peoples[index];
                  return PeopleCard(user: user,);
                },
              ):Center(
                child: Text('No Results Found'),
              ),
              Container(
                height: 0.05.sh,
                child: widget.search.genre.length>0?
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.search.genre.length,
                    itemBuilder: (context,index){
                      return GestureDetector(
                        child: Stack(
                          children: [
                            ProfileBookCard(book: widget.search.genre[index],),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width: 0.09.sw,
                                  height: 0.04.sh,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: globals.primary.withOpacity(0.9),
                                  ),
                                  child: Center(child: Text('# '+ '${index+1}',style: GoogleFonts.montserrat(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500),))),
                            ),
                          ],
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDetails(book: widget.search.data[index],)));
                        },
                      );
                    }):Center(
                  child: Text('No Results Found'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}