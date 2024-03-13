import Foundation

enum Course: String, Codable  {
    case A,B,C,D,E,F
}

//to represent student details
struct Student: Codable, Comparable{    //in class comparable will tell to add "==" func too
    
    let fullName: String        // can use coding keys to get encoded values in the same seq
    let age: Int
    let address: String
    let rollNumber: Int
    let courses: [Course]
    
    static func < (lhs: Student, rhs: Student) -> Bool {
        if lhs.fullName == rhs.fullName{
            return lhs.rollNumber < rhs.rollNumber
        }
        return lhs.fullName < rhs.fullName
    }
}

// to manage user data and operations
class UserManager {
    var users = [Student]()
    
    func addUser(student : Student){
        users.append(student)
        users.sort()
    }
    
    func displayUsers(){
        if users.isEmpty{
            print("No users found")
        }else{
            for user in users{
                print("Name: \(user.fullName), Age: \(user.age), Address: \(user.address), Roll Number: \(user.rollNumber), Courses: \(user.courses)")
            }
        }
    }
    
    // Method to delete user by roll number
    func deleteUser(rollNumber: Int) {
        if let index = users.firstIndex(where: { $0.rollNumber == rollNumber }) //find the index of the first element to match the given condtion.
        {
            users.remove(at: index)
            print("User with roll number \(rollNumber) deleted successfully.")
        } else {
            print("User with roll number \(rollNumber) not found.")
        }
    }
    
    // Method to save user details to disk
    func saveUsersToDisk() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("users.json")
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(users)
            try data.write(to: fileURL)
            print("User details saved to disk at path: \(fileURL)")
        } catch {
            print("Error saving user details to disk: \(error.localizedDescription)")
        }
    }
}

// Menu class to handle the command line menu
class Menu {
    let userManager = UserManager()
    
    func displayMenu() {
        var choice = 0
        repeat {
            print("\nMenu:")
            print("1. Add User details")
            print("2. Display User details")
            print("3. Delete User details")
            print("4. Save User details to disk")
            print("5. Exit")
            
            if let input = readLine(), let option = Int(input) {
                switch option {
                case 1:
                    addUserDetails()
                case 2:
                    userManager.displayUsers()
                case 3:
                    deleteUserDetails()
                case 4:
                    userManager.saveUsersToDisk()
                case 5:
                    choice = 5
                default:
                    print("Invalid choice. Please enter a number between 1 and 5.")
                }
            }
        } while choice != 5
    }
    
    func addUserDetails() {
        print("Enter Full Name:")
        guard let fullName = readLine(), !fullName.isEmpty else {
            print("Full Name cannot be empty.")
            return
        }
        
        print("Enter Age:")
        guard let ageString = readLine(), let age = Int(ageString) else {
            print("Invalid Age.")
            return
        }
        
        print("Enter Address:")
        guard let address = readLine(), !address.isEmpty else {
            print("Address cannot be empty.")
            return
        }
        
        print("Enter Roll Number:")
        guard let rollNumberString = readLine(), let rollNumber = Int(rollNumberString) else {
            print("Invalid Roll Number.")
            return
        }
        
        // Get courses
        var courses = [Course]()
        while courses.count < 4 {
            print("Choose Course \(courses.count + 1) out of A, B, C, D, E, F:")
            if let courseInput = readLine(), let course = Course(rawValue: courseInput.uppercased()) {
                courses.append(course)
            } else {
                print("Invalid Course.")
            }
        }
        
        let student = Student(fullName: fullName, age: age, address: address, rollNumber: rollNumber, courses: courses)
        userManager.addUser(student: student)
        print("User details added successfully.")
    }
    
    func deleteUserDetails() {
        print("Enter Roll Number of User to Delete:")
        guard let rollNumberString = readLine(), let rollNumber = Int(rollNumberString) else {
            print("Invalid Roll Number.")
            return
        }
        userManager.deleteUser(rollNumber: rollNumber)
    }
}

// Main entry point of the program
let menu = Menu()
menu.displayMenu()
