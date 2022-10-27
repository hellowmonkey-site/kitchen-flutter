import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitchen_flutter/component/common_component.dart';
import 'package:kitchen_flutter/model/recipe_model.dart';

class RecipeItemComponent extends StatelessWidget {
  final RecipeItemModel recipe;
  const RecipeItemComponent(this.recipe, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('/detail/${recipe.id}');
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: 'recipe-item-${recipe.id}',
                  child: cachedNetworkImage(recipe.cover),
                ),
              ),
            ),
            Container(
              height: 32,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: Text(
                recipe.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Container(
              height: 20,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (recipe.userCover != '')
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(recipe.userCover),
                            ),
                          ),
                        ),
                      Text(
                        recipe.userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).disabledColor),
                      )
                    ],
                  )),
                  if (recipe.video.isNotEmpty)
                    const Icon(
                      Icons.play_circle_outline_outlined,
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
