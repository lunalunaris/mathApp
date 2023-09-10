import 'dart:convert';
import 'dart:io';

import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as Imagi;
import 'package:image_picker/image_picker.dart';
import 'package:math/Model/BoundBox.dart';
import 'package:math/Model/Coords.dart';
import 'package:http/http.dart';
class PhotoDecoder {
  PhotoDecoder() {}
  final BLACK = 0;
  final WHITE = 255;
  late List<List<int>> checkedPixels = [];
  late List<List<int>> tempPixels = [];

  preProcessImage(XFile file) async {
    // var bytes = await file.readAsBytes();
    File f = await getFile(file);
    print(f.readAsBytes().toString());
    // final decoder = Imagi.JpegDecoder();
    // final decodedImg = decoder.decode(bytes) as Imagi.Image;
    //
    //
    //  final array  = decodedImg.getBytes(order: Imagi.ChannelOrder.rgb);
    //   String _base64String = base64.encode(array);
    //   var base= base64Encode(array);
     final uri= Uri.http("192.168.1.7:5000",'/upload');
    //
    // var data = await getData(uri);
    // print(data.toString());
    // add KNN algorithm
    // order the results and get everything after last =
    // get the samples in order and import
    // waiting screen
    // test if this shit even works
    var request = MultipartRequest('POST', uri);
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(MultipartFile('image', f.readAsBytes().asStream(), f.lengthSync(), filename: "filename.jpg"),
    );
    print(request.files.toString());
    request.headers.addAll(headers);
    print("request: " + request.toString());
    var res = await request.send();
    Response response = await Response.fromStream(res);
    print(response.body.toString());
  }


  getFile(file) async{
    File f =  File(file.path);

    return f;
  }
  Future getData(url) async {
    Response response = await get(url);
    return response.body;
  }


// List<List<dynamic>> greyscale =
// transformToGreyscale(data, decodedImg.height, decodedImg.width);
//
// List<List<dynamic>> binarised = applyTreshold(greyscale);
// dev.log(binarised[0][0].toString());
// print("getting char boxes");
//
// List<BoundBox> boxes = getCharacterBoxes(binarised);
// print("merging chars");
// boxes = mergeChars(boxes);
// print("resizing");
// List<BoundBox> sizedBoxes = [];
// for (BoundBox sizeBox in boxes) {
//   sizedBoxes.add(resize(
//       sizeBox, sizeBox.pixels[0].length, sizeBox.pixels.length, 25, 25));
// }
// print("projections");
// sizedBoxes = getProjectionHorizontal(sizedBoxes);
// sizedBoxes = getProjectionVertical(sizedBoxes);
// sizedBoxes = getColumnCrossings(sizedBoxes);
// sizedBoxes = getRowCrossings(sizedBoxes);
// sizedBoxes = getZones(sizedBoxes);
// print("exporitng");
// List<List<dynamic>> featureArray = exportToTestFormat(sizedBoxes);
// print(featureArray.length);


  // transformToGreyscale(image, height, width) {
  //   var index = 0;
  //   List<List<dynamic>> toupleArray = generateList(255, width, height);
  //   print(toupleArray.length);
  //   for (var row = 0; row < toupleArray.length; row++) {
  //     for (var col = 0; col < toupleArray[0].length; col++) {
  //       double temp = (image[index] + image[index + 1] + image[index + 2]) / 3;
  //       toupleArray[row][col] = temp.round();
  //       index += 3;
  //     }
  //   }
  //   return toupleArray;
  // }
  //
  // getTreshold(List<List<dynamic>>array) {
  //   List<dynamic> tempArray = [];
  //   for (var i = 0; i < array.length; i++) {
  //     for (var j = 0; j < array[0].length; j++) {
  //       tempArray.add(array[i][j]);
  //     }
  //   }
  //   tempArray.sort((a, b) => a.compareTo(b));
  //   var lowerBound = 0;
  //   var upperBound = 0;
  //   for (var a in tempArray) {
  //     if (a != BLACK) {
  //       lowerBound = a;
  //       break;
  //     }
  //   }
  //   tempArray.sort((b, a) => a.compareTo(b));
  //   for (var b in tempArray) {
  //     if (b != WHITE) {
  //       upperBound = b;
  //       break;
  //     }
  //   }
  //   return lowerBound + (0.5 * (upperBound - lowerBound));
  // }
  //
  // List<List<dynamic>> applyTreshold(List<List<dynamic>>array) {
  //   var treshold = getTreshold(array);
  //   for (var i = 0; i < array.length; i++) {
  //     for (var j = 0; j < array[0].length; j++) {
  //       if (array[i][j] > treshold) {
  //         array[i][j] = WHITE;
  //       } else {
  //         array[i][j] = BLACK;
  //       }
  //     }
  //   }
  //   return array;
  // }
  //
  // List<dynamic> addToQueue(row, col) {
  //   List<dynamic>queue = [];
  //   queue.add([row - 1, col - 1]);
  //   queue.add([row - 1, col]);
  //   queue.add([row - 1, col + 1]);
  //   queue.add([row, col - 1]);
  //   queue.add([row, col + 1]);
  //   queue.add([row + 1, col - 1]);
  //   queue.add([row + 1, col]);
  //   queue.add([row + 1, col + 1]);
  //   return queue;
  // }
  //
  // BoundBox? getBoundingBox(List<dynamic> tempPixels, array) {
  //   List<int> allRow = [];
  //   List<int> allCol = [];
  //   for (var k in tempPixels) {
  //     allRow.add(k[0]);
  //     allCol.add(k[1]);
  //   }
  //   var minRow = allRow.reduce(min);
  //   var minCol = allCol.reduce(min);
  //   var maxRow = allRow.reduce(max);
  //   var maxCol = allCol.reduce(max);
  //   var pixels = [];
  //   var temp = [];
  //   for (var row = minRow; row < maxRow + 1; row++) {
  //     for (var col = minCol; col < maxCol + 1; col++) {
  //       if (tempPixels.contains([row, col])) {
  //         temp.add(array[row][col]);
  //       } else {
  //         temp.add(WHITE);
  //       }
  //     }
  //     pixels.add(temp);
  //     temp = [];
  //   }
  //   if (countPixels(pixels) > 5) {
  //     return BoundBox(maxRow - minRow, maxCol - minCol,
  //         Coords(minRow, maxRow, minCol, maxCol), pixels);
  //   } else {
  //     return null;
  //   }
  // }
  //
  // int countPixels(pixels) {
  //   int sum = 0;
  //   for (var i = 0; i < pixels.length; i++) {
  //     for (var j = 0; j < pixels[0].length; j++) {
  //       if (pixels[i][j] == BLACK) {
  //         sum += 1;
  //       }
  //     }
  //   }
  //   return sum;
  // }
  //
  // checkPixel(array, i, j) {
  //   var queue = [];
  //   if(i<array.length && i>=0 && j<array[0].length && j>=0){
  //     if (array[i][j] == BLACK && !checkedPixels.contains([i, j])) {
  //       checkedPixels.add([i, j]);
  //       tempPixels.add([i, j]);
  //       queue = addToQueue(i, j);
  //       for (var q in queue) {
  //         checkPixel(array, q[0], q[1]);
  //       }
  //     }
  //   }
  // }
  //
  //   List<BoundBox> getCharacterBoxes(array) {
  //     List<dynamic> tempPixels = [];
  //     var queue = [];
  //     List<BoundBox> boxes = [];
  //     for (var i = 0; i < array.length; i++) {
  //       for (var j = 0; j < array[0].length; j++) {
  //         if (array[i][j] == BLACK && !checkedPixels.contains([i, j])) {
  //           checkedPixels.add([i, j]);
  //           tempPixels.add([i, j]);
  //           queue = addToQueue(i, j);
  //           for (var q in queue) {
  //             checkPixel(array, q[0], q[1]);
  //           }
  //           var box = getBoundingBox(tempPixels, array);
  //           if (box != null) {
  //             boxes.add(box);
  //           }
  //           tempPixels = [];
  //           queue = [];
  //         }
  //       }
  //     }
  //     return boxes;
  //   }
  //
  //   List<BoundBox> mergeChars(List<BoundBox> boxes) {
  //     List<BoundBox> boxesMerged = [];
  //     List<BoundBox> temp = [];
  //     int index = 0;
  //     for (BoundBox box in boxes) {
  //       // # check over and below for boxes contained in left-2, right+2
  //
  //       if (!boxesMerged.contains(box)) {
  //         int top = box.coords.top;
  //         int bottom = box.coords.bottom;
  //         int left = box.coords.left;
  //         int right = box.coords.right;
  //
  //         index += 1;
  //         for (BoundBox secBox in boxes) {
  //           int width = right - left;
  //           int widthSec = secBox.coords.right - secBox.coords.left;
  //           if (left - 5 <= secBox.coords.left &&
  //               secBox.coords.left <= right + 5 &&
  //               box.coords.left != secBox.coords.left &&
  //               box.coords.top != secBox.coords.top &&
  //               width <= widthSec) {
  //             if ((top > secBox.coords.bottom &&
  //                 secBox.coords.bottom >= top - 5) ||
  //                 (bottom > secBox.coords.top &&
  //                     secBox.coords.top > bottom + 5)) {
  //               print(
  //                   "EVALUATED: top: $top bottom: $bottom left: $left right: $right");
  //               print(
  //                   "COMPARED: top: ${secBox.coords.top} bottom: ${secBox.coords
  //                       .bottom} left: ${secBox.coords.left} right: ${secBox
  //                       .coords.right}");
  //               boxesMerged.add(box);
  //               boxesMerged.add(secBox);
  //               BoundBox resultBox = mergeBoxes([secBox, box]);
  //               temp.add(resultBox);
  //             }
  //           }
  //         }
  //       }
  //     }
  //     for (BoundBox b in boxesMerged) {
  //       boxes.remove(b);
  //     }
  //     boxes = boxes + temp;
  //     return boxes;
  //   }
  //
  //   BoundBox mergeBoxes(boxes) {
  //     List<int> bottom = [];
  //     List<int> top = [];
  //     List<int> left = [];
  //     List<int> right = [];
  //     for (BoundBox box in boxes) {
  //       bottom.add(box.coords.bottom);
  //       top.add(box.coords.top);
  //       left.add(box.coords.left);
  //       right.add(box.coords.right);
  //     }
  //     int newTop = top.reduce(min);
  //     int newBottom = bottom.reduce(max);
  //     int newLeft = left.reduce(min);
  //     int newRight = right.reduce(max);
  //     List<List<dynamic>> newBox =
  //     generateList(255, newRight - newLeft + 1, newBottom - newTop + 1);
  //     for (BoundBox box in boxes) {
  //       int iIndex = 0;
  //       for (var i = box.coords.top - newTop;
  //       i < box.coords.bottom - newTop + 1;
  //       i++) {
  //         int jIndex = 0;
  //         for (var j = box.coords.left - newLeft;
  //         j < box.coords.right - newLeft + 1;
  //         j++) {
  //           if (box.pixels[iIndex][jIndex] == BLACK) {
  //             newBox[i][j] = box.pixels[iIndex][jIndex];
  //           }
  //           jIndex += 1;
  //         }
  //         iIndex += 1;
  //       }
  //     }
  //     print(newBox);
  //     BoundBox newBoxfinal = BoundBox(newBottom - newTop, newRight - newLeft,
  //         Coords(newTop, newBottom, newLeft, newRight), newBox);
  //     return newBoxfinal;
  //   }
  //
  //   List<List<dynamic>> generateList(value, width, height) {
  //     List<List<dynamic>> list = [];
  //     for (var i = 0; i < height; i++) {
  //       var temp = [];
  //       for (var j = 0; j < width; j++) {
  //         temp.add(value);
  //       }
  //       list.add(temp);
  //     }
  //     return list;
  //   }
  //
  //   BoundBox singleResize(box, widthOld, heightOld, widthNew, heightNew) {
  //     double wScale = (widthOld / widthNew);
  //     double hScale = (heightOld / heightNew);
  //     box.width = box.width * wScale;
  //     box.height = box.height * hScale;
  //     List<List<dynamic>> scaled = generateList(255, widthNew, heightNew);
  //     for (var j = 0; j < widthNew; j++) {
  //       for (var i = 0; i < heightNew; i++) {
  //         scaled[i][j] = box.pixels[(i * hScale).toInt()][(j * wScale).toInt()];
  //       }
  //     }
  //     box.pixels = scaled;
  //     return box;
  //   }
  //
  //   BoundBox resize(box, widthOld, heightOld, widthNew, heightNew) {
  //     var expand = [];
  //     if ((heightOld / widthOld) > 1) {
  //       int wNew = heightOld;
  //       expand = generateList(255, wNew, heightOld);
  //       int index = 0;
  //       int offset = ((wNew - widthOld) / 2).toInt();
  //       for (var j = offset; j < offset + widthOld; j++) {
  //         for (var i = 0; i < heightOld; i++) {
  //           expand[i][j] = box.pixels[i][index];
  //         }
  //         index += 1;
  //       }
  //     } else if (heightOld == widthOld) {
  //       expand = box.pixels;
  //     } else if ((heightOld / widthOld).toInt() < 1) {
  //       int hNew = widthOld;
  //       expand = generateList(255, widthOld, hNew);
  //       int index = 0;
  //       int offset = ((hNew - heightOld) / 2).toInt();
  //       for (var i = offset; i < offset + heightOld; i++) {
  //         for (var j = 0; j < widthOld; j++) {
  //           expand[i][j] = box.pixels[index][j];
  //         }
  //         index += 1;
  //       }
  //     }
  //     box.pixels = expand;
  //     box =
  //         singleResize(
  //             box, expand[0].length, expand.length, widthNew, heightNew);
  //     return box;
  //   }
  //   List<BoundBox> getProjectionHorizontal(boxes) {
  //     List<BoundBox> projectBoxes = [];
  //     for (BoundBox box in boxes) {
  //       List<int> countHorizontal = generate1DArray(box.pixels[0].length);
  //       for (var i = 0; i < box.pixels.length; i++) {
  //         for (var j = 0; j < box.pixels[0].length; j++) {
  //           if (box.pixels[i][j] == BLACK) {
  //             countHorizontal[j] = countHorizontal[j] + 1;
  //           }
  //         }
  //       }
  //       box.projectionHorizontal = countHorizontal;
  //       projectBoxes.add(box);
  //     }
  //     return projectBoxes;
  //   }
  //   List<BoundBox> getProjectionVertical(boxes) {
  //     List<BoundBox> projectBoxes = [];
  //     for (BoundBox box in boxes) {
  //       List<int> projectionVertical = generate1DArray(box.pixels.length);
  //       for (var j = 0; j < box.pixels[0].length; j++) {
  //         for (var i = 0; i < box.pixels.length; i++) {
  //           if (box.pixels[i][j] == BLACK) {
  //             projectionVertical[i] = projectionVertical[i] + 1;
  //           }
  //         }
  //       }
  //       box.projectionVertical = projectionVertical;
  //       projectBoxes.add(box);
  //     }
  //     return projectBoxes;
  //   }
  //
  //   List<BoundBox> getZones(boxes) {
  //     for (BoundBox box in boxes) {
  //       List<List<dynamic>>temp = generateList(
  //           0, box.pixels[0].length, box.pixels.length);
  //       for (var i = 0; i < box.pixels.length; i++) {
  //         for (var j = 0; j < box.pixels[0].length; j++) {
  //           if (box.pixels[i][j] == BLACK) {
  //             temp[i][j] = 1;
  //           }
  //           else {
  //             temp[i][j] = 0;
  //           }
  //         }
  //       }
  //       box.binary = temp;
  //     }
  //     // get zones
  //     List<BoundBox> temp = [];
  //     for (BoundBox box in boxes) {
  //       List<int>zones = [];
  //       for (var i = 0; i < box.pixels.length; i += 5) {
  //         for (var j = 0; j < box.pixels[0].length; j += 5) {
  //           int sums = countPixelsStep(box.pixels, i, j, j + 4) +
  //               countPixelsStep(box.pixels, i + 1, j, j + 4) +
  //               countPixelsStep(box.pixels, i + 2, j, j + 4) +
  //               countPixelsStep(box.pixels, i + 3, j, j + 4) +
  //               countPixelsStep(box.pixels, i + 4, j, j + 4);
  //           zones.add(sums);
  //         }
  //       }
  //       box.zones = zones;
  //       temp.add(box);
  //     }
  //     return temp;
  //   }
  //
  //   List<BoundBox> getColumnCrossings(boxes) {
  //     List<BoundBox> temp = [];
  //     for (BoundBox box in boxes) {
  //       List<int>crossings = [];
  //       for (var j = 0; j < box.pixels[0].length; j++) {
  //         int sum = 0;
  //         for (var i = 0; i < box.pixels.length; i++) {
  //           if (i != 0) {
  //             if (box.binary[i][j] == 1 && box.binary[i - 1][j] == 0) {
  //               sum += 1;
  //             }
  //           }
  //           else if (i == 0 && box.binary[i][j] == 1) {
  //             sum += 1;
  //           }
  //           crossings.add(sum);
  //         }
  //         box.crossingsVertical = crossings;
  //         temp.add(box);
  //       }
  //     }
  //     return temp;
  //   }
  //   List<BoundBox> getRowCrossings(boxes) {
  //     List<BoundBox> temp = [];
  //     for (BoundBox box in boxes) {
  //       List<int>crossings = [];
  //       for (var i = 0; i < box.pixels.length; i++) {
  //         int sum = 0;
  //         for (var j = 0; j < box.pixels[0].length; j++) {
  //           if (j != 0) {
  //             if (box.binary[i][j] == 1 && box.binary[i ][j - 1] == 0) {
  //               sum += 1;
  //             }
  //           }
  //           else if (j == 0 && box.binary[i][j] == 1) {
  //             sum += 1;
  //           }
  //           crossings.add(sum);
  //         }
  //         box.crossingsHorizontal = crossings;
  //         temp.add(box);
  //       }
  //     }
  //     return temp;
  //   }
  //
  //
  //   exportToTestFormat(boxes) {
  //     List<List<dynamic>> featureArray = generateList(0, 128, boxes.length);
  //     List<String> fieldArray = ["class", "width", "height"];
  //     for (var i = 0; i < 25; i++) {
  //       fieldArray.add("projection_vertical_$i");
  //     }
  //     for (var i = 0; i < 25; i++) {
  //       fieldArray.add("projection_horizontal_$i");
  //     }
  //     for (var i = 0; i < 25; i++) {
  //       fieldArray.add("crossing_horizontal_$i");
  //     }
  //     for (var i = 0; i < 25; i++) {
  //       fieldArray.add("crossing_vertical_$i");
  //     }
  //     for (var i = 0; i < 25; i++) {
  //       fieldArray.add("zone_$i");
  //     }
  //
  //     int index = 0;
  //     for (BoundBox box in boxes) {
  //       featureArray[index] = [box.value, box.width, box.height];
  //       featureArray[index] = featureArray[index] + box.projectionVertical;
  //       featureArray[index] = featureArray[index] + box.projectionHorizontal;
  //       featureArray[index] = featureArray[index] + box.crossingsHorizontal;
  //       featureArray[index] = featureArray[index] + box.crossingsVertical;
  //       featureArray[index] = featureArray[index] + box.zones;
  //       index += 1;
  //     }
  //     return featureArray;
  //   }
  //
  //   int countPixelsStep(pixels, i, start, stop) {
  //     int sum = 0;
  //     for (var j = start; j < stop; j++) {
  //       if (pixels[i][j] == BLACK) {
  //         sum += 1;
  //       }
  //     }
  //     return sum;
  //   }
  //   List<int> generate1DArray(size) {
  //     List<int> array = [];
  //     for (var i = 0; i < size; i++) {
  //       array.add(0);
  //     }
  //     return array;
  //   }
  //
  //
  //












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
// queue = queue+addToQueue(i, j);
// while (queue.isNotEmpty) {
//   print("here");
//   print(queue.length);
//   List<dynamic> point= queue.first;
//   queue.remove(point);
//   if (array.length > point[0] &&
//       point[0] >= 0 &&
//       array[0].length >= point[1] &&
//       point[1] >= 0) {
//     if (array[point[0]][point[1]] == BLACK &&
//         !checkedPixels.contains([point[0], point[1]])) {
//       checkedPixels.add([point[0], point[1]]);
//       tempPixels.add([point[0], point[1]]);
//       queue= queue+addToQueue(point[0], point[1]);
//     }
//   }
// }

int loopLimit =1000;
// for(int x = 0; x < loopLimit; x++) {
//   int red = decodedBytes[decodedImg.width*3 + x*3];
//   int green = decodedBytes[decodedImg.width*3 + x*3 + 1];
//   int blue = decodedBytes[decodedImg.width*3 + x*3 + 2];
//   imgArray.add([red, green, blue]);
// }
// print(imgArray);
// XFile? filePick = files;
// File selectedImg;
// if (filePick != null) {
//   selectedImg=(File(filePick.path));
//   List<int> imageBytes = selectedImg.readAsBytesSync();
//   String imageAsString = base64Encode(imageBytes);
//   Uint8List uint8list = base64.decode(imageAsString);
//   Image image = Image.memory(uint8list);
//   log(imageBytes.toString());
//   final pngByteData = await image.toByteData(format: ImageByteFormat.rawRgba);
// String base64Image = base64Encode(imageBytes);
// log(base64Image);
//
// await selectedImg.writeAsBytes(base64.decode());
//   setState(() {});
// } else {
//   if (!mounted) return;
//   ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(S.of(context).nothingIsSelected)));
// }