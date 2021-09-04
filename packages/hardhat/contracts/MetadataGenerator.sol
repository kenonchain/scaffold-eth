// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.7.0;

import "hardhat/console.sol";
import 'base64-sol/base64.sol';
import "@openzeppelin/contracts/utils/Strings.sol";
import './HexStrings.sol';
import './ToColor.sol';

/// @title NFTSVG
/// @notice Provides a function for generating an SVG associated with a Uniswap NFT
library MetadataGenerator {

  using Strings for uint256;
  using HexStrings for uint160;
  using ToColor for bytes3;

  function toBits(uint256 n) internal pure returns (uint256[] memory) {
    uint256[] memory output = new uint256[](10);

    for (uint8 i = 1; i <= 10; i++) {
      output[10 - i] = (n % 2 == 1) ? 1 : 0;
      n /= 2;
    }

    return output;
}

  function generateSVGofTokenById(address owner, uint256 tokenId, bytes3 color, uint256 chubbiness) internal pure returns (string memory) {

    uint256[] memory bits = toBits(tokenId);

    string memory svg = string(abi.encodePacked(
      '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
          '<rect width="100%" height="100%" fill="black" />',
          '<text x="10" y="20" class="base">',bits[0].toString(),'</text>',
          '<text x="10" y="40" class="base">',bits[1].toString(),'</text>',
          '<text x="10" y="60" class="base">',bits[2].toString(),'</text>',
          '<text x="10" y="80" class="base">',bits[3].toString(),'</text>',
          '<text x="10" y="100" class="base">',bits[4].toString(),'</text>',
          '<text x="10" y="120" class="base">',bits[5].toString(),'</text>',
          '<text x="10" y="140" class="base">',bits[6].toString(),'</text>',
          '<text x="10" y="160" class="base">',bits[7].toString(),'</text>',
          '<text x="10" y="180" class="base">',bits[8].toString(),'</text>',
          '<text x="10" y="200" class="base">',bits[9].toString(),'</text>',
        '</svg>'
    ));

    return svg;
  }

  function tokenURI(address owner, uint256 tokenId, bytes3 color, uint256 chubbiness) internal pure returns (string memory) {

      string memory name = string(abi.encodePacked('The B #',tokenId.toString()));
      string memory description = string(abi.encodePacked('This B is #',tokenId.toString(),'!!!'));
      string memory image = Base64.encode(bytes(generateSVGofTokenById(owner, tokenId, color, chubbiness)));

      return
          string(
              abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                          abi.encodePacked(
                              '{"name":"',
                              name,
                              '", "description":"',
                              description,
                              '", "external_url":"https://burnyboys.com/token/',
                              tokenId.toString(),
                              '", "attributes": [], "owner":"',
                              (uint160(owner)).toHexString(20),
                              '", "image": "',
                              'data:image/svg+xml;base64,',
                              image,
                              '"}'
                          )
                        )
                    )
              )
          );
  }

  function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
      if (_i == 0) {
          return "0";
      }
      uint j = _i;
      uint len;
      while (j != 0) {
          len++;
          j /= 10;
      }
      bytes memory bstr = new bytes(len);
      uint k = len;
      while (_i != 0) {
          k = k-1;
          uint8 temp = (48 + uint8(_i - _i / 10 * 10));
          bytes1 b1 = bytes1(temp);
          bstr[k] = b1;
          _i /= 10;
      }
      return string(bstr);
  }

}
