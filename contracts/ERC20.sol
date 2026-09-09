// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @notice Minimal ERC20 base. Extend it and mint your supply in the constructor.
abstract contract ERC20 {
    string public name;
    string public symbol;
    uint8 public immutable decimals;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function approve(
        address spender,
        uint256 amount
    ) public virtual returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        // Without this the shortfall shows up as a bare arithmetic panic, which is
        // very hard to read. The usual cause is a number typed with the wrong number
        // of zeros, since this token has 18 decimals.
        require(
            balanceOf[msg.sender] >= amount,
            "ERC20: balance too small, check the decimals on the amount"
        );
        balanceOf[msg.sender] -= amount;
        unchecked {
            balanceOf[to] += amount;
        }
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        uint256 allowed = allowance[from][msg.sender];
        require(allowed >= amount, "ERC20: not approved for that amount");
        require(
            balanceOf[from] >= amount,
            "ERC20: balance too small, send tokens to that contract first"
        );
        if (allowed != type(uint256).max)
            allowance[from][msg.sender] = allowed - amount;
        balanceOf[from] -= amount;
        unchecked {
            balanceOf[to] += amount;
        }
        emit Transfer(from, to, amount);
        return true;
    }

    function _mint(address to, uint256 amount) internal virtual {
        // Increases totalSupply by input amount
        totalSupply += amount;
        unchecked {
            balanceOf[to] += amount; // Credits to's balance by amount — that address's balanceOf goes up.
        }
        emit Transfer(address(0), to, amount); // Signals to the world that new tokens have been created and sent to `to`.
    }
}
