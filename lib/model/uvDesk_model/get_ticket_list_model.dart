class GetTicketListModel {
  Labels? labels;
  List<Tickets>? tickets;
  Pagination? pagination;
  Tabs? tabs;
  UserDetails? userDetails;
  List<Status>? status;
  List<Group>? group;
  List<Team>? team;
  List<Priority>? priority;
  List<Type>? type;

  GetTicketListModel(
      {this.labels,
      this.tickets,
      this.pagination,
      this.tabs,
      this.userDetails,
      this.status,
      this.group,
      this.team,
      this.priority,
      this.type});

  GetTicketListModel.fromJson(Map<String, dynamic> json) {
    labels =
        json['labels'] != null ? new Labels.fromJson(json['labels']) : null;
    if (json['tickets'] != null) {
      tickets = <Tickets>[];
      json['tickets'].forEach((v) {
        tickets!.add(new Tickets.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    tabs = json['tabs'] != null ? new Tabs.fromJson(json['tabs']) : null;
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
    if (json['status'] != null) {
      status = <Status>[];
      json['status'].forEach((v) {
        status!.add(new Status.fromJson(v));
      });
    }
    if (json['group'] != null) {
      group = <Group>[];
      json['group'].forEach((v) {
        group!.add(new Group.fromJson(v));
      });
    }
    if (json['team'] != null) {
      priority = <Priority>[];
      json['priority'].forEach((v) {
        priority!.add(new Priority.fromJson(v));
      });

      (json['team'] as List<dynamic>?)
              ?.map((e) => Team.FromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    }
    if (json['priority'] != null) {
      priority = <Priority>[];
      json['priority'].forEach((v) {
        priority!.add(new Priority.fromJson(v));
      });
    }
    if (json['type'] != null) {
      type = <Type>[];
      json['type'].forEach((v) {
        type!.add(new Type.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.labels != null) {
      data['labels'] = this.labels!.toJson();
    }
    if (this.tickets != null) {
      data['tickets'] = this.tickets!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.tabs != null) {
      data['tabs'] = this.tabs!.toJson();
    }
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status!.map((v) => v.toJson()).toList();
    }
    if (this.group != null) {
      data['group'] = this.group!.map((v) => v.toJson()).toList();
    }
    if (this.team != null) {
      data['team'] = this.team!.map((v) => v.toJson()).toList();
    }
    if (this.priority != null) {
      data['priority'] = this.priority!.map((v) => v.toJson()).toList();
    }
    if (this.type != null) {
      data['type'] = this.type!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Labels {
  Predefind? predefind;
  // List<Null>? custom;

  Labels({
    this.predefind,
    // this.custom
  });

  Labels.fromJson(Map<String, dynamic> json) {
    predefind = json['predefind'] != null
        ? new Predefind.fromJson(json['predefind'])
        : null;
    // if (json['custom'] != null) {
    //   custom = <Null>[];
    //   json['custom'].forEach((v) { custom!.add(new Null.fromJson(v)); });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.predefind != null) {
      data['predefind'] = this.predefind!.toJson();
    }
    // if (this.custom != null) {
    //   data['custom'] = this.custom!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Predefind {
  int? all;
  int? newVal;
  int? unassigned;
  int? notreplied;
  int? mine;
  int? starred;
  int? trashed;

  Predefind(
      {this.all,
      this.newVal,
      this.unassigned,
      this.notreplied,
      this.mine,
      this.starred,
      this.trashed});

  Predefind.fromJson(Map<String, dynamic> json) {
    all = json['all'];
    newVal = json['new'];
    unassigned = json['unassigned'];
    notreplied = json['notreplied'];
    mine = json['mine'];
    starred = json['starred'];
    trashed = json['trashed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all'] = this.all;
    data['new'] = this.newVal;
    data['unassigned'] = this.unassigned;
    data['notreplied'] = this.notreplied;
    data['mine'] = this.mine;
    data['starred'] = this.starred;
    data['trashed'] = this.trashed;
    return data;
  }
}

class Tickets {
  int? id;
  String? subject;
  bool? isCustomerView;
  Priority? status;
  String? source;
  bool? isStarred;
  dynamic group;
  Priority? type;
  Priority? priority;
  String? formatedCreatedAt;
  String? totalThreads;
  Agent? agent;
  Customer? customer;

  Tickets({
    this.id,
    this.subject,
    this.isCustomerView,
    this.status,
    this.source,
    this.isStarred,
    this.group,
    this.type,
    this.priority,
    this.formatedCreatedAt,
    this.totalThreads,
    this.agent,
    this.customer,
  });

  factory Tickets.fromJson(Map<String, dynamic> json) => Tickets(
        id: json["id"],
        subject: json["subject"],
        isCustomerView: json["isCustomerView"],
        status:
            json["status"] != null ? Priority.fromJson(json["status"]) : null,
        source: json["source"],
        isStarred: json["isStarred"],
        group: json["group"],
        type: json["type"] != null ? Priority.fromJson(json["type"]) : null,
        priority: json["priority"] != null
            ? Priority.fromJson(json["priority"])
            : null,
        formatedCreatedAt: json["formatedCreatedAt"],
        totalThreads: json["totalThreads"],
        agent: json["agent"] != null ? Agent.fromJson(json["agent"]) : null,
        customer: json["customer"] != null
            ? Customer.fromJson(json["customer"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject": subject,
        "isCustomerView": isCustomerView,
        "status": status?.toJson(),
        "source": source,
        "isStarred": isStarred,
        "group": group,
        "type": type?.toJson(),
        "priority": priority?.toJson(),
        "formatedCreatedAt": formatedCreatedAt,
        "totalThreads": totalThreads,
        "agent": agent?.toJson(),
        "customer": customer?.toJson(),
      };
}

class Agent {
  int id;
  String email;
  String name;
  String firstName;
  String lastName;
  bool isEnabled;
  String profileImagePath;
  String smallThumbnail;
  bool isActive;
  bool isVerified;
  String? designation;
  String? contactNumber;
  String? signature;
  String? ticketAccessLevel;

  Agent({
    required this.id,
    required this.email,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.isEnabled,
    required this.profileImagePath,
    required this.smallThumbnail,
    required this.isActive,
    required this.isVerified,
    this.designation,
    this.contactNumber,
    this.signature,
    this.ticketAccessLevel,
  });

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        isEnabled: json["isEnabled"],
        profileImagePath: json["profileImagePath"],
        smallThumbnail: json["smallThumbnail"],
        isActive: json["isActive"],
        isVerified: json["isVerified"],
        designation: json["designation"],
        contactNumber: json["contactNumber"],
        signature: json["signature"],
        ticketAccessLevel: json["ticketAccessLevel"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "firstName": firstName,
        "lastName": lastName,
        "isEnabled": isEnabled,
        "profileImagePath": profileImagePath,
        "smallThumbnail": smallThumbnail,
        "isActive": isActive,
        "isVerified": isVerified,
        "designation": designation,
        "contactNumber": contactNumber,
        "signature": signature,
        "ticketAccessLevel": ticketAccessLevel,
      };
}

class Customer {
  int id;
  String email;
  String name;
  String firstName;
  String lastName;
  dynamic contactNumber;
  String profileImagePath;
  String smallThumbnail;

  Customer({
    required this.id,
    required this.email,
    required this.name,
    required this.firstName,
    required this.lastName,
    this.contactNumber,
    required this.profileImagePath,
    required this.smallThumbnail,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        contactNumber: json["contactNumber"],
        profileImagePath: json["profileImagePath"],
        smallThumbnail: json["smallThumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "firstName": firstName,
        "lastName": lastName,
        "contactNumber": contactNumber,
        "profileImagePath": profileImagePath,
        "smallThumbnail": smallThumbnail,
      };
}

class Priority {
  int id;
  String? code;
  String? description;
  String? colorCode;
  int? sortOrder;
  bool? isActive;

  Priority({
    required this.id,
    required this.code,
    required this.description,
    this.colorCode,
    this.sortOrder,
    this.isActive,
  });

  factory Priority.fromJson(Map<String, dynamic> json) => Priority(
        id: json["id"],
        code: json["code"].toString(),
        description: json["description"].toString(),
        colorCode: json["colorCode"].toString(),
        sortOrder: json["sortOrder"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "colorCode": colorCode,
        "sortOrder": sortOrder,
        "isActive": isActive,
      };
}

class Status {
  int? id;
  String? name;
  String? description;
  String? color;
  int? sortOrder;

  Status({this.id, this.name, this.description, this.color, this.sortOrder});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    color = json['color'];
    sortOrder = json['sortOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['color'] = this.color;
    data['sortOrder'] = this.sortOrder;
    return data;
  }
}

// class Agent {
//   int? id;
//   String? smallThumbnail;
//   String? name;
//
//   Agent({this.id, this.smallThumbnail, this.name});
//
//   Agent.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     smallThumbnail = json['smallThumbnail'];
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['smallThumbnail'] = this.smallThumbnail;
//     data['name'] = this.name;
//     return data;
//   }
// }

// class Customer {
//   int? id;
//   String? smallThumbnail;
//   String? email;
//   String? name;
//
//   Customer({this.id, this.smallThumbnail, this.email, this.name});
//
//   Customer.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     smallThumbnail = json['smallThumbnail'];
//     email = json['email'];
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['smallThumbnail'] = this.smallThumbnail;
//     data['email'] = this.email;
//     data['name'] = this.name;
//     return data;
//   }
// }

class CreatedAt {
  String? date;
  int? timezoneType;
  String? timezone;

  CreatedAt({this.date, this.timezoneType, this.timezone});

  CreatedAt.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    timezoneType = json['timezone_type'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['timezone_type'] = this.timezoneType;
    data['timezone'] = this.timezone;
    return data;
  }
}

class Pagination {
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

  Pagination(
      {this.last,
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
      this.url});

  Pagination.fromJson(Map<String, dynamic> json) {
    last = json['last'];
    current = json['current'];
    numItemsPerPage = json['numItemsPerPage'];
    first = json['first'];
    pageCount = json['pageCount'];
    totalCount = json['totalCount'];
    pageRange = json['pageRange'];
    startPage = json['startPage'];
    endPage = json['endPage'];
    pagesInRange = json['pagesInRange'].cast<int>();
    firstPageInRange = json['firstPageInRange'];
    lastPageInRange = json['lastPageInRange'];
    currentItemCount = json['currentItemCount'];
    firstItemNumber = json['firstItemNumber'];
    lastItemNumber = json['lastItemNumber'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last'] = this.last;
    data['current'] = this.current;
    data['numItemsPerPage'] = this.numItemsPerPage;
    data['first'] = this.first;
    data['pageCount'] = this.pageCount;
    data['totalCount'] = this.totalCount;
    data['pageRange'] = this.pageRange;
    data['startPage'] = this.startPage;
    data['endPage'] = this.endPage;
    data['pagesInRange'] = this.pagesInRange;
    data['firstPageInRange'] = this.firstPageInRange;
    data['lastPageInRange'] = this.lastPageInRange;
    data['currentItemCount'] = this.currentItemCount;
    data['firstItemNumber'] = this.firstItemNumber;
    data['lastItemNumber'] = this.lastItemNumber;
    data['url'] = this.url;
    return data;
  }
}

class Tabs {
  int? i1;
  int? i2;
  int? i3;
  int? i4;
  int? i5;
  int? i6;

  Tabs({this.i1, this.i2, this.i3, this.i4, this.i5, this.i6});

  Tabs.fromJson(Map<String, dynamic> json) {
    i1 = json['1'];
    i2 = json['2'];
    i3 = json['3'];
    i4 = json['4'];
    i5 = json['5'];
    i6 = json['6'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.i1;
    data['2'] = this.i2;
    data['3'] = this.i3;
    data['4'] = this.i4;
    data['5'] = this.i5;
    data['6'] = this.i6;
    return data;
  }
}

class UserDetails {
  int? user;
  String? name;
  String? pic;
  bool? role;

  UserDetails({this.user, this.name, this.pic, this.role});

  UserDetails.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    name = json['name'];
    pic = json['pic'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['name'] = this.name;
    data['pic'] = this.pic;
    data['role'] = this.role;
    return data;
  }
}

class Group {
  int? id;
  String? name;
  List<Null>? subGroups;

  Group({this.id, this.name, this.subGroups});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // if (json['subGroups'] != null) {
    //   subGroups = <Null>[];
    //   json['subGroups'].forEach((v) { subGroups!.add(new Null.fromJson(v)); });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    // if (this.subGroups != null) {
    //   data['subGroups'] = this.subGroups!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Type {
  int? id;
  String? name;
  String? description;
  bool? isActive;

  Type({this.id, this.name, this.description, this.isActive});

  Type.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    return data;
  }
}

class Team {
  num? id;
  String? name;

  Team({this.id, this.name});

  Team.FromJson(Map<String, dynamic> json) {
    id = json['id'] as int? ?? 0;
    name = json['name'] as String? ?? '';
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'name': this.name,
      };
}
