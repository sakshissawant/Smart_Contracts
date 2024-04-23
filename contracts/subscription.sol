//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SubscriptionService {

    struct subs{
        address User;
        bool subscribed;
    }

    subs[] People;
    mapping(address => bool) addressToBool;

    function subscribe(uint256 duration) public payable {
      require(msg.value == 1000, "Send 1000 wei.");
      for(uint256 i=block.timestamp;i<=duration;){
        subs memory add = subs(msg.sender,true);
        People.push(add);
        addressToBool[msg.sender] = true;
      }
      addressToBool[msg.sender]=false;
    }

    function isSubscribed(address user) external view returns (bool) {
        return addressToBool[user];
    }

    function cancelSubscription() external {
        addressToBool[msg.sender] = false;
    }
}
