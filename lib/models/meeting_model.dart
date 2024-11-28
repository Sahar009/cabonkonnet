// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cabonconnet/models/product_model.dart';
import 'package:cabonconnet/models/user_model.dart';

enum MeetingStatus {
  pending,
  scheduled,
  rescheduled,
  cancelled,
  rejected,
  completed;

  String toMap() => name;

  static MeetingStatus fromMap(String value) {
    return MeetingStatus.values.firstWhere((e) => e.name == value);
  }
}

class MeetingModel {
  final String id;
  final String investorId;
  final UserModel? investor;
  final String founderId;
  final UserModel? founder;
  final String productId;
  final ProductModel? product;
  final DateTime? scheduledAt;
  final MeetingStatus status;
  final String? meetingNote;
  final String? meetingLink;
  final String? investorCancelReason;
  final String? founderRejectReason;
  final String? adminCancelReason;
  final bool isScheduled;

  MeetingModel(
      {required this.id,
      required this.investorId,
      this.investor,
      required this.founderId,
      this.founder,
      required this.productId,
      this.product,
      this.scheduledAt,
      this.status = MeetingStatus.pending,
      this.meetingNote,
      this.investorCancelReason,
      this.founderRejectReason,
      this.adminCancelReason,
      this.isScheduled = false,
      this.meetingLink});

  MeetingModel copyWith(
      {String? id,
      String? investorId,
      UserModel? investor,
      String? founderId,
      UserModel? founder,
      String? productId,
      ProductModel? product,
      DateTime? scheduledAt,
      MeetingStatus? status,
      String? meetingNote,
      String? investorCancelReason,
      String? founderRejectReason,
      String? adminCancelReason,
      bool? isScheduled,
      String? meetingLink}) {
    return MeetingModel(
        id: id ?? this.id,
        investorId: investorId ?? this.investorId,
        investor: investor ?? this.investor,
        founderId: founderId ?? this.founderId,
        founder: founder ?? this.founder,
        productId: productId ?? this.productId,
        product: product ?? this.product,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        status: status ?? this.status,
        meetingNote: meetingNote ?? this.meetingNote,
        investorCancelReason: investorCancelReason ?? this.investorCancelReason,
        founderRejectReason: founderRejectReason ?? this.founderRejectReason,
        adminCancelReason: adminCancelReason ?? this.adminCancelReason,
        isScheduled: isScheduled ?? this.isScheduled,
        meetingLink: meetingLink ?? this.meetingLink);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'investorId': investorId,
      'investor': investorId,
      'founderId': founderId,
      'founder': founderId,
      'productId': productId,
      'product': productId,
      'scheduledAt': scheduledAt?.toIso8601String(),
      'status': status.toMap(),
      'meetingNote': meetingNote,
      'investorCancelReason': investorCancelReason,
      'founderRejectReason': founderRejectReason,
      'adminCancelReason': adminCancelReason,
      'isScheduled': isScheduled,
      "meetingLink": meetingLink
    };
  }

  factory MeetingModel.fromMap(Map<String, dynamic> map) {
    return MeetingModel(
        id: map['\$id'] as String,
        investorId: map['investorId'] as String,
        investor: UserModel.fromMap(map['investor'] as Map<String, dynamic>),
        founderId: map['founderId'] as String,
        founder: UserModel.fromMap(map['founder'] as Map<String, dynamic>),
        productId: map['productId'] as String,
        product: ProductModel.fromMap(map['product'] as Map<String, dynamic>),
        scheduledAt: map['scheduledAt'] != null
            ? DateTime.tryParse(map['scheduledAt'])
            : null,
        status: MeetingStatus.fromMap(map['status']),
        meetingNote:
            map['meetingNote'] != null ? map['meetingNote'] as String : null,
        investorCancelReason: map['investorCancelReason'] != null
            ? map['investorCancelReason'] as String
            : null,
        founderRejectReason: map['founderRejectReason'] != null
            ? map['founderRejectReason'] as String
            : null,
        adminCancelReason: map['adminCancelReason'] != null
            ? map['adminCancelReason'] as String
            : null,
        isScheduled: map['isScheduled'] as bool,
        meetingLink: map["meetingLink"]);
  }

  String toJson() => json.encode(toMap());

  factory MeetingModel.fromJson(String source) =>
      MeetingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MeetingModel(id: $id, investorId: $investorId, investor: $investor, founderId: $founderId, founder: $founder, productId: $productId, product: $product, scheduledAt: $scheduledAt, status: $status, meetingNote: $meetingNote, investorCancelReason: $investorCancelReason, founderRejectReason: $founderRejectReason, adminCancelReason: $adminCancelReason, isScheduled: $isScheduled)';
  }

  @override
  bool operator ==(covariant MeetingModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.investorId == investorId &&
        other.investor == investor &&
        other.founderId == founderId &&
        other.founder == founder &&
        other.productId == productId &&
        other.product == product &&
        other.scheduledAt == scheduledAt &&
        other.status == status &&
        other.meetingNote == meetingNote &&
        other.investorCancelReason == investorCancelReason &&
        other.founderRejectReason == founderRejectReason &&
        other.adminCancelReason == adminCancelReason &&
        other.isScheduled == isScheduled;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        investorId.hashCode ^
        investor.hashCode ^
        founderId.hashCode ^
        founder.hashCode ^
        productId.hashCode ^
        product.hashCode ^
        scheduledAt.hashCode ^
        status.hashCode ^
        meetingNote.hashCode ^
        investorCancelReason.hashCode ^
        founderRejectReason.hashCode ^
        adminCancelReason.hashCode ^
        isScheduled.hashCode;
  }
}
