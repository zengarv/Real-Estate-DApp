// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract UserManagement {
    struct User {
        address userAddress;
        string name;
        string email;
        bool isVerified;
    }

    mapping(address => User) public users;
    address public admin;

    event UserRegistered(address indexed userAddress, string name, string email);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerUser(address _userAddress, string memory _name, string memory email) public onlyAdmin {
        require(users[msg.sender].isVerified, "User already registered");

        users[_userAddress] = User({
            userAddress: _userAddress,
            name: _name,
            email: email,
            isVerified: false
        });

        emit UserRegistered(msg.sender, _name, email);
    }

    function verifyUser(address _userAddress) public onlyAdmin {
        users[_userAddress].isVerified = true;
    } 

    function getUser(address _userAddress) public view returns (User memory) {
        require(users[msg.sender].isVerified, "User already registered");
        return users[_userAddress];
    }
}
