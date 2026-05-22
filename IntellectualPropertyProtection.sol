// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IntellectualPropertyProtection
 * @dev Implements IP registration, ownership management, and verification[cite: 13, 26].
 */
contract IntellectualPropertyProtection {

    // Task: Allow owners to register IP with specific details.
    struct IntellectualProperty {
        uint256 id;
        string ipType; // e.g., Patent, Copyright, Trademark 
        string description;
        address currentOwner;
        uint256 registrationTimestamp;
        bool isRegistered;
    }

    uint256 private _nextIpId = 1;
    
    // Mapping to store IP records by their unique ID
    mapping(uint256 => IntellectualProperty) public ipRegistry;
    
    // Task: Track and record all ownership transfers securely.
    mapping(uint256 => address[]) public ownershipHistory;

    event IPRegistered(uint256 indexed id, string ipType, address indexed owner);
    event OwnershipTransferred(uint256 indexed id, address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Task: Register New Intellectual Property.
     */
    function registerIP(string memory _ipType, string memory _description) public {
        uint256 newId = _nextIpId++;
        
        ipRegistry[newId] = IntellectualProperty({
            id: newId,
            ipType: _ipType,
            description: _description,
            currentOwner: msg.sender,
            registrationTimestamp: block.timestamp,
            isRegistered: true
        });

        ownershipHistory[newId].push(msg.sender);

        emit IPRegistered(newId, _ipType, msg.sender);
    }

    /**
     * @dev Task: Manage and Transfer Ownership Rights[cite: 43].
     */
    function transferOwnership(uint256 _id, address _newOwner) public {
        require(ipRegistry[_id].isRegistered, "IP record does not exist.");
        require(ipRegistry[_id].currentOwner == msg.sender, "Only the current owner can transfer rights.");
        require(_newOwner != address(0), "Invalid new owner address.");

        address previousOwner = msg.sender;
        ipRegistry[_id].currentOwner = _newOwner;
        ownershipHistory[_id].push(_newOwner);

        emit OwnershipTransferred(_id, previousOwner, _newOwner);
    }

    /**
     * @dev Task: Verify Intellectual Property Authenticity[cite: 50].
     */
    function verifyIP(uint256 _id) public view returns (bool, address, string memory) {
        if (!ipRegistry[_id].isRegistered) {
            return (false, address(0), "Not Found");
        }
        return (true, ipRegistry[_id].currentOwner, ipRegistry[_id].ipType);
    }

    /**
     * @dev Task: View Intellectual Property Details and History[cite: 51, 52].
     */
    function getIPDetails(uint256 _id) public view returns (
        string memory ipType,
        string memory description,
        address currentOwner,
        uint256 registeredAt,
        address[] memory history
    ) {
        require(ipRegistry[_id].isRegistered, "IP record not found.");
        IntellectualProperty storage ip = ipRegistry[_id];
        
        return (
            ip.ipType,
            ip.description,
            ip.currentOwner,
            ip.registrationTimestamp,
            ownershipHistory[_id]
        );
    }
}
