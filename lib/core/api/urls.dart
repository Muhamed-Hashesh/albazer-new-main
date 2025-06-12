class AppUrls {
  const AppUrls._();
  // static const _testUrl = "https://albazar-test.onrender.com";
  // static const baseUrl = _testUrl;
  // https://back.albazar.app/api
  static const _prodUrl = "https://back.albazar.app";
  static const baseUrl = _prodUrl;
  static const _baseApiUrl = "$_prodUrl/api";
  //*Auth
  static const _auth = "$_baseApiUrl/auth";
  static const login = "$_auth/login";
  static const signup = "$_auth/signup";
  static const forgetPassword = "$_auth/forgetPassword";
  static const verifyResetCode = "$_auth/verifyResetCode";
  static const resetPassword = "$_auth/resetPassword";
  //*User
  static const _user = "$_baseApiUrl/user";
  static const user = "$_baseApiUrl/user";
  static const getUser = "$_user/getme";
  static const changePassword = "$_user/changeMyPassword";
  static const updateUser = "$_user/updateMyData";
  static const follow = "$_user/follow";
  static const unfollow = "$_user/unfollow";
  //*Categories
  static const categories = "$_baseApiUrl/categore";
  //*Ads
  static const ads = "$_baseApiUrl/listing";
  static const myAds = "$_baseApiUrl/listing/userListing";
  //?Favorites
  static const favorites = "$_baseApiUrl/favourite";
  //?Reviews
  static const reviews = "$_baseApiUrl/reveiw/listing";
  static const review = "$_baseApiUrl/reveiw";
  //?Following List
  static const followingListing = "$_baseApiUrl/listing/followinglisting";
  //?Accept/Reject
  static const acceptAd = "$_baseApiUrl/listing/accept";
  static const rejectAd = "$_baseApiUrl/listing/reject";
  //*Messages
  static const _messages = "$_baseApiUrl/message";
  static const chats = "$_messages/users";
  static const updateToken = "$_messages/updatefcmtoken";
  static const message = _messages;
}
