//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.0;

import "@zk-kit/incremental-merkle-tree.sol/IncrementalBinaryTree.sol";

// Please note that you should adjust the length of the inputs
interface IVerifier {
    function verifyProof(
        uint256[2] memory a,
        uint256[2] memory b,
        uint256[2] memory c,
        uint256[3] memory publicSignals
    ) external view returns (bool r);
}

contract Auction {
    using IncrementalBinaryTree for IncrementalTreeData;

    struct Proof {
        
    }

    event TreeCreated(bytes32 id, uint256 depth);
    event LeafInserted(uint256 leaf, uint256 root);
    event Start(uint256 startTime, uint256 endTime);
    event Bid(address bidder, bytes32 encryptedData);
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
    mapping(uint256 => address) public bidder; 
    mapping(uint256 => bytes32) public leaves; 
    uint256 public leafCount = 0;
    bytes32 public root;
    IncrementalTreeData public tree;

    //verifier
    address public immutable verifier;
    

    constructor(address verifier_, uint256 duration_, uint256 treeDepth_) {
        tree.init(treeDepth_, 0);
        
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
        bidder[leafCount] = msg.sender;
        leaves[leafCount] = _encryptedBid;
        leafCount++;
        tree.insert(_encryptedBid); 
        emit Bid(msg.sender, _encryptedBid);
        emit LeafInserted(_encryptedBid, tree.root);
    }


    function endAuction(bytes32 _winningProof, address _winner) public {
        require(block.timestamp >= endTime, "Bidding time not yet ended.");
        require(!ended, "Auction already ended.");
        
        root = tree.root;
        ended = true;
        emit End();
    }


    function tally(uint256[3] memory publicSignals, Proof memory proof, uint256 winnerIdx) public {
        require(msg.sender == _owner, "Only owner can tally.");
        bool result = IVerifier(verifier).verifyProof(
            proof.a,
            proof.b,
            proof.c,
            publicSignals
        );
        
        require(result == 1, "Invalid proof.");

        winner = bidder[winnerIdx];
    }


}
