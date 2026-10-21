import 'package:flutter/material.dart';

enum RideType { go, comfort, auto, bike }

class RideOption {
  final RideType type; final String name; final String eta; final String fare; final String capacity; final IconData icon;
  const RideOption(this.type, this.name, this.eta, this.fare, this.capacity, this.icon);
}

class Driver {
  final String name, car, plate, rating;
  const Driver(this.name, this.car, this.plate, this.rating);
}

const rideOptions = [
  RideOption(RideType.go, 'P-Ride Go', '3 min', '₹189', '4 seats', Icons.directions_car_filled_rounded),
  RideOption(RideType.comfort, 'P-Ride Comfort', '5 min', '₹269', '4 seats', Icons.airline_seat_recline_normal_rounded),
  RideOption(RideType.auto, 'Auto', '2 min', '₹126', '3 seats', Icons.electric_rickshaw_rounded),
  RideOption(RideType.bike, 'Bike', '4 min', '₹99', '1 seat', Icons.two_wheeler_rounded),
];
const demoDriver = Driver('Amit Patil', 'Maruti Suzuki Dzire', 'MH 12 KT 4821', '4.9');
