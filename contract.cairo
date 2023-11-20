# Cairo smart contract for a double or nothing game

# Declare the contract
contract DoubleOrNothing:

    # State variable to store the contract balance
    var balance : felt

    # Initialize the contract with an initial balance
    public func init(initialAmount: felt):
        self.balance = initialAmount

    # Function to participate in the game by sending funds
    public func participate(amount: felt):
        # Ensure the sent amount is greater than 0
        require amount > 0:
            fail msg="Amount must be greater than 0"
        
        # Double the amount sent
        let doubledAmount = amount * 2
        
        # Verify that the contract has enough balance to cover the potential win
        require self.balance >= doubledAmount:
            fail msg="Insufficient balance in the contract"

        # Randomly determine the outcome (win or lose)
        let randomValue = get_random()
        let isWin = randomValue % 2 == 0

        # If the participant wins, send them double the amount sent
        if isWin:
            self.balance -= doubledAmount  # Decrease the contract balance
            msg_sender!.deposit(amount: doubledAmount) # Send the doubled amount to the participant

    # Function to deposit funds into the contract
    public func deposit(amount: felt):
        require amount > 0:
            fail msg="Amount must be greater than 0"
        self.balance += amount  # Increase the contract balance with the deposited amount

    # Function to check the contract balance
    public view func getBalance() -> felt:
        return self.balance

    # Internal function to generate pseudo-random numbers
    private func get_random() -> felt:
        return (block_number + block_timestamp) % 1000
