// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LibraryGuard {

    address private ContractOwner;

    struct Reader{
        uint ID;
        address Address;
        uint _Role;
    }

    Reader[] readers;
    mapping(address => uint) addressToRole; 
    mapping(address => uint) addressToID;

    constructor() {
        ContractOwner = msg.sender;
    }
    
    function assign(uint _ID, address _Address, uint _Role) public {
        Reader memory add = Reader(_ID, _Address, _Role);
        readers.push(add);
        addressToRole[_Address] = _Role;
        addressToID[_Address] = _ID;
    }

    function contractOwner() public view returns(address) {
        return ContractOwner;
    }

    function transferOwnership(address _newOwner) public {
        transferOwnership(_newOwner);
        
    }

    function addAdmin(address _admin) public {
        if(msg.sender == ContractOwner){
            addressToRole[_admin] = 100;
        }
    }

    function removeAdmin(address _admin) public {
        if(msg.sender == ContractOwner){
            addressToRole[_admin] = 101;
        }
    }

    function updateUserRole(address _user, uint _role) public {
        if(addressToRole[_user] == 100){
            addressToRole[_user] = _role;
        } 
    }
    
    function isAdmin(address _user) public view returns(uint) {
	    return addressToRole[_user];
    }
    
    function userRole(address _user) public view returns(uint){
        return addressToID[_user];
    }
}
