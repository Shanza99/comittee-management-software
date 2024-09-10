import 'dart:io';
import 'dart:math';

void main() {
  Map<String, Map<String, dynamic>> committees = {}; // To store committees
  Map<String, Map<String, dynamic>> members = {}; // To store members
  Map<String, String> users = {
    'admin': 'adminpassword', // Admin credentials
    'user': 'userpassword',   // User credentials
  };

  while (true) {
    print('Committee Management System');
    print('1. Admin Login');
    print('2. User Login');
    print('3. Exit');
    String? choice = stdin.readLineSync()?.trim();

    if (choice == '1') {
      adminLogin(committees, members, users);
    } else if (choice == '2') {
      userLogin(committees, members, users);
    } else if (choice == '3') {
      print('Exiting...');
      break;
    } else {
      print('Invalid choice, please try again.');
    }
  }
}

void adminLogin(Map<String, Map<String, dynamic>> committees,
    Map<String, Map<String, dynamic>> members, Map<String, String> users) {
  print('Enter Admin ID:');
  String? id = stdin.readLineSync()?.trim();
  print('Enter Password:');
  String? password = stdin.readLineSync()?.trim();

  if (users.containsKey(id) && users[id] == password) {
    print('Admin logged in successfully.');
    adminMenu(committees, members);
  } else {
    print('Invalid credentials.');
  }
}

void userLogin(Map<String, Map<String, dynamic>> committees,
    Map<String, Map<String, dynamic>> members, Map<String, String> users) {
  print('Enter User ID:');
  String? id = stdin.readLineSync()?.trim();
  print('Enter Password:');
  String? password = stdin.readLineSync()?.trim();

  if (users.containsKey(id) && users[id] == password) {
    print('User logged in successfully.');
    userMenu(committees, members);
  } else {
    print('Invalid credentials.');
  }
}

void adminMenu(Map<String, Map<String, dynamic>> committees,
    Map<String, Map<String, dynamic>> members) {
  while (true) {
    print('Admin Menu');
    print('1. Create Committee');
    print('2. Add Member');
    print('3. Remove Member');
    print('4. Update Member Details');
    print('5. View All Members');
    print('6. View Committee Schedule');
    print('7. Exit');
    String? choice = stdin.readLineSync()?.trim();

    if (choice == '1') {
      createCommittee(committees);
    } else if (choice == '2') {
      addMember(committees, members);
    } else if (choice == '3') {
      removeMember(members);
    } else if (choice == '4') {
      updateMemberDetails(members);
    } else if (choice == '5') {
      viewAllMembers(members);
    } else if (choice == '6') {
      viewCommitteeSchedule(committees);
    } else if (choice == '7') {
      break;
    } else {
      print('Invalid choice, please try again.');
    }
  }
}

void userMenu(Map<String, Map<String, dynamic>> committees,
    Map<String, Map<String, dynamic>> members) {
  while (true) {
    print('User Menu');
    print('1. View Committee Schedule');
    print('2. Check Committee Status');
    print('3. Exit');
    String? choice = stdin.readLineSync()?.trim();

    if (choice == '1') {
      viewCommitteeSchedule(committees);
    } else if (choice == '2') {
      checkCommitteeStatus(committees, members);
    } else if (choice == '3') {
      break;
    } else {
      print('Invalid choice, please try again.');
    }
  }
}

void createCommittee(Map<String, Map<String, dynamic>> committees) {
  print('Enter Committee Name:');
  String? name = stdin.readLineSync()?.trim();
  print('Enter Committee Price:');
  String? price = stdin.readLineSync()?.trim();
  print('Enter Required Number of Members:');
  int? numMembers = int.tryParse(stdin.readLineSync() ?? '');

  if (name != null && price != null && numMembers != null) {
    String id = generateShortCommitteeId();
    String password = generatePassword();
    committees[id] = {
      'name': name,
      'price': price,
      'requiredMembers': numMembers,
      'password': password,
    };
    print('Committee created successfully.');
    print('Generated Short Committee ID: $id');
    print('Committee Password: $password');
  } else {
    print('Invalid input. Please try again.');
  }
}

void addMember(Map<String, Map<String, dynamic>> committees,
    Map<String, Map<String, dynamic>> members) {
  print('Enter Committee ID to add member:');
  String? committeeId = stdin.readLineSync()?.trim();
  if (committees.containsKey(committeeId)) {
    print('Enter Member Name:');
    String? name = stdin.readLineSync()?.trim();
    print('Enter Member Phone Number:');
    String? phone = stdin.readLineSync()?.trim();
    print('Enter Member Email:');
    String? email = stdin.readLineSync()?.trim();

    if (name != null && phone != null && email != null) {
      members[name] = {'phone': phone, 'email': email, 'committeeId': committeeId};
      print('Member added successfully to Committee ID: $committeeId');
    } else {
      print('Invalid input. Please try again.');
    }
  } else {
    print('Invalid Committee ID.');
  }
}

void removeMember(Map<String, Map<String, dynamic>> members) {
  print('Enter Member Name to remove:');
  String? name = stdin.readLineSync()?.trim();
  if (members.containsKey(name)) {
    members.remove(name);
    print('Member removed successfully.');
  } else {
    print('Member not found.');
  }
}

void updateMemberDetails(Map<String, Map<String, dynamic>> members) {
  print('Enter Member Name to update:');
  String? name = stdin.readLineSync()?.trim();
  if (members.containsKey(name)) {
    print('Enter New Phone Number:');
    String? phone = stdin.readLineSync()?.trim();
    print('Enter New Email:');
    String? email = stdin.readLineSync()?.trim();

    if (phone != null && email != null) {
      members[name]!['phone'] = phone;
      members[name]!['email'] = email;
      print('Member details updated successfully.');
    } else {
      print('Invalid input. Please try again.');
    }
  } else {
    print('Member not found.');
  }
}

void viewAllMembers(Map<String, Map<String, dynamic>> members) {
  if (members.isEmpty) {
    print('No members found.');
  } else {
    members.forEach((name, details) {
      print('Name: $name, Phone: ${details['phone']}, Email: ${details['email']}');
    });
  }
}

void viewCommitteeSchedule(Map<String, Map<String, dynamic>> committees) {
  if (committees.isEmpty) {
    print('No committees scheduled.');
  } else {
    committees.forEach((id, details) {
      print(
          'Committee ID: $id, Name: ${details['name']}, Price: ${details['price']}, Members Required: ${details['requiredMembers']}');
    });
  }
}

void checkCommitteeStatus(Map<String, Map<String, dynamic>> committees,
    Map<String, Map<String, dynamic>> members) {
  print('Enter Committee ID to check status:');
  String? id = stdin.readLineSync()?.trim();
  if (committees.containsKey(id)) {
    var committeeMembers = members.values
        .where((member) => member['committeeId'] == id)
        .toList();
    var committee = committees[id]!;
    int availableSlots = committee['requiredMembers'] - committeeMembers.length;

    print(
        'Committee ID: $id, Name: ${committee['name']}, Members Required: ${committee['requiredMembers']}');
    print('Currently available slots: $availableSlots');
  } else {
    print('Invalid Committee ID.');
  }
}

String generateShortCommitteeId() {
  const length = 4; // Short ID with 4 characters
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'; // Characters for ID
  Random rand = Random();
  return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
}

String generatePassword() {
  return 'password'; // Placeholder password generator
}
