// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract CarRental {
  uint totalAvailableCars;
  address rentalOwner; 
  address[] renters;
  bool rented;

  constructor() {
    rentalOwner = msg.sender;
    // fixed number of cars
    totalAvailableCars = 10;
  }

   modifier isOwner() {
    require(msg.sender == rentalOwner, "Only rental owner can perform this action");
    _;
  }
// Check rental DB
function checkDatabase() public isOwner view returns(address[] memory,uint) {
    return (
      renters,
      totalAvailableCars
    );
}
  event RentalIsSuccefull (address, string);
  error PendingRentalReturn(address, string );
  error RentalNotAvailable (string);

  function requestARental (uint req ) public  { 
 
  //address can only rent if there are no pending returns
  for (uint256 index = 0; index < renters.length; index++) {
    if(renters[index] == msg.sender) {
      revert PendingRentalReturn(msg.sender, "You are yet to returned previous rental");
    } 
  }
   // address shouldnt rent more than 1
  require( req > 1, "You can only rent one per time");

  // check availability
    if(totalAvailableCars == 0 ) revert RentalNotAvailable("No rental available at this time");
    // approve rental
    totalAvailableCars -= req;  
    renters.push(msg.sender);
    emit RentalIsSuccefull(msg.sender, "You have successfully rented a car");

  }

  function returnRental () public  {  
  // check if address rented a car
    for (uint i = 0; i < renters.length; i++) {
      if(msg.sender == renters[i]) {
        totalAvailableCars += 1;
        delete renters[i];  /* fix the emmpty index */
        emit RentalIsSuccefull(msg.sender, "You have successfully returned your rental");
      } else {
        revert PendingRentalReturn(msg.sender, "No pending rental found");     
      }
     
    }
  }
}