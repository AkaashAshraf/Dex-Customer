/*
 *    ozozoz   ozozoz
 *    oz  oz      oz
 *    oz  oz     oz
 *    oz  oz    oz  
 *    ozozoz   ozozoz
 *
 * Created on Mon Jun 29 2020   
 *
 * Copyright (c) 2020 Osman Solomon
 */
List<TranzList> tranzList;

class TranzList {
  int id;
  String note;
  String createdAt;
  String updatedAt;
  String merchantPhone;
  String customerGivenName;
  String customerPhone;
  String cartItemName;
  String amount;
  String currency;
  String paymentCuse;
  String hayperPayId;
  String state;
  int customerId;
  int driverId;
  int merchantId;

  TranzList(
      {this.id,
      this.note,
      this.createdAt,
      this.updatedAt,
      this.merchantPhone,
      this.customerGivenName,
      this.customerPhone,
      this.cartItemName,
      this.amount,
      this.currency,
      this.paymentCuse,
      this.hayperPayId,
      this.state,
      this.customerId,
      this.driverId,
      this.merchantId});

  TranzList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    merchantPhone = json['merchantPhone'];
    customerGivenName = json['customerGivenName'];
    customerPhone = json['customerPhone'];
    cartItemName = json['cartItemName'];
    amount = json['amount'];
    currency = json['currency'];
    paymentCuse = json['paymentCuse'];
    hayperPayId = json['hayperPayId'];
    state = json['state'];
    customerId = json['customerId'];
    driverId = json['driverId'];
    merchantId = json['merchantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.note;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['merchantPhone'] = this.merchantPhone;
    data['customerGivenName'] = this.customerGivenName;
    data['customerPhone'] = this.customerPhone;
    data['cartItemName'] = this.cartItemName;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['paymentCuse'] = this.paymentCuse;
    data['hayperPayId'] = this.hayperPayId;
    data['state'] = this.state;
    data['customerId'] = this.customerId;
    data['driverId'] = this.driverId;
    data['merchantId'] = this.merchantId;
    return data;
  }
}
