class FeedbackModel {
  //https://script.google.com/macros/s/AKfycbyq2glkqwpJqr4R3lgkTk6jjsS-mdGkUjhu1mVfXcwDpAtrGs_hsNfCM5Yp78jEKg_R/exec
  String countryImg;
  String species;
  String commonName;
  String birdURL;
  String countryTotal;

  FeedbackModel(
      {required this.countryImg, required this.species, required this.commonName, required this.birdURL, required this.countryTotal});

  factory FeedbackModel.fromJson(dynamic json) {
    return FeedbackModel(
      countryImg: "${json['countryImg']}",
      species: "${json['species']}",
      commonName: "${json['commonName']}",
      birdURL: "${json['birdURL']}",
      countryTotal: "${json['countryTotal']}",
    );
  }

  Map toJson() => {
    "countryImg": countryImg,
    "species": species,
    "commonName": commonName,
    "birdURL": birdURL,
    "countryTotal": countryTotal,
  };
}