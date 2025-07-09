import 'package:bhawsar_chemical/helper/app_helper.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/widgets/app_bar.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AboutUsScreen extends StatefulWidget {
  AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: offWhite,
      appBar: CustomAppBar(
        AppText(
          localization.about_us,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: getBackArrow(),
          color: primary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: HtmlWidget('''
     <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 20px;
        }
        h1, h2, h3 {
            color: #333;
        }
        ul {
            margin: 10px 0;
        }
    </style>
</head>
<body>

    <h1>Bhawsar Chemicals Private Limited - Employee and Sales Team Mobile Application</h1>

    <p>Welcome to the official mobile application for Bhawsar Chemicals Private Limited, designed exclusively for our employees and sales team members. This private application serves as a comprehensive tool for order management, tracking employee locations, and efficiently managing attendance records using daily login and location fetching. The main purpose of the app is to track employee and sales team members' work. Their tasks and work are done efficiently on a daily basis. We also aim to reduce paperwork for authorities and employees. Employees and sales team members visit medical facilities, warehouses, clinics, and distributors in person to place orders for needed medicine. If medicine are not needed, we gather reasons for why they are not required, whether it's already having them or lack of interest. Authorities track their members' locations via the admin panel to see whether members actually visit the stores or not.</p>

    <h2>Here's what you can expect from our app:</h2>

    <h3>Key Features:</h3>

    <h4>Management of medical, doctor, warehouse, and distributor information:</h4>
    <ul>
        <li>Sales team members and employees can add medical, doctor, warehouse, and distributor information via the app to scale our business.</li>
        <li>The app can collect information such as name, number, email, address, pin code, and images of medical stores or warehouses.</li>
        <li>This information is used to ensure smooth communication and record-keeping.</li>
    </ul>

    <h4>Digital Order Diary:</h4>
    <ul>
        <li>Easily take and manage orders from medical professionals, doctors, and distributors.</li>
        <li>A simplified order entry process ensures quick and accurate order placement.</li>
        <li>The app provides a search feature for ordering medical items.</li>
        <li>View order history and track order status in real-time.</li>
        <li>Track order location to verify if the order is taken from the correct place or not.</li>
        <li>Punch both types of orders, productive and non-productive, directly through the app.</li>
    </ul>

    <h4>Employee Tracking:</h4>
    <ul>
        <li>Monitor the location of your sales team members during their working hours.</li>
        <li>Ensure that employees are meeting their scheduled appointments and visits via location tracking.</li>
        <li>Track employee performance based on their orders received from medical facilities.</li>
        <li>Improve accountability and productivity with accurate location data.</li>
    </ul>

    <h4>Travel & Food Expenses:</h4>
    <ul>
        <li>Employees can add their travel and food expenses via the app.</li>
        <li>In this process, provide the start and end areas, place of work, distance traveled, expense type, travel type, expense date, amount, notes, and receipt.</li>
    </ul>

    <h4>Attendance Management:</h4>
    <ul>
        <li>Record and track employee attendance directly through the application.</li>
        <li>Automated attendance logging based on location data and login/logout times.</li>
        <li>Generate comprehensive attendance reports for HR and management purposes.</li>
    </ul>

    <h4>Create Reminder:</h4>
    <ul>
        <li>Employees can create reminders for store visits and placing orders.</li>
        <li>Create reminders for 1 week, 15 days, and 1 month.</li>
    </ul>

    <h3>Benefits:</h3>
    <ul>
        <li><strong>Enhanced Efficiency:</strong> Streamline the order-taking process with a digital solution, reducing paperwork and manual entry errors.</li>
        <li><strong>Improved Accountability:</strong> Location tracking ensures that employees are following their schedules and meeting their targets.</li>
        <li><strong>Accurate Attendance Records:</strong> Automated attendance management helps maintain accurate records, reducing discrepancies and manual effort.</li>
        <li><strong>Data-Driven Insights:</strong> Access valuable data on order trends, employee performance, and attendance patterns to make informed decisions.</li>
    </ul>

    <h2>How to Use</h2>

    <h3>Ordering Process:</h3>
    <ol>
        <li><strong>Login:</strong> Employees and sales team members can securely log in using their company credentials.</li>
        <li><strong>Ensure Location Permission:</strong> After login, need to ensure to provide location permission always allow. Location services are enabled to allow tracking during work hours.</li>
        <li><strong>Order Management:</strong> Navigate to the order section using the search medical option from the home page. Search medical which went to create an order. Select then create new orders.</li>
        <li><strong>View Order and Update Order:</strong> Select the order history section from the home page to view all orders and update orders.</li>
        <li><strong>Attendance:</strong> Attendance tracking via login/logout feature to log attendance seamlessly.</li>
    </ol>

    <h3>Add Medical, Doctor, Warehouse, and Distributor:</h3>
    <ol>
        <li><strong>Login:</strong> Employees and sales team members can securely log in using their company credentials.</li>
        <li><strong>Ensure Location Permission:</strong> After logging in, ensure to provide location permission and always allow it. Location services must be enabled to allow tracking during work hours.</li>
        <li><strong>Add Medical, Doctor, Warehouse, and Distributor:</strong> Navigate to the add medical section to add new medical facilities, doctors, warehouses, and distributors. Fill in all information correctly.</li>
        <li><strong>View Medical:</strong> Navigate to the search medical section to search for medical facilities and obtain related information.</li>
    </ol>

</body>
</html>

      '''),
          ),
        ),
      ),
    );
  }
}
