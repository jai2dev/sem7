pragma solidity ^0.4.25; 
 
contract CrowdFunding {     
    
    // Investor struct     
    struct Investor {         
        
        address addr;// investor's address         
        
        uint amount; // investment amount     
    }     
        
    address public owner; // contract owner     
    
    uint public numbInvestors; // the number of investors     
    
    uint public deadline;  // deadline for this contract to be closed     
    
    string public status; // "Funding", "Campaign Success", "Campaign Failed"     
    
    bool public isOver;  // has the campaign ended?    
    
    uint public goalAmount; // target amount     
    
    uint public totalAmount;  //total ammout     
    
    mapping(uint => Investor) public investors; //Investor mapping  
              
            
    constructor(uint _duration, uint _goalAmount) public {     
        owner = msg.sender;
        deadline = getNow() + _duration;
        goalAmount = _goalAmount;
        status = "Funding";
        isOver = false;
        numbInvestors = 0;
        totalAmount = 0;
    }       
            
    // Function to be called when investing     
    function fund() public payable {  
        //If the campaign is over
        if(isOver) { 
            msg.sender.transfer(msg.value);
            return;
        }

        Investor memory investor;
        investor = Investor({addr: msg.sender, amount: msg.value}); 
        numbInvestors++;
        investors[numbInvestors] = investor;
        totalAmount += msg.value;

        checkGoalReached();
    }          
    
    function checkGoalReached () public {          
        //Check if this crowd funding ended or not          
        if(isOver) { return;} 
        //Check if the deadline is past or not  
        if(getNow() > deadline) {
            isOver = true;
        }         

        //Making the totalAmount comparable to the goalamount
        uint totalAmountAsETH = totalAmount / 1000000000000000000; //WEI to ETH conversion
        
        //If this crowd funding is successful, send funded ETH to owner  
        if(totalAmountAsETH >= goalAmount) { 
            owner.transfer(totalAmount);
            status = "Campaign Succes";
            isOver = true;
        }
        
        //If not, return fund-raising to each investor
        if(totalAmountAsETH < goalAmount && isOver) {
            for(numbInvestors; numbInvestors > 0; numbInvestors--) { 
                Investor memory investor;
                investor = investors[numbInvestors];
                address returnAddress = investor.addr;
                uint amountToReturn = investor.amount;
                returnAddress.transfer(amountToReturn);
            }
            status = "Campaign Failed";
            isOver = true;
        }
        
    }          
    
    // Function to destroy this contract 
    // inspired by https://ethereumdev.io/ethereum-smart-contracts-lifecycle/
    function kill() public {
       if (owner == msg.sender) { // Only privillige of owner
          selfdestruct(owner); //destroy contract
       }
    }


    //Get the amount funded by a specific investor address
    function getFundingFromInvestor(address investorAddr) public view returns(uint) { 
        uint amountInvested = 0; //If investor addr is not present in mapping, the given addr funded 0
        for(uint i = 1; i <= numbInvestors; i++) { 
            if(investors[i].addr == investorAddr) { 
                amountInvested = investors[i].amount;
            }
        }
        return amountInvested;
    }

    function getNow() public view returns (uint256) { 
        return now;
    }   

     function getIsOver() public view returns (bool) { 
        return isOver;
    } 

     function getDeadline() public view returns (uint) { 
        return deadline;
    }   

    function getTotalFunding() public view returns (uint) { 
        return totalAmount; 
    }
    
    function getStatus() public view returns (string) { 
        return status;
    }

} 