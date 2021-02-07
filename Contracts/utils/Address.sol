pragma solidity ^0.8.0;

// 可用在地址型变量的工具库
library Address {

  // 检查目标地址是否一个合约
  // internal 限制了这个函数只能由 import 这个合约的合约内部来使用
  // view 声明了这个函数不会修改状态
  function isContract(address addr) internal view returns (bool) {
    uint256 size;
    // 通过判断地址所关联的代码大小来判断某个地址上是否有一个合约
    // assembly 指明了后边的程序是内联汇编的
    assembly {
      // 用 extcodesize 函数取得输入参数 addr 所对应的账户地址关联的 EVM 字节码数据的长度
      size := extcodesize(addr)
    }
    return size > 0;
  }

  // 发送值，需要判断该地址下的越是否大于 amount
  function sendValue(address payable recipient, uint256 amount) internal {
    require(address(this).balance >= amount, "Address: insufficient balance");

    (bool success, ) = recipient.call {
      value: amount
    }("");
    require(success, "Address: unable to send value, recipient may have reverted");
  }
}