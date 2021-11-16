// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/VRFRequestIDBase.sol";

import "@solidstate/contracts/token/ERC721/metadata/ERC721Metadata.sol";

import "./VRFStorage.sol";
import "./BaseCharacterStorage.sol";
import "@solidstate/contracts/token/ERC721/base/ERC721BaseStorage.sol";

import "@solidstate/contracts/token/ERC721/ERC721.sol";

import "./interfaces/IERC20.sol";

/** ****************************************************************************
 * @notice Interface for contracts using VRF randomness
 * *****************************************************************************
 * @dev PURPOSE
 *
 * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
 * @dev to Vera the verifier in such a way that Vera can be sure he's not
 * @dev making his output up to suit himself. Reggie provides Vera a public key
 * @dev to which he knows the secret key. Each time Vera provides a seed to
 * @dev Reggie, he gives back a value which is computed completely
 * @dev deterministically from the seed and the secret key.
 *
 * @dev Reggie provides a proof by which Vera can verify that the output was
 * @dev correctly computed once Reggie tells it to her, but without that proof,
 * @dev the output is indistinguishable to her from a uniform random sample
 * @dev from the output space.
 *
 * @dev The purpose of this contract is to make it easy for unrelated contracts
 * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
 * @dev simple access to a verifiable source of randomness.
 * *****************************************************************************
 * @dev USAGE
 *
 * @dev Calling contracts must inherit from VRFConsumerBase, and can
 * @dev initialize VRFConsumerBase's attributes in their constructor as
 * @dev shown:
 *
 * @dev   contract VRFConsumer {
 * @dev     constuctor(<other arguments>, address _vrfCoordinator, address _link)
 * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
 * @dev         <initialization with other arguments goes here>
 * @dev       }
 * @dev   }
 *
 * @dev The oracle will have given you an ID for the VRF keypair they have
 * @dev committed to (let's call it keyHash), and have told you the minimum LINK
 * @dev price for VRF service. Make sure your contract has sufficient LINK, and
 * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
 * @dev want to generate randomness from.
 *
 * @dev Once the VRFCoordinator has received and validated the oracle's response
 * @dev to your request, it will call your contract's fulfillRandomness method.
 *
 * @dev The randomness argument to fulfillRandomness is the actual random value
 * @dev generated from your seed.
 *
 * @dev The requestId argument is generated from the keyHash and the seed by
 * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
 * @dev requests open, you can use the requestId to track which seed is
 * @dev associated with which randomness. See VRFRequestIDBase.sol for more
 * @dev details. (See "SECURITY CONSIDERATIONS" for principles to keep in mind,
 * @dev if your contract could have multiple requests in flight simultaneously.)
 *
 * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
 * @dev differ. (Which is critical to making unpredictable randomness! See the
 * @dev next section.)
 *
 * *****************************************************************************
 * @dev SECURITY CONSIDERATIONS
 *
 * @dev A method with the ability to call your fulfillRandomness method directly
 * @dev could spoof a VRF response with any random value, so it's critical that
 * @dev it cannot be directly called by anything other than this base contract
 * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
 *
 * @dev For your users to trust that your contract's random behavior is free
 * @dev from malicious interference, it's best if you can write it so that all
 * @dev behaviors implied by a VRF response are executed *during* your
 * @dev fulfillRandomness method. If your contract must store the response (or
 * @dev anything derived from it) and use it later, you must ensure that any
 * @dev user-significant behavior which depends on that stored value cannot be
 * @dev manipulated by a subsequent VRF request.
 *
 * @dev Similarly, both miners and the VRF oracle itself have some influence
 * @dev over the order in which VRF responses appear on the blockchain, so if
 * @dev your contract could have multiple VRF requests in flight simultaneously,
 * @dev you must ensure that the order in which the VRF responses arrive cannot
 * @dev be used to manipulate your contract's user-significant behavior.
 *
 * @dev Since the ultimate input to the VRF is mixed with the block hash of the
 * @dev block in which the request is made, user-provided seeds have no impact
 * @dev on its economic security properties. They are only included for API
 * @dev compatability with previous versions of this contract.
 *
 * @dev Since the block hash of the block which contains the requestRandomness
 * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
 * @dev miner could, in principle, fork the blockchain to evict the block
 * @dev containing the request, forcing the request to be included in a
 * @dev different block with a different hash, and therefore a different input
 * @dev to the VRF. However, such an attack would incur a substantial economic
 * @dev cost. This cost scales with the number of blocks the VRF oracle waits
 * @dev until it calls responds to a request.
 */

interface DLC {
  function balanceOf(address) external returns (uint256);

  /// TODO add burn function to DLC
  function transfer(address, uint256) external returns (bool);

  function transferFrom(
    address,
    address,
    uint256
  ) external returns (bool);

  function approve(address, uint256) external returns (bool);
}

contract VRFFacet is ERC721 {
  DLC dlc = DLC(0x69bdE563680f580A2da5b5d4E202ecA4FDF35664);
  IERC20 weth = IERC20(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619);

  /// @dev the name, symbol, and baseURI is set on deployment.
  constructor(
    string memory name,
    string memory symbol,
    string memory baseURI
  ) {
    ERC721MetadataStorage.Layout storage l = ERC721MetadataStorage.layout();
    l.name = name;
    l.symbol = symbol;
    l.baseURI = baseURI;
  }

  /// @dev 1. player mints a base character NFT
  /// TODO add whitelist
  function mintGenesis(uint256 _tokenId, uint256 _donation) external {
    // require(  )
    require(dlc.balanceOf(msg.sender) >= 10e18, "mintGenesisCharacter: Love balance is not enough");

    BaseCharacterStorage.Layout storage bcs = BaseCharacterStorage.layout();

    /// @dev player can only mint 1
    // require(erc.holderTokens[msg.sender].length() == 0, "mintGenesis: msg.sender balance > 0");
    require(bcs.baseCharId[msg.sender] == 0, "mintGenesis: msg.sender balance > 0");

    dlc.transferFrom(msg.sender, 0x000000000000000000000000000000000000dEaD, 10e18);
    // dlc.transfer(0x000000000000000000000000000000000000dEaD, 10e18);

    // requestRandomness(_tokenId);
  }

  /// @dev 2. chainlink gods are requested to bestow us with a random number
  function requestRandomness(uint256 _tokenId) internal {
    VRFStorage.Layout storage s = VRFStorage.layout();

    uint256 fee = s.fee;
    require(s.link.balanceOf(address(this)) >= fee, "VRFFacet: Not enough LINK");
    bytes32 previousKeyHash = s.keyHash;
    require(s.link.transferAndCall(s.vrfCoordinator, fee, abi.encode(previousKeyHash, 0)), "VRFFacet: LINK transfer failed");
    uint256 vrfSeed = uint256(keccak256(abi.encode(previousKeyHash, 0, address(this), s.vrfNonces[previousKeyHash])));
    s.vrfNonces[previousKeyHash]++;
    bytes32 requestId = keccak256(abi.encodePacked(previousKeyHash, vrfSeed));
    s.vrfRequestIdToTokenId[requestId] = _tokenId;
  }

  /// @dev 3. chainlink gods come back to us with a random number
  function rawFulfillRandomness(bytes32 _requestId, uint256 _randomNumber) external {
    VRFStorage.Layout storage s = VRFStorage.layout();

    require(msg.sender == s.vrfCoordinator, "Only VRFCoordinator can fulfill");

    fulfillRandomness(_requestId, _randomNumber);
  }

  /// @dev 4. the attributes we are randomizing for the player's base character NFT
  function fulfillRandomness(bytes32 _requestId, uint256 _randomNumber) internal {
    VRFStorage.Layout storage s = VRFStorage.layout();
    BaseCharacterStorage.Layout storage bcs = BaseCharacterStorage.layout();

    uint256 tokenId = s.vrfRequestIdToTokenId[_requestId];
    uint256 randomNumber = _randomNumber;
    bcs.hp[tokenId] = randomNumber % 255;
    bcs.mana[tokenId] = randomNumber % 255;
    bcs.stamina[tokenId] = randomNumber % 255;
  }

  /// TODO: access control
  function changeVrf(
    uint256 _newFee,
    bytes32 _keyHash,
    address _vrfCoordinator,
    address _link
  ) external {
    VRFStorage.Layout storage s = VRFStorage.layout();
    if (_newFee != 0) {
      s.fee = uint96(_newFee);
    }
    if (_keyHash != 0) {
      s.keyHash = _keyHash;
    }
    if (_vrfCoordinator != address(0)) {
      s.vrfCoordinator = _vrfCoordinator;
    }
    if (_link != address(0)) {
      s.link = LinkTokenInterface(_link);
    }
  }
}
