import 'dart:convert';


GastosFijos gastosFijosFromJson(String str) => GastosFijos.fromJson(json.decode(str));

String gastosFijosToJson(GastosFijos data) => json.encode(data.toJson());

class GastosFijos {
    int? id;
    Usuario? usuario;
    String? tipo;
    double? monto;
    String? descripcion;
    DateTime? fecha;
    int? idCategoria;

    GastosFijos({
        this.id,
        this.usuario,
        this.tipo, 
        this.monto,
        this.descripcion,
        this.fecha,
        this.idCategoria,
    });

    factory GastosFijos.fromJson(Map<String, dynamic> json) => GastosFijos(
        id: json["id"],
        usuario: Usuario.fromJson(json["usuario"]),
        tipo: json["tipo"],
        monto: json["monto"],
        descripcion: json["descripcion"],
        fecha: DateTime.parse(json["fecha"]),
        idCategoria: json["id_Categoria"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "usuario": usuario?.toJson(),
        "tipo": tipo,
        "monto": monto,
        "descripcion": descripcion,
        "fecha": fecha?.toIso8601String(),
        "id_Categoria": idCategoria,
    };
}

class Usuario {
    int? id;
    String? username;
    String? email;

    Usuario({
        required this.id,
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
