class ExhibitionItemDTO {
  String _id;
  String _url;
  String _title;
  String _text;
  String _dateStart;
  String _dateEnd;
  String _isActive;

  String get id => _id;

  String get url => _url;

  String get title => _title;

  String get text => _text;

  String get dateStart => _dateStart;

  String get dateEnd => _dateEnd;

  String get isActive => _isActive;

  ExhibitionItemDTO(
      {String id,
      String url,
      String title,
      String text,
      String dateStart,
      String dateEnd,
      String isActive}) {
    _id = id;
    _url = url;
    _title = title;
    _text = text;
    _dateStart = dateStart;
    _dateEnd = dateEnd;
    _isActive = isActive;
  }

  ExhibitionItemDTO.fromJson(dynamic json) {
    _id = json["id"];
    _url = json["url"];
    _title = json["title"];
    _text = json["text"];
    _dateStart = json["date_start"];
    _dateEnd = json["date_end"];
    _isActive = json["is_active"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["url"] = _url;
    map["title"] = _title;
    map["text"] = _text;
    map["date_start"] = _dateStart;
    map["date_end"] = _dateEnd;
    map["is_active"] = _isActive;
    return map;
  }
}

class ObjectItemDTO {
  String _id;
  String _tmsId;
  String _accessionNumber;
  String _title;
  String _titleRaw;
  String _url;
  dynamic _hasNoKnownCopyright;
  String _departmentId;
  String _periodId;
  String _mediaId;
  String _typeId;
  String _date;
  int _yearStart;
  int _yearEnd;
  String _yearAcquired;
  String _decade;
  String _countryId;
  String _medium;
  String _markings;
  dynamic _signed;
  String _inscribed;
  String _provenance;
  String _dimensions;
  Dimensions _dimensionsRaw;
  String _creditLine;
  String _description;
  dynamic _justification;
  dynamic _galleryText;
  dynamic _labelText;
  dynamic _videos;
  dynamic _onDisplay;
  String _country;
  String _type;
  List<MultiSizeImage> _images;
  List<Participants> _participants;
  String _countryName;
  int _isLoanObject;

  String get id => _id;

  String get tmsId => _tmsId;

  String get accessionNumber => _accessionNumber;

  String get title => _title;

  String get titleRaw => _titleRaw;

  String get url => _url;

  dynamic get hasNoKnownCopyright => _hasNoKnownCopyright;

  String get departmentId => _departmentId;

  String get periodId => _periodId;

  String get mediaId => _mediaId;

  String get typeId => _typeId;

  String get date => _date;

  int get yearStart => _yearStart;

  int get yearEnd => _yearEnd;

  String get yearAcquired => _yearAcquired;

  String get decade => _decade;

  String get countryId => _countryId;

  String get medium => _medium;

  String get markings => _markings;

  dynamic get signed => _signed;

  String get inscribed => _inscribed;

  String get provenance => _provenance;

  String get dimensions => _dimensions;

  Dimensions get dimensionsRaw => _dimensionsRaw;

  String get creditLine => _creditLine;

  String get description => _description;

  dynamic get justification => _justification;

  dynamic get galleryText => _galleryText;

  dynamic get labelText => _labelText;

  dynamic get videos => _videos;

  dynamic get onDisplay => _onDisplay;

  String get country => _country;

  String get type => _type;

  List<MultiSizeImage> get images => _images;

  List<Participants> get participants => _participants;

  String get countryName => _countryName;

  int get isLoanObject => _isLoanObject;

  ObjectItemDTO(
      {String id,
      String tmsId,
      String accessionNumber,
      String title,
      String titleRaw,
      String url,
      dynamic hasNoKnownCopyright,
      String departmentId,
      String periodId,
      String mediaId,
      String typeId,
      String date,
      int yearStart,
      int yearEnd,
      String yearAcquired,
      String decade,
      String countryId,
      String medium,
      String markings,
      dynamic signed,
      String inscribed,
      String provenance,
      String dimensions,
      Dimensions dimensionsRaw,
      String creditLine,
      String description,
      dynamic justification,
      dynamic galleryText,
      dynamic labelText,
      dynamic videos,
      dynamic onDisplay,
      String country,
      String type,
      List<MultiSizeImage> images,
      List<Participants> participants,
      String countryName,
      int isLoanObject}) {
    _id = id;
    _tmsId = tmsId;
    _accessionNumber = accessionNumber;
    _title = title;
    _titleRaw = titleRaw;
    _url = url;
    _hasNoKnownCopyright = hasNoKnownCopyright;
    _departmentId = departmentId;
    _periodId = periodId;
    _mediaId = mediaId;
    _typeId = typeId;
    _date = date;
    _yearStart = yearStart;
    _yearEnd = yearEnd;
    _yearAcquired = yearAcquired;
    _decade = decade;
    _countryId = countryId;
    _medium = medium;
    _markings = markings;
    _signed = signed;
    _inscribed = inscribed;
    _provenance = provenance;
    _dimensions = dimensions;
    _dimensionsRaw = dimensionsRaw;
    _creditLine = creditLine;
    _description = description;
    _justification = justification;
    _galleryText = galleryText;
    _labelText = labelText;
    _videos = videos;
    _onDisplay = onDisplay;
    _country = country;
    _type = type;
    _images = images;
    _participants = participants;
    _countryName = countryName;
    _isLoanObject = isLoanObject;
  }

  ObjectItemDTO.fromJson(dynamic json) {
    _id = json["id"];
    _tmsId = json["tms:id"];
    _accessionNumber = json["accession_number"];
    _title = json["title"];
    _titleRaw = json["title_raw"];
    _url = json["url"];
    _hasNoKnownCopyright = json["has_no_known_copyright"];
    _departmentId = json["department_id"];
    _periodId = json["period_id"];
    _mediaId = json["media_id"];
    _typeId = json["type_id"];
    _date = json["date"];
    _yearStart = json["year_start"];
    _yearEnd = json["year_end"];
    _yearAcquired = json["year_acquired"];
    _decade = json["decade"];
    _countryId = json["woe:country_id"];
    _medium = json["medium"];
    _markings = json["markings"];
    _signed = json["signed"];
    _inscribed = json["inscribed"];
    _provenance = json["provenance"];
    _dimensions = json["dimensions"];
    _dimensionsRaw = json["dimensions_raw"] != null
        ? Dimensions.fromJson(json["dimensions_raw"])
        : null;
    _creditLine = json["creditline"];
    _description = json["description"];
    _justification = json["justification"];
    _galleryText = json["gallery_text"];
    _labelText = json["label_text"];
    _videos = json["videos"];
    _onDisplay = json["on_display"];
    _country = json["woe:country"];
    _type = json["type"];
    if (json["images"] != null) {
      final List<dynamic> imagesList = json["images"];
      _images = [];
      for (int i = 0; i < imagesList.length; i++) {
        final dynamic multiSizeImageJson = imagesList[i];
        _images.add(MultiSizeImage(
            large: Image.fromJson(multiSizeImageJson["b"]),
            medium: Image.fromJson(multiSizeImageJson['z']),
            small: Image.fromJson(multiSizeImageJson['n']),
            xsmall: Image.fromJson(multiSizeImageJson['sq'])));
      }
    }
    if (json["participants"] != null) {
      _participants = [];
      json["participants"].forEach((v) {
        _participants.add(Participants.fromJson(v));
      });
    }
    _countryName = json["woe:country_name"];
    _isLoanObject = json["is_loan_object"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["tms:id"] = _tmsId;
    map["accession_number"] = _accessionNumber;
    map["title"] = _title;
    map["title_raw"] = _titleRaw;
    map["url"] = _url;
    map["has_no_known_copyright"] = _hasNoKnownCopyright;
    map["department_id"] = _departmentId;
    map["period_id"] = _periodId;
    map["media_id"] = _mediaId;
    map["type_id"] = _typeId;
    map["date"] = _date;
    map["year_start"] = _yearStart;
    map["year_end"] = _yearEnd;
    map["year_acquired"] = _yearAcquired;
    map["decade"] = _decade;
    map["woe:country_id"] = _countryId;
    map["medium"] = _medium;
    map["markings"] = _markings;
    map["signed"] = _signed;
    map["inscribed"] = _inscribed;
    map["provenance"] = _provenance;
    map["dimensions"] = _dimensions;
    if (_dimensionsRaw != null) {
      map["dimensions_raw"] = _dimensionsRaw.toJson();
    }
    map["creditline"] = _creditLine;
    map["description"] = _description;
    map["justification"] = _justification;
    map["gallery_text"] = _galleryText;
    map["label_text"] = _labelText;
    map["videos"] = _videos;
    map["on_display"] = _onDisplay;
    map["woe:country"] = _country;
    map["type"] = _type;
    if (_images != null) {
      map['images'] = [];
      for (int i = 0; i < _images.length; i++) {
        final multiSizeImage = images[i];
        map["images"].add({
          "b": multiSizeImage.large.toJson(),
          "z": multiSizeImage.medium.toJson(),
          'n': multiSizeImage.small.toJson(),
          "sq": multiSizeImage.xsmall.toJson()
        });
      }
    }
    if (_participants != null) {
      map["participants"] = _participants.map((v) => v.toJson()).toList();
    }
    map["woe:country_name"] = _countryName;
    map["is_loan_object"] = _isLoanObject;
    return map;
  }
}

class Participants {
  String _personId;
  String _roleId;
  String _personName;
  String _personDate;
  String _roleName;
  String _roleDisplayName;
  String _personUrl;
  String _roleUrl;

  String get personId => _personId;

  String get roleId => _roleId;

  String get personName => _personName;

  String get personDate => _personDate;

  String get roleName => _roleName;

  String get roleDisplayName => _roleDisplayName;

  String get personUrl => _personUrl;

  String get roleUrl => _roleUrl;

  Participants(
      {String personId,
      String roleId,
      String personName,
      String personDate,
      String roleName,
      String roleDisplayName,
      String personUrl,
      String roleUrl}) {
    _personId = personId;
    _roleId = roleId;
    _personName = personName;
    _personDate = personDate;
    _roleName = roleName;
    _roleDisplayName = roleDisplayName;
    _personUrl = personUrl;
    _roleUrl = roleUrl;
  }

  Participants.fromJson(dynamic json) {
    _personId = json["person_id"];
    _roleId = json["role_id"];
    _personName = json["person_name"];
    _personDate = json["person_date"];
    _roleName = json["role_name"];
    _roleDisplayName = json["role_display_name"];
    _personUrl = json["person_url"];
    _roleUrl = json["role_url"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["person_id"] = _personId;
    map["role_id"] = _roleId;
    map["person_name"] = _personName;
    map["person_date"] = _personDate;
    map["role_name"] = _roleName;
    map["role_display_name"] = _roleDisplayName;
    map["person_url"] = _personUrl;
    map["role_url"] = _roleUrl;
    return map;
  }
}

class MultiSizeImage {
  Image _large;
  Image _medium;
  Image _small;
  Image _xsmall;

  Image get large => _large;

  Image get medium => _medium;

  Image get small => _small;

  Image get xsmall => _xsmall;

  MultiSizeImage({Image large, Image medium, Image small, Image xsmall}) {
    _large = large;
    _medium = medium;
    _small = small;
    _xsmall = xsmall;
  }

  MultiSizeImage.fromJson(dynamic json) {
    _large = json["b"] != null ? Image.fromJson(json["b"]) : null;
    _medium = json["z"] != null ? Image.fromJson(json["z"]) : null;
    _small = json["n"] != null ? Image.fromJson(json["n"]) : null;
    _xsmall = json["sq"] != null ? Image.fromJson(json["sq"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_large != null) {
      map["b"] = _large.toJson();
    }
    if (_medium != null) {
      map["z"] = _medium.toJson();
    }
    if (_small != null) {
      map["n"] = _small.toJson();
    }
    if (_xsmall != null) {
      map["sq"] = _xsmall.toJson();
    }
    return map;
  }
}

class Image {
  String _url;
  int _width;
  int _height;
  String _isPrimary;
  String _imageId;

  String get url => _url;

  int get width => _width;

  int get height => _height;

  String get isPrimary => _isPrimary;

  String get imageId => _imageId;

  Image({String url, int width, int height, String isPrimary, String imageId}) {
    _url = url;
    _width = width;
    _height = height;
    _isPrimary = isPrimary;
    _imageId = imageId;
  }

  Image.fromJson(dynamic json) {
    _url = json["url"];
    _width = json["width"];
    _height = json["height"];
    _isPrimary = json["is_primary"];
    _imageId = json["image_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["url"] = _url;
    map["width"] = _width;
    map["height"] = _height;
    map["is_primary"] = _isPrimary;
    map["image_id"] = _imageId;
    return map;
  }
}

class Dimensions {
  List<String> _height;
  List<String> _width;

  List<String> get height => _height;

  List<String> get width => _width;

  Dimensions({List<String> height, List<String> width}) {
    _height = height;
    _width = width;
  }

  Dimensions.fromJson(dynamic json) {
    _height = json["height"] != null ? json["height"].cast<String>() : [];
    _width = json["width"] != null ? json["width"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["height"] = _height;
    map["width"] = _width;
    return map;
  }
}
