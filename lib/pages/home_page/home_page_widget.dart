import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:animate_do/animate_do.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/animations.dart';
import '/components/autocomplete_options_list.dart';
import '/components/the_theme.dart';
import '/components/the_util.dart';
import '/components/comp_widgets.dart';
import '/components/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  bool textFieldFocusListenerRegistered = false;

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 1.ms),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 500.ms,
          begin: const Offset(-100.0, 0.0),
          end: const Offset(0.0, 0.0),
        ),
      ],
    ),
  };
final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
int hour_index = 0;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
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
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor:  Color(0xff060720),//FlutterFlowTheme.of(context).secondaryBackground,
        appBar: !_model.isLoading
            ? AppBar(
                backgroundColor:  Color(0xff060720),
                automaticallyImplyLeading: false,
                
                
                actions: const [],
              
                // bottom: PreferredSize(
                //   preferredSize: const Size.fromHeight(70.0),
                //   child: Container(),
                // ),
                centerTitle: true,
                elevation: 2.0,
              )
            : null,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!_model.isLoading)
                Column(
                 // mainAxisSize: MainAxisSize.max,
                  children: [
                FadeInDown(
              duration:const Duration(milliseconds: 800),
              child:       Text(
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
                                             FadeInDown(
              duration:const Duration(milliseconds: 1400),
              child:    ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  'https:${_model.condIcon}',
                                                height: myHeight * 0.2,
                  width: myWidth * 0.3,

                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                            FadeInDown(
              duration:const Duration(milliseconds: 1600),
              child:     Row(
                                               mainAxisAlignment: MainAxisAlignment.center, 
                                                children:[  Text(
                                            'Feels Like : ',
                                            style:FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                                          ),
                                          Text(
                                            '${_model.feelsLike}ᐤ',
                                            style:FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight:  FontWeight.w600,
                        fontSize: 20.0,
                      ),
                                          ),
                                        ],
                                            )),
                   ] ),
                                        ),
                                          SizedBox(height: myHeight/15,),
                   
                   FadeInDown(
              duration:const Duration(milliseconds: 1800),
              child:    Container(
                  height: myHeight * 0.09,

                 
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[  Icon(
                                                      Icons.cloud,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 20.0,
                                                    ),
                                                   Text(
                                'Clouds',
                                style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white.withOpacity(.5),
                        fontWeight:  FontWeight.w500,
                        fontSize: 20.0,
                     ),
                              )]),
                              Text(
                                 '${_model.cloud}%',
                                style:FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight:  FontWeight.w500,
                        fontSize: 20.0,
                     ),
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                             Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                              children:[FaIcon(
                                                      FontAwesomeIcons.wind,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 20.0,),   Text(
                                'Wind',
                                style:FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white.withOpacity(.5),
                        fontWeight:  FontWeight.w500,
                        fontSize: 20.0,
                     ),
                              ),]),
                              Text(
                               '${_model.windSpeed} kph',
                                style:FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight:  FontWeight.w500,
                        fontSize: 20.0,
                     ),
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                             Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                              children:[Icon(
                                                      Icons.water,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 20.0,
                                                    ), Text(
                                'Humidity',
                                style:FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white.withOpacity(.5),
                        fontWeight:  FontWeight.w500,
                        fontSize: 20.0,
                     ),
                              ),]),
                              Text(
                                '${_model.humid}%',
                                style:FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight:  FontWeight.w500,
                        fontSize: 20.0,
                     ),
                              ),
                            ],
                          )),
                    ],
                  ),
                )),
                 SizedBox(
                  height: myHeight * 0.01,
                ),
            Padding(
                  padding: EdgeInsets.symmetric(horizontal: myWidth * 0.06),
                  child:FadeInDown(
              duration:const Duration(milliseconds: 1900),
              child:    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today',
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight:  FontWeight.w500,
                        fontSize: 25.0,
                      )),
                      GestureDetector(onTap: (){context.pushNamed("forecast");},
                      child:GradientText(
                        'View full report',
                        style:FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white.withOpacity(.5),
                        fontWeight:  FontWeight.w500,
                        fontSize: 20.0,
                     ),
                        colors:[
                           Color(0xFFed4478),
Color(0xFF8355c8),
                        ]
                      )),
                    ],
                  ),
                )),
                SizedBox(
                  height: myHeight * 0.02,
                ),

               FadeInDown(
              duration:const Duration(milliseconds: 2000),
              child:      Container(
                  height: myHeight * 0.15,
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
                                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight:  FontWeight.w500,
                        fontSize: 20.0,
                     ),),
                                      Text(
                                      '${getJsonField(
                                                  daysListItem,
                                                  r'''$.day.avgtemp_c''',
                                                ).toString()}ᐤ',
                                        style:FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight:  FontWeight.w500,
                        fontSize: 25.0,
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
                  ),
                )),
                    
                  ],
                ),
              if (_model.isLoading)
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Lottie.asset(
                            'assets/lottie_animations/Animation_-_1707900685521.json',
                            width: 150.0,
                            height: 130.0,
                            fit: BoxFit.cover,
                            animate: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 32.0, 0.0, 0.0),
                          child: GradientText(
                            
                            'Loading weather data',
                            colors: [
        Color(0xFFed4478),
Color(0xFF8355c8),
    ],
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Manrope',
                                  color: FlutterFlowTheme.of(context).secondary,
                                  fontSize: 21.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
