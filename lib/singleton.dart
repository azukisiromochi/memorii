class UserData {
  UserData._();
  static final instance = UserData._();

  // uid
  String user = "";
  // 作品一覧情報
  List documentList = [];
  List documentLikeList = [];

  String choiceList = "all";
  List listAll = [];
  List listMen = [];
  List listLadies = [];
  List listStreet = [];
  List listClassic = [];
  List listMode = [];
  List listFeminin = [];
  List listGrunge = [];
  List listAnnui = [];
  List listRock = [];
  List listCrieitive = [];

  List likePhotos = [];
  int accountPostCount = 0;
  List account = [];
}