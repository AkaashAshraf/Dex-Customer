class DeliveryChatListItem {
  int _id;
  String _createdAt;
  String _updatedAt;
  int _threadId;
  int _senderId;
  String _target;
  String _title;
  String _body;
  String _image;
  String _name;

  DeliveryChatListItem(
      {int id,
      String createdAt,
      String updatedAt,
      int threadId,
      int senderId,
      String target,
      String title,
      String body,
      String image,
      String name}) {
    this._id = id;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._threadId = threadId;
    this._senderId = senderId;
    this._target = target;
    this._title = title;
    this._body = body;
    this._image = image;
    this._name = name;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  int get threadId => _threadId;
  set threadId(int threadId) => _threadId = threadId;
  int get senderId => _senderId;
  set senderId(int senderId) => _senderId = senderId;
  String get target => _target;
  set target(String target) => _target = target;
  String get title => _title;
  set title(String title) => _title = title;
  String get body => _body;
  set body(String body) => _body = body;
  String get image => _image;
  set image(String image) => _image = image;
  String get name => _name;
  set name(String name) => _name;

  DeliveryChatListItem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _threadId = json['thread_id'];
    _senderId = json['sender_id'];
    _target = json['target'];
    _title = json['title'];
    _body = json['body'];
    _image = json['image'] ?? '';
    _name = json['senderInfo'] != null
        ? json['senderInfo']['first_name']
        : 'Unknown';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['thread_id'] = this._threadId;
    data['sender_id'] = this._senderId;
    data['target'] = this._target;
    data['title'] = this._title;
    data['body'] = this._body;
    data['image'] = this._image;
    data['senderInfo']['first_name'] = this._name;
    return data;
  }
}
