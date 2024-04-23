// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Auction {

        struct AuctionItem{
            uint256 ItemNumber;
            uint256 StartingPrice;
            uint256 Duration;
            bool whetherActive;
        }

        AuctionItem[] Items;

        struct Mappings{
            mapping(uint256 => uint256) itemNumberToStartingPrice;
            mapping(uint256 => bool) itemNumberToWhetherActive;
            mapping(uint256 => address) maxbidToAddress;
            mapping(uint256 => uint256) itemNumberToDuration;
        }
        
        Mappings mappings;


        function conditions(uint256 itemNumber,uint256 startingPrice,uint256 duration) public view {
            for (uint i=0; i < Items.length; i++) 
            {
                if(Items[i].ItemNumber == itemNumber){
                    revert("Item Number should be unique.");
                }
            }
            
            if (startingPrice == 0 || duration == 0) {
                revert("Starting price or duration cannont be 0.");
            }
        }

		function createAuction(uint256 itemNumber,uint256 startingPrice,uint256 duration) public { 
            conditions(itemNumber,startingPrice,duration);
            AuctionItem memory add = AuctionItem(itemNumber, startingPrice, duration, true);
            Items.push(add);
            mappings.itemNumberToDuration[itemNumber] = duration;
        }

        
		function bid(uint256 itemNumber, uint256 bidAmount) public payable{
            require(block.timestamp < mappings.itemNumberToDuration[itemNumber],"Time up!");
            require(msg.value == bidAmount, "Amount is invalid");
            mappings.itemNumberToStartingPrice[itemNumber] = bidAmount;
        }

        function IndexByItemNumber(uint256 itemNumber) private view returns(uint256){
            uint256 index = 0;
            for (uint256 i=0; index!=0 ; i++){
                if (Items[i].ItemNumber == itemNumber){
                    index = i;
                }
            }
            return index;
        }

		function checkAuctionActive(uint256 itemNumber) public returns (bool) { 
            uint256 index = IndexByItemNumber(itemNumber);
            mappings.itemNumberToWhetherActive[itemNumber] = Items[index].whetherActive;
            return mappings.itemNumberToWhetherActive[itemNumber];
        }

        

		function cancelAuction(uint256 itemNumber) public { 
            uint256 index = IndexByItemNumber(itemNumber);
            if (mappings.itemNumberToWhetherActive[itemNumber] == true){
                delete Items[index];
            }
        }

		function timeLeft(uint256 itemNumber) public view returns(uint256) { 
            if (mappings.itemNumberToWhetherActive[itemNumber] == true){
                return block.timestamp;
            }else{
                revert("The auction isnt active.");
            }
        }

        function checkMax(uint256 itemNumber) private view returns(uint256) {
            uint256 max = 0;
            for (uint256 i=0; i<Items.length; i++) 
            {
                if (mappings.itemNumberToStartingPrice[itemNumber] >= max){
                    max = mappings.itemNumberToStartingPrice[itemNumber];
                    return max;
                }
            }
            
        }

         

		function checkHighestBidder(uint256 itemNumber) public returns (address) { 
            uint256 maxbid = checkMax(itemNumber);
            mappings.maxbidToAddress[maxbid] = msg.sender;
            return mappings.maxbidToAddress[maxbid];
        }

		function checkActiveBidPrice(uint256 itemNumber) public view returns (uint256){
            return mappings.itemNumberToStartingPrice[itemNumber];
        }

}