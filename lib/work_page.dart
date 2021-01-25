import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

class WorkData {
  final int workNo;
  final String workTitle;
  final String createDate;
  int sort;

  // 객체가 호출될 때 생성자가 생성된다.
  // work 순서 ,work생성날짜 ,work이름,work번호 => 필요한 인자값.
  WorkData(this.workNo, this.workTitle, this.createDate, this.sort);
}

class CardData {
  final int projectNo;
  final int workNo;
  final int cardNo;
  final String content;
  final String member;
  final String tag;

  // 객체가 호출될 때 생성자가 생성된다.
  // card번호, card내용, card멤버, card 태그 => 필요한 인자값.
  CardData(this.projectNo, this.content, this.workNo, this.tag, this.member, this.cardNo);
}

class WorkPage extends StatefulWidget {
  // workPage는 인자로projectNo를 받는다.
  final int projectNo;

  WorkPage(this.projectNo);

  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  // targetVisble이라는 bool을 선언.
  bool targetVisible = false;

  // work 및 card리스트 생성.
  List<WorkData> _workList = [];
  List<CardData> _cardList = [];

  // currentDragData를 선언.
  WorkData currentDragData;

  // position Offset값을 0,0으로 생성.
  Offset position = Offset(0, 0);

  // text컨트롤러
  TextEditingController workTitleController = TextEditingController();
  TextEditingController editingController = TextEditingController();
  TextEditingController cardTitleController = TextEditingController();
  TextEditingController memberController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController editCardController = TextEditingController();
  TextEditingController cardMemberController = TextEditingController();
  TextEditingController cardTagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // dummy데이터 생성후 list에 넣어준다.
    _workList.add(WorkData(1, 'A', 'createDate', 0));
    _workList.add(WorkData(2, 'B', 'createDate', 1));
    _workList.add(WorkData(3, 'C', 'createDate', 2));
    _workList.add(WorkData(4, 'D', 'createDate', 3));
    _workList.add(WorkData(5, 'E', 'createDate', 4));

    // a와 b를 비교한다.
    _workList.sort((a, b) => a.sort.compareTo(b.sort));

    // loadWork(widget.projectNo);
    // loadCard(widget.projectNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black,
            height: 60,
            child: Center(
              child: Text(
                '워크리스트',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 30),
          _buildAddButton(),
          SizedBox(height: 30),
          Stack(
            children: [
              _buildWorkList(),
              Visibility(
                // 기본값은 false => drag시작시 true로 변함.
                visible: targetVisible,
                child: _buildDragTarget(),
              ),
            ],
          ),
          _buildCardList(),
        ],
      ),
    );
  }

  Widget _buildAddCard(int workNo) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("카드 추가하기"),
              content: Column(
                children: [
                  Container(
                    child: TextFormField(
                      controller: cardTitleController,
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: memberController,
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: tagController,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("추가"),
                  onPressed: () {
                    addCard(widget.projectNo, workNo, cardTitleController.text,
                        memberController.text, tagController.text);
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
        width: 50,
        height: 20,
        color: Colors.blueGrey,
        child: Text('카드추가'),
      ),
    );
  }

  Widget _buildCardList() {
    return Container(
      constraints: BoxConstraints(maxHeight: 550),
      // listView를 생성한다.
      child: ListView.builder(
        // 스크롤방향
        scrollDirection: Axis.vertical,
        // 필요한 만큼만 공간을 사용함.
        shrinkWrap: true,
        // cardList 길이만큼 생성
        itemCount: _cardList.length,
        itemBuilder: (context, int index) {
          return Column(
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.grey,
                child: Column(
                  children: [
                    Text(_cardList[index].content),
                    Container(
                      width: 50,
                      height: 25,
                      color: Colors.yellow,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("카드 수정하기"),
                                  content: Column(
                                    children: [
                                      Container(
                                        child: TextFormField(
                                          controller: editCardController,
                                        ),
                                      ),
                                      Container(
                                        child: TextFormField(
                                          controller: cardTagController,
                                        ),
                                      ),
                                      Container(
                                        child: TextFormField(
                                          controller: cardMemberController,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("수정"),
                                      onPressed: () {
                                        editCard(
                                            _cardList[index].cardNo,
                                            editCardController.text,
                                            cardTagController.text,
                                            cardMemberController.text);
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
                          child: Text('수정'),
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 25,
                      color: Colors.brown,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            deleteCard(_cardList[index].cardNo);
                          },
                          child: Text('삭제'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return Center(
      child: InkWell(
        onTap: () {
          // _workList[0].sort = 1;
          // _workList[1].sort = 0;
          // _workList.sort((a,b) => a.sort.compareTo(b.sort));
          // setState(() {});
          return;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: Text("목록 추가하기"),
                content: Column(
                  children: [
                    Container(
                      child: TextFormField(
                        controller: workTitleController,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("추가"),
                    onPressed: () {
                      addWork(widget.projectNo, workTitleController.text);
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
          width: 100,
          height: 20,
          color: Colors.blueAccent,
          child: Center(child: Text('목록 추가하기')),
        ),
      ),
    );
  }

  Widget _buildWorkList() {
    // 리스트를 만든다
    List<Widget> list = [];
    // workItem수만큼 Draggable을 만든다.
    for (var workItem in _workList) {
      // list에 Draggable을 넣어준다.
      list.add(
        Draggable<dynamic>(
          // 보내는 data는 workItem
          data: workItem,
          // 드래그를 시작할 때
          onDragStarted: () {
            // 현재데이터는 선택한 workItem
            currentDragData = workItem;
            // Draggable을 투명하게 만들어준다.
            targetVisible = true;
            setState(() {});
          },
          child: Container(
            margin: EdgeInsets.all(20),
            width: 100,
            height: 100,
            color: Colors.lightGreen,
            child: Text(workItem.workTitle),
          ),
          // drag가 취소됐을 때.
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              // visible값을 false로 바꿔준다.
              targetVisible = false;
            });
          },
          // drag중 일때 Drag위젯 상태
          feedback: Opacity(
            opacity: 0.5,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.lightGreen,
              child: Text(workItem.workTitle),
            ),
          ),
        ),
      );
    }

    return Row(
      children: list,
    );
  }

  Widget _buildDragTarget() {
    List<Widget> targetList = [];
    // DragTarget을 마찬가지로 생성한다.
    for (int i = 0; i < _workList.length; i++) {
      targetList.add(
        DragTarget<dynamic>(
          builder:
              (context, List<dynamic> candidata, List<dynamic> rejectedData) {
            return Container(
              margin: EdgeInsets.all(20),
              width: 100,
              height: 100,
              color: Colors.blue,
            );
          },
          // 데이터를 받아온 후 true를 보내 onAccept를 부른다.
          onWillAccept: (data) {
            return true;
          },
          onAccept: (data) {
            print('현재카드' + currentDragData.workTitle + ':' + currentDragData.sort.toString());
            print('타겟' + i.toString());
            targetVisible = false;
            setState(
              () {
                // 현재대상이 가고자하는 대상보다 sort값이 크다면 (이동하는 방향을 판단한다.)
                if (currentDragData.sort > i) {
                  // for문을 활용하여 이동해야 될 데이터들을
                  for (var workItem in _workList) {
                    if (workItem.sort <= i) {
                      // sort값을 1씩 더해서 밀어낸다.
                      workItem.sort = workItem.sort + 1;
                    }
                  }
                  // 현재대상에 원하는곳의 sort값을 넣어서 이동
                  currentDragData.sort = i;
                  _workList.sort((a, b) => a.sort.compareTo(b.sort));
                } else {
                  for (var workItem in _workList) {
                    // sort값이 원하는 대상보다 크다면
                    if (workItem.sort >= i) {
                      // sort값을 -1씩 밀어낸다.
                      workItem.sort = workItem.sort - 1;
                    }
                  }
                  // 현재데이터에 i값을 넣어준다.
                  currentDragData.sort = i;
                  _workList.sort((a, b) => a.sort.compareTo(b.sort));
                }
              },
            );
            // var targetSort = (position.dx / 140).toInt();
          },
        ),
      );
    }
    return Row(
      children: targetList,
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: _workList.length,
      itemBuilder: (context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 90,
              color: Colors.green,
              child: Center(
                child: Container(
                  child: Column(
                    children: [
                      Text(_workList[index].workTitle),
                      _buildAddCard(_workList[index].workNo),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: Text("목록 수정하기"),
                                content: Column(
                                  children: [
                                    Container(
                                      child: TextFormField(
                                        controller: editingController,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("수정"),
                                    onPressed: () {
                                      editWork(_workList[index].workNo,
                                          editingController.text);
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
                          height: 20,
                          color: Colors.blueAccent,
                          child: Text('수정'),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          deleteWork(_workList[index].workNo);
                        },
                        child: Container(
                          height: 20,
                          color: Colors.red,
                          child: Text('삭제'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 50),
          ],
        );
      },
    );
  }

  // work목록을 불러오는 함수. 인자값으로 projectNo를 받는다.
  void loadWork(int projectNo) {
    String url = 'YOUR API';
    // token은 localstorage의 token값
    var token = window.localStorage['token'];
    // header에 토큰
    var header = {'Authorization': token};

    // get으로 url header를 보낸 후
    http.get(url, headers: header).then((response) {
      // 받아온 바디값을 jsonDecode한다.
      final parsed = jsonDecode(response.body);
      //workList는 파싱한workList
      var workList = parsed['workList'];
      // 상태코드가 200이면
      if (response.statusCode == 200) {
        // worklist를 초기화.
        _workList.clear();
      } else {
        print('워크리스트 로딩 실패');
      }
      //  workitem개수만큼 for문을 돌린다.
      for (var workItem in workList) {
        // worklist에 workData를 넣어준다.
        _workList.add(WorkData(workItem['workNo'], workItem['workTitle'],
            workItem['createDate'], workItem['sort']));
      }
      setState(() {});
    });
  }

  // 워크리스트 생성하기
  Future<void> addWork(int projectNo, String workTitle) async {
    String url = 'YOUR API';
    var token = window.localStorage['token'];
    var header = {'Authorization': token};
    // projectNo값을 String형태로 바꿔준다.
    var num = projectNo.toString();
    // 컨트롤러에서 받아온 값을 body라는 변수에 넣어준다.
    var body = {'projectNo': num, 'workTitle': workTitle};

    // http에 url에 header,body값을 보내준다.
    var response = await http.post(url, headers: header, body: body);
    // 상태코드가 200일때 loadWork메서드를 실행한다.
    if (response.statusCode == 200) {
      loadWork(projectNo);
    }
  }

  // Todo 워크리스트 삭제하기
  // 비동기형태의 deleteWork메서드
  Future<void> deleteWork(int workNo) async {
    String url = 'YOUR API';
    var token = window.localStorage['token'];
    var header = {'Authorization': token};

    // 메모리에서 지우고자 하는 대상을 찾아서 지운다.
    WorkData deleteData = _workList.firstWhere((workItem) => workItem.workNo == workNo);
    _workList.remove(deleteData);
    setState(() {});

    // http로 url에 header값을 보낸다.
    final http.Response response = await http.delete(url, headers: header);
    // 상태코드가 200일 때 loadWork메서드를 실행한다.
    if (response.statusCode == 200) {
      loadWork(widget.projectNo);
    } else {
      // 에러메시지
      Fluttertoast.showToast(
          msg: "서버에러",
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      loadWork(widget.projectNo);
    }
    return response;
  }

  // workList수정 메서드
  Future<void> editWork(int workNo, String workTitle) async {
    String url = 'YOUR API';
    var token = window.localStorage['token'];
    var header = {'Authorization': token};
    var num = workNo.toString();
    // body값에 인자로 받아온 값들을 넣어준다.
    var body = {
      'workNo': num,
      'workTitle': workTitle,
    };

    // put메서드로 url에 header body를 보낸후
    var response = await http.put(url, headers: header, body: body);
    // 상태코드가 200이면 loadWork 메서드를 실행한다.
    if (response.statusCode == 200) {
      loadWork(widget.projectNo);
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

    // Todo 워크리스트 이동
  }

  // Todo 카드리스트 불러오기
  void loadCard(int projectNo) {
    String url = 'YOUR API';
    var token = window.localStorage['token'];
    var header = {'Authorization': token};

    // http get 메서드를 실행한다. url에 header값을 보낸다.
    http.get(url, headers: header).then((response) {
      // body값을 jsonDecode한다.
      final parsed = jsonDecode(response.body);
      var cardList = parsed['projectList'];

      // 상태값이 200이면 cardList를 클리어한다.
      if (response.statusCode == 200) {
        _cardList.clear();
      }
      // for문으로 cardList길이 만큼 CardData를 추가해준다.
      for (var cardItem in cardList) {
        _cardList.add(
          CardData(
            cardItem['projectNo'],
            cardItem['content'],
            cardItem['workNo'],
            cardItem['tag'],
            cardItem['member'],
            cardItem['cardNo'],
          ),
        );
      }
      setState(() {});
      print('card');
      print(response.body);
    });
  }

  // Todo 카드생성하기
  Future<void> addCard(int projectNo, int workNo, String content, String member, String tag) async {
    String url = 'YOUR API';
    var token = window.localStorage['token'];
    var header = {'Authorization': token};
    var projectNum = projectNo.toString();
    var workNum = workNo.toString();

    // addCard메서드가 실행될 때 받아온 값들을 body에 각각 넣어준다.
    var body = {
      'projectNo': projectNum,
      'workNo': workNum,
      'content': content,
      'member': member,
      'tag': tag,
    };
    // http post메서드로 url에 header값 body값을 보낸다.
    var response = await http.post(url, headers: header, body: body);
    // 상태코드가 200이면 loadCard메서드를 실행한다.
    if (response.statusCode == 200) {
      loadCard(projectNo);
    }
  }

  // Todo 카드삭제하기
  Future<void> deleteCard(int cardNo) async {
    String url = 'YOUR API';
    var token = window.localStorage['token'];
    var header = {'Authorization': token};

    CardData deleteData = _cardList.firstWhere((cardItem) => cardItem.cardNo == cardNo);
    _cardList.remove(deleteData);
    setState(() {});


    final http.Response response = await http.delete(url, headers: header);
    if (response.statusCode == 200) {
      loadWork(widget.projectNo);
    } else {
      Fluttertoast.showToast(
          msg: "서버에러",
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      loadWork(widget.projectNo);
    }
    return response;
  }

  // Todo 카드내용 수정하기
  Future<void> editCard(int cardNo, String content, String tag, String member) async {
    String url = 'YOUR API';
    var token = window.localStorage['token'];
    var header = {'Authorization': token};
    var cardNum = cardNo.toString();

    var body = {
      'cardNo': cardNum,
      'content': content,
      'tag': tag,
      'member': member,
    };

    var response = await http.put(url, headers: header, body: body);
    if (response.statusCode == 200) {
      loadCard(widget.projectNo);
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
  }

// Todo 카드 이동하기
}
