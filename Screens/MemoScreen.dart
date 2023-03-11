import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Model/Memo_Model.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({Key? key}) : super(key: key);

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  final User? user = FirebaseAuth.instance.currentUser; // 현재 사용자의 값을 변수에 user에 대입
  bool state = false;
  User? logger;
  final _auth = FirebaseAuth.instance;
  final _con1 = TextEditingController();
  final _con2 = TextEditingController();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime selectdDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime focusedDay = DateTime.now();

  final CollectionReference _usersStream =
      FirebaseFirestore.instance.collection('User2');

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('Memo');

  @override
  void initState() {
    // TODO: implement initState
    Firebase.initializeApp();
    super.initState();
    getCur();
  }

  @override
  void dispose() {
    super.dispose();
    _con1.dispose();
    _con2.dispose();
  }

  void getCur() {
    try {
      final user = _auth.currentUser; //사용자 정보
      if (user != null) {
        //사용자 정보가 null이 아니면 실행
        logger = user; //logger 참조 변수에 user (사용자 정보 데이터) 대입
        print(logger!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  saveDataToFirebase(DateTime day, String tt, String mm, User? user) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(day);
    if (user != null) {
      final String Uid = user.uid.toString();

      String memoDocPath = "$Uid/$formattedDate";

      FirebaseFirestore.instance.doc(memoDocPath).get().then((docSnapshot) {
        if (docSnapshot.exists) {
          // 기존 데이터가 존재하는 경우
          List<dynamic> titleList = docSnapshot.data()!['title'];
          List<dynamic> memoList = docSnapshot.data()!['memo'];
          List<dynamic> timeList = docSnapshot.data()!['time'];

          titleList.add(tt);
          memoList.add(mm);
          timeList.add(day);

          FirebaseFirestore.instance.doc(memoDocPath).update({
            'title': titleList,
            'memo': memoList,
            'time': timeList,
          });
        } else {
          // 기존 데이터가 없는 경우
          FirebaseFirestore.instance.doc(memoDocPath).set({
            'title': [tt],
            'memo': [mm],
            'time': [day],
          });
        }
      });
      return;
    }
  }

  Future<List<MemoData>> _getModelDataFromFirebase(
      DateTime day, User? user) async {
    if (user != null) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedDate = formatter.format(day);
      final String userID = user.uid.toString();
      String memoDocPath = "$userID/$formattedDate";

      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance.doc(memoDocPath).get();

      if (docSnapshot.exists) {
        // Document(문서)에 데이터가 존재하면 실행
        final List<dynamic> titleList = docSnapshot.data()!['title'];
        final List<dynamic> memoList = docSnapshot.data()!['memo'];
        final List<dynamic> timeList = docSnapshot.data()!['time'];

        final List<MemoData> modelList = []; //MemoData 타입 modelList 생성

        for (int i = 0; i < titleList.length; i++) {
          //MemoData타입 리스트에 각 요소별로 반복문을 통해서 대입
          MemoData model = MemoData(
            title: titleList[i],
            memo: memoList[i],
            time: timeList[i].toDate(),
          );
          modelList.add(model); //위의 추가한 변수를 리스트에 추가
        }

        return modelList;
      } else {
        return [];
      }
    }
    return [];
  }

  Widget buildDrawer(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('image/loveCat.gif'),
              backgroundColor: Colors.white,
            ),
            accountEmail: Text(user!.email.toString()),
            accountName: user != null
                ? Text('닉네임: ' + user.displayName.toString())
                : Text('user is null'),
            onDetailsPressed: () {
              state = true;
            },
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40)),
            ),
          ),
        ],
      ),
    );
  } //왼쪽 카테고리

  void FlutterDialog() {
    if (user != null) {
      showDialog(
          useRootNavigator: false,
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Column(
                children: [
                  Text('Memo'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      key: ValueKey(1),
                      controller: _con1,
                      maxLines: null,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter charact';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.margin,
                          size: 20,
                          color: Colors.black87,
                        ),
                        hintText: '제목을 입력하세요',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _con2,
                      maxLines: null,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter charact';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.black87,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        hintText: '내용을 입력하세요',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    child: Text('취소'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                ElevatedButton(
                    child: Text('저장'),
                    onPressed: () {
                      if (user != null) {
                        saveDataToFirebase(
                            focusedDay, _con1.text, _con2.text, user);
                      } else {
                        debugPrint('error');
                      }
                    })
              ],
            );
          });
    }
  } // Dialog

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: _usersStream.snapshots(),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: user != null
                    ? Text(user.displayName.toString() + '의 메모장')
                    : Text('정보음슴'),
                actions: [
                  IconButton(
                      onPressed: () {
                        _auth.signOut();
                        // Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.exit_to_app_sharp,
                        color: Colors.black,
                      ))
                ],
              ),
              drawer: buildDrawer(context), //카테고리 만들어 놓은 위젯 가져옴
              body: Container(
                child: FutureBuilder<List<MemoData>>(
                  future: _getModelDataFromFirebase(focusedDay, user),
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        TableCalendar<MemoData>(
                          firstDay: DateTime.utc(1900),
                          lastDay: DateTime.utc(2150),
                          focusedDay: focusedDay,
                          onDaySelected:
                              (DateTime selectDay, DateTime focuseDay) {
                            setState(() {
                              this.selectdDay = selectDay;
                              this.focusedDay = focuseDay;
                            });
                          },
                          //eventLoader: (day) async => _getModelDataFromFirebase(day),

                          selectedDayPredicate: (DateTime day) {
                            return isSameDay(selectdDay, day);
                          },
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder(
                              stream: _products.snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child:
                                        CircularProgressIndicator(), //waiting 표시 함수
                                  );
                                }

                                Future<void> _deleteDoc(
                                    DateTime day,User? user, int index) async {
                                 // if(user != null){
                                  final String formattedDate =
                                      formatter.format(day);
                                  final String Uid = user!.uid.toString();
                                  String memoDocPath = "$Uid/$formattedDate";

                                  FirebaseFirestore.instance
                                      .doc(memoDocPath)
                                      .get()
                                      .then((value) async {
                                    if (value.exists) {
                                      List<dynamic> list1 =
                                          value.data()!['title'];
                                      List<dynamic> list2 =
                                          value.data()!['memo'];
                                      List<dynamic> list3 =
                                          value.data()!['time'];

                                      list1.removeAt(index); // 해당 인덱스의 값을 삭제함
                                      list2.removeAt(index); // 해당 인덱스의 값을 삭제함
                                      list3.removeAt(index); // 해당 인덱스의 값을 삭제함

                                      await FirebaseFirestore.instance
                                          .doc(memoDocPath)
                                          .update({
                                        'title': list1,
                                        'memo': list2,
                                        'time': list3
                                      });
                                    } else {
                                      return null;
                                    }
                                  });

                                  // 수정된 리스트를 문서에 업데이트함
                                }

                                void _showDialog(DateTime day, int idx) {
                                  showDialog(
                                      useRootNavigator: false,
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          title: Column(
                                            children: [
                                              Text('Memo'),
                                            ],
                                          ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextFormField(
                                                  key: ValueKey(1),
                                                  controller: _con1,
                                                  maxLines: null,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter charact';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(
                                                      Icons.margin,
                                                      size: 20,
                                                      color: Colors.black87,
                                                    ),
                                                    hintText: '제목을 입력하세요',
                                                    hintStyle: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                TextFormField(
                                                  controller: _con2,
                                                  maxLines: null,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter charact';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(
                                                      Icons.mail,
                                                      color: Colors.black87,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                    hintText: '내용을 입력하세요',
                                                    hintStyle: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                child: Text('취소'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                }),
                                            // ElevatedButton(
                                            //     child: Text('수정'),
                                            //     onPressed: () {
                                            //       saveDataToFirebase(focusedDay,
                                            //           _con1.text, _con2.text);
                                            //     }),
                                          ],
                                        );
                                      });
                                }

                                return FutureBuilder<List<MemoData>>(
                                  future: _getModelDataFromFirebase(
                                      focusedDay, user), //Future : 인자에는 비동기 적으로 실행될 함수를 전달하고 그 함수가 완료될 때까지 기다린 다음 반환된 결과를 가지고 빌드 메서드를 호출한다
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onLongPress: () {},
                                              child: ListTile(
                                                title: Text(snapshot
                                                    .data![index].title),
                                                subtitle: Text(
                                                    snapshot.data![index].memo),
                                                trailing: IconButton(
                                                  icon: Icon(Icons.delete,
                                                      color: Colors.red),
                                                  onPressed: () => _deleteDoc(
                                                      focusedDay,user, index),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        return ListTile(
                                            title: Text("데이터가 없습니다"));
                                      }
                                    }
                                    return Center(
                                        child: CircularProgressIndicator());
                                  },
                                );
                              }),
                        )
                      ],
                    );
                  },
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => FlutterDialog(), //버튼 누르면 위에 만들어 놓은 Dialog위젯함수 실행
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              )

              // This trai

              );
        });
  }
}
