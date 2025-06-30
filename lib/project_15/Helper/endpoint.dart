class Endpoint {
  static const baseUrl = "https://appfutsal.mobileprojp.com/api";

  // Auth
  static const register = '$baseUrl/register';
  static const login = '$baseUrl/login';

  // Fields (Lapangan)
  static const add = '$baseUrl/fields';
  static const fields = '$baseUrl/fields';
  static String update(int id) => '$baseUrl/fields/$id'; // PATCH or DELETE

  // Schedule
  static const addSchedule = '$baseUrl/schedules';
  static String schedulesByField(int fieldId) =>
      '$baseUrl/schedules/$fieldId'; // GET all

  // Booking
  static const bookSchedule = '$baseUrl/bookings'; // POST
  static const myBookings = '$baseUrl/my-bookings'; // GET
  static const allBookings = '$baseUrl/all-bookings'; // GET
}
