import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WeatherScreen(),
    );}}
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return WeatherScreenState();
  }}
class WeatherScreenState extends State<WeatherScreen> {
  String temperature = "Temperature --";
  String city = "Dhaka";
  String feelsLike = "Feels Like --";
  String windSpeed = "Wind Speed -- ";
  String humidity = "Humidity --";
  String visibility = "Visibility --";
  String pressure = "Pressure --";
  String icon = "https://cdn.weatherapi.com/weather/64x64/night/113.png";
  String key="291e2d051e624ed488974910240410";
  TextEditingController cityController = TextEditingController();
  static const baseUrl='http://api.weatherapi.com/v1';
  Future<void> GetWeatherData() async {
    //API call
    Uri uri=Uri.parse("http://api.weatherapi.com/v1/current.json?key=$key&q=$city");
    Map<String, String> headers= {"accept":"application/json"};
    final response= await http.get(uri, headers: headers);
    final body= json.decode(response.body);

    setState(() {
       temperature = "Temperature:${body['current']['temp_c']} Degree";
       feelsLike = "Feels Like:${body['current']['feelslike_c'] } Degree";
       windSpeed = "Wind Speed: ${body['current']['wind_kph']} kph";
       humidity = "Humidity: ${body['current']['humidity']} kph";
       visibility = "Visibility: ${body['current']['vis_km']} km";
       pressure = "Pressure: ${body['current']['pressure_mb']} mb";
       icon = "https:${body['current']['condition']['icon']}";
    });
  }
  @override
  void initState() {
    super.initState();
    GetWeatherData();
  }
  @override
  void dispose() {
    cityController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text("Weather App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: cityController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(onPressed: () {
                setState(() {
                  city=cityController.text;
                });
                GetWeatherData();
              }, child: const Text("Get Weather Data")),
              const SizedBox(height: 10),
              Image.network(icon),
              const SizedBox(height: 10),
              Text(temperature, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(feelsLike, style: const TextStyle(fontSize: 18)),
              Text(windSpeed, style: const TextStyle(fontSize: 18)),
              Text(humidity, style: const TextStyle(fontSize: 18)),
              Text(visibility, style: const TextStyle(fontSize: 18)),
              Text(pressure, style: const TextStyle(fontSize: 18)),
              Text("City: $city", style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
