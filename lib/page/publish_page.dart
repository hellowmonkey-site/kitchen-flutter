import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitchen_flutter/helper/application.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';
import 'package:kitchen_flutter/provider/recipe_provider.dart';
import 'package:provider/provider.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({Key? key}) : super(key: key);

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  final ImagePicker imagePicker = ImagePicker();

  final GlobalKey _formKey0 = GlobalKey<FormState>();
  final GlobalKey _formKey1 = GlobalKey<FormState>();
  final GlobalKey _formKey2 = GlobalKey<FormState>();

  RecipeInputModel recipeInput = RecipeInputModel(
      categorys: [],
      materials: [RecipeMaterialItemModel()],
      steps: [RecipeStepItemModel()],
      cover: '',
      samp: '',
      video: '',
      title: '');

  int _currentStep = 0;
  int _lastStep = 0;

  final steps = ['基本信息', '配菜及佐料', '做法及步骤', '推荐至分类'];

  get _canPublish => _lastStep == steps.length - 1;

  StepState _getState(index) {
    if (_currentStep == index) return StepState.editing;
    if (_lastStep > index) return StepState.complete;
    return StepState.indexed;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              padding: EdgeInsets.only(bottom: _canPublish ? 50 : 0),
              child: Stepper(
                elevation: Theme.of(context).appBarTheme.elevation,
                type: StepperType.vertical,
                currentStep: _currentStep,
                onStepTapped: (index) {
                  if (_lastStep < index) {
                    return;
                  }
                  setState(() {
                    _currentStep = index;
                  });
                },
                onStepContinue: () {
                  setState(() {
                    _currentStep++;
                    _lastStep = _currentStep;
                  });
                },
                onStepCancel: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                controlsBuilder: _controlsBuilder,
                steps: [
                  _step1(),
                  _step2(),
                  _step3(),
                  _step4(),
                ],
              ),
            ),
            if (_canPublish) _publish()
          ],
        ),
      ),
    );
  }

  Widget _controlsBuilder(_, ControlsDetails details) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment:
            details.currentStep == 0 || details.currentStep == steps.length - 1
                ? MainAxisAlignment.end
                : MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (details.currentStep > 0 && details.currentStep < steps.length - 1)
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(30),
                  )),
              onPressed: details.onStepCancel,
              child: const Text('上一步'),
            ),
          if (details.currentStep < steps.length - 1)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
              onPressed: () {
                switch (details.currentStep) {
                  case 0:
                    if ((_formKey0.currentState as FormState).validate()) {
                      if (recipeInput.coverId == 0 &&
                          recipeInput.videoId == 0) {
                        Application.toast('请先上传菜谱封面');
                        return;
                      }
                      details.onStepContinue!();
                    }
                    break;
                  case 1:
                    if ((_formKey1.currentState as FormState).validate()) {
                      details.onStepContinue!();
                    }
                    break;
                  case 2:
                    if ((_formKey2.currentState as FormState).validate()) {
                      // if (recipeInput.steps
                      //     .any((item) => item.img.isEmpty)) {
                      //   Application.toast('请先上传步骤面');
                      //   return;
                      // }
                      details.onStepContinue!();
                    }
                    break;
                }
              },
              child: const Text('下一步'),
            ),
        ],
      ),
    );
  }

  Widget _publish() {
    return Positioned(
      bottom: 15,
      left: 15,
      right: 15,
      child: FloatingActionButton.extended(
        elevation: 5,
        onPressed: () {
          final calcel = BotToast.showLoading();
          RecipeModel.postRecipe(recipeInput).then((value) {
            Get.back(result: 1);
          }).whenComplete(() {
            calcel();
          });
        },
        tooltip: '发布菜谱',
        icon: const Icon(Icons.send_rounded),
        label: const Text('发布菜谱'),
      ),
    );
  }

  Step _step1() {
    return Step(
      title: Text(steps[0]),
      isActive: _currentStep == 0,
      state: _getState(0),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: TextFormField(
                      textInputAction: TextInputAction.next,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, width: 1))),
                      onChanged: (value) {
                        recipeInput.title = value;
                      },
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return '请先填写菜谱名称';
                        }
                        return null;
                      })),
              Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                      autofocus: false,
                      textInputAction: TextInputAction.newline,
                      textCapitalization: TextCapitalization.sentences,
                      cursorWidth: 3,
                      minLines: 1,
                      maxLines: 10,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                          labelText: '菜谱介绍',
                          fillColor: Theme.of(context).bottomAppBarColor,
                          hintText: '菜谱介绍',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            textBaseline: TextBaseline.ideographic,
                          ),
                          prefixIcon: const Icon(Icons.soap_outlined),
                          filled: true,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                  style: BorderStyle.solid, width: 1))),
                      onChanged: (value) {
                        recipeInput.samp = value;
                      },
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return '请先填写菜谱介绍';
                        }
                        return null;
                      })),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () async {
                    final cover = await Application.uploadImage();
                    if (cover != null) {
                      setState(() {
                        recipeInput.cover = cover.url;
                        recipeInput.coverId = cover.id;
                      });
                    }
                  },
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                        color:
                            Theme.of(context).disabledColor.withOpacity(.02)),
                    height: 250,
                    child: recipeInput.cover.isNotEmpty
                        ? Image.network(
                            recipeInput.cover,
                            fit: BoxFit.cover,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '上传菜谱封面',
                                style: TextStyle(color: Colors.grey),
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
    );
  }

  Step _step2() {
    return Step(
      title: Text(steps[1]),
      isActive: _currentStep == 1,
      state: _getState(1),
      content: SingleChildScrollView(
          child: Form(
        key: _formKey1,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Column(
            children: [
              ...recipeInput.materials.asMap().entries.map((item) {
                return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
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
                                  ),
                                  onChanged: (value) {
                                    recipeInput.materials[item.key].name =
                                        value;
                                  },
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return '请先填食材';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.line_weight_outlined),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    labelText: '用量',
                                  ),
                                  onChanged: (value) {
                                    recipeInput.materials[item.key].unit =
                                        value;
                                  },
                                  // validator: (v) {
                                  //   if (v == null ||
                                  //       v.trim().isEmpty) {
                                  //     return '请先填写用量';
                                  //   }
                                  //   return null;
                                  // }
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  recipeInput.materials.removeAt(item.key);
                                });
                              },
                              child: Icon(
                                Icons.remove_circle_outline,
                                color: Theme.of(context).disabledColor,
                              )),
                        ),
                      ],
                    ));
              }).toList(),
              TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15)),
                onPressed: () {
                  setState(() {
                    recipeInput.materials.add(RecipeMaterialItemModel());
                  });
                },
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
    );
  }

  Step _step3() {
    return Step(
      title: Text(steps[2]),
      isActive: _currentStep == 2,
      state: _getState(2),
      content: SingleChildScrollView(
          child: Form(
              key: _formKey2,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...recipeInput.steps.asMap().entries.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Text(
                                          '步骤${item.key + 1}',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          onTap: () async {
                                            final data =
                                                await Application.uploadImage();
                                            if (data != null) {
                                              setState(() {
                                                recipeInput.steps[item.key]
                                                    .img = data.url;
                                              });
                                            }
                                          },
                                          child: Container(
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Theme.of(context)
                                                    .disabledColor
                                                    .withOpacity(.02)),
                                            height: 200,
                                            child: recipeInput.steps[item.key]
                                                    .img.isNotEmpty
                                                ? Image.network(
                                                    recipeInput
                                                        .steps[item.key].img,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Center(
                                                    child: Text(
                                                      '上传步骤图',
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor
                                                              .withOpacity(.4)),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: TextFormField(
                                            decoration: const InputDecoration(
                                              prefixIcon:
                                                  Icon(Icons.flag_outlined),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              labelText: '步骤说明',
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                recipeInput.steps[item.key]
                                                    .text = value;
                                              });
                                            },
                                            validator: (v) {
                                              if (v == null ||
                                                  v.trim().isEmpty) {
                                                return '请先填步骤说明';
                                              }
                                              return null;
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          recipeInput.steps.removeAt(item.key);
                                        });
                                      },
                                      child: Icon(
                                        Icons.remove_circle_outline,
                                        color: Theme.of(context).disabledColor,
                                      )),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15)),
                          onPressed: () {
                            setState(() {
                              recipeInput.steps.add(RecipeStepItemModel());
                            });
                          },
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
                      ])))),
    );
  }

  Step _step4() {
    final recipeRandomCategorys =
        Provider.of<RecipeProvider>(context).recipeRandomCategorys;
    return Step(
      title: Text(steps[3]),
      isActive: _currentStep == 3,
      state: _getState(3),
      content: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.start,
          children: recipeRandomCategorys
              .map((item) => FilterChip(
                    avatar: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.3)),
                    selectedColor: Theme.of(context).primaryColor,
                    selected: recipeInput.categorys.contains(item.name),
                    label: Text(item.name),
                    onSelected: (bool value) {
                      var list = recipeInput.categorys;
                      if (value) {
                        list.add(item.name);
                      } else {
                        list = list
                            .where((element) => element != item.name)
                            .toList();
                      }
                      setState(() {
                        recipeInput.categorys = list;
                      });
                    },
                  ))
              .toList(),
        ),
      )),
    );
  }
}
