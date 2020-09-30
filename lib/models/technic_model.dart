class TechnicModel {
  String name;
  String urlAvatar;
  String address;
  String phome;
  String lat;
  String lng;

  TechnicModel(
      {this.name,
      this.urlAvatar,
      this.address,
      this.phome,
      this.lat,
      this.lng});

  TechnicModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    urlAvatar = json['UrlAvatar'];
    address = json['Address'];
    phome = json['Phome'];
    lat = json['Lat'];
    lng = json['Lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['UrlAvatar'] = this.urlAvatar;
    data['Address'] = this.address;
    data['Phome'] = this.phome;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    return data;
  }
}

