// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_reward_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyRewardAdapter extends TypeAdapter<DailyReward> {
  @override
  final int typeId = 27;

  @override
  DailyReward read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyReward(
      day: fields[0] as int,
      rewardType: fields[1] as String,
      rewardId: fields[2] as String,
      amount: fields[3] as double,
      isClaimed: fields[4] as bool,
      claimDate: fields[5] as DateTime?,
      streak: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyReward obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.rewardType)
      ..writeByte(2)
      ..write(obj.rewardId)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.isClaimed)
      ..writeByte(5)
      ..write(obj.claimDate)
      ..writeByte(6)
      ..write(obj.streak);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyRewardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
