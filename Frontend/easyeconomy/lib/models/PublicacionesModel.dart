import 'dart:convert';

PublicacionesModel publicacionesModelFromJson(String str) => PublicacionesModel.fromJson(json.decode(str));

String publicacionesModelToJson(PublicacionesModel data) => json.encode(data.toJson());

class PublicacionesModel {
    int? id;
    String? usuario;
    String? contenido;
    DateTime? fecha;
    String? image;

    PublicacionesModel({
        this.id,
        this.usuario,
        this.contenido,
        this.fecha,
        this.image,
    });

    factory PublicacionesModel.fromJson(Map<String, dynamic> json) => PublicacionesModel(
        id: json["id"],
        usuario: json["usuario"],
        contenido: json["contenido"],
        fecha: DateTime.parse(json["fecha"]),
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "usuario": usuario,
        "contenido": contenido,
        "fecha": fecha?.toIso8601String(),
        "image": image,
    };
}
