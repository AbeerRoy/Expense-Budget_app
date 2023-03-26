import 'dart:io';
import './widgets/chart.dart';
import 'package:flutter/material.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // //using setPreffered orientations app is restricted from being used in landscape
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fontScaleFactor = MediaQuery.of(context).textScaleFactor;
    return MaterialApp(
      title: 'Budget App',
      home: HomePage(),
      theme: ThemeData(
          //textTheme: GoogleFonts.latoTextTheme(),
          primaryColor: Color.fromARGB(255, 0, 95, 150),
          fontFamily: 'Lato',
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: 'Lato',
                fontSize: 25 * fontScaleFactor,
                fontWeight: FontWeight.bold),
            elevation: 15,
          )),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  //Hardcoded Transaction list preset for display and format

  @override
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'Display',
    //   amount: 40.00,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'DDR3 RAM',
    //   amount: 18.00,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't3',
    //   title: 'Medicine',
    //   amount: 65.00,
    //   date: DateTime.now(),
    // ),
  ];
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  bool _showChart = false;

  @override
  void initState() {
    // to trigger the lifecycle states we have to call initstate just to fetch the data
    WidgetsBinding.instance
        .addObserver(this); //adds the observer to check state
    super.initState();
  }

  @override
  //when ever app lifecycle changes the function gets triggered
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    //disposes any running app lifecycle state
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //dynamically updates user transactions using setState in the stateful widget
  void _addNewTransaction(
      String txTitle, double txAmount, DateTime selectedDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: selectedDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      //appends user input the list of transactions after triggering runtime and updates transactions
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext modalContext) {
    showModalBottomSheet(
      context: modalContext,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(addnewTransaction: _addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
        // return NewTransaction(
        //   addnewTransaction: (_addNewTransaction),
        // );
      },
    );
  }

  // To delete an Item from the list

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget transactionListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const FittedBox(
            child: Text(
              'Show Chart',
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 138, 138, 138),
                // fontSize: 25 * curScaleFactor,
              ),
            ),
          ),
          Switch.adaptive(
              value: _showChart,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                setState(() {
                  _showChart = value;
                });
              }),
        ],
      ),
      _showChart //if value is true
          ? Container(
              //Having appBar as variable we accessed appBar height and subtracted appBar height based on the device default dimention using 'prefferedSize'
              height:
                  (mediaQuery.size.height - appBar.preferredSize.height) * 0.65,
              child: Chart(_recentTransactions))
          : // if _showChart is false only list wiil be shown
          //User Input of title and amount
          // //List view of the total transactions
          transactionListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget transactionListWidget) {
    return [
      Container(
        //Having appBar as variable we accessed appBar height and subtracted appBar height based on the device default dimention using 'prefferedSize'
        height: (mediaQuery.size.height - appBar.preferredSize.height) * 0.35,
        child: Chart(_recentTransactions),
      ),
      transactionListWidget
    ];
  }

  // Widget appBar() {
  //   return AppBar(
  //     backgroundColor: Color.fromARGB(255, 0, 95, 150),
  //     title: const Text('Budget App'),
  //     actions: <Widget>[
  //       IconButton(
  //         onPressed: () => _startAddNewTransaction(context),
  //         icon: Icon(Icons.add, color: Colors.white),
  //       )
  //     ],
  //   );
  // }

  // Widget iosAppBar() {
  //   return CupertinoNavigationBar(
  //     middle: const Text(
  //       'Personal Expenses',
  //     ),
  //     trailing: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         GestureDetector(
  //           child: Icon(CupertinoIcons.add),
  //           onTap: () => _startAddNewTransaction(context),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    //storing context of media query in one variable instead of rerendering
    var mediaQuery = MediaQuery.of(context);

    //final prefferedSize = mediaQuery.size.aspectRatio * 0.15;
    //saves bool value of the orientation, landscape or Portrait
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    // final preferredSize = PreferredSizeWidget;

    // storing the appBar as an variable(object) makes us access the height and dimentions of object
    final appBar = AppBar(
      backgroundColor: Color.fromARGB(255, 0, 95, 150),
      title: const Text('Budget App'),
      actions: <Widget>[
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: Icon(Icons.add, color: Colors.white),
        )
      ],
    );

    final iosAppBar = CupertinoNavigationBar(
      middle: const Text(
        'Personal Expenses',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
          ),
        ],
      ),
    );
    //Transaction list is stored in a widget variable for reuse
    final transactionListWidget = Container(
      //Having appBar as variable we accessed appBar height and subtracted appBar height based on the device default dimention using 'prefferedSize'
      height: (mediaQuery.size.height - appBar.preferredSize.height) * 0.65,
      child: TransactionList(
          transactions: _userTransactions,
          deleteTransaction: _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Displays a barchart of the transactions
            //Use toggle switch to display chart if in landscape
            if (isLandscape)
              ..._buildLandscapeContent(
                  mediaQuery, appBar, transactionListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(
                  mediaQuery, appBar, transactionListWidget),
          ],
        ),
      ),
    );
    //if (Platform.isIOS) iosAppBar;
    //if (Platform.isAndroid) appBar;

    //conditional for IOS app Bar
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: iosAppBar,
          )
        : Scaffold(
            appBar: appBar,
            //SingleChildScrollView makes the column nested scrollable in same page
            body: pageBody,
            //can be done without LayoutBuilder
            floatingActionButton:
                LayoutBuilder(builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (Platform.isAndroid || Platform.isWindows)
                    Container(
                      height: constraints.maxHeight * 0.15,
                      child: FloatingActionButton(
                        onPressed: () => _startAddNewTransaction(context),
                        backgroundColor: Color.fromARGB(255, 0, 95, 150),
                        child: const Icon(
                          Icons.list,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              );
            }),
          );
  }
}

// @override
// Widget build(BuildContext context) {
//   final mediaQuery = MediaQuery.of(context);
//   final isLandscape = mediaQuery.orientation == Orientation.landscape;
//   final appBar = AppBar(
//     backgroundColor: Color.fromARGB(255, 0, 95, 150),
//     title: Text('Budget App'),
//     actions: <Widget>[
//       IconButton(
//         onPressed: () => _startAddNewTransaction(context),
//         icon: Icon(Icons.add, color: Colors.white),
//       )
//     ],
//   );
//   // final PreferredSizeWidget appBar =

//   final PreferredSizeWidget iosAppBar = CupertinoNavigationBar(
//     middle: Text(
//       'Personal Expenses',
//     ),
//     trailing: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         GestureDetector(
//           child: Icon(CupertinoIcons.add),
//           onTap: () => _startAddNewTransaction(context),
//         ),
//       ],
//     ),
//   );
//   if (Platform.isIOS) iosAppBar;
//   if (Platform.isAndroid) appBar;
//   // : AppBar(
//   //     title: Text(
//   //       'Personal Expenses',
//   //     ),
//   //     actions: <Widget>[
//   //       IconButton(
//   //         icon: Icon(Icons.add),
//   //         onPressed: () => _startAddNewTransaction(context),
//   //       ),
//   //     ],
//   //   );
//     final transactionListWidget = Container(
//       //Having appBar as variable we accessed appBar height and subtracted appBar height based on the device default dimention using 'prefferedSize'
//       height: (mediaQuery.size.height - appBar.preferredSize.height) * 0.65,
//       child: TransactionList(
//           transactions: _userTransactions,
//           deleteTransaction: _deleteTransaction),
//     );
//     final pageBody = SafeArea(
//       child: SingleChildScrollView(
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             if (isLandscape)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     'Show Chart',
//                     style: Theme.of(context).textTheme.titleSmall,
//                   ),
//                   Switch.adaptive(
//                     activeColor: Theme.of(context).primaryColor,
//                     value: _showChart,
//                     onChanged: (val) {
//                       setState(() {
//                         _showChart = val;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             if (!isLandscape)
//               Container(
//                 height: (mediaQuery.size.height -
//                         appBar.preferredSize.height -
//                         mediaQuery.padding.top) *
//                     0.35,
//                 child: Chart(_recentTransactions),
//               ),
//             if (!isLandscape) transactionListWidget,
//             if (isLandscape)
//               _showChart
//                   ? Container(
//                       height: (mediaQuery.size.height -
//                               appBar.preferredSize.height -
//                               mediaQuery.padding.top) *
//                           0.65,
//                       child: Chart(_recentTransactions),
//                     )
//                   : transactionListWidget
//           ],
//         ),
//       ),
//     );
//     return
//         //conditional for IOS app Bar
//         // Platform.isIOS
//         //     ? CupertinoPageScaffold(
//         //         child: pageBody,
//         //         navigationBar: iosAppBar,
//         //       ) :
//         Scaffold(
//       appBar: appBar,
//       body: pageBody,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: Platform.isIOS
//           ? Container()
//           : LayoutBuilder(builder: (context, constraints) {
//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   if (Platform.isAndroid || Platform.isWindows)
//                     Container(
//                       padding: EdgeInsets.all(8.0),
//                       height: constraints.maxHeight * 0.15,
//                       child: FloatingActionButton(
//                         onPressed: () => _startAddNewTransaction(context),
//                         backgroundColor: Color.fromARGB(255, 0, 95, 150),
//                         child: Icon(
//                           Icons.list,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }),
//     );
//   }
// }
