pragma solidity ^0.4.26;
contract CrowdFunding {
    
    struct Investor {
        address addr; 
        uint amount;    
        }
        
        address  _contract;    
        address  owner;
        uint  numOfInvestors;    
        uint  deadline;    
        string  public status; 
        bool  end;    
        uint  goalAmount; 
        uint  totalAmount;    
        bool Success=false;
        mapping(uint => Investor)  investors;
        mapping(address => uint) addresses;
        
        modifier isOwner() {
        require(msg.sender == _contract);
        _;
    }
        
        
        constructor(uint _duration,address _owner,uint _goal)  public payable{
            _contract = address(this);
            owner = _owner;
            deadline = now + _duration * 1 seconds;
            goalAmount = _goal * (1 ether);
            status = "Funding";
            end = false;
            numOfInvestors = 0;
            totalAmount = 0;
            }
            
            
            function checkStatus() public returns (string memory) {
                
                if(totalAmount >= goalAmount && now <= deadline){
                end = true;
                status = "Campagin Success";
                Success = true;
                }
                else if(now >= deadline){
                end = true;
                status = "Campagin Failed";
                }
                return status;
            }
            
            function fund() public payable{
                require(msg.sender != _contract);
                require(msg.value > 0);
                checkStatus();
                if(end == false){
                    if(addresses[msg.sender] == 0){
                    numOfInvestors+=1;
                    addresses[msg.sender] = numOfInvestors;
                    }
                    uint _amount = investors[numOfInvestors].amount;
                    investors[numOfInvestors] = Investor(msg.sender,_amount + msg.value);
                    totalAmount+=msg.value;

                }
                }
                
            function checkFoalReached () public payable returns(string memory) {
                checkStatus();
                if (end == true && Success == false){
                    for(uint i=1;i<=numOfInvestors;i++){
                        investors[i].addr.transfer(investors[i].amount);
                    }
                }
                if (end == true && Success == true){
                    owner.transfer(goalAmount);
                    
                }
                return status;
                }
            }
