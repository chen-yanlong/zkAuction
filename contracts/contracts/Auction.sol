//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.0;

import "./PoseidonT3.sol";

// Please note that you should adjust the length of the inputs
interface IVerifier {
    function verifyProof(
        
    ) external view returns (bool r);
}

contract Auction {
    struct Proof {
        
    }

    event Start(uint256 startTime, uint256 endTime);
    event Bid(address indexed bidder);
    event End();
    event Tally(address winner);

    address _owner;

    // auction param
    bool public started;
    bool public ended;
    address public winner;
    uint256 public duration;
    uint256 public endTime;

    //merkle tree
    mapping(address => uint256) public bidderIdx; 
    mapping(uint256 => bytes32) public leaves; 
    uint256 public leafCount = 0;
    bytes32 public root;

    //verifier
    address public immutable verifier;
    

    constructor(address verifier_, uint256 duration_) {
        verifier = verifier_;
        _owner = msg.sender;
        duration = duration_;
    }

    function start() external {
        require(!started, "Auction has already started.");
        require(msg.sender == _owner, "Only creator can start.");

        started = true;
        endTime = block.timestamp + duration;

        emit Start(block.timestamp, endTime);
    }

    function bid(bytes32 _encryptedBid) public {
        require(block.timestamp < endTime, "Bidding time has ended.");
        require(bidderIdx[msg.sender] == 0, "User already submitted bid");
        bidderIdx[msg.sender] = leafCount;
        leaves[leafCount] = _encryptedBid;
        leafCount++;
        emit Bid(msg.sender);
    }


    function endAuction(bytes32 _winningProof, address _winner) public {
        require(block.timestamp >= endTime, "Bidding time not yet ended.");
        require(!ended, "Auction already ended.");

        bytes32 currentHash = leaves[0];
        for (uint256 i = 1; i < leafCount; i++) {
            currentHash = keccak256(abi.encodePacked(currentHash, leaves[i]));
        }
        
        root = currentHash;
        ended = true;
        emit End();
    }


    function tally(uint256[3] memory publicSignals, Proof memory proof) public {
        bool result = IVerifier(verifier).verifyProof(
            proof.a,
            proof.b,
            proof.c,
            publicSignals
        );
        
        require(verify(_winningProof), "Invalid proof.");

        winner = _winner;
    }


    /**
     * Please adjust the IVerifier.sol and the array length of publicSignals
     */
    function verify(uint256[3] memory publicSignals, Proof memory proof)
        public
        view
        returns (bool)
    {
        bool result = IVerifier(verifier).verifyProof(
            proof.a,
            proof.b,
            proof.c,
            publicSignals
        );
        return result;
    }

}
