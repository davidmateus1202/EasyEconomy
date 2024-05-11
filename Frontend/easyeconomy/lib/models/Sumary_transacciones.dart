import 'dart:convert';

SumaryTransacciones sumaryTransaccionesFromJson(String str) => SumaryTransacciones.fromJson(json.decode(str));

String sumaryTransaccionesToJson(SumaryTransacciones data) => json.encode(data.toJson());

class SumaryTransacciones {
    DateTime? fecha;
    double? total;

    SumaryTransacciones({
        this.fecha,
        this.total,
    });

    factory SumaryTransacciones.fromJson(Map<String, dynamic> json) => SumaryTransacciones(
        fecha: DateTime.parse(json["fecha"]),
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "fecha": "${fecha?.year.toString().padLeft(4, '0')}-${fecha?.month.toString().padLeft(2, '0')}-${fecha?.day.toString().padLeft(2, '0')}",
        "total": total,
    };
}
