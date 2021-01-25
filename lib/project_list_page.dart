import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:taskhero2/join_page.dart';

// ProjectData 클래스
class ProjectData {

  final int projectNo;
  final String title;
  final String memo;
  final String date;

  // 생성자
  ProjectData(this.projectNo, this.title, this.memo, this.date);
}

class ProjectList extends StatefulWidget {
  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {

  // 텍스트컨트롤러 클래스를 사용함.
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController titleController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  TextEditingController editTitleController = TextEditingController();
  TextEditingController editMemoController = TextEditingController();

  // type이 ProjectData인 projectList를 만든다.
  List<ProjectData> _projectList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단바 로그인 여부에 따라서 보여주는 화면이 바뀐다.
          window.localStorage['_isLogin'] == 'true'
              ? _buildLogoutForm()
              : _buildLoginForm(),
          // 그리드
          window.localStorage['_isLogin'] == 'true'
              ? _buildProjectList()
              : _buildGuset(),
        ],
      ),
    );
  }

  // 로그아웃 위젯.
  Widget _buildLogoutForm() {
    return Container(
      color: Colors.blueAccent,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이디 비밀번호 입력칸.
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Container(
                  color: Colors.white,
                  width: 100,
                  height: 25,
                  child: Text('UserName'),
                ),
                SizedBox(
                  width: 25,
                ),
                InkWell(
                  onTap: () {
                    // 버튼 클릭시 로그아웃.
                    window.localStorage['_isLogin'] = 'false';
                    setState(() {});
                  },
                  child: Container(
                    color: Colors.white,
                    width: 100,
                    height: 25,
                    child: Text('로그아웃'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      color: Colors.blueAccent,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이디 비밀번호 입력칸.
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Container(
                  color: Colors.white,
                  width: 100,
                  height: 25,
                  child: TextFormField(
                    controller: idController,
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                Container(
                  color: Colors.white,
                  width: 100,
                  height: 25,
                  child: TextFormField(
                    controller: passwordController,
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                InkWell(
                  onTap: () {
                    // 컨트롤러에 입력한 값으로 login메서드를 실행한다.
                    login(idController.text, passwordController.text);
                    setState(() {});
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
          // 로그인 회원가입칸.
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Container(
                  color: Colors.white,
                  width: 100,
                  height: 25,
                  child: Text('로그인'),
                ),
                SizedBox(
                  width: 25,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Join(),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.white,
                    width: 100,
                    height: 25,
                    child: Text('회원가입'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProject() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("프로젝트 추가하기"),
              content: Column(
                children: [
                  Container(
                    child: TextFormField(
                      controller: titleController,
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: memoController,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("추가"),
                  onPressed: () {
                    addProject(titleController.text, memoController.text);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("취소"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 150,
        height: 50,
        child: Center(child: Text('프로젝트 추가하기.')),
      ),
    );
  }

  Widget _buildGuset() {
    return Center(
      child: Text('로그인이 필요합니다.'),
    );
  }

  Widget _buildProjectList() {
    print(MediaQuery.of(context).size.width);

    double crossAxisCount = MediaQuery.of(context).size.width / 200;
    print(crossAxisCount.toInt());
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _projectList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount.toInt(),
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index){
        print(index);
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                  context,
                  '/workpage' +
                      '?projectNo=${_projectList[index].projectNo}');
            },
            child: Container(
              color: Colors.green,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _projectList[index].title,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  Text(
                    _projectList[index].memo,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      deleteProject(_projectList[index].projectNo);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.blue,
                      child: Text('삭제하기'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: Text("프로젝트 수정하기"),
                            content: Column(
                              children: [
                                Container(
                                  height: 100,
                                  child: TextFormField(
                                    controller: editTitleController,
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  child: TextFormField(
                                    controller: editMemoController,
                                  ),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("수정"),
                                onPressed: () {
                                  editProject(
                                      _projectList[index].projectNo,
                                      editTitleController.text,
                                      editMemoController.text);
                                  // setState(() {
                                  //
                                  // });
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text("취소"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      child: Center(child: Text('프로젝트 수정하기.')),
                    ),
                  ),
                ],
              ),
            ),
          );
      },

    );
  }

  void login(String userId, String password) async {
    String url = 'YOUR API';
    var body = {
      "userId": userId,
      "password": password,
    };
    var response = await http.post(url, body: body);
    var json = jsonDecode(response.body);

    window.localStorage['token'] = json['token'];
    var userToken = window.localStorage['token'];

    if (response.statusCode == 200) {
      window.localStorage['_isLogin'] = 'true';
      loadProjectList();
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: "아이디 및 비밀번호를 확인하세요",
          // toastLngth: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {});
    }
  }

  void loadProjectList() {
    String url = 'YOUR API';
    var token = window.localStorage['token'];
    var header = {'Authorization': token};

    http.get(url, headers: header).then((response) {
      final parsed = jsonDecode(response.body);
      var projectList = parsed['projectList'];
      if (response.statusCode == 200) {
        _projectList.clear();
      }
      // Todo 200이 아닐경우 예외처리
      for (var projectItem in projectList) {
        _projectList.add(ProjectData(projectItem['projectNo'],
            projectItem['title'], projectItem['memo'], projectItem['date']));
      }
      setState(() {});
    });
  }

  Future<void> addProject(String title, String memo) async {
    String url = 'YOUR API';
    var token = window.localStorage['token'];
    var header = {'Authorization': token};
    var body = {
      'title': titleController.text,
      'memo': memoController.text,
    };
    var response = await http.post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      loadProjectList();
    } else {
      Fluttertoast.showToast(
          msg: "서버에",
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return response;
  }

  Future<void> deleteProject(int projectNo) async {
    String url = 'YOUR API';
    var token = window.localStorage['token'];
    var header = {'Authorization': token};
    // Book findBook = Book findBook(int id) => list.firstWhere((book) => book.id == id);
    // _projectList.firstWhere((projectItem) => projectItem.projectNo == projectNo);
    // 지울 데이터를 찾는다.
    ProjectData deleteData = _projectList
        .firstWhere((projectItem) => projectItem.projectNo == projectNo);
    // 데이터를 삭제하고 화면을 갱신한다.
    _projectList.remove(deleteData);
    setState(() {});
    final http.Response response = await http.delete(url, headers: header);
    if (response.statusCode == 200) {
      loadProjectList();
    } else {
      Fluttertoast.showToast(
          msg: "서버에",
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      loadProjectList();
    }
    return response;
  }

  Future<void> editProject(int projectNo, String title, String memo) async {
    String url = 'YOUR API';
    String num = projectNo.toString();
    var token = window.localStorage['token'];
    var header = {'Authorization': token};
    var body = {
      'projectNo': num,
      'title': editTitleController.text,
      'memo': editMemoController.text,
    };

    var response = await http.put(url, headers: header, body: body);
    if (response.statusCode == 200) {
      loadProjectList();
    } else {
      Fluttertoast.showToast(
        msg: "서버에러",
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    return response;
  }
}
