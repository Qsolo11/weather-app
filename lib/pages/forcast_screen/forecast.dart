import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../backend/api_requests/api_calls.dart';

import 'package:animate_do/animate_do.dart';
import '../../components/the_theme.dart';
import '/components/custom_functions.dart' as functions;

import '../../components/the_util.dart';
import '../home_page/home_page_model.dart';

// ignore: must_be_immutable
class ForecastPage extends StatefulWidget {
 
  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  late HomePageModel _model;
   LatLng? currentUserLocationValue;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await scrollToIndex();
    });
   // find_myLocation_index();
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
    super.initState();
  }

 

  DateTime time = DateTime.now();
  int hour_index = 0;
  bool complete1 = false;
  bool complete2 = false;

 

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  scrollToIndex() async {
    itemScrollController.scrollTo(
        index: hour_index,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOutCubic);
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
                Text(
                  'Forecast report',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight:  FontWeight.w500,
                        fontSize: 25.0,
                     ),
                ),
                SizedBox(
                  height: myHeight * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: myWidth * 0.06),
                  child: FadeInDown(
              duration:const Duration(milliseconds: 800),
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today',
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white.withOpacity(.5),
                        fontWeight:  FontWeight.w500,
                        fontSize: 20.0,
                     ),
                      ),
                      Text(
                        '18 January 2024',
                        style:FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white.withOpacity(.5),
                        fontWeight:  FontWeight.w500,
                        fontSize: 20.0,
                     ),
                      ),
                    ],
                  ),
                )),
                SizedBox(
                  height: myHeight * 0.025,
                ),
                Container(
                  height: myHeight * 0.15,
                  child: FadeInDown(
              duration:const Duration(milliseconds: 1000),
              child: Builder(
                          builder: (context) {
                            final daysList = _model.forcastDaysList.toList();
                            return Padding(
                    padding: EdgeInsets.only(
                        left: myWidth * 0.03, bottom: myHeight * 0.03),
                    child: ScrollablePositionedList.builder(
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: daysList.length,
                      itemBuilder: (context, index) {
                          final daysList = _model.forcastDaysList.toList();
                           final daysListItem = daysList[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: myWidth * 0.02,
                              vertical: myHeight * 0.01),
                          child: Container(
                            width: myWidth * 0.35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: hour_index == index
                                    ? null
                                    : Colors.white.withOpacity(0.05),
                                gradient: hour_index == index
                                    ? LinearGradient(colors: [
                                      Color(0xFFed4478),
Color(0xFF8355c8),
                                      ])
                                    : null),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                                'https:${getJsonField(
                                                  daysListItem,
                                                  r'''$.day.condition.icon''',
                                                ).toString()}',
                                    height: myHeight * 0.04,
                                  ),
                                  SizedBox(
                                    width: myWidth * 0.04,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                       "11:00",
                                        style:FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight:  FontWeight.w500,
                        fontSize: 20.0,
                     )),
                                      Text(
                                      '${getJsonField(
                                                  daysListItem,
                                                  r'''$.day.avgtemp_c''',
                                                ).toString()}ᐤ',
                                        style:FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white.withOpacity(.5),
                        fontWeight:  FontWeight.w500,
                        fontSize: 20.0,
                     ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ));},
                  )),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: myWidth * 0.06),
                  child: FadeInDown(
              duration:const Duration(milliseconds: 900),
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Next forecast',
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white.withOpacity(.5),
                        fontWeight:  FontWeight.w500,
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
              duration:const Duration(milliseconds: 900),
              child:  Builder(
                          builder: (context) {
                            final daysList = _model.forcastDaysList.toList();
                             
                            return ListView.builder(
                  itemCount: daysList.length,
                  itemBuilder: (context, index) {
                       final daysListItem = daysList[index];
                    return 
                   Padding(
      padding: EdgeInsets.symmetric(
          vertical: myHeight * 0.015, horizontal: myWidth * 0.07),
      child: Container(
        height: myHeight * 0.11,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                 functions.weekDayNameFromEpoch(
                                              getJsonField(
                                            daysListItem,
                                            r'''$.date_epoch''',
                                          )),
                  style:FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight:  FontWeight.w500,
                        fontSize: 20.0,
                     ),
                ),
                Text(
                   functions.dateFromEpoch(getJsonField(
                                            daysListItem,
                                            r'''$.date_epoch''',
                                          )),
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white.withOpacity(.5),
                        fontWeight:  FontWeight.w500,
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
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight:  FontWeight.w500,
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
                );})))
              ],
            )),
      ),
    );
  }

  List<int> day = [
    18,
    19,
    20,
    21,
    22,
    23,
    24,
  ];
}
