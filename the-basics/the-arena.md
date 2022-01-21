# The Arena

The arena is an infinite battle royale fought by \[REDACTED]s. There are an infinite number of battles (assuming Ethereum runs forever) and there is no limit to the number of players in each battle. At the end of the game, the winning \[REDACTED]s obtain a share of the bounty (more on this in a sec) and the \[REDACTED]s' metadata are updated to reflect the win & winnings.

### Duration of entry and battle

* The entry window time will be a fixed 88 blocks (\~ 20 minutes)
* When entry closes, the battle begins right away&#x20;
* Every 88 blocks one \[REDACTED] is chosen to be a winner
* The battle duration will be a fixed 888 blocks (\~ 3.2 hours) for a total of 10 winners each battle
* After every battle, the cooldown time will be a fixed 88 blocks
* Then entry window starts again, and repeat perpetually

### Arena Terrain Randomization

The arena terrain will be randomized using Chainlink VRF. Each terrain will provide a probabilistic advantage to certain \[REDACTED]s to ensure a more equitable playing field (shitty \[REDACTED]s still have a chance). Terrains are as follows:

Add more as you'd like

1. Desert (range+, less clothing+, melee-)
2. Magnetism (leather+, metal-)
3. Radiation (metal+, leather-)
4. Atlantis (marine+, leather-)

Each terrain will appear with an equal probability (?).

### Winner Selection

Equations will be placed under the equations section. The probability of winning for each \[REDACTED] is determined by a combination of the \[REDACTED]'s battle rating (calculated from the attributes and rarities) and the Arena terrain.&#x20;

**Technical Explanation**

Selection will happen by:

1. Looping through all the \[REDACTED]s in the Arena and keep a cumulative count (starting at 0) of total rating (or it's complement if rating is descending) in a mapping for each \[REDACTED]. Then, select a random number between 0 and the total rating (n-th \[REDACTED]'s cumulative count) to pick a winner using Chainlink VRF. We will then set the selected winner's cumulative count to 0.&#x20;
2. At each iteration, we will first check whether the selected winner's cumulative count. If the count is 0, we decrement the counter to run the loop again.

```solidity
// this mapping is accessible from other contract
// mapping (uint256 => SomeStruct) public tokenIdToPlayer;

uint256 storage players[]; // Assume initialized with all [REDACTED]s' tokenIds
mapping (uint256 => cumRating) public tokenToCumRating;
uint256 memory total = 0;

// Done once
for(uint256 i; i < players.length; i++) {
    total += tokenIdToPlayer[players[i]].getRating() // Will access this another way in implementation
    tokenToCumRating[player[i]] = total;
}

// Called every 88 blocks (might be gas inefficient)
// Not really sure how to implement this yet tbh, can mb use tokenByIndex()
function selectWinner() internal returns (uint256) {
    uint256 rand = getRandomNumber() % players.length; // From ChainlinkVRF
    if(tokenToCumRating[
}

```

Alternatively, we could create that mapping as \[REDACTED]s enter the arena to save on computation. Not sure if this is fault-proof regarding true randomization; will have to check.

After the winner is selected, the contract will loop through each winner and change their metadata. Only the Arena contract will be able to change the metadata for obvious purposes.

### Infinite Execution

As you may or may not know, smart contracts can only execute functions when triggered by a transaction from an EOA (externally owned account). Therefore, to start each period (entry, game), an EOA must make a call to the contract.&#x20;

**Methods**

* The first and obvious method is funding an external wallet with funds and making continuous calls using an off-chain script (setInterval() for JS).&#x20;
* Another method is using Chainlink Keepers. Gotta read more on it but it allows for programmable perpetual execution.&#x20;