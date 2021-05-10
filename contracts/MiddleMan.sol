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

contract MiddleMan {
    struct Transaction {
        uint256 amountInWei;
        uint256 amountInToken;
    }
    IERC20 public token;
    mapping(address => mapping(address => Transaction)) public pending;

    constructor(address tokenAddress) public {
        token = IERC20(tokenAddress);
    }

    function payInEth(address receiver, uint256 amount) public payable {
        require(amount >= msg.value);
        pending[receiver][msg.sender] = Transaction(msg.value, amount);
    }

    function payInToken(address receiver) public payable {
        Transaction storage transaction = pending[msg.sender][receiver];
        require(transaction.amountInWei != 0);
        require(token.balanceOf(msg.sender) >= transaction.amountInToken);
        token.transfer(receiver, transaction.amountInToken);
        payable(msg.sender).transfer(transaction.amountInWei);
        delete pending[msg.sender][receiver];
    }
}
