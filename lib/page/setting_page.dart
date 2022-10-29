import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/common_model.dart';
import 'package:kitchen_flutter/model/user_model.dart';
import 'package:kitchen_flutter/provider/user_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('账号设置'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () async {
                  try {
                    final index =
                        await Application.showBottomSheet(['相册选取', '拍照']);
                    if (index == null) {
                      return;
                    }
                    final XFile? file = await imagePicker.pickImage(
                        source: index == 0
                            ? ImageSource.gallery
                            : ImageSource.camera);
                    if (file == null) {
                      return;
                    }
                    BotToast.showLoading();
                    final cover = await CommonModel.uploadFile(file);
                    await UserModel.putUserInfo({'cover_id': cover.id});
                  } catch (e) {
                    Application.toast('上传失败，请使用app重试');
                  } finally {
                    BotToast.closeAllLoading();
                  }
                },
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userProvider.user.cover),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              minLeadingWidth: 1,
              leading: const Icon(Icons.person_outline),
              onTap: () {
                _showEditInfoModal(
                    title: '昵称',
                    value: userProvider.user.nickname,
                    icon: Icons.person_outline,
                    key: 'nickname');
              },
              title: const Text('昵称'),
              subtitle: Text(userProvider.user.nickname.isEmpty
                  ? '点击设置昵称'
                  : userProvider.user.nickname),
              trailing: const Icon(Icons.chevron_right_outlined),
            ),
            ListTile(
              minLeadingWidth: 1,
              leading: const Icon(Icons.edit_note_outlined),
              onTap: () {
                _showEditInfoModal(
                    title: '个性签名',
                    value: userProvider.user.samp,
                    icon: Icons.edit_note_outlined,
                    key: 'samp');
              },
              title: const Text('个性签名'),
              subtitle: Text(
                userProvider.user.samp.isEmpty
                    ? '点击设置个性签名'
                    : userProvider.user.samp,
                overflow: TextOverflow.clip,
                maxLines: 1,
              ),
              trailing: const Icon(Icons.chevron_right_outlined),
            ),
            ListTile(
              minLeadingWidth: 1,
              leading: const Icon(Icons.password_outlined),
              onTap: () {
                _showEditInfoModal(
                    title: '密码',
                    value: '',
                    icon: Icons.password_outlined,
                    key: 'password');
              },
              title: const Text('密码'),
              subtitle: const Text('点击修改密码'),
              trailing: const Icon(Icons.chevron_right_outlined),
            ),
          ],
        ),
      )),
    );
  }

  // 编辑输入框
  _showEditInfoModal(
      {required String title,
      required String value,
      required IconData icon,
      required String key}) {
    final Map<String, dynamic> params = {};
    final obscureText = key == 'password';

    handleSubmit() {
      // if (textController.value.text.isEmpty) {
      //   Application.toast('请先编辑内容');
      //   return;
      // }
      params[key] = textController.value.text.trim();
      focusNode.unfocus();
      UserModel.putUserInfo(params).then((value) {
        Get.back();
      });
    }

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        color: Theme.of(context).backgroundColor,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '修改$title',
                  style: const TextStyle(fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: () {
                    handleSubmit();
                  },
                  child: const Text('保存'),
                )
              ],
            ),
            Container(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: TextField(
                  obscureText: obscureText,
                  focusNode: focusNode,
                  controller: textController,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.sentences,
                  cursorWidth: 3,
                  maxLines: obscureText ? 1 : 10,
                  minLines: 1,
                  autofocus: true,
                  // style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 15),
                      labelText: title,
                      fillColor: Theme.of(context).bottomAppBarColor,
                      hintText: title,
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        textBaseline: TextBaseline.ideographic,
                      ),
                      prefixIcon: Icon(icon),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 1,
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.5)))),
                  onSubmitted: (v) {
                    handleSubmit();
                  },
                ))
          ],
        ),
      ),
      backgroundColor: Get.isDarkMode ? Colors.white24 : Colors.black26,
    );
    textController.value = TextEditingValue(text: value);
  }
}
