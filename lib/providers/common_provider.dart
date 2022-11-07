import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';



final loginProvider = StateNotifierProvider.autoDispose<ToggleProvider, bool>(
        (ref) => ToggleProvider(true));


class ToggleProvider extends StateNotifier<bool>{
  ToggleProvider(super.state);

  void toggle(){
    state = !state;
  }

}



final loadingProvider = StateNotifierProvider.autoDispose<LoadingProvider, bool>(
        (ref) => LoadingProvider(false));


class LoadingProvider extends StateNotifier<bool>{
  LoadingProvider(super.state);

  void toggle(){
    state = !state;
  }

}



final imageProvider = StateNotifierProvider.autoDispose<ImageProvider, XFile?>(
        (ref) => ImageProvider(null));


class ImageProvider extends StateNotifier<XFile?>{
  ImageProvider(super.state);

  void pickAnImage(bool isCamera) async{
    final ImagePicker _picker = ImagePicker();
    if(isCamera){
      state = await _picker.pickImage(source: ImageSource.camera);
    }else{
      state = await _picker.pickImage(source: ImageSource.gallery);
    }
  }

}