// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

contract SplitWiseDecentralisedExpense {
    struct Trip {
        uint tripId;
        uint groupId;
        string placeToVisit;
    }

    struct Group {
        uint groupId;
        string placeToVisit;
    }

    mapping(uint => Trip) public visitedTripsByGroup;
    mapping(uint => Group) public registeredGroups;
    mapping(uint => address) public usersByGroup;
    mapping(uint => Trip) public tripDetails;

    
}
