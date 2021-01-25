import 'package:flutter/material.dart';
import 'package:taskhero2/project_list_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class Join extends StatefulWidget {
  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  TextEditingController idController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController jobtitleController = TextEditingController();

  TextEditingController departmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.yellow,
                    width: 250,
                    height: 50,
                    child: TextFormField(
                      controller: idController,
                      decoration: InputDecoration(hintText: '아이디를 입력하세요'),
                    ),
                  ),
                  Container(
                    color: Colors.yellow,
                    width: 250,
                    height: 50,
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(hintText: '비밀번호를 입력하세요'),
                    ),
                  ),
                  Container(
                    color: Colors.yellow,
                    width: 250,
                    height: 50,
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: '이름 입력하세요'),
                    ),
                  ),
                  Container(
                    color: Colors.yellow,
                    width: 250,
                    height: 50,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(hintText: '이메일을 입력하세요'),
                    ),
                  ),
                  Container(
                    color: Colors.yellow,
                    width: 250,
                    height: 50,
                    child: TextFormField(
                      controller: jobtitleController,
                      decoration: InputDecoration(hintText: '직업을 입력하세요'),
                    ),
                  ),
                  Container(
                    color: Colors.yellow,
                    width: 250,
                    height: 50,
                    child: TextFormField(
                      controller: departmentController,
                      decoration: InputDecoration(hintText: '부를 입력하세요'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          join(
                              nameController.text,
                              idController.text,
                              passwordController.text,
                              emailController.text,
                              jobtitleController.text,
                              departmentController.text);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProjectList()));
                        },
                        child: Container(
                          width: 75,
                          height: 50,
                          color: Colors.blue,
                          child: Center(child: Text('회원가입')),
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProjectList()));
                        },
                        child: Container(
                          width: 75,
                          height: 50,
                          color: Colors.red,
                          child: Center(child: Text('취소')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void join(String username, String userId, String password, String email,
      String jobtitle, String department) async {
    String url = 'YOUR API';
    var body = {
      'username': username,
      'userId': userId,
      'password': password,
      'email': email,
      'jobtitle': jobtitle,
      'department': department,
    };
    var res = await http.post(url, body: body);

    var json = jsonDecode(res.body);
  }
}
