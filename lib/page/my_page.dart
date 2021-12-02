import 'package:flutter/material.dart';
import 'package:m_pigplan/model/profile_model.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);
  @override
  _MyPage createState() => _MyPage();
}

class _MyPage extends State<MyPage> {

  @override
  void initState() {
    super.initState();
  }

  List<Profile> profiles = [
    Profile.fromMap({
      'name': 'test',
      'image': 'profile_1.PNG'
    })
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PigPlan'),
        centerTitle: true,
      ),
      body: Container(
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // ProfileSlider(profiles: profiles,),
                  OutlinedButton(onPressed: () {}, child: Text('프로필 관리')),
                ],
              ),
              const ListTile(
                //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
                leading: Icon(Icons.person),
                title: Text('프로필 설정'),

              ),
              const ListTile(
                //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
                leading: Icon(Icons.perm_identity_rounded),
                title: Text('계정'),
              ),
              const ListTile(
                //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
                leading: Icon(Icons.air_outlined),
                title: Text('농장환경정보 설정'),
              ),
              const ListTile(
                //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
                leading: Icon(Icons.add_alert),
                title: Text('알림 설정'),
              ),
            ],
          )
      ),
    );

  }




}