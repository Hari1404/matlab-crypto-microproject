# MATLAB-Based Public-Key Cryptography and Secure Communication

Micro-project for Alliance University, Alliance College of Engineering and Design.

## About

This project simulates secure communication between users in MATLAB. It uses Sets, Relations and Functions to model users, messages and keys, Graph Theory to model and analyse the communication network, and Group Theory with Modular Arithmetic to implement the Diffie–Hellman key exchange. Alice and Bob each choose a private key, exchange public values over an insecure channel, and arrive at the same shared secret, which is then used to encrypt and decrypt messages.

## How the mathematics maps to the code

| Topic | What it models | Folder |
| --- | --- | --- |
| Sets, Relations and Functions | Users, plaintext, ciphertext and keys; key ownership; encryption and decryption as functions | `src/sets_relations_functions` |
| Graph Theory | Communication network with users as vertices and channels as edges; adjacency matrix and list, connectivity, paths, cycles, bridge channels, cut users, pictures | `src/graph_network` |
| Group Theory and Modular Arithmetic | Modular exponentiation, cyclic groups, generators, identity and inverse elements | `src/group_theory` |
| Diffie–Hellman key exchange | A shared secret key over an insecure channel | `src/diffie_hellman` |
| Encryption and decryption | Messages protected with the shared key | `src/encryption` |
| Integration | All modules working together as one system | `src/integration` |

## Project status

The work is built in big checkpoints called points. The full list and the current state are in `PROGRESS.md`.

- [x] Point 0: Start (folders, rules, README, setup script)
- [x] Point 1: Sets, Relations and Functions model
- [x] Point 2: Graph network (the graph, its adjacency matrix and list, the analysis of connectivity, paths, cycles and removals, and the pictures)
- [x] Point 3: Group Theory and Modular Arithmetic core (fast modular exponentiation, gcd and inverse, primes, the group rules for Z_97*, orders, generators and cyclic subgroups)
- [x] Point 4: Diffie–Hellman and encryption (the key exchange for all users, encryption and decryption with the shared key, and an eavesdropper who attacks the key exchange and the cipher)
- [x] Point 5: The whole system and the demo (the keys on the channels, the messages along the paths, `demo_point5`, and `main_demo` with typed prompts and a picture of the route)
- [ ] Point 6: Tests, figures, report and slides

## How to run

1. Open MATLAB and set the current folder to this project folder.
2. Run `setup_project` to add the code folders to the MATLAB path.
3. Run `run_all_tests` to check everything, `demo_point1` to see the sets, relations and functions of Point 1, `demo_point2` to see the communication network as a graph, its analysis and 5 pictures (they open in figure windows and are saved as PNG files in the `outputs` folder), and `demo_point3` to see the modular arithmetic tools and the group Z_97* (fast modular powers, gcd and inverse, the group rules, orders, generators and cyclic subgroups), and `demo_point4` to see the Diffie-Hellman key exchange (Alice and Bob, then all users), the encryption with the shared key and an eavesdropper, `demo_point5` to see the secure network (a key on every channel and messages along the paths), and `main_demo` for the demo with typed prompts (you choose the users and type the messages, they travel along the route, you can break and repair channels, and option 7 draws the picture of the network with the route; the picture opens in a figure window and is saved as `outputs/point5_route.png`).

## Note

This is an educational project. Small numbers are used so every step can be checked by hand. It is not meant to protect real data.

## Team

Santanu Barua, M Hariharan, Kushi Pathak, P Abdul Wasim, Someshwar A, Adithya Sampath Kumar
