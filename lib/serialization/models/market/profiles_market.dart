
import 'profiles_market_item.dart';

class ProfilesMarket {
  int m_Version;
  String DisplayName;
  String Icon;
  String Color;
  int IsExchange;
  double InitStockPercent;
  List<ProfilesMarketItem> Items;

  String diskFilename = "";

  ProfilesMarket(
      this.m_Version,
      this.DisplayName,
      this.Icon,
      this.Color,
      this.IsExchange,
      this.InitStockPercent,
      this.Items
  );

  ProfilesMarket.fromJson(Map<String, dynamic> json) :
        m_Version = json['m_Version'],
        DisplayName = json['DisplayName'],
        Icon = json['Icon'],
        Color = json['Color'],
        IsExchange = json['IsExchange'],
        InitStockPercent = json['InitStockPercent'],
        Items = ProfilesMarketItem.parseList(json['Items']);

  Map<String, dynamic> toJson() => {
    'm_Version': m_Version,
    'DisplayName': DisplayName,
    'Icon': Icon,
    'Color': Color,
    'IsExchange': IsExchange,
    'InitStockPercent': InitStockPercent,
    'Items': Items,
  };

  @override
  String toString() {
    return 'ProfilesMarket{m_Version: $m_Version, DisplayName: $DisplayName, Icon: $Icon, Color: $Color, IsExchange: $IsExchange, InitStockPercent: $InitStockPercent, Items: $Items, diskFilename: $diskFilename}';
  }
}