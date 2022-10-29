import 'package:flutter/material.dart';

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
        actions: [
          FloatingActionButton(
            onPressed: () {},
            mini: true,
            tooltip: '立即发布',
            child: const Icon(Icons.save),
          )
        ],
      ),
      body: Container(
        color: Theme.of(context).bottomAppBarColor,
        child: Theme(
          data: Theme.of(context).copyWith(
              shadowColor: Theme.of(context).appBarTheme.shadowColor,
              primaryColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).primaryColor),
          child: Stepper(
            elevation: Theme.of(context).appBarTheme.elevation,
            type: StepperType.horizontal,
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
                if (_position < 2) {
                  _position++;
                }
              });
            },
            onStepCancel: () {
              if (_position > 0) {
                setState(() {
                  _position--;
                });
              }
            },
            controlsBuilder: (_, ControlsDetails details) {
              return Row(
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: const CircleBorder(
                          side:
                              BorderSide(width: 2.0, color: Color(0xFFDFDFDF)),
                        )),
                    onPressed: details.onStepContinue,
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: const CircleBorder(
                          side:
                              BorderSide(width: 2.0, color: Color(0xFFDFDFDF)),
                        )),
                    onPressed: details.onStepCancel,
                    child: const Icon(
                      Icons.keyboard_backspace,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
            steps: [
              Step(
                title: const Text('名称'),
                isActive: _position == 0,
                state: _getState(0),
                content: Center(
                    child: TextField(
                  focusNode: focusNode,
                  controller: textController,
                  textInputAction: TextInputAction.search,
                  textCapitalization: TextCapitalization.sentences,
                  cursorWidth: 3,
                  maxLength: 100,
                  minLines: 1,
                  maxLines: 3,
                  autofocus: true,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      labelText: '菜谱名称',
                      fillColor: Theme.of(context).bottomAppBarColor,
                      hintText: '菜谱名称',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        textBaseline: TextBaseline.ideographic,
                      ),
                      prefixIcon: const Icon(Icons.soup_kitchen),
                      filled: true,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide:
                              BorderSide(style: BorderStyle.solid, width: 1))),
                  onSubmitted: (v) {},
                )),
              ),
              Step(
                title: const Text('用料'),
                isActive: _position == 1,
                state: _getState(1),
                content: const SingleChildScrollView(child: Text('开发中...')),
              ),
              Step(
                title: const Text('步骤'),
                isActive: _position == 2,
                state: _getState(2),
                content: const SingleChildScrollView(child: Text('开发中...')),
              ),
              Step(
                title: const Text('发布'),
                isActive: _position == 3,
                state: _getState(3),
                content: const SingleChildScrollView(child: Text('开发中...')),
              )
            ],
          ),
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
