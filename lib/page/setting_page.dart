import 'package:flutter/material.dart';
import 'package:kitchen_flutter/provider/user_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('账号设置'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save_as),
            tooltip: '保存信息',
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {},
                child: Stack(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userProvider.user.cover),
                      ),
                    ),
                    const Positioned(
                      bottom: 10,
                      right: 10,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              title: const Text('昵称'),
              subtitle: Text(userProvider.user.nickname),
              trailing: const Icon(Icons.chevron_right_outlined),
            ),
            ListTile(
              onTap: () {},
              title: const Text('签名'),
              subtitle: Text(userProvider.user.samp),
              trailing: const Icon(Icons.chevron_right_outlined),
            ),
            ListTile(
              onTap: () {},
              title: const Text('密码'),
              subtitle: const Text('点击修改密码'),
              trailing: const Icon(Icons.chevron_right_outlined),
            ),
          ],
        ),
      )),
    );
  }
}
