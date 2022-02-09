import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:novel/models/search.dart';
import 'package:novel/widgets/see_all.dart';
class Categories extends StatelessWidget {
  const Categories({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: [
        SizedBox(width: 0.03.sw,),
        GestureDetector(
          onTap: ()async{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Searching Please Wait"),
              duration: Duration(milliseconds: 2500),
            ));
            List books = await Search().searchBookByGenre('Adventure');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Adventure",booksList: books,)));
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('asset/adventure.png',width: 0.22.sw)
          ),
        ),
        SizedBox(width: 0.03.sw,),
        GestureDetector(
          onTap: ()async{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Searching Please Wait"),
              duration: Duration(milliseconds: 2500),
            ));
            List books = await Search().searchBookByGenre('Drama');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Drama",booksList: books,)));
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('asset/Drama.png',width: 0.22.sw)
          ),
        ),
        SizedBox(width: 0.02.sw,),
        GestureDetector(
          onTap: ()async{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Searching Please Wait"),
              duration: Duration(milliseconds: 2500),
            ));
            List books = await Search().searchBookByGenre('Historical Fiction');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "History",booksList: books,)));
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('asset/History.png',width: 0.22.sw)
          ),
        ),
        SizedBox(width: 0.02.sw,),
        GestureDetector(
          onTap: ()async{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Searching Please Wait"),
              duration: Duration(milliseconds: 2500),
            ));
            List books = await Search().searchBookByGenre('Horror');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Horror",booksList: books,)));
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('asset/horror.png',width: 0.22.sw)
          ),
        ),
        SizedBox(width: 0.02.sw,),
        GestureDetector(
          onTap: ()async{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Searching Please Wait"),
              duration: Duration(milliseconds: 2500),
            ));
            List books = await Search().searchBookByGenre('Urban Legend');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Legends",booksList: books,)));
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('asset/legends.png',width: 0.22.sw)
          ),
        ),
        SizedBox(width: 0.02.sw,),
        GestureDetector(
          onTap: ()async{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Searching Please Wait"),
              duration: Duration(milliseconds: 2500),
            ));
            List books = await Search().searchBookByGenre('Poetry');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Poetry",booksList: books,)));
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('asset/poetry.png',width: 0.22.sw)
          ),
        ),
        SizedBox(width: 0.02.sw,),

        GestureDetector(
          onTap: ()async{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Searching Please Wait"),
              duration: Duration(milliseconds: 2500),
            ));
            List books = await Search().searchBookByGenre('Crime');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Crime",booksList: books,)));
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('asset/Crime.png',width: 0.22.sw)
          ),
        ),
        SizedBox(width: 0.02.sw,),

        GestureDetector(
          onTap: ()async{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Searching Please Wait"),
              duration: Duration(milliseconds: 2500),
            ));
            List books = await Search().searchBookByGenre('Fantasy');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Fantasy",booksList: books,)));
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('asset/Fantasy.png',width: 0.22.sw)
          ),
        ),
        SizedBox(width: 0.02.sw,),

        GestureDetector(
          onTap: ()async{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Searching Please Wait"),
              duration: Duration(milliseconds: 2500),
            ));
            List books = await Search().searchBookByGenre('Mystery');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Mystery",booksList: books,)));
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('asset/Mystrey.png',width: 0.22.sw)
          ),
        ),
        SizedBox(width: 0.02.sw,),

        GestureDetector(
          onTap: ()async{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Searching Please Wait"),
              duration: Duration(milliseconds: 2500),
            ));
            List books = await Search().searchBookByGenre('Romance');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Romance",booksList: books,)));
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('asset/Romance.png',width: 0.22.sw)
          ),
        ),
        SizedBox(width: 0.02.sw,),

        GestureDetector(
          onTap: ()async{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Searching Please Wait"),
              duration: Duration(milliseconds: 2500),
            ));
            List books = await Search().searchBookByGenre('Science');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Science",booksList: books,)));
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('asset/Science.png',width: 0.22.sw)
          ),
        ),
        SizedBox(width: 0.02.sw,),

        GestureDetector(
          onTap: ()async{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Searching Please Wait"),
              duration: Duration(milliseconds: 2500),
            ));
            List books = await Search().searchBookByGenre('Short Stories');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Short stories",booksList: books,)));
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('asset/short stories.png',width: 0.22.sw)
          ),
        ),
        SizedBox(width: 0.02.sw,),

        GestureDetector(
          onTap: ()async{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Searching Please Wait"),
              duration: Duration(milliseconds: 2500),
            ));
            List books = await Search().searchBookByGenre('Thriller');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Thriller",booksList: books,)));
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.asset('asset/thriller.png',width: 0.22.sw)
          ),
        ),
        SizedBox(width: 0.02.sw,),
      ],
    );
  }
}
