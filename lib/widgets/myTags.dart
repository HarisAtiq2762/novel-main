import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
class MyTags extends StatefulWidget {
  const MyTags({Key key}) : super(key: key);

  @override
  _MyTagsState createState() => _MyTagsState();
}

class _MyTagsState extends State<MyTags> {
  List _items;
  double _fontSize = 14;

  @override
  void initState(){
    super.initState();
    // if you store data on a local database (sqflite), then you could do something like this
  }
  @override
  Widget build(BuildContext context) {
    return Tags(
      key:_tagStateKey,
      textField: TagsTextField(
        textStyle: TextStyle(fontSize: _fontSize),
        constraintSuggestion: true, suggestions: [],
        //width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 10),
        onSubmitted: (String str) {
          // Add item to the data source.
          setState(() {
            // required
            _items.add(str);
          });
        },
      ),
      itemCount: _items.length, // required
      itemBuilder: (int index){
        final item = _items[index];

        return ItemTags(
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(index.toString()),
          index: index, // required
          title: item.title,
          active: item.active,
          customData: item.customData,
          textStyle: TextStyle( fontSize: _fontSize, ),
          combine: ItemTagsCombine.withTextBefore,
          image: ItemTagsImage(
              image: AssetImage("img.jpg") // OR NetworkImage("https://...image.png")
          ), // OR null,
          icon: ItemTagsIcon(
            icon: Icons.add,
          ), // OR null,
          removeButton: ItemTagsRemoveButton(
            onRemoved: (){
              // Remove the item from the data source.
              setState(() {
                // required
                _items.removeAt(index);
              });
              //required
              return true;
            },
          ), // OR null,
          onPressed: (item) => print(item),
          onLongPressed: (item) => print(item),
        );

      },
    );
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
}







