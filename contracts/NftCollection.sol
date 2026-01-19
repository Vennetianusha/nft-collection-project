// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NftCollection {

    /* ========== STATE VARIABLES ========== */

    string public name;
    string public symbol;

    address public admin;

    uint256 public maxSupply;
    uint256 public totalSupply;

    // Base URI for metadata
    string private _baseTokenURI;

    // tokenId => owner
    mapping(uint256 => address) private _owners;

    // owner => balance
    mapping(address => uint256) private _balances;

    // tokenId => approved address
    mapping(uint256 => address) private _tokenApprovals;

    // owner => operator => approved
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /* ========== EVENTS ========== */

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /* ========== CONSTRUCTOR ========== */

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _maxSupply,
        string memory baseURI_
    ) {
        name = _name;
        symbol = _symbol;
        maxSupply = _maxSupply;
        _baseTokenURI = baseURI_;
        admin = msg.sender;
    }

    /* ========== MODIFIERS ========== */

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed");
        _;
    }

    /* ========== INTERNAL HELPERS ========== */

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        returns (bool)
    {
        address owner = ownerOf(tokenId);
        return (
            spender == owner ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(owner, spender)
        );
    }

    /* ========== ERC721 READ FUNCTIONS ========== */

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Zero address not allowed");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Token does not exist");
        return owner;
    }

    /* ========== METADATA (STEP 8) ========== */

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return string(abi.encodePacked(_baseTokenURI, _toString(tokenId)));
    }

    function setBaseURI(string memory newBaseURI) public onlyAdmin {
        _baseTokenURI = newBaseURI;
    }

    /* ========== MINTING ========== */

    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "Mint to zero address");
        require(!_exists(tokenId), "Token already minted");
        require(totalSupply < maxSupply, "Max supply reached");

        _owners[tokenId] = to;
        _balances[to] += 1;
        totalSupply += 1;

        emit Transfer(address(0), to, tokenId);
    }

    function safeMint(address to, uint256 tokenId) public onlyAdmin {
        _mint(to, tokenId);
    }

    /* ========== TRANSFERS ========== */

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {
        require(to != address(0), "Transfer to zero address");
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not authorized");

        address owner = ownerOf(tokenId);
        require(owner == from, "From is not owner");

        _tokenApprovals[tokenId] = address(0);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {
        transferFrom(from, to, tokenId);
    }

    /* ========== APPROVALS ========== */

    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(to != owner, "Approval to current owner");
        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "Not owner nor approved"
        );

        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        require(_exists(tokenId), "Token does not exist");
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public {
        require(operator != msg.sender, "Approve to caller");
        _operatorApprovals[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator)
        public
        view
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    /* ========== UTIL (STRING CONVERSION) ========== */

    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
