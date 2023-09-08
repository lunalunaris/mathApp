import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:image/image.dart' as Imagi;
import 'package:image_picker/image_picker.dart';
class PhotoDecoder{
  late File photo;
  PhotoDecoder(){}

   preProcessImage(XFile file)async {
    var bytes= await file.readAsBytes();
    final decoder = Imagi.JpegDecoder();
    final decodedImg =  decoder.decode(bytes) as Imagi.Image;
    final data = decodedImg.getBytes(order: Imagi.ChannelOrder.rgb);
    log(data.toString());
    log(decodedImg.height.toString());
    log(decodedImg.width.toString());

    //przy maks 100x100 height=100 width = 75

  }

  // initialiseDecoder(File upload){
  //   photo=upload;
  //   photo.
  // }
  //
  // List<List<int>> imgArray = [];
  // void readImage() async{
  //
  //   final bytes = await controlImage!.readAsBytes();
  //   final decoder = Imagi.JpegDecoder();
  //   final decodedImg = decoder.decode(bytes);
  //   final decodedBytes = decodedImg!.getBytes(format: Imagi.Format.rgb);
  //   // print(decodedBytes);
  //   print(decodedBytes.length);
  //
  //   // int loopLimit = decodedImg.width;
  //   int loopLimit =1000;
  //   for(int x = 0; x < loopLimit; x++) {
  //     int red = decodedBytes[decodedImg.width*3 + x*3];
  //     int green = decodedBytes[decodedImg.width*3 + x*3 + 1];
  //     int blue = decodedBytes[decodedImg.width*3 + x*3 + 2];
  //     imgArray.add([red, green, blue]);
  //   }
  //   print(imgArray);

 // }
}