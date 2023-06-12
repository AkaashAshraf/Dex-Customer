// void _showBottomSheet() {
//   setState(() {
//     // disable the button
//     _showBottomSheetCallback = null;
//   });
//   _scaffoldKey.currentState
//       .showBottomSheet<Null>((BuildContext context) {
//         final ThemeData themeData = Theme.of(context);
//         return Container(
//           alignment: Alignment.topLeft,
//           padding: const EdgeInsets.all(10.0),
//           decoration: BoxDecoration(
//               border:
//                   Border(top: BorderSide(color: themeData.disabledColor))),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     IconButton(
//                         icon: const Icon(Icons.close),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         }),
//                     Text(
//                       'FILTER/SORTING',
//                       style: TextStyle(fontSize: 12.0, color: Colors.black26),
//                     ),
//                     _verticalD(),
//                     OutlineButton(
//                         borderSide: BorderSide(color: Colors.amber.shade500),
//                         child: const Text('CLEAR'),
//                         textColor: Colors.amber.shade500,
//                         onPressed: () {},
//                         shape: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                         )),
//                     _verticalD(),
//                     OutlineButton(
//                         borderSide: BorderSide(color: Colors.amber.shade500),
//                         child: const Text('APPLY'),
//                         textColor: Colors.amber.shade500,
//                         onPressed: () {},
//                         shape: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                         )),
//                   ],
//                 ),
//                 Container(
//                     child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       'Sort',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 17.0,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 )),
//                 Container(
//                     height: 80.0,
//                     margin: EdgeInsets.only(left: 7.0, top: 5.0),
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: <Widget>[
//                         Container(
//                           child: Card(
//                             elevation: 3.0,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       alignment: Alignment.center,
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(
//                                             'LOWEST',
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontSize: 15.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'PRICE',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'FIRST',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           child: Card(
//                             elevation: 3.0,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       padding: EdgeInsets.all(10.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(
//                                             'HEGHEST',
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontSize: 15.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'PRICE',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'FIRST',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           child: Card(
//                             elevation: 3.0,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       padding: EdgeInsets.all(10.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(
//                                             'POPULER',
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontSize: 15.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'PRICE',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'FIRST',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           child: Card(
//                             elevation: 3.0,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       padding: EdgeInsets.all(10.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(
//                                             'NEWEST',
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontSize: 15.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'PRICE',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'FIRST',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           child: Card(
//                             elevation: 3.0,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       padding: EdgeInsets.all(10.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(
//                                             'BEST',
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontSize: 15.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'PRICE',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'FIRST',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                     //listview

//                     ),
//                 _verticalDivider(),
//                 Container(
//                     child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       'Filter',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 17.0,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     _verticalDivider(),
//                     Text(
//                       'PRICE',
//                       style: TextStyle(
//                           color: Colors.black54,
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 )),

//                 /*  Container(
//         padding: const EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
//         child:  Column(
//             children: <Widget>[]
//               ..add(
//                 //
//                 // Simple example
//                 //
//                  RangeSlider(
//                   min: 0.0,
//                   max: 100.0,
//                   lowerValue: _lowerValue,
//                   upperValue: _upperValue,
//                   divisions: 5,
//                   showValueIndicator: true,
//                   valueIndicatorMaxDecimals: 1,
//                   onChanged: (double newLowerValue, double newUpperValue) {
//                     setState(() {
//                       _lowerValue = newLowerValue;
//                       _upperValue = newUpperValue;
//                     });
//                   },
//                   onChangeStart:
//                       (double startLowerValue, double startUpperValue) {
//                     print(
//                         'Started with values: $startLowerValue and $startUpperValue');
//                   },
//                   onChangeEnd: (double newLowerValue, double newUpperValue) {
//                     print(
//                         'Ended with values: $newLowerValue and $newUpperValue');
//                   },
//                 ),
//               )
//             // Add some space
//               ..add(
//                  SizedBox(height: 24.0),
//               )
//             //
//             // Add a series of RangeSliders, built as regular Widgets
//             // each one having some specific customizations
//             //
//               ..addAll(_buildRangeSliders())),
//       ),*/

//                 _verticalDivider(),
//                 Container(
//                     child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     _verticalDivider(),
//                     Text(
//                       'SELECT OFFER',
//                       style: TextStyle(
//                           color: Colors.black54,
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 )),
//                 Container(
//                     height: 50.0,
//                     margin: EdgeInsets.only(left: 7.0, top: 5.0),
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: <Widget>[
//                         Container(
//                           height: 50.0,
//                           width: 120.0,
//                           child: Card(
//                             color: Colors.pink.shade100,
//                             elevation: 3.0,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       color: Colors.pink.shade100,
//                                       alignment: Alignment.centerLeft,
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(
//                                             'Buy More,',
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontSize: 15.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'Save More',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 80.0,
//                           width: 120.0,
//                           child: Card(
//                             color: Colors.indigo.shade500,
//                             elevation: 3.0,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       alignment: Alignment.centerLeft,
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(
//                                             'Special,',
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontSize: 15.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'Price',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 80.0,
//                           width: 120.0,
//                           child: Card(
//                             color: Colors.teal.shade200,
//                             elevation: 3.0,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       alignment: Alignment.center,
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(
//                                             'Item of,',
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontSize: 15.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'The Day',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 80.0,
//                           width: 120.0,
//                           child: Card(
//                             color: Colors.yellow.shade100,
//                             elevation: 3.0,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       alignment: Alignment.centerLeft,
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(
//                                             'Buy 1,,',
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontSize: 15.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'GET 1 FREE',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     )),
//                 _verticalDivider(),
//                 Container(
//                     child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     _verticalDivider(),
//                     Text(
//                       'DISCOUNT',
//                       style: TextStyle(
//                           color: Colors.black54,
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 )),
//                 Container(
//                     height: 90.0,
//                     margin: EdgeInsets.only(left: 7.0, top: 5.0),
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: <Widget>[
//                         Container(
//                           height: 80.0,
//                           child: Card(
//                             color: Colors.white,
//                             elevation: 3.0,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       alignment: Alignment.centerLeft,
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: <Widget>[
//                                           Text(
//                                             '10%',
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontSize: 18.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'OR LESS',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 80.0,
//                           child: Card(
//                             color: Colors.white,
//                             elevation: 3.0,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       alignment: Alignment.centerLeft,
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: <Widget>[
//                                           Text(
//                                             '20%',
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontSize: 18.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'OR LESS',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 80.0,
//                           child: Card(
//                             color: Colors.white,
//                             elevation: 3.0,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       alignment: Alignment.centerLeft,
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: <Widget>[
//                                           Text(
//                                             '30%',
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontSize: 18.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'OR LESS',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 80.0,
//                           child: Card(
//                             color: Colors.white,
//                             elevation: 3.0,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Column(
//                                   children: <Widget>[
//                                     Container(
//                                       alignment: Alignment.centerLeft,
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: <Widget>[
//                                           Text(
//                                             '40%',
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontSize: 18.0,
//                                               fontWeight: FontWeight.bold,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                           _verticalDivider(),
//                                           Text(
//                                             'OR LESS',
//                                             style: TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 13.0,
//                                                 letterSpacing: 0.5),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     )),
//                 _verticalDivider(),
//                 Container(
//                     child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     _verticalDivider(),
//                     Text(
//                       'AVAILIBILITY',
//                       style: TextStyle(
//                           color: Colors.black54,
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 )),
//                 _verticalDivider(),
//                 Container(
//                     child: Align(
//                         alignment: const Alignment(0.0, -0.2),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             _verticalDivider(),
//                             Radio<int>(
//                                 value: 0,
//                                 groupValue: radioValue,
//                                 onChanged: handleRadioValueChanged),
//                             Text(
//                               'Available for this location',
//                               style: TextStyle(
//                                   color: Colors.black54,
//                                   fontSize: 14.0,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ))),
//               ]),
//         );
//       })
//       .closed
//       .whenComplete(() {
//         if (mounted) {
//           setState(() {
//             // re-enable the button
//             _showBottomSheetCallback = _showBottomSheet;
//           });
//         }
//       });
// }
