import 'package:users/nearbyAvailableDoctors.dart';

class GeoFireAssistant {
  static List<NearbyAvailableDoctors> nearbyAvailableDoctorsList = [];

  static void removeDoctorFromList(String key) {
    int index =
        nearbyAvailableDoctorsList.indexWhere((element) => element.key == key);
    nearbyAvailableDoctorsList.removeAt(index);
  }

  static void updateDoctorNearbyLocation(NearbyAvailableDoctors doctor) {
    int index = nearbyAvailableDoctorsList
        .indexWhere((element) => element.key == doctor.key);

    nearbyAvailableDoctorsList[index].latitude = doctor.latitude;
    nearbyAvailableDoctorsList[index].longitude = doctor.longitude;
  }
}
