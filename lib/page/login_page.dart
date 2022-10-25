import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/controller/login_controller.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/user_model.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final LoginController loginController = Get.put(LoginController());
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('登录'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey, //设置globalKey，用于后面获取FormState
                // autovalidate: true, //开启自动校验
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                          autofocus: true,
                          controller: _unameController,
                          cursorWidth: 3,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: '用户名',
                              fillColor: Colors.transparent,
                              hintText: '用户名',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                textBaseline: TextBaseline.ideographic,
                              ),
                              prefixIcon: Icon(Icons.person),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid, width: 2))),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return '用户名不能为空';
                            }
                            return null;
                          }
                          // onSubmitted: onSubmitted,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: TextFormField(
                          textInputAction: TextInputAction.send,
                          controller: _pwdController,
                          decoration: const InputDecoration(
                              labelText: '密码',
                              fillColor: Colors.transparent,
                              hintText: '密码',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                textBaseline: TextBaseline.ideographic,
                              ),
                              prefixIcon: Icon(Icons.lock),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid, width: 2))),
                          obscureText: true,
                          //校验密码
                          validator: (v) {
                            if (v == null || v.trim().length <= 5) {
                              return '密码不能少于6位';
                            }
                            return null;
                          }),
                    ),
                    // 登录按钮
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 1,
                                  color: Theme.of(context).primaryColor))),
                      child: const Text(
                        "登录",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        // 通过后再提交数据。
                        if ((_formKey.currentState as FormState).validate()) {
                          UserModel.postLogin(
                                  username: _unameController.value.text,
                                  password: _pwdController.value.text)
                              .then((v) {
                            Application.toast('登录成功');
                            Navigator.of(context).pop();
                          });
                        }
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: const Text(
                        '未注册的账号会被直接注册',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
