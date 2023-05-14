import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';
import 'package:graduation_project/Models/app_config.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import '../../Models/digital_parser.dart';
import '../../Models/functions.dart';
import 'package:path/path.dart';
import 'dart:async';
part 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(CalculatorInitial()) {
    startPosition = endPosition = controller.text.length;
    userExpr = controller.text;
    testCalculatorHistory = List.empty(growable: true);
  }

  String expr = '';
  late String userExpr;
  String pattern = '';
  String result = '0';
  String binResult = '0';
  String octResult = '0';
  String decResult = '0';
  String hexResult = '0';
  String curentNumerSystem = 'bin';
  bool isResultExist = false;
  bool isSigned = true;

  late int startPosition, endPosition;

  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  late List<Map<String, String>> testCalculatorHistory;
  // List<Map<String, String>> testCalculatorHistory = [
  //   {
  //     'expr': '1 AND 2 OR 3',
  //     'system': 'dec',
  //   },
  //   {
  //     'expr': '1 AND 2 OR 3',
  //     'system': 'oct',
  //   },
  //   {
  //     'expr': '11 AND 10 OR 101',
  //     'system': 'bin',
  //   },
  //   {
  //     'expr': '1 AND 2 OR 3',
  //     'system': 'dec',
  //   },
  //   {
  //     'expr': '1 AND F OR A1',
  //     'system': 'hex',
  //   },
  //   {
  //     'expr': '1 AND 2 OR 3',
  //     'system': 'dec',
  //   },
  //   {
  //     'expr': '1 AND 2 OR 3',
  //     'system': 'oct',
  //   },
  //   {
  //     'expr': '11 AND 10 OR 101',
  //     'system': 'bin',
  //   },
  //   {
  //     'expr': '1 AND 2 OR 3',
  //     'system': 'dec',
  //   },
  //   {
  //     'expr': '1 AND F OR A1',
  //     'system': 'hex',
  //   },
  //   {
  //     'expr': '1 AND 2 OR 3',
  //     'system': 'dec',
  //   },
  //   {
  //     'expr': '1 AND 2 OR 3',
  //     'system': 'oct',
  //   },
  //   {
  //     'expr': '11 AND 10 OR 101',
  //     'system': 'bin',
  //   },
  //   {
  //     'expr': '1 AND 2 OR 3',
  //     'system': 'dec',
  //   },
  //   {
  //     'expr': '1 AND F OR A1',
  //     'system': 'hex',
  //   },
  // ];
  int tmp = 0;
  final _auth = FirebaseAuth.instance;
  late User signInUser; //this get current user
  final _history = FirebaseFirestore.instance.collection('history');
  @override

  /*void getCurrentUser(){
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signInUser = user;
        print(user.email);
      }
    }catch(e){
      print(e);
    }
  }
   */
  Future<void> addUserHistory(xtext) {
    return _history
        .add({
          'operation': xtext, // add history
          'user': _auth.currentUser?.email //currentuser
          ,
          'type': curentNumerSystem
        })
        .then((value) => print("User History Added"))
        .catchError((error) => print("Failed to add user History: $error"));
  }

  Future<void> getHistoryData() async {
    testCalculatorHistory.clear();
    CollectionReference HistroyData =
        FirebaseFirestore.instance.collection('history');
    await HistroyData.where("user", isEqualTo: _auth.currentUser?.email)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        testCalculatorHistory.add(
          {
            'expr': element.get('operation'),
            'system': element.get('type'),
          },
        );
      });
    });
    emit(CalculatorExprUpdate());
  }

  void check() {
    try {
      // print(expr);
      Parser p = Parser(expr, curentNumerSystem);
      tmp = p.sampleParser();
      if (p.error) {
        binResult = "Math Error";
        decResult = "Math Error";
        hexResult = "Math Error";
        octResult = "Math Error";
      } else {
        if (isSigned) {
          binResult = tmp.toRadixString(2).toString();
          decResult = tmp.toString();
          hexResult = tmp.toRadixString(16).toString();
          octResult = tmp.toRadixString(8).toString();
        } else {
          binResult = BigInt.from(tmp).toUnsigned(32).toRadixString(2);
          decResult = tmp.toString();
          hexResult = BigInt.from(tmp).toUnsigned(32).toRadixString(16);
          octResult = BigInt.from(tmp).toUnsigned(32).toRadixString(8);
        }
      }
    } catch (e) {
      result = e.toString();
    }
  }

  // void updateExpr(String str, String userStr) {
  //   String temp = userExpr.substring(endPosition);
  //   isResultExist = false;
  //   result = 'No Result';
  //   //if (expr.isEmpty) userExpr = '';
  //   expr += str;
  //   userExpr = userExpr.substring(0, startPosition);
  //   userExpr += userStr;
  //   startPosition = endPosition = userExpr.length;
  //   userExpr += temp;
  //   check();
  //   emit(CalculatorExprUpdate());
  // }

  void updateExpr(String str, String userStr, String pattern) {
    focusNode.requestFocus();
    if (isResultExist) clearAll();
    if (startPosition != controller.selection.start ||
        endPosition != controller.selection.end) {
      startPosition = controller.selection.start;
      endPosition = controller.selection.end;
    }
    String temp = controller.text.substring(endPosition);
    controller.text = controller.text.substring(0, startPosition) + userStr;
    print('text+str: ${controller.text}, ($startPosition, $endPosition)');
    controller.text += temp;

    userExpr = controller.text;
    expr += str;

    this.pattern = this.pattern.substring(0, startPosition) +
        pattern +
        this.pattern.substring(endPosition);
    startPosition = endPosition = controller.text.length;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: endPosition));
    print(this.pattern);
    check();
    emit(CalculatorExprUpdate());
  }

  void getResult() {
    focusNode.requestFocus();
    print(_auth.currentUser?.email);
    Parser p = Parser(expr, curentNumerSystem);
    tmp = p.sampleParser();
    if (!(p.error)) {
      switch (curentNumerSystem) {
        case "bin":
          {
            result = decToBinary(tmp);
          }
          break;
        case "hex":
          {
            result = decToHex(tmp);
          }
          break;
        case "oct":
          {
            result = decToOctal(tmp);
          }
          break;
        default:
          {
            result = tmp.toString();
          }
      }
      addUserHistory(controller.text);
    } else
      result = "Math Error";

    isResultExist = true;
    emit(CalculatorResult());

    // createData();
    // insertToDatabase();
  }

  void clearAll() {
    focusNode.requestFocus();
    isResultExist = false;
    controller.text = '';
    expr = '';
    pattern = '';
    userExpr = '';
    startPosition = endPosition = userExpr.length;
    emit(CalculatorExprUpdate());
  }

  void del() {
    focusNode.requestFocus();
    if (startPosition == endPosition) {
      if (pattern[startPosition - 1] == " ") startPosition--;
      switch (pattern[startPosition - 1]) {
        case "o":
          {
            int end = startPosition - 1;
            int start = startPosition - 1;
            while (pattern[end + 1] == 'o') {
              end++;
              if (end + 1 >= pattern.length - 1) break;
            }
            while (pattern[start - 1] == 'o') {
              start--;
              if (start == 0) break;
            }
            controller.text = controller.text.substring(0, start - 1) +
                controller.text.substring(end + 2, controller.text.length);
            pattern = pattern.substring(0, start - 1) +
                pattern.substring(end + 2, pattern.length);
          }
          break;
        case "n":
          {
            if (pattern[startPosition - 1] == " ") startPosition--;

            controller.text = controller.text.substring(0, startPosition - 1) +
                controller.text
                    .substring(startPosition, controller.text.length);
            pattern = pattern.substring(0, startPosition - 1) +
                pattern.substring(startPosition, pattern.length);
          }
          break;
        default:
          {
            expr = expr.substring(0, expr.length - 1);
            check();
          }
      }
    } else {
      if (pattern[startPosition] == " ") startPosition++;
      if (pattern[endPosition - 1] == " ") endPosition--;

      int end = endPosition - 1;
      int start = startPosition;
      if (pattern[endPosition - 1] == 'o') {
        if (end < pattern.length - 1) {
          while (pattern[end + 1] == 'o') {
            end++;
            if (end + 1 >= pattern.length - 1) break;
          }
        }
      }
      if (pattern[startPosition] == 'o') {
        while (pattern[start - 1] == 'o') {
          start--;
          if (start == 0) break;
        }
      }

      if (pattern[startPosition] == 'n') {
        start = startPosition;
      }
      if (pattern[endPosition - 1] == 'n') {
        end = endPosition - 2;
      }
      controller.text = controller.text.substring(0, start) +
          controller.text.substring(end + 2, controller.text.length);
      pattern = pattern.substring(0, start) +
          pattern.substring(end + 2, pattern.length);
    }

    emit(CalculatorExprUpdate());
    check();
    startPosition = endPosition = controller.text.length;
  }

  void changeNumberSystem(String system) {
    focusNode.requestFocus();
    if (system == 'bin') {
      curentNumerSystem = 'bin';
      result = binResult;
    } else if (system == 'oct') {
      curentNumerSystem = 'oct';
      result = octResult;
    } else if (system == 'dec') {
      curentNumerSystem = 'dec';
      result = decResult;
    } else {
      curentNumerSystem = 'hex';
      result = hexResult;
    }
    emit(CalculatorNumberSystemChange());
    emit(CalculatorResult());
  }

  void isSignedChanger() {
    focusNode.requestFocus();
    isSigned = !isSigned;
    emit(CalculatorIsSignedChange());
  }

  void setExpr(String expr) {
    controller.text = expr;
    // call the generateExpr()
    // check();
    emit(CalculatorExprUpdate());
  }

  void showHistory(
    BuildContext context,
    String theme,
  ) async {
    await getHistoryData();
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocBuilder<CalculatorCubit, CalculatorState>(
        buildWhen: (previous, current) => current is CalculatorHistoryUpdate,
        builder: (context, state) => ListView.builder(
          itemCount: testCalculatorHistory.length,
          itemBuilder: (context, index) => Dismissible(
            key: Key('cal$index'),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) => testCalculatorHistory.removeAt(index),
            confirmDismiss: (direction) => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: const Text('Are you sure ,you want to delete it?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: theme == 'light'
                          ? ThemeColors.lightBlackText
                          : ThemeColors.darkWhiteText,
                    ),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      testCalculatorHistory.removeAt(index);
                      emit(CalculatorHistoryUpdate());
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: ThemeColors.redColor,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
            background: Container(
              color: ThemeColors.redColor,
              child: Row(
                children: [
                  SizedBox(
                    width: SizeConfig.widthBlock! * 2,
                  ),
                  const Icon(
                    Icons.delete,
                    color: ThemeColors.darkWhiteText,
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              color: ThemeColors.redColor,
              child: Row(
                children: [
                  SizedBox(
                    width: SizeConfig.widthBlock! * 2,
                  ),
                  const Icon(
                    Icons.delete,
                    color: ThemeColors.darkWhiteText,
                  ),
                ],
              ),
            ),
            child: ListTile(
              onTap: () {
                setExpr(testCalculatorHistory[index]['expr']!);
                Navigator.of(context).pop();
              },
              title: Text(
                testCalculatorHistory[index]['expr']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                softWrap: true,
              ),
              textColor: (theme == 'light')
                  ? ThemeColors.lightForegroundTeal
                  : ThemeColors.darkForegroundTeal,
              tileColor: (theme == 'light')
                  ? ThemeColors.lightCanvas
                  : ThemeColors.darkCanvas,
            ),
          ),
        ),
      ),
    );
  }
  // void changePosition(int start, int end) {
  //   startPosition = start;
  //   endPosition = end;
  // }

  /*void createData()async {

     database = await openDatabase(
      join(await getDatabasesPath(), 'history.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE data(id INTEGER PRIMARY KEY ,operation TEXT,user TEXT,type TEXT)')
            .then((value) {
          print('table created');
        }).catchError((Error) {
          print(Error.toString);
        });
      },
      onOpen: (db) {
        print('table open');
      },
    );

  }
  void insertToDatabase(){
     database.transaction((txn)async{
      await txn.rawInsert('INSERT INTO data( operation , user , type ) VALUES("1+2" , "eslam@gmail.com" , "dic" ) ').then((value){
        print("$value insert succssefly");
      }).catchError((error){
        print("error when insert $error");
      });

    });
  }

   */
}
