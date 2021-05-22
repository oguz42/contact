// To parse this JSON data, do
//
//     final contact = contactFromJson(jsonString);

import 'dart:convert';

List<Contact> contactFromJson(String str) => List<Contact>.from(json.decode(str).map((x) => Contact.fromJson(x)));

String contactToJson(List<Contact> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Contact {
  Contact({
    this.id,
    this.name,
    this.email,
    this.num,
    this.createdAt,
    this.updatedAt,
    this.avatar,
  });

  int id;
  String name;
  String email;
  String num;
  DateTime createdAt;
  DateTime updatedAt;
  Avatar avatar;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    num: json["num"] == null ? null : json["num"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "num": num == null ? null : num,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "avatar": avatar == null ? null : avatar.toJson(),
  };
}
List<Avatar> avatarfromlist(String str) => List<Avatar>.from(json.decode(str).map((x) => Avatar.fromJson(x)));

class Avatar {
  Avatar({
    this.id,
    this.name,
    this.alternativeText,
    this.caption,
    this.width,
    this.height,
    this.formats,
    this.hash,
    this.ext,
    this.mime,
    this.size,
    this.url,
    this.previewUrl,
    this.provider,
    this.providerMetadata,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String alternativeText;
  String caption;
  int width;
  int height;
  Formats formats;
  String hash;
  String ext;
  String mime;
  double size;
  String url;
  dynamic previewUrl;
  String provider;
  dynamic providerMetadata;
  DateTime createdAt;
  DateTime updatedAt;

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    alternativeText: json["alternativeText"] == null ? null : json["alternativeText"],
    caption: json["caption"] == null ? null : json["caption"],
    width: json["width"] == null ? null : json["width"],
    height: json["height"] == null ? null : json["height"],
    formats: json["formats"] == null ? null : Formats.fromJson(json["formats"]),
    hash: json["hash"] == null ? null : json["hash"],
    ext: json["ext"] == null ? null : json["ext"],
    mime: json["mime"] == null ? null : json["mime"],
    size: json["size"] == null ? null : json["size"].toDouble(),
    url: json["url"] == null ? null : json["url"],
    previewUrl: json["previewUrl"],
    provider: json["provider"] == null ? null : json["provider"],
    providerMetadata: json["provider_metadata"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );



  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "alternativeText": alternativeText == null ? null : alternativeText,
    "caption": caption == null ? null : caption,
    "width": width == null ? null : width,
    "height": height == null ? null : height,
    "formats": formats == null ? null : formats.toJson(),
    "hash": hash == null ? null : hash,
    "ext": ext == null ? null : ext,
    "mime": mime == null ? null : mime,
    "size": size == null ? null : size,
    "url": url ==   null? null: url,
    "previewUrl": previewUrl,
    "provider": provider == null ? null : provider,
    "provider_metadata": providerMetadata,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };

  @override
  String toString() {
    // TODO: implement toString
    return "id :$id , name : $name alternativeText : $alternativeText , caption : $caption , width :$width,  height:$height , formats :$formats""hash :$hash  ext: $ext : mime:$mime , size:$size url:$url , previewUrl:$previewUrl , providermetadata: $providerMetadata, createda :$createdAt ,updateatat:$updatedAt ";
  }
}

class Formats {
  Formats({
    this.thumbnail,
    this.large,
    this.medium,
    this.small,
  });

  Large thumbnail;
  Large large;
  Large medium;
  Large small;

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
    thumbnail: json["thumbnail"] == null ? null : Large.fromJson(json["thumbnail"]),
    large: json["large"] == null ? null : Large.fromJson(json["large"]),
    medium: json["medium"] == null ? null : Large.fromJson(json["medium"]),
    small: json["small"] == null ? null : Large.fromJson(json["small"]),
  );

  Map<String, dynamic> toJson() => {
    "thumbnail": thumbnail == null ? null : thumbnail.toJson(),
    "large": large == null ? null : large.toJson(),
    "medium": medium == null ? null : medium.toJson(),
    "small": small == null ? null : small.toJson(),
  };
}

class Large {
  Large({
    this.name,
    this.hash,
    this.ext,
    this.mime,
    this.width,
    this.height,
    this.size,
    this.path,
    this.url,
  });

  String name;
  String hash;
  String ext;
  String mime;
  int width;
  int height;
  double size;
  dynamic path;
  String url;

  factory Large.fromJson(Map<String, dynamic> json) => Large(
    name: json["name"] == null ? null : json["name"],
    hash: json["hash"] == null ? null : json["hash"],
    ext: json["ext"] == null ? null : json["ext"],
    mime: json["mime"] == null ? null : json["mime"],
    width: json["width"] == null ? null : json["width"],
    height: json["height"] == null ? null : json["height"],
    size: json["size"] == null ? null : json["size"].toDouble(),
    path: json["path"],
    url: json["url"] == null ? null : json["url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "hash": hash == null ? null : hash,
    "ext": ext == null ? null : ext,
    "mime": mime == null ? null : mime,
    "width": width == null ? null : width,
    "height": height == null ? null : height,
    "size": size == null ? null : size,
    "path": path,
    "url": url == null ? null : url,
  };
}
