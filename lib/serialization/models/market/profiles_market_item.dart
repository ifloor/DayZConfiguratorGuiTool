import 'package:dayz_configurator_gui_tool/utils/deserialization_utils.dart';
import 'package:flutter/cupertino.dart';

class ProfilesMarketItem {
  String ClassName;
  int MaxPriceThreshold;
  int MinPriceThreshold;
  double SellPricePercent;
  int MaxStockThreshold;
  int MinStockThreshold;
  int QuantityPercent;
  List<String> SpawnAttachments;
  List<String> Variants;

  ProfilesMarketItem(
      this.ClassName,
      this.MaxPriceThreshold,
      this.MinPriceThreshold,
      this.SellPricePercent,
      this.MaxStockThreshold,
      this.MinStockThreshold,
      this.QuantityPercent,
      this.SpawnAttachments,
      this.Variants
  );

  ProfilesMarketItem.fromJson(Map<String, dynamic> json) :
        ClassName = json['ClassName']?.toLowerCase(),
        MaxPriceThreshold = json['MaxPriceThreshold'],
        MinPriceThreshold = json['MinPriceThreshold'],
        SellPricePercent = json['SellPricePercent'],
        MaxStockThreshold = json['MaxStockThreshold'],
        MinStockThreshold = json['MinStockThreshold'],
        QuantityPercent = int.parse((json['QuantityPercent']).toString()),
        SpawnAttachments = DeserializationUtils.toStringList(json['SpawnAttachments'], applyLowerCasing: true),
        Variants = DeserializationUtils.toStringList(json['Variants'], applyLowerCasing: true);

  Map<String, dynamic> toJson() => {
    'ClassName': ClassName.toLowerCase(),
    'MaxPriceThreshold': MaxPriceThreshold,
    'MinPriceThreshold': MinPriceThreshold,
    'SellPricePercent': SellPricePercent,
    'MaxStockThreshold': MaxStockThreshold,
    'MinStockThreshold': MinStockThreshold,
    'QuantityPercent': QuantityPercent,
    'SpawnAttachments': DeserializationUtils.toStringList(SpawnAttachments, applyLowerCasing: true),
    'Variants': DeserializationUtils.toStringList(Variants, applyLowerCasing: true),
  };

  static List<ProfilesMarketItem> parseList(List<dynamic> jsons) {
    List<ProfilesMarketItem> parsedItems = [];

    for (var json in jsons) {
      try {
        parsedItems.add(ProfilesMarketItem.fromJson(json));
      } catch (error) {
        debugPrint('Error parsing ProfilesMarketItem: $error\nFor json: ${json.toString()}');
        rethrow;
      }
    }

    return parsedItems;
  }

  @override
  String toString() {
    return 'ProfilesMarketItem{ClassName: $ClassName, MaxPriceThreshold: $MaxPriceThreshold, MinPriceThreshold: $MinPriceThreshold, SellPricePercent: $SellPricePercent, MaxStockThreshold: $MaxStockThreshold, MinStockThreshold: $MinStockThreshold, QuantityPercent: $QuantityPercent, SpawnAttachments: $SpawnAttachments, Variants: $Variants}';
  }
}