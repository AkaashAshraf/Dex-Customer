enum StoryType { vid, img }

class Story {
  int id;
  String createdAt;
  String updatedAt;
  String storyTitle;
  String storyImage;
  String storyVid;
  String storyText;
  String purplisherName;
  String purplisherNameAr;
  String purplisherImage;
  String backgroundColor;
  String seenCounter;
  int targetedShopId;
  String mentionedName;
  dynamic mentionedId;
  dynamic isOn;
  List<dynamic> textList;
  StoryType type;

  Story(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.storyTitle,
      this.storyImage,
      this.storyVid,
      this.storyText,
      this.purplisherName,
      this.purplisherNameAr,
      this.purplisherImage,
      this.backgroundColor,
      this.seenCounter,
      this.targetedShopId,
      this.mentionedId,
      this.mentionedName,
      this.textList,
      this.isOn,
      this.type});

  Story.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    storyTitle = json['storyTitle'];
    storyImage = json['storyImage'];
    storyVid = json['fileURL'];
    storyText = json['storyText'];
    purplisherName = json['purplisherName'];
    purplisherNameAr = json['purplisherName_ar'];
    purplisherImage = json['purplisherImage'];
    backgroundColor = json['backgroundColor'];
    seenCounter = json['seenCounter'];
    targetedShopId = json['targetedShopId'];
    mentionedName = json["getregix"] == null ? '' : json["getregix"]['name'] ?? '';
    isOn = json['isOn'];
    mentionedId =
        json["getregix"] == null ? '' : json["getregix"]['id'] != null ? json["getregix"]['id']['id'] : '';
    textList = json["getregix"] == null ? [] : json["getregix"]['textaray'];
    type = json['fileURL'] != null ? StoryType.vid : StoryType.img;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['storyTitle'] = this.storyTitle;
    data['fileURL'] = this.storyVid;
    data['storyImage'] = this.storyImage;
    data['storyText'] = this.storyText;
    data['purplisherName'] = this.purplisherName;
    data['purplisherName_ar'] = this.purplisherNameAr;
    data['purplisherImage'] = this.purplisherImage;
    data['backgroundColor'] = this.backgroundColor;
    data['seenCounter'] = this.seenCounter;
    data['targetedShopId'] = this.targetedShopId;
    return data;
  }
}
