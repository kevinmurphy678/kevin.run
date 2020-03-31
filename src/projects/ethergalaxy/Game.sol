pragma solidity ^0.4.18;

contract Ethernebula
{
   
    /*
    -Game sequence-
    
    Tick every X blocks
    Each tick, loop through players who are exploring
    TODO: think of this
    */
    
    struct Position{
        //A ships position in space
        uint32 x;
        uint32 y;
    }
    
    struct PlayerData{
        Position currentPosition;       //Ships current position in space
        Position destinationPosition;   //Destination position in space
        uint timeToCompletion;          //The time they will be at their destinatio
        bool exploring;                 
        uint exploringBlock;      //Block number someone started exploring
        uint exploringBlocksLeft; //How many blocks a player has left to explore
        bool hasPrize;
        string name;
    }

    mapping(address => PlayerData) playerData;
    address[] public accounts;

    address[] public exploringAccounts; //Accounts currently exploring for the next tick..
    
    event Registered(string name);
    
    function explore() public //Set the account to explore next game tick..
    {
        var account = playerData[msg.sender];
        account.exploring = true;
        account.exploringBlock = block.number-1;
        exploringAccounts.push(msg.sender);
    }
    
    
    function tick() public//Game tick
    {
        for(uint i = 0; i < exploringAccounts.length; i++)
        {
            uint blockDistance = block.number - 1 - playerData[exploringAccounts[i]].exploringBlock;
            if(blockDistance >= 1)
            {
                uint rand = getRand(playerData[msg.sender].exploringBlock + 1, exploringAccounts[i], 100);
                if(rand > 10)
                {
                    playerData[exploringAccounts[i]].hasPrize = true;
                }
            }
        }
    }

    function isPlayerRegistered(address addr) view public returns (bool)
    {
         var account = playerData[addr];
         bytes memory nameBytes = bytes(account.name);
         return(nameBytes.length != 0);
    }
    
    
    function sqrt(uint x) public pure returns (uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

    //Calculate move speed of a player. 1 for now
    function calculateMoveSpeed() internal pure returns (uint){
        return 3; 
    }

    //Gets the percentage a player is to their destination. 1 = complete
    function getPlayerReachedDestination(address addr) public view returns (bytes1) {
         var account = playerData[addr];
         if(block.timestamp > account.timeToCompletion) return 1; else return 0;
    }

    event Move(uint32 x, uint32 y, uint timeToCompletion, address addr);
    function move(uint32 x, uint32 y) //Moves a player. Input is new coordinates
    {
        if(isPlayerRegistered(msg.sender))
        {
           if(getPlayerReachedDestination(msg.sender)==1)
           {
                var account = playerData[msg.sender];
                account.currentPosition = account.destinationPosition;
                account.destinationPosition.x = x;
                account.destinationPosition.y = y;
                
                var distance =  sqrt((account.destinationPosition.x - account.currentPosition.x)**2 + (account.destinationPosition.y - account.currentPosition.y)**2);
                var timeToCompletion = distance / calculateMoveSpeed();
                account.timeToCompletion = timeToCompletion + block.timestamp;
                Move(x,y, account.timeToCompletion, msg.sender);
           }  
        }
    }
    
    function register(string name) public
    {
        var account = playerData[msg.sender];

        if(!isPlayerRegistered(msg.sender))
        {
            bytes memory nameBytes = bytes(name);
            if(nameBytes.length==0)
                account.name = "Anon";
            else
                account.name = name;
                
            account.currentPosition.x = getRand(block.number - 1, msg.sender, 4000);
            account.currentPosition.y = getRand(block.number - 1, msg.sender, 4000);
            account.destinationPosition = account.currentPosition;
            
            
            accounts.push(msg.sender) - 1;
            Registered(name);
        }
        else
        {
            account.name = name;
        }
    
    }
    
    function getRand(uint blockNumber,address addr, uint32 max) constant internal returns(uint32) {
        return(uint32(sha3(block.blockhash(blockNumber)^bytes32(addr))) % max);
    }
    
    //A list of all addresses who are registered..
    function getAccounts() view public returns (address[]) {
        return accounts;
    }
    

    function getAccount(address addr) view public returns(uint32, uint32, string, uint32, uint32, uint)
    {
        return(playerData[addr].currentPosition.x, playerData[addr].currentPosition.y, playerData[addr].name, playerData[addr].destinationPosition.x, playerData[addr].destinationPosition.y, playerData[addr].timeToCompletion);
    }
    
    function getNumberOfAccounts() public view returns(uint){
        return accounts.length;
    }
    
    
}
