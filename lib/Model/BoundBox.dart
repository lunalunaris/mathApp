
import 'Coords.dart';

class BoundBox{
  late List<dynamic> pixels;
  late int height;
  late int width;
  late Coords coords;
  late List<List<dynamic>> binary;
  late String value;
  late String latexValue;
  late List<int> projectionHorizontal;
  late List<int> projectionVertical;
  late List<int> zones;
  late List<int> crossingsVertical;
  late List<int> crossingsHorizontal;
  BoundBox(this.height,this.width, this.coords,this.pixels);
}