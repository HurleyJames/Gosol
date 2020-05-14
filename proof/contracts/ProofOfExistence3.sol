pragma solidity >= 0.5.0 < 0.7.0;

contract ProofOfExistence3 {
  constructor() public {
  }

  mapping (bytes32 => bool) private proofs;

  function storeProof(bytes32 proof) public {
    proofs[proof] = true;
  }

  function notarize(string memory document) public {
    bytes32 proof = proofFor(document);
    storeProof(proof);
  }

  function proofFor(string memory document) public view returns (bytes32) {
    return sha256(abi.encode(document));
  }

  function checkDocument(string memory document) public view returns (bool) {
    bytes32 proof = proofFor(document);
    return hasProof(proof);
  }

  function hasProof(bytes32 proof) public view returns (bool) {
    return proofs[proof];
  }
}
