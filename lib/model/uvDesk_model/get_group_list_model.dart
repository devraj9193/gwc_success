class GroupListModel {
  bool? success;
  Collection? collection;

  GroupListModel({
     this.success,
     this.collection,
  });

  factory GroupListModel.fromJson(Map<String, dynamic> json) => GroupListModel(
    success: json["success"],
    collection: Collection.fromJson(json["collection"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "collection": collection?.toJson(),
  };
}

class Collection {
  List<Group>? groups;
  PaginationData? paginationData;

  Collection({
    this.groups,
     this.paginationData,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    groups: List<Group>.from(json["groups"].map((x) => Group.fromJson(x))),
    paginationData: PaginationData.fromJson(json["pagination_data"]),
  );

  Map<String, dynamic> toJson() => {
    "groups": List<dynamic>.from(groups!.map((x) => x.toJson())),
    "pagination_data": paginationData?.toJson(),
  };
}

class Group {
  int? id;
  String? name;
  String ?description;
  bool? isActive;

  Group({
     this.id,
     this.name,
     this.description,
     this.isActive,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "isActive": isActive,
  };
}

class PaginationData {
  int? last;
  int? current;
  int? numItemsPerPage;
  int? first;
  int? pageCount;
  int? totalCount;
  int? pageRange;
  int? startPage;
  int? endPage;
  List<int>? pagesInRange;
  int? firstPageInRange;
  int? lastPageInRange;
  int? currentItemCount;
  int? firstItemNumber;
  int? lastItemNumber;
  String? url;

  PaginationData({
     this.last,
     this.current,
     this.numItemsPerPage,
     this.first,
     this.pageCount,
     this.totalCount,
     this.pageRange,
     this.startPage,
     this.endPage,
     this.pagesInRange,
     this.firstPageInRange,
     this.lastPageInRange,
     this.currentItemCount,
     this.firstItemNumber,
     this.lastItemNumber,
     this.url,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) => PaginationData(
    last: json["last"],
    current: json["current"],
    numItemsPerPage: json["numItemsPerPage"],
    first: json["first"],
    pageCount: json["pageCount"],
    totalCount: json["totalCount"],
    pageRange: json["pageRange"],
    startPage: json["startPage"],
    endPage: json["endPage"],
    pagesInRange: List<int>.from(json["pagesInRange"].map((x) => x)),
    firstPageInRange: json["firstPageInRange"],
    lastPageInRange: json["lastPageInRange"],
    currentItemCount: json["currentItemCount"],
    firstItemNumber: json["firstItemNumber"],
    lastItemNumber: json["lastItemNumber"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "last": last,
    "current": current,
    "numItemsPerPage": numItemsPerPage,
    "first": first,
    "pageCount": pageCount,
    "totalCount": totalCount,
    "pageRange": pageRange,
    "startPage": startPage,
    "endPage": endPage,
    "pagesInRange": List<dynamic>.from(pagesInRange!.map((x) => x)),
    "firstPageInRange": firstPageInRange,
    "lastPageInRange": lastPageInRange,
    "currentItemCount": currentItemCount,
    "firstItemNumber": firstItemNumber,
    "lastItemNumber": lastItemNumber,
    "url": url,
  };
}
