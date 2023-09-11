# ZK Card Game Implementation Based on Mental Poker

## Project Overview

This project presents a Zero-Knowledge (ZK) implementation of card games rooted in the principles of Mental Poker.

## Features

### Atomic Card Operations:

#### For a Single Card:
- **Creation**: Produce a single card.
- **Mask**: Encrypt a card to hide its identity.
- **Unmask**: Decrypt a masked card to reveal its identity.
- **Remask**: Apply multiple layers of encryption to a card.

#### For a Deck of Cards:
- **Shuffle Deck**: Randomize the order of cards in a deck.
- **Split Deck**: Divide a deck into two or more parts.
- **Draw**: Take a card from the deck to be played.
- **Reveal to Arbitrary Number of Players**: Allow any number of users to see a specific card.

### Zero-Knowledge Proofs:

All operations are enhanced with zero-knowledge, ensuring transparency and fairness. Every game function generates a corresponding Zero-Knowledge Proof (zkp) to guarantee the process's fairness and transparency.

## License

This project is licensed under the MIT License.