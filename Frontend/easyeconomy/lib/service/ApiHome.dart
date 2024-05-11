import 'package:easyeconomy/models/Sumary_transacciones.dart';


class ListaSumary {
  List<SumaryTransacciones> sumary = [];
  ListaSumary({required this.sumary});

  factory ListaSumary.fromList(List list) {
    List<SumaryTransacciones> _sumary = [];
    for (var element in list) {
      _sumary.add(SumaryTransacciones.fromJson(element));
    }
    return ListaSumary(sumary: _sumary);
  }
}
