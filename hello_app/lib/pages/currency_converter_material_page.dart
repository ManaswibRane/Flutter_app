import 'package:flutter/material.dart';

class CurrencyConverterMaterialPage extends StatelessWidget{

  const CurrencyConverterMaterialPage({super.key});
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        body:ColoredBox(
          color: Color.fromRGBO(100, 100, 199, 0.5),
          child: Center(
           child:Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('01',
                style: TextStyle(fontSize: 60,fontWeight: FontWeight.bold),),
                
              ],
              
        )
        ) ,
        )
        
      );
  }
}