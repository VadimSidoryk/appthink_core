class BehanceProjectListDTO {
  List<BehanceProjectDTO> _projects;

  List<BehanceProjectDTO> get projects => _projects;

  BehanceProjectListDTO.fromJson(dynamic json) {
    _projects = [];
    final List<Map<String, dynamic>> projField = json["projects"];
    for(int i = 0; i < projField.length; i++) {
      _projects.add(BehanceProjectDTO.fromJson(projField[i]));
    }
  }
}

class BehanceProjectDTO {
  int _id;
  String _name;
  int _publishedOn;
  int _createdOn;
  int _modifiedOn;
  String _url;
  List<String> _fields;
  Covers _covers;
  int _matureContent;
  Owners _owners;
  Stats _stats;

  int get id => _id;
  String get name => _name;
  int get publishedOn => _publishedOn;
  int get createdOn => _createdOn;
  int get modifiedOn => _modifiedOn;
  String get url => _url;
  List<String> get fields => _fields;
  Covers get covers => _covers;
  int get matureContent => _matureContent;
  Owners get owners => _owners;
  Stats get stats => _stats;

  BehanceProjectDTO({
      int id, 
      String name, 
      int publishedOn, 
      int createdOn, 
      int modifiedOn, 
      String url, 
      List<String> fields, 
      Covers covers, 
      int matureContent,
      Owners owners,
      Stats stats}){
    _id = id;
    _name = name;
    _publishedOn = publishedOn;
    _createdOn = createdOn;
    _modifiedOn = modifiedOn;
    _url = url;
    _fields = fields;
    _covers = covers;
    _matureContent = matureContent;
    _owners = owners;
    _stats = stats;
}

  BehanceProjectDTO.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _publishedOn = json["published_on"];
    _createdOn = json["created_on"];
    _modifiedOn = json["modified_on"];
    _url = json["url"];
    _fields = json["fields"] != null ? json["fields"].cast<String>() : [];
    _covers = json["covers"] != null ? Covers.fromJson(json["covers"]) : null;
    _matureContent = json["mature_content"];
    _owners = json["owners"] != null ? Owners.fromJson(json["owners"]) : null;
    _stats = json["stats"] != null ? Stats.fromJson(json["stats"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["published_on"] = _publishedOn;
    map["created_on"] = _createdOn;
    map["modified_on"] = _modifiedOn;
    map["url"] = _url;
    map["fields"] = _fields;
    if (_covers != null) {
      map["covers"] = _covers.toJson();
    }
    map["mature_content"] = _matureContent;
    if (_owners != null) {
      map["owners"] = _owners.toJson();
    }
    if (_stats != null) {
      map["stats"] = _stats.toJson();
    }
    return map;
  }

}

/// views : 1510
/// appreciations : 179
/// comments : 21

class Stats {
  int _views;
  int _appreciations;
  int _comments;

  int get views => _views;
  int get appreciations => _appreciations;
  int get comments => _comments;

  Stats({
      int views, 
      int appreciations, 
      int comments}){
    _views = views;
    _appreciations = appreciations;
    _comments = comments;
}

  Stats.fromJson(dynamic json) {
    _views = json["views"];
    _appreciations = json["appreciations"];
    _comments = json["comments"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["views"] = _views;
    map["appreciations"] = _appreciations;
    map["comments"] = _comments;
    return map;
  }

}

class Owners {
  Map<String, Owner> ownersMap;

  Owners.fromJson(Map<String, dynamic> json) {
    ownersMap = {};
    for(String key in json.keys) {
      ownersMap[key] = Owner.fromJson(json[key]);
    }
  }

  Map<String, Owner> toJson() {
    return ownersMap;
  }
}

class Owner {
  int _id;
  String _firstName;
  String _lastName;
  String _username;
  String _city;
  String _state;
  String _country;
  String _company;
  String _occupation;
  int _createdOn;
  String _url;
  String _displayName;
  Images _images;
  List<String> _fields;

  int get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get username => _username;
  String get city => _city;
  String get state => _state;
  String get country => _country;
  String get company => _company;
  String get occupation => _occupation;
  int get createdOn => _createdOn;
  String get url => _url;
  String get displayName => _displayName;
  Images get images => _images;
  List<String> get fields => _fields;

  Owner({
      int id, 
      String firstName, 
      String lastName, 
      String username, 
      String city, 
      String state, 
      String country, 
      String company, 
      String occupation, 
      int createdOn, 
      String url, 
      String displayName, 
      Images images, 
      List<String> fields}){
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _username = username;
    _city = city;
    _state = state;
    _country = country;
    _company = company;
    _occupation = occupation;
    _createdOn = createdOn;
    _url = url;
    _displayName = displayName;
    _images = images;
    _fields = fields;
}

  Owner.fromJson(dynamic json) {
    _id = json["id"];
    _firstName = json["first_name"];
    _lastName = json["last_name"];
    _username = json["username"];
    _city = json["city"];
    _state = json["state"];
    _country = json["country"];
    _company = json["company"];
    _occupation = json["occupation"];
    _createdOn = json["created_on"];
    _url = json["url"];
    _displayName = json["display_name"];
    _images = json["images"] != null ? Images.fromJson(json["images"]) : null;
    _fields = json["fields"] != null ? json["fields"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["first_name"] = _firstName;
    map["last_name"] = _lastName;
    map["username"] = _username;
    map["city"] = _city;
    map["state"] = _state;
    map["country"] = _country;
    map["company"] = _company;
    map["occupation"] = _occupation;
    map["created_on"] = _createdOn;
    map["url"] = _url;
    map["display_name"] = _displayName;
    if (_images != null) {
      map["images"] = _images.toJson();
    }
    map["fields"] = _fields;
    return map;
  }

}

class Images {
  String _xxsmall;
  String _xsmall;
  String _small;
  String _medium;
  String _large;
  String _xlarge;

  String get xxsmall => _xxsmall;
  String get xsmall => _xsmall;
  String get small => _small;
  String get medium => _medium;
  String get large => _large;
  String get xlarge => _xlarge;

  Images({
      String xxsmall, 
      String xsmall, 
      String small, 
      String medium , 
      String large, 
      String xlarge}){
    _xxsmall = xxsmall;
    _xsmall = xsmall;
    _small = small;
    _medium = medium;
    _large = large;
    _xlarge = xlarge;
}

  Images.fromJson(dynamic json) {
    _xxsmall = json["32"];
    _xsmall = json["50"];
    _small = json["78"];
    _medium = json["115"];
    _large = json["129"];
    _xlarge = json["138"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["32"] = _xxsmall;
    map["50"] = _xsmall;
    map["78"] = _small;
    map["115"] = _medium;
    map["129"] = _large;
    map["138"] = _xlarge;
    return map;
  }

}

class Covers {
  String _medium;
  String _large;

  String get medium => _medium;
  String get large => _large;

  Covers({
      String medium,
      String large}){
    _medium = medium;
    _large = large;
}

  Covers.fromJson(dynamic json) {
    _medium = json["115"];
    _large = json["202"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["115"] = _medium;
    map["202"] = _large;
    return map;
  }

}