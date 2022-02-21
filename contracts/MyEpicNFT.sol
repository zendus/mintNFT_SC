// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

     // We split the SVG at the part where it asks for the background color.
    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ['vigorous', 'psychedelic', 'wealthy', 'nice', 'craven', 'unknown', 'foamy', 'many', 'electric', 'fancy', 'literate', 'obese', 'curvy', 'confident', 'wrong', 'visible', 'illegal', 'squalid', 'maddening', 'axiomatic', 'gaudy', 'enchanting', 'gleaming', 'vagabond', 'nutritious', 'hellish', 'old-fashioned', 'majestic', 'warlike', 'evasive'];
    string[] secondWords = ['charity', 'trainer', 'attitude', 'advice', 'judgment', 'surgery', 'instruct', 'steak', 'audience', 'distribution', 'extent', 'fridge', 'physics', 'difficulty', 'homework', 'university', 'macho', 'resolution', 'reputation', 'potato', 'army', 'noun', 'interaction', 'history', 'percentage', 'employee', 'news', 'personality', 'woman', 'society'];
    string[] thirdWords = ['Sekizuno', 'Wakanishi', 'Kagasawa', 'Mitsu', 'Kaguyomi', 'Higazuno', 'Horiro', 'Riroma', 'Manasugi', 'Azuni', 'Tanitaki', 'Shinogita', 'Nonagi', 'Marusuchi', 'Furube', 'Katsurada', 'Wakimori', 'Fuchiruta', 'Akinari', 'Nida', 'Okahoshi', 'Hanaba', 'Onahaya', 'Motosone', 'Homine', 'Hoshimeko', 'Hiranen', 'Marineko', 'Setsumi', 'Hitsune'];

    // Get fancy with it! Declare a bunch of colors.
    string[] colors = ["red", "#08C2A8", "black", "yellow", "blue", "green"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721 ("ThreeRandomWordNFT", "ZENP") {
        console.log("Be still my foolish heart");
    }

    function pickRandomFirstWord(uint tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
    rand = rand % colors.length;
    return colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        // Add the random color in.
        string memory randomColor = pickRandomColor(newItemId);
        string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );


        console.log("\n--------------------");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        _tokenIds.increment();
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}