pramga solidity ^0.8.0;

// ERC20 的接口
interface IERC20 {

  // 获取 token 的总发行量
  function totalSupply() external view returns (uint256);

  // 获取某个地址持有的 token 数量
  function balanceOf(address account) external view returns (uint256);

  // token 之间进行转账
  function transfer(address recipient, uint256 amount) external returns (bool);

  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}