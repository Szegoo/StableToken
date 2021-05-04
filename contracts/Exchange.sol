interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function mint(address account, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Exchange {
    IERC20 public token;
    address public owner;
    uint256 fee_numerator = 10;
    uint256 fee_denumerator = 10;

    uint256 rate = 1;

    mapping(address => uint256) balances;

    constructor(address adresa) public {
        owner = msg.sender;
        token = IERC20(adresa);
    }

    function buy(address buyer) public payable {
        require(msg.value > 0);
        uint256 amountInWei = msg.value;
        uint256 amount = calculateAmount(amountInWei);
        token.mint(buyer, amount);
        payable(address(token)).transfer(msg.value);
        balances[buyer] = amountInWei;
    }

    function calculateAmount(uint256 amountInWei) public returns (uint256) {
        uint256 a = 1;
        uint256 b = 100;
        uint256 amount = amountInWei * 1;
        uint256 feeAmount = (amount * a) / b;
        amount -= feeAmount;
        balances[owner] += feeAmount;
        return amount;
    }

    function TestCalculate(uint256 amountInWei) public view returns (uint256) {
        uint256 a = 1;
        uint256 b = 100;
        uint256 amount = amountInWei * 1;
        uint256 feeAmount = (amount * a) / b;
        amount -= feeAmount;
        return amount;
    }

    fallback() external payable {
        buy(msg.sender);
    }

    function withdraw(uint256 amount) public {
        require(msg.sender == owner);
        require(amount <= balances[owner]);
        payable(owner).transfer(amount);
    }
}
