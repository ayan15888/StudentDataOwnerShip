// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentDataOwnership {
    
    struct Student {
        string name;
        string email;
        address owner;
        bool exists;
    }

    mapping(address => Student) private students;

    // Events
    event StudentRegistered(address indexed studentAddress, string name, string email);
    event StudentDataUpdated(address indexed studentAddress, string newName, string newEmail);
    event StudentDataAccessGranted(address indexed studentAddress, address indexed requester);

    modifier onlyOwner() {
        require(students[msg.sender].owner == msg.sender, "Only the owner can perform this action");
        _;
    }

    modifier onlyExistingStudent(address _studentAddress) {
        require(students[_studentAddress].exists, "Student does not exist");
        _;
    }

    // Register a new student profile
    function registerStudent(string memory _name, string memory _email) external {
        require(!students[msg.sender].exists, "Student already registered");

        students[msg.sender] = Student({
            name: _name,
            email: _email,
            owner: msg.sender,
            exists: true
        });

        emit StudentRegistered(msg.sender, _name, _email);
    }

    // Update student data
    function updateStudentData(string memory _newName, string memory _newEmail) external onlyOwner {
        students[msg.sender].name = _newName;
        students[msg.sender].email = _newEmail;

        emit StudentDataUpdated(msg.sender, _newName, _newEmail);
    }

    // Function to allow third parties to request access to student data
    function grantAccess(address _requester) external onlyOwner onlyExistingStudent(msg.sender) {
        // Here, the student can grant access to their data to a third party
        emit StudentDataAccessGranted(msg.sender, _requester);
    }

    // Function to view student data (can be restricted to authorized entities)
    function viewStudentData(address _studentAddress) external view onlyExistingStudent(_studentAddress) returns (string memory, string memory) {
        Student memory student = students[_studentAddress];
        return (student.name, student.email);
    }
}
