

#   stage 1 
#  initiation
#  distrubte sk and pk

import numpy as np
from Crypto.Random import random
from baby_jubjub import *

global G 
G = Point(Fq(5299619240641551281634865583518297030282874472190772894086521144482721001553),Fq(16950150798460657717958625567821834550301663161624707787222815936182638968203))

# def key_gen(players)
#     for player in players:




class player:
    def __init__(self, sk):
        self._sk  = Fq(random.randint(0,21888242871839275222246405745257275088548364400416034343698204186575808495617))
        self._pk = self._sk*G    


class deck:
    def __init__(self, num_cards):  
        self._cards = []
        for i in range(num_cards):
            c = card(str(i))
            c.create_an_open_card(0) ## TODO , change 0 to pk
            self._cards.append(c)

        self._cards_order = np.array([i for i in range(num_cards)])

    def mask_shuffling(self, permutation_matrix, pk, r):
        mask_zkp =  []
        for card in self._cards:
            _, zkp  =  card.mask_a_card(pk, r)
            mask_zkp.append(zkp)


        self._cards_order = permutation_matrix.dot(self._cards_order)
        # write permutation and generate zkp with circom
        zkp = 321
        return mask_zkp, zkp


    def mask_spliting(self,x, pk, r):
        mask_zkp = []
        for card in self._cards:
            _, zkp = card.mask_a_card(pk,r)
            mask_zkp.append(zkp)

        self._cards_order = np.roll(self._cards_order, len(self._cards_order)- x)
        
    def draw_a_card_from_the_deck(self):
        return


        




class card:
    def __init__(self, value):
        self._value = value
        self._encrypted = 0
    
    def encrypt(self, pk, r):
        # TODO implement this encryption

        
        self._value = self._value +"#"
        self._encrypted +=1
    
    def decrypt(self, sk, r):
        self._value = self._value[:-1]

    def create_an_open_card(self, pk ):
        self.encrypt(pk, 1) # open card definition, r = 1

    def mask_a_card(self, pk, r):
        self.encrypt(pk, r) #
        # TODO 这里需要zkp 
        
        # TODO, generate zkp for this mask op
        zkp = 123
        
        return self._value, zkp

    def create_a_private_card(self, pk, r):

        return
    
    def open_a_card(self):

        return 

    







def demo_main():

    #mapping = {}
    



    n = input("enter the number of player: ")
    print(int(n))



    players = []

    for i in range(int(n)):

        # TODO implement k_Gen
        sk = 1 + i
        pk = sk +2

        #
        p = player(sk)
        players.append(p)
        print("player's sk is ", p._sk)
        print("player's pk is", pk)

        

    num_cards = int(input("input your number of cards used: "))
    my_deck  = deck(int(num_cards))


    print("open cards value ciphertext: ")
    for card in my_deck._cards:
        print(card._value)

    print("open cards ciphertext: ")
    for card in my_deck._cards:
        # TODO make it more compact
        print(card._value)

    
    card_num = input("input a card index for verification: ")
    
    chosen_card = my_deck._cards[int(card_num)]
    print("open card ciphertext for the chosen card:", chosen_card._value)

    chosen_card.decrypt(0,1)
    print("open card value plaint text for the chosen card",chosen_card._value)

    chosen_card.encrypt(0,1)

    
    player_idx  = int(input("input your player idx"))
    card_idx  = int(input("input your card idx"))

    p_chosen = players[player_idx]

    chosen_card = my_deck._cards[card_idx]

    r = 314 #TODO r should be a strong random
    # write to a json file for circom input
    
    
    cipher_card, zkp = chosen_card.mask_a_card(pk, r)

    print("the masked card is: ")
    print(cipher_card)
    print("and the corresponding zkp is :")
    print(zkp)


## shuffle demo
    player_idx  = int(input("input your shuffle player"))

    A = np.identity(num_cards)
    A = np.random.permutation(A)


# TODO changge pk and r 
    my_deck.mask_shuffling(permutation_matrix= A, pk= 0,r = 0)
    

    print(my_deck._cards_order)

# TODO changge pk and r
    my_deck.mask_spliting(4, pk= 0, r = 0)
    print(my_deck._cards_order)
    

    


##




        
   


# demo_main()


if __name__ == '__main__':
    player_amount = int(input("please input the number of players:"))
    players = []
    for i in range(player_amount):
        players.append(player(key_gen()))
    card_amount = int(input("please input the number of players:"))
    my_deck = deck(int(card_amount))
    print("open cards value ciphertext: ")
    for card in my_deck.cards:
        print(card.value)
    print("open cards ciphertext: ")
    for card in my_deck._cards:
        # TODO make it more compact
        print(card._value)
    while True:
        print("Available commands:\n1.encrypt(self, String pk, int r)\n" +
              "2.decrypt(self, String sk, int r)\n" +
              "3.mask_a_card(self, String pk, int r)")
        print("format: number paras")
        cmd_ipt = input("which command do you want to run? q for quit\n")
        cmd = cmd_ipt.split()
        match cmd[0]:
            case "q":
                break
            case "1":
                index = int(input("input a card index for verification: "))
                my_deck.cards[index].encrypt(cmd[1], int(cmd[2]))
            case "2":
                index = int(input("input a card index for verification: "))
                my_deck._cards[int(index)].decrypt(cmd[1], int(cmd[2]))
            case "3":
                pass
            case _:
                print("non-existent command")
        print()
        