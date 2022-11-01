import 'package:flutter/material.dart';
import 'package:kitchen_flutter/helper/application.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({Key? key}) : super(key: key);

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();

  int _position = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布菜谱'),
      ),
      backgroundColor: Theme.of(context).bottomAppBarColor,
      body: Theme(
        data: Theme.of(context).copyWith(
            shadowColor: Theme.of(context).appBarTheme.shadowColor,
            primaryColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Stepper(
                elevation: Theme.of(context).appBarTheme.elevation,
                type: StepperType.vertical,
                currentStep: _position,
                onStepTapped: (index) {
                  if (_position <= index) {
                    return;
                  }
                  setState(() {
                    _position = index;
                  });
                },
                onStepContinue: () {
                  setState(() {
                    _position++;
                  });
                },
                onStepCancel: () {
                  setState(() {
                    _position--;
                  });
                },
                controlsBuilder: (_, ControlsDetails details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment:
                          details.currentStep == 0 || details.currentStep == 3
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (details.currentStep > 0 && details.currentStep < 3)
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(30),
                                )),
                            onPressed: details.onStepCancel,
                            child: const Text('上一步'),
                          ),
                        if (details.currentStep < 3)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                )),
                            onPressed: details.onStepContinue,
                            child: const Text('下一步'),
                          ),
                      ],
                    ),
                  );
                },
                steps: [
                  Step(
                    title: const Text('名称'),
                    isActive: _position == 0,
                    state: _getState(0),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child: Form(
                                child: TextFormField(
                                  focusNode: focusNode,
                                  controller: textController,
                                  textInputAction: TextInputAction.search,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  cursorWidth: 3,
                                  maxLength: 100,
                                  minLines: 1,
                                  maxLines: 3,
                                  autofocus: true,
                                  style: const TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                      labelText: '菜谱名称',
                                      fillColor:
                                          Theme.of(context).bottomAppBarColor,
                                      hintText: '菜谱名称',
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        textBaseline: TextBaseline.ideographic,
                                      ),
                                      prefixIcon:
                                          const Icon(Icons.soup_kitchen),
                                      filled: true,
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              width: 1))),
                                ),
                              )),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              onTap: () {
                                Application.showBottomSheet(['上传图片', '上传小视频']);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withOpacity(.1)),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Theme.of(context)
                                        .disabledColor
                                        .withOpacity(.02)),
                                height: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 60,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                    ),
                                    Text(
                                      '上传菜谱封面',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .disabledColor
                                              .withOpacity(.4)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Step(
                    title: const Text('用料'),
                    isActive: _position == 1,
                    state: _getState(1),
                    content: SingleChildScrollView(
                        child: Form(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                  decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.food_bank_outlined),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                labelText: '食材',
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                  decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.line_weight_outlined),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                labelText: '用量',
                              )),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15)),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Icon(
                                      Icons.add_circle_outline_outlined,
                                      size: 30,
                                    ),
                                  ),
                                  Text('增加一行')
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                  ),
                  Step(
                    title: const Text('步骤'),
                    isActive: _position == 2,
                    state: _getState(2),
                    content: SingleChildScrollView(
                        child: Form(
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 20),
                                        child: Text(
                                          '步骤1',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .disabledColor
                                                        .withOpacity(.1)),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Theme.of(context)
                                                    .disabledColor
                                                    .withOpacity(.02)),
                                            height: 200,
                                            child: Text(
                                              '上传步骤图',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .disabledColor
                                                      .withOpacity(.4)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: TextFormField(
                                            decoration: const InputDecoration(
                                          prefixIcon: Icon(Icons.flag_outlined),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          labelText: '步骤说明',
                                        )),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15)),
                                        onPressed: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              child: Icon(
                                                Icons
                                                    .add_circle_outline_outlined,
                                                size: 30,
                                              ),
                                            ),
                                            Text('增加一行')
                                          ],
                                        ),
                                      )
                                    ])))),
                  ),
                  Step(
                    title: const Text('分类'),
                    isActive: _position == 3,
                    state: _getState(3),
                    content: SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.start,
                        children: [
                          1,
                          2,
                          3,
                          4,
                          5,
                          6,
                          7,
                          8,
                          9,
                        ]
                            .map((child) => FilterChip(
                                  avatar: CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.3)),
                                  selectedColor: Theme.of(context).primaryColor,
                                  label: Text('分类$child'),
                                  onSelected: (bool value) {},
                                ))
                            .toList(),
                      ),
                    )),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: FloatingActionButton.extended(
                onPressed: _position == 3 ? () {} : null,
                tooltip: '发布菜谱',
                icon: const Icon(Icons.send_rounded),
                label: const Text('发布菜谱'),
              ),
            )
          ],
        ),
      ),
    );
  }

  StepState _getState(index) {
    if (_position == index) return StepState.editing;
    if (_position > index) return StepState.complete;
    return StepState.indexed;
  }
}
