// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'provider.dart';
//
// class BackgroundAnimationPagePage extends StatelessWidget {
//   const BackgroundAnimationPagePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (BuildContext context) => BackgroundAnimationPageProvider(),
//       builder: (context, child) => const _BuildPage(),
//     );
//   }
// }
//
// class _BuildPage extends StatelessWidget {
//   const _BuildPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BackgroundAnimationPageProvider>();
//
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           Container(
//             height: 400,
//             width: 500,
//             child: AnimatedContainer(
//               duration: const Duration(seconds: 2),
//               onEnd: () => provider.onEndButton(),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: provider.begin,
//                   end: provider.end,
//                   colors: [provider.bottomColor, provider.topColor],
//                 ),
//               ),
//             ),
//           ),
//           // IconButton(
//           //   alignment: Alignment.bottomCenter,
//           //   onPressed: () => provider.changeColor(),
//           //   icon: const Icon(Icons.play_circle_filled_outlined, size: 50,color: Colors.transparent,),
//           // ),
//         ],
//       ),
//     );
//   }
// }
