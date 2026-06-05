import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_tracker/app_constants.dart';
import 'package:health_tracker/supabase.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map recivedData;
  late bool isTimePassed;
  List<Map> formattedData = [];

  final Map<String, LinearGradient> colorGradients = {
    "Green Gradient": LinearGradient(
      colors: [AppConstants.green, AppConstants.greenGradient],
      stops: [0.2, 0.78],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),

    "Yellow Gradient": LinearGradient(
      colors: [AppConstants.yellow, AppConstants.yellowGradient],
      stops: [0.0, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),

    "Red Gradient": LinearGradient(
      colors: [AppConstants.red, AppConstants.redGradient],
      stops: [0.0, 0.5],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  };

  final tableService = SupabaseTableService();
  bool isLoading = true;

  void loadUserData() async {
    try {
      setState(() => isLoading = true);

      var response = await tableService.loadLastestRow();

      setState(() {
        if (response.isNotEmpty) {
          isLoading = false;

          recivedData = response;
          isTimePassed =
              DateTime.now()
                  .toUtc()
                  .difference(DateTime.parse(recivedData['created_at']).toUtc())
                  .inMinutes >=
              20;
          formatRecivedData();
          debugPrint('Data fetched');
        }
      });
    } catch (e) {
      debugPrint("An Error has occured: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void formatRecivedData() {
    final bodyTemp = (recivedData['body_temp'] as num).toDouble();
    final spo2 = int.parse(recivedData['spo2'].toString());
    final hearRate = recivedData['bbm'].toString();
    final bloodPressure = recivedData['blood_pressure'];
    final bloodPressureMeasure = bloodPressure.split("/");

    /*
    
    Formating Spo2
    
    */
    if (spo2 >= 95 && spo2 <= 100) {
      formattedData.add(
        _buildMap(
          "images/Oxygen_Level.png",
          "Oxygen Saturation Level",
          '${spo2.toString()} %',
          colorGradients['Green Gradient']!,
        ),
      );
    } else if (spo2 >= 91 && spo2 <= 94) {
      formattedData.add(
        _buildMap(
          "images/Oxygen_Level.png",
          "Oxygen Saturation Level",
          '${spo2.toString()} %',
          colorGradients['Yellow Gradient']!,
        ),
      );
    } else if (spo2 <= 90) {
      formattedData.add(
        _buildMap(
          "images/Oxygen_Level.png",
          "Oxygen Saturation Level",
          '${spo2.toString()} %',
          colorGradients['Red Gradient']!,
        ),
      );
    }

    /*
    
    Formating Body Temperature
    
    */

    if (bodyTemp >= 36.1 && bodyTemp <= 37.2) {
      formattedData.add(
        _buildMap(
          "images/Body_Temp.png",
          "Body Temperature",
          '${bodyTemp.toString()} c°',
          colorGradients['Green Gradient']!,
        ),
      );
    } else if (bodyTemp >= 37.3 && bodyTemp <= 39.4) {
      formattedData.add(
        _buildMap(
          "images/Body_Temp.png",
          "Body Temperature",
          '${bodyTemp.toString()} c°',
          colorGradients['Yellow Gradient']!,
        ),
      );
    } else if (bodyTemp >= 39.5 || bodyTemp < 36.1) {
      formattedData.add(
        _buildMap(
          "images/Body_Temp.png",
          "Body Temperature",
          '${bodyTemp.toString()} c°',
          colorGradients['Red Gradient']!,
        ),
      );
    }

    /*
    
    Formating Heart Rate
    
    */
    if (int.parse(hearRate) >= 40 && int.parse(hearRate) <= 120) {
      formattedData.add(
        _buildMap(
          "images/Heart_Rate.png",
          "Heart Rate",
          "$hearRate BPM",
          colorGradients['Green Gradient']!,
        ),
      );
    } else if (int.parse(hearRate) >= 121 && int.parse(hearRate) <= 150) {
      formattedData.add(
        _buildMap(
          "images/Heart_Rate.png",
          "Heart Rate",
          "$hearRate BPM",
          colorGradients['Yellow Gradient']!,
        ),
      );
    } else if (int.parse(hearRate) > 150 || int.parse(hearRate) < 40) {
      formattedData.add(
        _buildMap(
          "images/Heart_Rate.png",
          "Heart Rate",
          "$hearRate BPM",
          colorGradients['Red Gradient']!,
        ),
      );
    }

    /*
    
    Fomating Blood Pressure
    
    */
    if (int.parse(bloodPressureMeasure[0]) >= 100 &&
        int.parse(bloodPressureMeasure[0]) <= 129 &&
        int.parse(bloodPressureMeasure[1]) >= 80 &&
        int.parse(bloodPressureMeasure[1]) <= 90) {
      formattedData.add(
        _buildMap(
          "images/Blood_Pressure.png",
          "Blood Pressure",
          '${bloodPressure.toString()} mmHg',
          colorGradients['Green Gradient']!,
        ),
      );
    } else if (int.parse(bloodPressureMeasure[0]) >= 130 &&
        int.parse(bloodPressureMeasure[0]) <= 139 &&
        int.parse(bloodPressureMeasure[1]) >= 91 &&
        int.parse(bloodPressureMeasure[1]) <= 100) {
      formattedData.add(
        _buildMap(
          "images/Blood_Pressure.png",
          "Blood Pressure",
          '${bloodPressure.toString()} mmHg',
          colorGradients['Yellow Gradient']!,
        ),
      );
    } else if (int.parse(bloodPressureMeasure[0]) >= 140 &&
            int.parse(bloodPressureMeasure[1]) >= 101 ||
        int.parse(bloodPressureMeasure[0]) < 100 &&
            int.parse(bloodPressureMeasure[1]) < 80) {
      formattedData.add(
        _buildMap(
          "images/Blood_Pressure.png",
          "Blood Pressure",
          '${bloodPressure.toString()} mmHg',
          colorGradients['Red Gradient']!,
        ),
      );
    }
  }

  /*
  
  Healper function for adding the map to the list of measurments
  
  */
  Map<String, dynamic> _buildMap(
    String measurementIcon,
    String measurementTitle,
    String measurement,
    LinearGradient colorGradient,
  ) {
    return {
      "measurement icon": measurementIcon,
      "measurement title": measurementTitle,
      "measurement": measurement,
      "color gradient": colorGradient,
    };
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppConstants.mainColor,
        statusBarBrightness: Brightness.light,
      ),
    );

    return isLoading
        /*
    
    Loading Section
    
    */
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      color: AppConstants.mainColor,
                      strokeWidth: 8,
                    ),
                  ),
                ],
              ),
            ),
          )
        /*
          
          The Data Section
          
          */
        : Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  // Image(
                  //   image: AssetImage('images/Leading_Logo.png'),
                  //   width: 45,
                  //   height: 45,
                  // ),
                  // SizedBox(width: 3),
                  Text(
                    "Results",
                    style: TextStyle(
                      fontSize: 32,
                      color: AppConstants.mainColor,
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(5),
                child: Divider(
                  height: 2,
                  thickness: 2,
                  color: AppConstants.mainColor,
                  endIndent: 12,
                  indent: 12,
                ),
              ),
            ),
            /*
            
            The containers that will hold the data
            
            */
            body: isTimePassed
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 250,
                          child: Text(
                            'Connect device to show data',
                            style: TextStyle(
                              fontSize: 50,
                              color: AppConstants.mainColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Column(
                      children: [
                        /*
                  
                  The map section
                  
                  */
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 23,
                              height: 23,
                              decoration: BoxDecoration(
                                color: AppConstants.green,
                              ),
                            ),
                            SizedBox(width: 3),
                            Text(
                              "Good",
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Inter",
                              ),
                            ),
                            SizedBox(width: 6),

                            Container(
                              width: 23,
                              height: 23,
                              decoration: BoxDecoration(
                                color: AppConstants.yellow,
                              ),
                            ),
                            SizedBox(width: 3),
                            Text(
                              "Could be better",
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Inter",
                              ),
                            ),
                            SizedBox(width: 6),

                            Container(
                              width: 23,
                              height: 23,
                              decoration: BoxDecoration(
                                color: AppConstants.red,
                              ),
                            ),
                            SizedBox(width: 3),
                            Text(
                              "Danger",
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Inter",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "(Last updated ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now()).toString()})",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),

                        /*
                  
                  Containers
                  
                  */
                        Expanded(
                          child: ListView.builder(
                            itemCount: formattedData.length,
                            itemBuilder: (context, index) {
                              var data = formattedData[index];
                              var measurementSplit = data['measurement'].split(
                                " ",
                              );

                              return Container(
                                height: 140,
                                width: 390,
                                margin: EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                  color: AppConstants.green,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.50),
                                      blurRadius: 8,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                  gradient: data['color gradient'],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                              data['measurement icon'],
                                            ),
                                            width: 40,
                                            height: 40,
                                          ),
                                          Text(
                                            data['measurement title'],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            measurementSplit[0],
                                            style: TextStyle(
                                              fontSize: 36,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 5),
                                            child: Text(
                                              measurementSplit[1],
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
  }
}
