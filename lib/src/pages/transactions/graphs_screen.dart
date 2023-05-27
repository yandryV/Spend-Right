import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../models/chart_model.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});
  //TODO: hacer dinámica la sección de gráficos

  @override
  Widget build(BuildContext context) {
    final List<BarChartData> data = [
      BarChartData(
        DateTime(2023, 5, 1),
        100.0,
        'Datos 1',
        Icons.data_usage,
      ),
      BarChartData(
        DateTime(2023, 6, 2),
        200.0,
        'Datos 2',
        Icons.insert_chart,
      ),
      BarChartData(
        DateTime(2023, 7, 3),
        150.0,
        'Datos 3',
        Icons.pie_chart,
      ),
      // Puedes agregar más datos aquí según sea necesario
    ];

    List<charts.Series<BarChartData, DateTime>> seriesList = [
      charts.Series<BarChartData, DateTime>(
        id: 'data',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BarChartData data, _) => data.date,
        measureFn: (BarChartData data, _) => data.amount,
        data: data,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Graph Screen'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: charts.TimeSeriesChart(
          seriesList,
          animate: true,
          dateTimeFactory: const charts.LocalDateTimeFactory(),
        ),
      ),
    );
  }
}
