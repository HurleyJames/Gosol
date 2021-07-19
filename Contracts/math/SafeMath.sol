pragma solidity ^0.8.0;

library SafeMath {

  // 加（安全）
  function safeAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
      uint256 c = a + b;
      if (c > a) {
        return (false, 0);
      }
      return (true, c);
    }
  }

  // 减（安全）
  function safeSub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
      if (b > a) {
        return (false, 0);
      }
      return (true, a - b);
    }
  }

  // 乘（安全）
  function safeMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
      if (a == 0) {
        return (true, 0);
      }
      uint256 c = a * b;
      if (c / a != b) {
        return (false, 0);
      }
      return (true, c);
    }
  }

  // 除（安全）
  function safeDiv(uint256, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
      if (b == 0) {
        return (false, 0);
      }
      return (true, a / b);
    }
  }

  // 余数（安全）
  function safeMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
      if (b == 0) {
        return (false, 0);
      }
      return (true, a % b);
    }
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    return a + b;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return a - b;
  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    return a * b;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return a / b;
  }

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return a % b;
  }

  // 减：检测是否符合要求，否则显示错误信息
  function sub(uint256 a, uint256 b, string memory errorMsg) internal pure (uint256) {
    unchecked {
      require(b <= a, errorMsg);
      return a - b;
    }
  }

  // 除：检测是否符合要求，否则显示错误信息
  function div(uint256 a, uint256 b, string memory errorMsg) internal pure returns (uint256) {
    unchecked {
      require(b > 0, errorMsg);
    }
    return a / b;
  }

  // 余：检测是否符合要求，否则显示错误信息
  function mod(uint256 a, uint256 b, string memory errorMsg) internal pure returns (uint256) {
    unchecked {
      require(b > 0, errorMsg);
      return a % b;
    }
  }

  function power(uint256 a, uint256 b) internal pure returns (uint256) {
      if (a == 0) return 0;
      if (b == 0) return 0;

      uint256 c = 1;
      for (uint256 i = 0; i < b; i++) {
        c = mul(c, a);
      }
  }
}