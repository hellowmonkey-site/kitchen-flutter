import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/controller/login_controller.dart';

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
                key: _formKey,
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
                          decoration: InputDecoration(
                              labelText: '用户名',
                              fillColor: Theme.of(context).bottomAppBarColor,
                              hintText: '用户名',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                textBaseline: TextBaseline.ideographic,
                              ),
                              prefixIcon: const Icon(Icons.person),
                              filled: true,
                              border: const OutlineInputBorder(
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
                        decoration: InputDecoration(
                            labelText: '密码',
                            fillColor: Theme.of(context).bottomAppBarColor,
                            hintText: '密码',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              textBaseline: TextBaseline.ideographic,
                            ),
                            prefixIcon: const Icon(Icons.lock),
                            filled: true,
                            border: const OutlineInputBorder(
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
                        },
                        onFieldSubmitted: (value) {
                          handleSubmit();
                        },
                      ),
                    ),
                    // 登录按钮
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
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
                        handleSubmit();
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

  // 提交
  void handleSubmit() {
    // 通过后再提交数据。
    if ((_formKey.currentState as FormState).validate()) {
      loginController.handleSubmit(
          username: _unameController.value.text,
          password: _pwdController.value.text);
    }
  }
}
