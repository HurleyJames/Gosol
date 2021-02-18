pragma solidity ^0.8.0;

import "./ConditionalEscrow.sol";

// 这是一个托管合约的拓展，提供了为特定受益人筹款的功能，并允许捐款人（充值地址）取回资金
contract RefundEscrow is ConditionalEscrow {
  // 捐款人的地址
  using address for address payable;

  // 状态的枚举：活跃，退款中，关闭
  enum State {
    Active,
    Refunding,
    Closed
  }

  // 退款关闭
  event RefundClosed();
  // 退款开启
  event RefundsEnabled();

  // 状态
  State private _state;
  // 受益人的地址
  address payable private _beneficiary;

  // 构造函数需要满足地址不为 0，状态为活跃态
  constructor (address payable beneficiary_) {
    // 合约的构造函数指定了唯一的受益人地址，即捐款完成之后可以取走所有款项的地址
    require(beneficiary_ != address(0), "RefundEscrow: beneficiary is the zero address");
    _beneficiary = beneficiary_;
    _state = State.Active;
  }

  // 返回状态
  function state() view virtual returns (State) {
    return _state;
  }

  // 返回受惠者的地址
  function beneficiary() public view virtual returns (address payable) {
    return _beneficiary;
  }

  // 指定退还款项的地址
  function deposit(address refundee) public payable virtual override {
    require(state() == State.Active, "RefundEscrow: can only deposit while active");
    super.deposit(refundee);
  }

  // 允许受益人取回所有的资金，并拒绝后续的捐款（关闭通道）
  function close() public virtual onlyOwner {
    require(state() == State.Active, "RefundEscrow: can only close while active");
    _state = State.Closed;
    emit RefundClosed();
  }

  // 允许款项退还，并拒绝后续的捐款
  function enableRefunds() public onlyOwner virtual {
    require(state() == State.Active, "RefundEscrow: can only enable refunds while active");
    _state = State.Refunding;
    emit RefundsEnabled();
  }

  // 将合约余额转给受益人
  function beneficiaryWithdraw() public virtual {
    require(state() == State.Closed, "RefundEscrow: beneficiary can only withdraw while closed");
    beneficiary().sendValue(address(this).balance);
  }

  // 返回是否正在进行退还捐款（捐款人指定的退款地址是否能取回退款）
  function withdrawAllowed(address) public view override returns (bool) {
    return state() == State.Refunding;
  }
}