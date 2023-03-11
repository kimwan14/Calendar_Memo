import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'MemoScreen.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  User? user1= FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;
  final _forkey = GlobalKey<FormState>();
  bool isSign = true;
  bool showSpinner = false;
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  void _tryVal() {
    final isValid = _forkey.currentState!.validate();
    if (isValid) {
      _forkey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: Text(
          '머더라',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
        elevation: 0,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: 180,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  padding: EdgeInsets.all(20),
                  height: isSign ? 280.0 : 250.0,
                  width: MediaQuery.of(context).size.width - 40,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 5)
                      ]),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSign = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: !isSign
                                            ? Colors.black
                                            : Colors.white24),
                                  ),
                                  if (!isSign)
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Colors.red,
                                    )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSign = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'SignUp',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: isSign
                                            ? Colors.black
                                            : Colors.white24), //삼항조건연산자 true일때 컬러를 블랙 아니면 화이트
                                  ),
                                  if (isSign)
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Colors.red,
                                    ) //ture일때 빨간 밑줄
                                ],
                              ),
                            )
                          ],
                        ),
                        if (isSign)
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Form(
                              key: _forkey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      key: ValueKey(1),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value!.length < 4) {
                                          return 'Please enter at least 4 characters';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userName = value!;
                                      },
                                      onChanged: (value) {
                                        userName = value;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.drive_file_rename_outline,
                                          color: Colors.black87,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black12),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35))),
                                        hintText: 'User Name',
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Colors.white24),
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      key: ValueKey(2),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value!.length < 4) {
                                          return 'Please enter at least email characters';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userEmail = value!;
                                      },
                                      onChanged: (value) {
                                        userEmail = value;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: Colors.black87,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black12),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35))),
                                        hintText: 'User Email',
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Colors.white24),
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      key: ValueKey(3),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value!.length < 4) {
                                          return 'Please enter at least 4 characters';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userPassword = value!;
                                      },
                                      onChanged: (value) {
                                        userPassword = value;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock_open,
                                          color: Colors.black87,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black12),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35))),
                                        hintText: 'User Password',
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Colors.white24),
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (!isSign)
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                TextFormField(
                                  key: ValueKey(4),
                                  validator: (value) {
                                    if (value!.isEmpty || value!.length < 4) {
                                      return 'Please enter at least 4 characters';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    userEmail = value!;
                                  },
                                  onChanged: (value) {
                                    userEmail = value;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: Colors.black87,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35))),
                                    hintText: 'User Email',
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Colors.white24),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  key: ValueKey(5),
                                  validator: (value) {
                                    if (value!.isEmpty || value!.length < 4) {
                                      return 'Please enter at least 4 characters';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    userPassword = value!;
                                  },
                                  onChanged: (value) {
                                    userPassword = value;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock_open,
                                      color: Colors.black87,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35))),
                                    hintText: 'User Password',
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Colors.white24),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ), //로그인 or 회원가입 창
              AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  top: isSign ? 430.0 : 390,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(50)),
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          if (isSign) {
                            try {
                              _tryVal();
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: userEmail, password: userPassword,);


                              await FirebaseFirestore.instance
                                  .collection('User2')
                                  .doc(newUser.user!.uid)
                                  .set({
                                'userEmail': userEmail,
                                'userpassword': userPassword,
                              });
                              user1 = newUser.user;
                              if (newUser.user != null) {
                                if(user1 != null) {
                                  await user1?.updateDisplayName(userName);
                                  print('사용자의 이름이 업데이트 되었습니다.');
                                } else {
                                  print('현재 로그인된 사용자가 없습니다.');
                                }

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MemoScreen()));
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Please check your email and password'
                                    ),
                                    backgroundColor: Colors.lightBlue,
                                  ));
                              setState(() {
                                showSpinner = false;
                              });
                              print(e);
                            }
                          }
                          if (!isSign) {
                            try {
                              final newUser =
                                  await _auth.signInWithEmailAndPassword(
                                      email: userEmail, password: userPassword); // signInWithEmailAndPassword 함수를 통해 이메일 인증
                              if (newUser.user != null) {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => MemoScreen()));
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            } catch (e) {
                              print(e);
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple,
                                  Colors.pinkAccent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(0, 1),
                                )
                              ]),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )) //전송 버튼
            ],
          ),
        ),
      ),
    );
  }
}
