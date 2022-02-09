import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
class WalletScreen extends StatelessWidget {
  const WalletScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styleOfTexts = GoogleFonts.roboto(color: Colors.black,fontSize: 25);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#cc7471'),
        title: Text('Wallet',style: styleOfTexts,),
        leading: IconButton(
          icon:Icon(Icons.arrow_back_ios),
          color: Colors.black, onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: HexColor('#cc7471')
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.attach_money),
                      Center(
                          child: Text('Coins = 2000',style: styleOfTexts,)),
                    ],
                  )
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: HexColor('#cc7471')
                  ),
                  child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.history),
                              SizedBox(width: 5,),
                              Text('Transaction History',style: styleOfTexts,),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ))
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: HexColor('#cc7471')
                  ),
                  child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lock_open_outlined),
                              SizedBox(width: 5,),
                              Text('Chapter Unlocked',style: styleOfTexts,),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ))
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: HexColor('#cc7471')
                  ),
                  child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.hourglassHalf),
                              SizedBox(width: 5,),
                              Text('Expiry Date',style: styleOfTexts,),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ))
              ),
            ),
          ),
        ],
      ),
    );
  }
}
