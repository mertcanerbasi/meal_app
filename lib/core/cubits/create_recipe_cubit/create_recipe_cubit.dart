import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app/core/cubits/create_recipe_cubit/create_recipe_states.dart';
import 'package:meal_app/core/data/models/meal_model/meal_model.dart';
import 'package:meal_app/core/data/models/meal_type_model/meal_type_model.dart';
import 'package:meal_app/core/shared/theme/app_colors.dart';
import 'package:uuid/uuid.dart';

class CreateRecipeCubit extends Cubit<CreateRecipeStates> {
  CreateRecipeCubit() : super(CreateRecipeInitialState());

  static CreateRecipeCubit get(context) => BlocProvider.of(context);

  void createRecipe({required String mealName, required int minutes}) async {
    emit(CreateRecipeLoadingState());

    String id = const Uuid().v4();
    Reference ref = FirebaseStorage.instance.ref().child("meals/$id");
    UploadTask uploadTask = ref.putFile(image!);
    await uploadTask.whenComplete(() async {
      String imageUrl = await ref.getDownloadURL();
      MealModel mealModel = MealModel(
          name: mealName,
          chefUid: FirebaseAuth.instance.currentUser!.uid,
          likes: 0,
          minutes: minutes,
          mealTypes: mealType.name,
          mealId: id,
          ingredients: ingredientsList,
          tags: tags,
          image: imageUrl);
      await FirebaseFirestore.instance
          .collection('meals')
          .doc(id)
          .set(mealModel.toJson())
          .then((value) {
        ingredientsList.clear();
        tags.clear();
        emit(CreateRecipeSuccessState());
      }).catchError((error) {
        emit(CreateRecipeErrorState(error: error.toString()));
      });
    });
  }

  void clearState() {
    ingredientsList.clear();
    tags.clear();
    image = null;
    emit(CreateRecipeInitialState());
  }

  MealType mealType = MealType.breakfast;
  void changeMealType(String? value) {
    if (value == MealType.breakfast.name) {
      mealType = MealType.breakfast;
    } else if (value == MealType.lunch.name) {
      mealType = MealType.lunch;
    } else if (value == MealType.dinner.name) {
      mealType = MealType.dinner;
    } else if (value == MealType.snacks.name) {
      mealType = MealType.snacks;
    }

    emit(CreateRecipeInitialState());
  }

  List<String> mealTypes = [
    MealType.breakfast.name,
    MealType.lunch.name,
    MealType.dinner.name,
    MealType.snacks.name
  ];

  List<String> ingredientsList = [];

  void addIndgredient(String ingredient) {
    ingredientsList.add(ingredient);
    emit(CreateRecipeInitialState());
  }

  void removeIngredient(int index) {
    ingredientsList.removeAt(index);
    emit(CreateRecipeInitialState());
  }

  List<String> tags = [];

  void addTag(String tag) {
    tags.add(tag);
    emit(CreateRecipeInitialState());
  }

  void removeTag(int index) {
    tags.removeAt(index);
    emit(CreateRecipeInitialState());
  }

  File? image;
  var picker = ImagePicker();

  Future getImage() async {
    final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 400,
        imageQuality: 80,
        maxWidth: 400);
    if (pickedImage != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: AppColors.mainColor,
              toolbarWidgetColor: AppColors.backgroundColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if (croppedFile != null) {
        image = File(croppedFile.path);
      }

      emit(CreateRecipeInitialState());
    } else {
      emit(CreateRecipeInitialState());
    }
  }
}
