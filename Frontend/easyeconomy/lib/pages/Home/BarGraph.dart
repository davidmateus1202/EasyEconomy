import 'dart:convert';
import 'dart:math';
import 'package:easyeconomy/models/Sumary_transacciones.dart';
import 'package:http/http.dart' as http;
import 'package:easyeconomy/models/user_cubir.dart';
import 'package:easyeconomy/models/user_model.dart';
import 'package:easyeconomy/service/ApiHome.dart';
import 'package:easyeconomy/service/api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({super.key});

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state;
    ObtenerSumary();
  }

  UserModer? user;
  late List<Map<String, dynamic>> sumary = [];

  Future<ListaSumary?> ObtenerSumary() async {
    var url =
        Uri.parse('${Api.BaseUrl}/transaccion/obtenerTransaccion/${user!.id}/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        sumary = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
      print(sumary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        maxY: sumary.isNotEmpty
            ? sumary
                    .map((e) => e['total'] as double)
                    .reduce((max, element) => max > element ? max : element) *
                1.2
            : 10000,
        minY: 0,
        titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                    DateFormat.E().format(DateTime.parse(
                      sumary[value.toInt()]['fecha'] as String)),

                );
              },
            ))),
        barGroups: sumary.sublist(max(0 , sumary.length - 6), sumary.length)
        .map((item) {
          return BarChartGroupData(x: sumary.indexOf(item) , barRods: [
            BarChartRodData(
                toY: double.parse(item['total'].toString()),
                color: HexColor('B401FF'),
                width: 20,
                borderRadius: BorderRadius.circular(4),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: sumary.map((e) => e['total'] as double).reduce(
                          (max, element) => max > element ? max : element) *
                      1.2,
                  color: Colors.grey[200],
                ))
          ]);
        }).toList()));
  }
}
