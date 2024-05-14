import 'dart:convert';

TransaccionesModel transaccionesModelFromJson(String str) => TransaccionesModel.fromJson(json.decode(str));

String transaccionesModelToJson(TransaccionesModel data) => json.encode(data.toJson());

class TransaccionesModel {
    String? user;
    String? tipo;
    String? descripcion;
    double? monto;
    String? imagen;
    DateTime? fecha;
    int? id_Categoria;

    TransaccionesModel({
        this.user,
        this.tipo,
        this.descripcion,
        this.monto,
        this.imagen,
        this.fecha,
        this.id_Categoria,
    });

    factory TransaccionesModel.fromJson(Map<String, dynamic> json) => TransaccionesModel(
        user: json["user"],
        tipo: json["tipo"],
        descripcion: json["descripcion"],
        monto: json["monto"],
        imagen: json["imagen"],
        fecha: DateTime.parse(json["fecha"]),
        id_Categoria: json["id_Categoria"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "tipo": tipo,
        "descripcion": descripcion,
        "monto": monto,
        "imagen": imagen,
        "fecha": fecha?.toIso8601String(),
        "id_Categoria": id_Categoria,
    };
}