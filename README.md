# MATLAB-Based Public-Key Cryptography and Secure Communication

Micro-project for Alliance University, Alliance College of Engineering and Design.

## About

This project simulates secure communication between users in MATLAB. It uses Sets, Relations and Functions to model users, messages and keys, Graph Theory to model and analyse the communication network, and Group Theory with Modular Arithmetic to implement the Diffie–Hellman key exchange. Alice and Bob each choose a private key, exchange public values over an insecure channel, and arrive at the same shared secret, which is then used to encrypt and decrypt messages. RSA public-key encryption is added as a second example of the same mathematics: the public key encrypts, the private key decrypts, and it works because of the group Z_n*.

## How the mathematics maps to the code

| Topic | What it models | Folder |
| --- | --- | --- |
| Sets, Relations and Functions | Users, plaintext, ciphertext and keys; key ownership; encryption and decryption as functions | `src/sets_relations_functions` |
| Graph Theory | Communication network with users as vertices and channels as edges; adjacency matrix and list, connectivity, paths, cycles, bridge channels, cut users, pictures; the directed version (arcs, in- and out-degree, strongly connected groups, arrows) | `src/graph_network` |
| Group Theory and Modular Arithmetic | Modular exponentiation, cyclic groups, generators, identity and inverse elements | `src/group_theory` |
| Diffie–Hellman key exchange | A shared secret key over an insecure channel | `src/diffie_hellman` |
| Encryption and decryption | Messages protected with the shared key | `src/encryption` |
| Integration | All modules working together as one system | `src/integration` |
| RSA public-key encryption | RSA key pairs from two primes, encryption and decryption of numbers and text, why it works in the group Z_n*; the RSA keys of all users and their messages, key transport (an RSA-encrypted key of the cipher) an eavesdropper who factors n, and the verification of RSA a second way | `src/rsa` |

## Project status

The work is built in big checkpoints called points. The full list and the current state are in `PROGRESS.md`.

- [x] Point 0: Start (folders, rules, README, setup script)
- [x] Point 1: Sets, Relations and Functions model
- [x] Point 2: Graph network (the graph, its adjacency matrix and list, the analysis of connectivity, paths, cycles and removals, and the pictures; packet 2D: the directed graph with arcs, in- and out-degrees, directed distances, strongly connected groups, Warshall's check, `demo_point2d` and 3 pictures with arrows)
- [x] Point 3: Group Theory and Modular Arithmetic core (fast modular exponentiation, gcd and inverse, primes, the group rules for Z_97*, orders, generators and cyclic subgroups)
- [x] Point 4: Diffie–Hellman and encryption (the key exchange for all users, encryption and decryption with the shared key, and an eavesdropper who attacks the key exchange and the cipher)
- [x] Point 5: The whole system and the demo (the keys on the channels, the messages along the paths, `demo_point5`, and `main_demo` with typed prompts and a picture of the route)
- [x] Point 6: Tests, figures, report and slides (`demo_point6`, the verification of the shared key, the decryption and the graph; the 5 flowcharts in `docs/flowcharts`; the 11 seminar slides; the technical report `docs/Technical_Report.docx` and `.pdf`, 28 pages). The pictures in the report are Octave renders and stand-ins until the MATLAB run (see `docs/report_figures/README.md`)
- [x] Point 7: RSA public-key encryption (the RSA keys from two primes, encryption and decryption of numbers and text, why it works in the group Z_n*, the RSA keys of the 6 users and their messages, the key transport, an eavesdropper who factors n or uses a list of all small numbers, the verification of RSA a second way with 15 checks, `demo_point7`)

## How to run

1. Open MATLAB and set the current folder to this project folder.
2. Run `setup_project` to add the code folders to the MATLAB path.
3. Run `run_all_tests` to check everything, `demo_point1` to see the sets, relations and functions of Point 1, `demo_point2` to see the communication network as a graph, its analysis and 5 pictures (they open in figure windows and are saved as PNG files in the `outputs` folder), `demo_point2d` to see the same network as a directed graph (8 arcs, 8 checks, strongly connected groups and 3 pictures with arrows, saved as `outputs/point2d_*.png`), and `demo_point3` to see the modular arithmetic tools and the group Z_97* (fast modular powers, gcd and inverse, the group rules, orders, generators and cyclic subgroups), and `demo_point4` to see the Diffie-Hellman key exchange (Alice and Bob, then all users), the encryption with the shared key and an eavesdropper, `demo_point5` to see the secure network (a key on every channel and messages along the paths), `demo_point6` to see the verification (the shared keys, the decryption and the graph are checked a second way: 21 checks in 3 tables), `demo_point7` to see RSA public-key encryption (the keys from two primes, a number and a text encrypted and decrypted, why it works in the group Z_n*, a wrong key; then the RSA keys of the 6 users and their messages, the key transport and the eavesdropper: 4 blocks with 34 checks in all; then the verification of RSA a second way: 15 checks in 3 tables, also for a second set of keys), and `main_demo` for the demo with typed prompts (you choose the users and type the messages, they travel along the route, you can break and repair channels, and option 7 draws the picture of the network with the route; the picture opens in a figure window and is saved as `outputs/point5_route.png`).

## Report material

The technical report is `docs/Technical_Report.docx` (a PDF copy is next to it). Its source is `docs/report/Technical_Report.md`; after editing it, run `python3 handoff/build_report.py` to rebuild the Word and PDF files. The `docs` folder also holds the 5 flowcharts (`docs/flowcharts`: Diffie-Hellman, encryption and decryption, routing along the network, RSA and the architecture of the modules) and the seminar slides (`docs/Crypto_Microproject_Presentation.pptx`). The network pictures for the report are made by `demo_point2`, `demo_point2d` and `main_demo` (option 7) and saved in `outputs`.

## Note

This is an educational project. Small numbers are used so every step can be checked by hand. It is not meant to protect real data.

## Team

Santanu Barua, M Hariharan, Kushi Pathak, P Abdul Wasim, Someshwar A, Adithya Sampath Kumar
