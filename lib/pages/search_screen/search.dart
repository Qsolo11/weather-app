import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:weather_app/components/autocomplete_options_list.dart';
import 'package:weather_app/components/the_util.dart';
import '../../backend/api_requests/api_calls.dart';
import '../../components/comp_widgets.dart';
import '../../components/the_theme.dart';
import '../home_page/home_page_model.dart';
import 'package:animate_do/animate_do.dart';
import '/components/custom_functions.dart' as functions;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late HomePageModel _model;
  LatLng? currentUserLocationValue;
  int currentLocaton = 0;
  bool textFieldFocusListenerRegistered = false;

  @override
  void initState() {
    _model = createModel(context, () => HomePageModel());
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      currentUserLocationValue =
          await getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0));
      setState(() {
        _model.isLoading = true;
      });
      setState(() {
        _model.latLngQuery = currentUserLocationValue;
      });
      _model.apiResulti5v = await GetCurrentLocationForecaseCall.call(
        q: functions.convertLatLngToString(_model.latLngQuery!),
      );
      if ((_model.apiResulti5v?.succeeded ?? true)) {
        setState(() {
          _model.locationName = GetCurrentLocationForecaseCall.locationName(
            (_model.apiResulti5v?.jsonBody ?? ''),
          );
          _model.countryName = GetCurrentLocationForecaseCall.countryName(
            (_model.apiResulti5v?.jsonBody ?? ''),
          );
          _model.isDay = GetCurrentLocationForecaseCall.isDay(
                    (_model.apiResulti5v?.jsonBody ?? ''),
                  ) ==
                  1
              ? true
              : false;
          _model.tempDegree = GetCurrentLocationForecaseCall.tempC(
            (_model.apiResulti5v?.jsonBody ?? ''),
          )?.toString();
          _model.windSpeed = GetCurrentLocationForecaseCall.windSpeed(
            (_model.apiResulti5v?.jsonBody ?? ''),
          )?.toString();
          _model.feelsLike = GetCurrentLocationForecaseCall.feelsLike(
            (_model.apiResulti5v?.jsonBody ?? ''),
          )?.toString();
          _model.cloud = GetCurrentLocationForecaseCall.cloud(
            (_model.apiResulti5v?.jsonBody ?? ''),
          )?.toString();
          _model.humid = GetCurrentLocationForecaseCall.humidity(
            (_model.apiResulti5v?.jsonBody ?? ''),
          )?.toString();
          _model.condi = GetCurrentLocationForecaseCall.condition(
            (_model.apiResulti5v?.jsonBody ?? ''),
          );
          _model.condIcon = GetCurrentLocationForecaseCall.condiIcon(
            (_model.apiResulti5v?.jsonBody ?? ''),
          );
        });
      } else {
        // ignore: use_build_context_synchronously
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: const Text('Error fetching location data'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }

      _model.apiResultpr9 = await GetCurrentLocationFiveDaysAheadCall.call(
        q: functions.convertLatLngToString(_model.latLngQuery!),
        days: '5',
      );
      if ((_model.apiResultpr9?.succeeded ?? true)) {
        setState(() {
          _model.forcastDaysList =
              GetCurrentLocationFiveDaysAheadCall.forecastDays(
            (_model.apiResultpr9?.jsonBody ?? ''),
          )!
                  .toList()
                  .cast<dynamic>();
          _model.isLoading = false;
        });
      }
    });

    _model.textController ??= TextEditingController();
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff060720),
        body: Container(
            height: myHeight,
            width: myWidth,
            child: Column(
              children: [
                SizedBox(
                  height: myHeight * 0.03,
                ),
                Text('Pick location',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 30.0,
                        )),
                SizedBox(
                  height: myHeight * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: myWidth * 0.05),
                  child: Column(
                    children: [
                      FadeInDown(
                          duration: const Duration(milliseconds: 800),
                          child: Text(
                              'find the area or city that you want to khow',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: Colors.white.withOpacity(.5),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ))),
                      FadeInDown(
                          duration: const Duration(milliseconds: 900),
                          child: Text(
                            'the detailed weather info at this time',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white.withOpacity(.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: myHeight * 0.05,
                ),
                FadeInDown(
                    duration: const Duration(milliseconds: 1000),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: myWidth * 0.06),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Container(
                                  // height: myHeight * 0.1,
                                  // width: myWidth * 0.6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white.withOpacity(0.05)),
                                  child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8.0, 1.0, 8.0, 0.0),
                                      child: Autocomplete<String>(
                                          initialValue:
                                              const TextEditingValue(),
                                          optionsBuilder: (textEditingValue) {
                                            if (textEditingValue.text == '') {
                                              return const Iterable<
                                                  String>.empty();
                                            }
                                            return functions
                                                .returnStringListForAutoComplete(
                                                    _model.autoCompleteList
                                                        .toList())
                                                .where((option) {
                                              final lowercaseOption =
                                                  option.toLowerCase();
                                              return lowercaseOption.contains(
                                                  textEditingValue.text
                                                      .toLowerCase());
                                            });
                                          },
                                          optionsViewBuilder:
                                              (context, onSelected, options) {
                                            return AutocompleteOptionsList(
                                              textFieldKey: _model.textFieldKey,
                                              textController:
                                                  _model.textController!,
                                              options: options.toList(),
                                              onSelected: onSelected,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                              textHighlightStyle:
                                                  const TextStyle(),
                                              elevation: 4.0,
                                              optionBackgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              optionHighlightColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              maxHeight: 200.0,
                                            );
                                          },
                                          onSelected: (String selection) async{
                                            
                                            setState(() =>
                                                _model.textFieldSelectedOption =
                                                    selection);
                                            FocusScope.of(context).unfocus();
                                              setState(() {
                                                        _model.latLngQuery =
                                                            functions.getLatLon(
                                                                _model
                                                                    .autoCompleteList
                                                                    .toList(),
                                                                _model
                                                                    .textFieldSelectedOption!);
                                                      });
                                                      setState(() {
                                                        _model.isLoading = true;
                                                      });
                                                      _model.apiResultpr9 = await GetCurrentLocationFiveDaysAheadCall.call(
        q: functions.convertLatLngToString(_model.latLngQuery!),
        days: '5',
      );
      if ((_model.apiResultpr9?.succeeded ?? true)) {
        setState(() {
          _model.forcastDaysList =
              GetCurrentLocationFiveDaysAheadCall.forecastDays(
            (_model.apiResultpr9?.jsonBody ?? ''),
          )!
                  .toList()
                  .cast<dynamic>();
          _model.isLoading = false;
        });
      }
                                                      _model.apiResulti5v2 =
                                                          await GetCurrentLocationForecaseCall
                                                              .call(
                                                        q: functions
                                                            .convertLatLngToString(
                                                                _model
                                                                    .latLngQuery!),
                                                      );
                                                      if ((_model.apiResulti5v2
                                                              ?.succeeded ??
                                                          true)) {
                                                        setState(() {
                                                          _model.locationName =
                                                              GetCurrentLocationForecaseCall
                                                                  .locationName(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          );
                                                          
                                                          _model.countryName =
                                                              GetCurrentLocationForecaseCall
                                                                  .countryName(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          );
                                                                                                                  _model.isDay =
                                                              GetCurrentLocationForecaseCall
                                                                          .isDay(
                                                                        (_model.apiResulti5v2?.jsonBody ??
                                                                            ''),
                                                                      ) ==
                                                                      1
                                                                  ? true
                                                                  : false;
                                                          _model.tempDegree =
                                                              GetCurrentLocationForecaseCall
                                                                  .tempC(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )?.toString();
                                                          _model.windSpeed =
                                                              GetCurrentLocationForecaseCall
                                                                  .windSpeed(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )?.toString();
                                                          _model.feelsLike =
                                                              GetCurrentLocationForecaseCall
                                                                  .feelsLike(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )?.toString();
                                                          _model.cloud =
                                                              GetCurrentLocationForecaseCall
                                                                  .cloud(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )?.toString();
                                                          _model.humid =
                                                              GetCurrentLocationForecaseCall
                                                                  .humidity(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )?.toString();
                                                          _model.condi =
                                                              GetCurrentLocationForecaseCall
                                                                  .condition(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          );
                                                          _model.condIcon =
                                                              GetCurrentLocationForecaseCall
                                                                  .condiIcon(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          );
                                                        });
                                           } else {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Error fetching location data'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext),
                                                                  child:
                                                                      const Text(
                                                                          'Ok'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                          
                                            //context.pushNamed("forecast");
                                          },
                                          fieldViewBuilder: (
                                            context,
                                            textEditingController,
                                            focusNode,
                                            onEditingComplete,
                                          ) {
                                            _model.textFieldFocusNode =
                                                focusNode;
                                            if (!textFieldFocusListenerRegistered) {
                                              textFieldFocusListenerRegistered =
                                                  true;
                                              _model.textFieldFocusNode!
                                                  .addListener(
                                                () async {
                                                  setState(() {
                                                    _model.latLngQuery =
                                                        functions.getLatLon(
                                                            _model
                                                                .autoCompleteList
                                                                .toList(),
                                                            _model
                                                                .textFieldSelectedOption!);
                                                  });
                                                },
                                              );
                                            }
                                            _model.textController =
                                                textEditingController;
                                            return TextFormField(
                                              key: _model.textFieldKey,
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              onEditingComplete:
                                                  onEditingComplete,
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                '_model.textController',
                                                const Duration(
                                                    milliseconds: 2000),
                                                () async {
                                                  _model.apiResult8wh =
                                                      await SearchCityAutoCompleteCall
                                                          .call(
                                                    q: _model
                                                        .textController.text,
                                                  );
                                                  if ((_model.apiResult8wh
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model.autoCompleteList =
                                                        (_model.apiResult8wh
                                                                    ?.jsonBody ??
                                                                '')
                                                            .toList()
                                                            .cast<dynamic>();
                                                  }

                                                  setState(() {});
                                                },
                                              ),
                                              onFieldSubmitted: (_) async {
                                                setState(() {
                                                  _model.latLngQuery =
                                                      functions.getLatLon(
                                                          _model
                                                              .autoCompleteList
                                                              .toList(),
                                                          _model
                                                              .textFieldSelectedOption!);
                                                });
                                              },
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                icon: GestureDetector(
                                                    onTap: () async {
                                                      setState(() {
                                                        _model.latLngQuery =
                                                            functions.getLatLon(
                                                                _model
                                                                    .autoCompleteList
                                                                    .toList(),
                                                                _model
                                                                    .textFieldSelectedOption!);
                                                      });
                                                      setState(() {
                                                        _model.isLoading = true;
                                                      });
                                                      _model.apiResulti5v2 =
                                                          await GetCurrentLocationForecaseCall
                                                              .call(
                                                        q: functions
                                                            .convertLatLngToString(
                                                                _model
                                                                    .latLngQuery!),
                                                      );
                                                      if ((_model.apiResulti5v2
                                                              ?.succeeded ??
                                                          true)) {
                                                        setState(() {
                                                          _model.locationName =
                                                              GetCurrentLocationForecaseCall
                                                                  .locationName(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          );
                                                          _model.countryName =
                                                              GetCurrentLocationForecaseCall
                                                                  .countryName(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          );
                                                          _model.isDay =
                                                              GetCurrentLocationForecaseCall
                                                                          .isDay(
                                                                        (_model.apiResulti5v2?.jsonBody ??
                                                                            ''),
                                                                      ) ==
                                                                      1
                                                                  ? true
                                                                  : false;
                                                          _model.tempDegree =
                                                              GetCurrentLocationForecaseCall
                                                                  .tempC(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )?.toString();
                                                          _model.windSpeed =
                                                              GetCurrentLocationForecaseCall
                                                                  .windSpeed(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )?.toString();
                                                          _model.feelsLike =
                                                              GetCurrentLocationForecaseCall
                                                                  .feelsLike(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )?.toString();
                                                          _model.cloud =
                                                              GetCurrentLocationForecaseCall
                                                                  .cloud(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )?.toString();
                                                          _model.humid =
                                                              GetCurrentLocationForecaseCall
                                                                  .humidity(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )?.toString();
                                                          _model.condi =
                                                              GetCurrentLocationForecaseCall
                                                                  .condition(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          );
                                                          _model.condIcon =
                                                              GetCurrentLocationForecaseCall
                                                                  .condiIcon(
                                                            (_model.apiResulti5v2
                                                                    ?.jsonBody ??
                                                                ''),
                                                          );
                                                        });
                                                      } else {
                                                        await showDialog(
                                                          context: context,
                                                          builder:
                                                              (alertDialogContext) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Error fetching location data'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          alertDialogContext),
                                                                  child:
                                                                      const Text(
                                                                          'Ok'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }

                                                      _model.apiResultpr92 =
                                                          await GetCurrentLocationFiveDaysAheadCall
                                                              .call(
                                                        q: functions
                                                            .convertLatLngToString(
                                                                _model
                                                                    .latLngQuery!),
                                                        days: '5',
                                                      );
                                                      if ((_model.apiResultpr92
                                                              ?.succeeded ??
                                                          true)) {
                                                        setState(() {
                                                          _model.forcastDaysList =
                                                              GetCurrentLocationFiveDaysAheadCall
                                                                      .forecastDays(
                                                            (_model.apiResultpr92
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )!
                                                                  .toList()
                                                                  .cast<
                                                                      dynamic>();
                                                          _model.isLoading =
                                                              false;
                                                        });
                                                      }

                                                      setState(() {});
                                                    },
                                                    child: Image.asset(
                                                      'assets/icons/2.2.png',
                                                      height: myHeight * 0.025,
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                    )),
                                                hintText: 'Search',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: Colors.white
                                                              .withOpacity(.5),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20.0,
                                                        ),
                                              ),
                                            );
                                          })))),
                          SizedBox(
                            width: myWidth * 0.03,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              // height: myHeight * 0.1,
                              // width: myWidth * 0.6,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white.withOpacity(0.05)),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: myHeight * 0.013),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/icons/6.png',
                                      height: myHeight * 0.03,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(
                  height: myHeight * 0.02,
                ),
                 FadeInDown(
              duration:const Duration(milliseconds: 800),
              child: Text(
                  '${valueOrDefault<String>(
                    _model.locationName,
                    'Can\'t get location',
                  )} , ${_model.countryName}',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                )),
                 FadeInDown(
              duration:const Duration(milliseconds: 1000),
              child:   Text(
                                            '${_model.tempDegree}ᐤ',
                                           style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 30.0,
                                                       )            )
                                          ),   
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              FadeInDown(
              duration:const Duration(milliseconds: 1200),
              child:   GradientText(
                                                valueOrDefault<String>(
                                                  _model.condi,
                                                  'Faild to get',
                                                ),
                                                colors: [
        Color(0xFFed4478),
Color(0xFF8355c8),
    ],
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          fontSize: 25.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                              )),
                                             
                                           
                   ] ),
                                        ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: myWidth * 0.06),
                    child: FadeInDown(
                      duration: const Duration(milliseconds: 900),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Next forecast',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white.withOpacity(.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0,
                                ),
                          ),
                          Image.asset(
                            'assets/icons/5.png',
                            height: myHeight * 0.03,
                            color: Colors.white.withOpacity(0.5),
                          )
                        ],
                      ),
                    )),
                SizedBox(
                  height: myHeight * 0.02,
                ),
                Expanded(
                    child: FadeInDown(
                        duration: const Duration(milliseconds: 900),
                        child: Builder(builder: (context) {
                          final daysList = _model.forcastDaysList.toList();

                          return ListView.builder(
                            itemCount: daysList.length,
                            itemBuilder: (context, index) {
                              final daysListItem = daysList[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: myHeight * 0.015,
                                    horizontal: myWidth * 0.07),
                                child: Container(
                                  height: myHeight * 0.11,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(18)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            functions.weekDayNameFromEpoch(
                                                getJsonField(
                                              daysListItem,
                                              r'''$.date_epoch''',
                                            )),
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20.0,
                                                ),
                                          ),
                                          Text(
                                            functions
                                                .dateFromEpoch(getJsonField(
                                              daysListItem,
                                              r'''$.date_epoch''',
                                            )),
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  color: Colors.white
                                                      .withOpacity(.5),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.0,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${getJsonField(
                                              daysListItem,
                                              r'''$.day.avgtemp_c''',
                                            ).toString()}ᐤ',
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 45.0,
                                                ),
                                          ),
                                          // Column(
                                          //   mainAxisAlignment: MainAxisAlignment.center,
                                          //   children: [
                                          //     Text(
                                          //       '°C',
                                          //       style: TextStyle(color: Colors.white, fontSize: 25),
                                          //     ),
                                          //     Text('')
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                      Image.network(
                                        'https:${getJsonField(
                                          daysListItem,
                                          r'''$.day.condition.icon''',
                                        ).toString()}',
                                        height: myHeight * 0.05,
                                        width: myWidth * 0.13,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }))),
                // Expanded(
                //     child: FadeInDown(
                //         duration: const Duration(milliseconds: 1200),
                //         child: Builder(builder: (context) {
                //           final daysList = _model.forcastDaysList.toList();
                //           return GridView.custom(
                //               padding: EdgeInsets.symmetric(
                //                   horizontal: myWidth * 0.01),
                //               gridDelegate: SliverStairedGridDelegate(
                //                   mainAxisSpacing: 13,
                //                   startCrossAxisDirectionReversed: false,
                //                   pattern: [
                //                     StairedGridTile(0.7, 3 / 2.2),
                //                     StairedGridTile(0.7, 3 / 2.2),
                //                   ]),
                //               childrenDelegate: SliverChildBuilderDelegate(
                //                 childCount: daysList.length,
                //                 (context, index) {
                //                   final daysListItem = daysList[index];
                //                   return Padding(
                //                     padding: EdgeInsets.symmetric(
                //                         horizontal: myWidth * 0.05),
                //                     child: Container(
                //                       decoration: BoxDecoration(
                //                           color: index == currentLocaton
                //                               ? null
                //                               : Colors.white.withOpacity(0.05),
                //                           gradient: index == currentLocaton
                //                               ? LinearGradient(colors: [
                //                                   Color(0xFFed4478),
                //                                   Color(0xFF8355c8),
                //                                 ])
                //                               : null,
                //                           borderRadius:
                //                               BorderRadius.circular(18)),
                //                       child: Padding(
                //                         padding: const EdgeInsets.all(20.0),
                //                         child: Column(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.spaceBetween,
                //                           children: [
                //                             Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment
                //                                       .spaceBetween,
                //                               children: [
                //                                 Column(
                //                                   crossAxisAlignment:
                //                                       CrossAxisAlignment.start,
                //                                   children: [
                //                                     Text(
                //                                       '${_model.tempDegree}ᐤ',
                //                                       //.replaceAll('C', ''),
                //                                       style: FlutterFlowTheme
                //                                               .of(context)
                //                                           .headlineMedium
                //                                           .override(
                //                                             fontFamily:
                //                                                 'Outfit',
                //                                             color: Colors.white,
                //                                             fontWeight:
                //                                                 FontWeight.w500,
                //                                             fontSize: 25.0,
                //                                           ),
                //                                     ),
                //                                     SizedBox(
                //                                       height: myHeight * 0.01,
                //                                     ),
                //                                     Text(
                //                                       weather_state[index]
                //                                           .toString(),
                //                                       style: FlutterFlowTheme
                //                                               .of(context)
                //                                           .headlineMedium
                //                                           .override(
                //                                             fontFamily:
                //                                                 'Outfit',
                //                                             color: Colors.white
                //                                                 .withOpacity(
                //                                                     .5),
                //                                             fontWeight:
                //                                                 FontWeight.w500,
                //                                             fontSize: 17.0,
                //                                           ),
                //                                     )
                //                                   ],
                //                                 ),
                //                                 Image.network(
                //                                   'https:${getJsonField(
                //                                     daysListItem,
                //                                     r'''$.day.condition.icon''',
                //                                   ).toString()}',
                //                                   height: myHeight * 0.06,
                //                                   width: myWidth * 0.13,
                //                                 ),
                //                               ],
                //                             ),
                //                             Row(
                //                               children: [
                //                                 Text('${_model.countryName}',
                //                                     style: FlutterFlowTheme.of(
                //                                             context)
                //                                         .headlineMedium
                //                                         .override(
                //                                           fontFamily: 'Outfit',
                //                                           color: Colors.white,
                //                                           fontWeight:
                //                                               FontWeight.w500,
                //                                           fontSize: 17.0,
                //                                         )),
                //                               ],
                //                             )
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   );
                //                 },
                //               ));
                //         })))
              ],
            )),
      ),
    );
  }

  List<String> weather_state = [
    "Rainny",
    "Rainny",
    "Rainny",
    "Cloudy",
    "Sunny",
    "Sunny",
  ];
}
