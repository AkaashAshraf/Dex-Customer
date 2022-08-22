// import 'package:flutter/material.dart';
// import 'package:flutter_rating/flutter_rating.dart';

// class RateCard extends StatelessWidget {
//   final String title;
//   final double rate;
//   RateCard({this.title, this.rate});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: new BoxDecoration(
//         boxShadow: [
//           new BoxShadow(
//             color: Colors.black,
//             blurRadius: 20.0,
//           ),
//         ],
//       ),
//       child: Card(
//         child: Column(
//           children: [
//             Text(title),
//             StarRating(
//               rating: rate,
//               size: 40,
//               starCount: 5,
//               color: Theme.of(context).secondaryHeaderColor,
//               onRatingChanged: (rate) {
//                 setState(() {
//                   rateShop = rate;
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
