class ClubDetails {
  final String id;
  final String? area;
  final String? address;
  final List<String>? members;
  final String? name;
  final String? clubLogo;
  final int? contactNumber;
  final String? desc;

  ClubDetails(
      {required this.id,
      this.area,
      this.address,
      this.members,
      this.name,
      this.contactNumber,
      this.desc,
      this.clubLogo});

  ClubDetails.fromJson(Map<String, dynamic> json, this.id)
      : area = json['area'] as String?,
        address = json['address'] as String?,
        members = (json['members'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        name = json['name'] as String?,
        contactNumber = json['contactNumber'] as int?,
        desc = json['desc'] as String?,
        clubLogo = json['clubLogo'] as String?;

  Map<String, dynamic> toJson() => {
        'area': area,
        'address': address,
        'members': members,
        'name': name,
        'contactNumber': contactNumber,
        'desc': desc,
        'clubLogo': clubLogo,
      };
}
