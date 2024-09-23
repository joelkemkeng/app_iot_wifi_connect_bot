import 'dart:convert';
import 'package:collection/collection.dart';

class Credential {
  final String ssid;
  final String password;

  Credential({required this.ssid, required this.password});

  @override
  String toString() => 'Credential(ssid: $ssid, password: $password)';

  // Factory pour créer un objet Credential à partir d'une map
  factory Credential.fromMap(Map<String, dynamic> data) {
    return Credential(
      ssid: data['ssid'] as String,
      password: data['password'] as String,
    );
  }

  // Méthode pour convertir l'objet Credential en Map
  Map<String, dynamic> toMap() => {
    'ssid': ssid,
    'password': password,
  };

  static String convertToStringSend(){
    return '{"ssid":"ssid","password":"password"}';
  }

  /// `dart:convert`
  ///
  /// Parse la chaîne JSON et renvoie l'objet [Credential].
  factory Credential.fromJson(String data) {
    return Credential.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Convertit l'objet [Credential] en chaîne JSON.
  String toJson() {
    print("\n\n Json credential Send in Server is -->>> : ${json.encode(toMap())} \n\n ");
    return json.encode(toMap());
  }

  // Méthode copyWith pour cloner un objet en modifiant des valeurs spécifiques
  Credential copyWith({
    String? ssid,
    String? password,
  }) {
    return Credential(
      ssid: ssid ?? this.ssid,
      password: password ?? this.password,
    );
  }

  // Opérateur d'égalité pour comparer deux objets Credential
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Credential) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  // HashCode pour l'objet Credential
  @override
  int get hashCode => ssid.hashCode ^ password.hashCode;
}