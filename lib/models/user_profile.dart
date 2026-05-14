import 'package:hive/hive.dart';

class UserProfile {
  String name;
  String email;
  DateTime registrationDate;
  int score;

  UserProfile({
    required this.name,
    required this.email,
    required this.registrationDate,
    required this.score,
  });
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    return UserProfile(
      name: reader.readString(),
      email: reader.readString(),
      registrationDate: DateTime.parse(reader.readString()),
      score: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.email);
    writer.writeString(obj.registrationDate.toIso8601String());
    writer.writeInt(obj.score);
  }
}