import 'package:intl/intl.dart';

class EmploymentUtils {
  static String getStatus(double score, int level) {
    if (score >= 80) return "A promotion and consequential pay increase";
    if (score >= 50) return "No Change";
    if (score >= 40) return level == 0 ? "No Change" : "A Demotion";
    return "Termination";
  }

  static String getNewSalary(int level, double score) {
    String salary;

    if (score < 40) return "₦0";

    int newLevel = level;

    if (score >= 80) {
      newLevel = level + 1;
    } else if (score < 50 && score >= 40 && level > 0) {
      newLevel = level - 1;
    }

    if (newLevel > 5) newLevel = 5;

    switch (newLevel) {
      case 0:
        salary = "₦70,000";
        break;
      case 1:
        salary = "₦100,000";
        break;
      case 2:
        salary = "₦120,000";
        break;
      case 3:
        salary = "₦180,000";
        break;
      case 4:
        salary = "₦200,000";
        break;
      case 5:
        salary = "₦250,000";
        break;
      default:
        salary = "₦0";
    }

    return salary;
  }

  static String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }
}
