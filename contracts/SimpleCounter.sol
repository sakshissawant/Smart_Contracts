// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityCounter {
    mapping(uint256=> uint256) IDtoCount;

    struct Counter{
        uint256 ID;
        uint256 count;
        
    }

    Counter[] Announcement;

    function CheckIfUnique(uint announcement_id) private view returns(bool a,uint b){
        for(uint i=0; i<Announcement.length; i++){
            if(announcement_id == Announcement[i].ID){
                return (true, i);
            }
        }
    }

    function incrementCounter(uint announcement_id) public {
        if(Announcement.length == 0){
            uint count = 1;
            Counter memory newAnnouncement = Counter(announcement_id, count);
            Announcement.push(newAnnouncement);
            IDtoCount[announcement_id] = count;
        }else{
        (bool check,uint index) = CheckIfUnique(announcement_id);
        if (check == true){
            Announcement[index].count++;
            IDtoCount[announcement_id] = Announcement[index].count;
        }else{
        Counter memory newAnnouncement = Counter(announcement_id, Announcement[index].count);
        Announcement.push(newAnnouncement);
        IDtoCount[announcement_id] = Announcement[index].count;

        }
        }
    }

    function viewCounter(uint256 announcement_id) public view returns(uint256) {
        return IDtoCount[announcement_id];
    }

}
