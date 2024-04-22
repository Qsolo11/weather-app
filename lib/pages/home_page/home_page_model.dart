import '/backend/api_requests/api_calls.dart';
import '/components/the_util.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  String? locationName;

  String? countryName;

  bool isDay = false;

  String? tempDegree;

  String? windSpeed;

  String? feelsLike;

  String? cloud;

  String? humid;

  String? condi;

  String? condIcon;

  List<dynamic> forcastDaysList = [];
  void addToForcastDaysList(dynamic item) => forcastDaysList.add(item);
  void removeFromForcastDaysList(dynamic item) => forcastDaysList.remove(item);
  void removeAtIndexFromForcastDaysList(int index) =>
      forcastDaysList.removeAt(index);
  void insertAtIndexInForcastDaysList(int index, dynamic item) =>
      forcastDaysList.insert(index, item);
  void updateForcastDaysListAtIndex(int index, Function(dynamic) updateFn) =>
      forcastDaysList[index] = updateFn(forcastDaysList[index]);

  List<dynamic> autoCompleteList = [];
  void addToAutoCompleteList(dynamic item) => autoCompleteList.add(item);
  void removeFromAutoCompleteList(dynamic item) =>
      autoCompleteList.remove(item);
  void removeAtIndexFromAutoCompleteList(int index) =>
      autoCompleteList.removeAt(index);
  void insertAtIndexInAutoCompleteList(int index, dynamic item) =>
      autoCompleteList.insert(index, item);
  void updateAutoCompleteListAtIndex(int index, Function(dynamic) updateFn) =>
      autoCompleteList[index] = updateFn(autoCompleteList[index]);

  bool isLoading = true;

  LatLng? latLngQuery;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (Get Current Location Forecase)] action in HomePage widget.
  ApiCallResponse? apiResulti5v;
  // Stores action output result for [Backend Call - API (Get Current Location five days ahead)] action in HomePage widget.
  ApiCallResponse? apiResultpr9;
  // State field(s) for TextField widget.
  final textFieldKey = GlobalKey();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? textFieldSelectedOption;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (Search City Auto Complete)] action in TextField widget.
  ApiCallResponse? apiResult8wh;
  // Stores action output result for [Backend Call - API (Get Current Location Forecase)] action in Button widget.
  ApiCallResponse? apiResulti5v2;
  // Stores action output result for [Backend Call - API (Get Current Location five days ahead)] action in Button widget.
  ApiCallResponse? apiResultpr92;
final Shader linearGradient = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[ Color(0xFFed4478),
Color(0xFF8355c8),],
).createShader(Rect.fromLTWH(100.0, 200.0, 100.0, 90.0));
  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
