
pragma solidity ^0.4.26;

contract AddNewFlights {
    
    CryptoFlight[] public flights;
    
    function getDeployedFlights() public view returns (CryptoFlight[] memory) {
        return flights;
    }

    function addFlight(uint minBid, string memory startLocation, string memory destination) public {
        CryptoFlight newFlight = new CryptoFlight(minBid, startLocation, destination, msg.sender);
        flights.push(newFlight);
    }

}

contract CryptoFlight {
    
    struct Bidder {
        uint bid;
        address  addr;
        bool won;
    }

    Bidder[] public travellers;
    
    address owner;
    uint minBid;
    string startLocation;
    string destination;
    bool end;

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(uint _minBid, string memory _startLocation, string memory _destination, address  addr) public payable {
        owner = addr;
        minBid = _minBid * (1 ether);
        startLocation = _startLocation;
        destination =  _destination;
        end = false;
    }

    function getFlight() public view returns(address, uint, string memory, string memory, bool) {
        return (owner, minBid, startLocation, destination, end);
    }
    
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    
    function getAdd() public view returns(address){
        return address(this);
    }
    
    function addTraveller() public payable {
        require(msg.value >= minBid);
        
        Bidder memory newTraveller = Bidder({
           addr: msg.sender,
           bid: msg.value,
           won: false
        });

        travellers.push(newTraveller);
    }

    function finalizeFlight(uint seatsLeft) public payable  {
        uint seatsFilled = 0;

        while (seatsFilled < seatsLeft && seatsFilled < travellers.length) {
            uint highestBid = 0;
            uint highestIndex = 0;
            for (uint i = 0; i < travellers.length; i++) {
                if (highestBid < travellers[i].bid && !travellers[i].won) {
                    highestBid = travellers[i].bid;
                    highestIndex = i;
                }
            }
            travellers[highestIndex].won = true;
            seatsFilled++;
        }

        for ( i = 0; i < travellers.length; i++) {
            if (travellers[i].won) {
                owner.transfer(travellers[i].bid);
            } else {
                travellers[i].addr.transfer(travellers[i].bid);
            }
        }

        end = true;
    }
}
