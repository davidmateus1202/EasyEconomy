import 'dart:convert';

BolsillosModel bolsillosModelFromJson(String str) => BolsillosModel.fromJson(json.decode(str));

String bolsillosModelToJson(BolsillosModel data) => json.encode(data.toJson());

class BolsillosModel {
    int? id;
    Usuario? usuario;
    String? nombreBolsillo;
    String? descripcion;
    double? saldo;
    DateTime? fecha;

    BolsillosModel({
        this.id,
        this.usuario,
        this.nombreBolsillo,
        this.descripcion,
        this.saldo,
        this.fecha,
    });

    factory BolsillosModel.fromJson(Map<String, dynamic> json) => BolsillosModel(
        id: json["id"],
        usuario: Usuario.fromJson(json["usuario"]),
        nombreBolsillo: json["nombre_bolsillo"],
        descripcion: json["descripcion"],
        saldo: json["saldo"],
        fecha: DateTime.parse(json["fecha"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "usuario": usuario?.toJson(),
        "nombre_bolsillo": nombreBolsillo,
        "descripcion": descripcion,
        "saldo": saldo,
        "fecha": fecha?.toIso8601String(),
    };
}

class Usuario {
    int? id;
    String? username;
    String? email;

    Usuario({
        this.id,
        this.username,
        this.email,
    });

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        username: json["username"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
    };
}
