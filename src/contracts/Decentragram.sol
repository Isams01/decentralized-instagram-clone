pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";

  uint public imageCount = 0;
  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  mapping(uint => Image) public images;

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  // Create images
  function uploadImage(string memory _imgHash, string memory _description) public {
    require(bytes(_imgHash).length > 0, 'Image hash is required');
    require(bytes(_description).length > 0, 'Image description is required');
    require(msg.sender != address(0x0), 'Invalid address');

    imageCount ++;
    images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender);
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  // Tip images
  // payable means that this function can receive ether
  function tipImageOwner(uint _id) public payable {
    require(_id > 0 && _id <= imageCount, 'Invalid image id');
    Image memory _image = images[_id];
    address payable _author = _image.author;
    // transfer allows solidity to send ether to an address
    // msg.value is the amount of ether sent to this function
    address(_author).transfer(msg.value);
    _image.tipAmount = _image.tipAmount + msg.value;
    images[_id] = _image;
  }
}