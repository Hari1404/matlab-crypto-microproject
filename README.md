# MATLAB-Based Public-Key Cryptography and Secure Communication

Using Group Theory and Modular Arithmetic

Micro-project for Alliance University, Alliance College of Engineering and Design.

## About

This project simulates secure communication between users in MATLAB. It uses Sets, Relations and Functions to model users, messages and keys, Graph Theory to model and analyse the communication network, and Group Theory with Modular Arithmetic to implement the Diffie–Hellman key exchange.

Alice and Bob each choose a private key, exchange public values over an insecure channel, and arrive at the same shared secret. That secret is then used to encrypt and decrypt messages. RSA public-key encryption is added as a second example of the same mathematics: the public key encrypts, the private key decrypts, and it works because of the group Z_n*.

The example uses the prime p = 97 and the generator g = 5, with six users (Alice, Bob, Carol, Dave, Frank and Grace) connected by six channels.

## How the mathematics maps to the code

| Topic | What it models | Folder |
| --- | --- | --- |
| Sets, Relations and Functions | Users, plaintext, ciphertext and keys; key ownership; encryption and decryption as functions | `src/sets_relations_functions` |
| Graph Theory | The communication network with users as vertices and channels as edges: adjacency matrix and list, connectivity, shortest paths, cycles, bridge channels, cut users and pictures. Also the directed version: arcs, in- and out-degree, strongly connected groups and arrows | `src/graph_network` |
| Group Theory and Modular Arithmetic | Fast modular exponentiation, gcd and modular inverse, primes, the group Z_97*, element orders, generators and cyclic subgroups | `src/group_theory` |
| Diffie–Hellman key exchange | A shared secret key agreed over an insecure channel, and an eavesdropper who attacks it | `src/diffie_hellman` |
| Encryption and decryption | Messages protected with the shared key, and an eavesdropper who tries every key | `src/encryption` |
| Integration | All modules working together as one network: a key on every channel and messages routed along the shortest path | `src/integration` |
| RSA public-key encryption | RSA keys from two primes; encryption and decryption of numbers and text; why it works in Z_n*; RSA keys for every user; key transport (an RSA-encrypted cipher key); an eavesdropper who factors n; and a second, independent verification | `src/rsa` |

## Requirements

Base MATLAB only. No toolboxes are needed. The code also runs in GNU Octave.

## How to run

1. Open MATLAB and set the current folder to this project folder.
2. Run `setup_project` to add the code folders to the MATLAB path.
3. Run any of the commands below.

| Command | What it shows |
| --- | --- |
| `run_all_tests` | Runs every test file and ends with `ALL TESTS PASSED` when everything is correct |
| `demo_point1` | The sets, relations and functions: users, plaintext, ciphertext, keys, key ownership and the cipher as a function |
| `demo_point2` | The communication network as a graph, its analysis (connectivity, paths, cycles, bridge channels, cut users) and 5 pictures. The pictures open in figure windows and are saved as PNG files in `outputs` |
| `demo_point2d` | The same network as a directed graph: 8 arcs, 8 checks, strongly connected groups and 3 pictures with arrows, saved as `outputs/point2d_*.png` |
| `demo_point3` | The modular arithmetic tools and the group Z_97*: fast modular powers, gcd and inverse, the group rules, orders, generators and cyclic subgroups |
| `demo_point4` | The Diffie–Hellman key exchange (Alice and Bob, then all users), encryption with the shared key, and an eavesdropper |
| `demo_point5` | The secure network: a key on every channel and messages sent along the paths |
| `demo_point6` | Verification: the shared keys, the decryption and the graph are each checked a second way (21 checks in 3 tables) |
| `demo_point7` | RSA: keys from two primes, a number and a text encrypted and decrypted, why it works in Z_n*, then the RSA keys of the 6 users, key transport and the eavesdropper (34 checks), then a second verification (15 checks in 3 tables, also for a second set of keys) |
| `main_demo` | The interactive demo with typed prompts. You choose the users and type the messages, watch them travel along the route, and break and repair channels. Option 7 draws the network with the route and saves it as `outputs/point5_route.png` |

## Project layout

| Path | Contents |
| --- | --- |
| `src/` | The MATLAB code, one folder per module (see the table above) |
| `tests/` | One test file per module, and `run_all_tests` |
| `docs/` | The technical report, seminar slides, flowcharts and report figures |
| `outputs/` | Pictures saved by the demos (not committed) |
| `handoff/` | Scripts that rebuild the report and its figures |
| `setup_project.m` | Adds the code folders to the MATLAB path |

## Report material

The technical report is `docs/Technical_Report.docx`, with a PDF copy next to it. Its source is `docs/report/Technical_Report.md`; after editing it, run `python3 handoff/build_report.py` to rebuild the Word and PDF files.

The `docs` folder also holds:

- The 5 flowcharts in `docs/flowcharts`: Diffie–Hellman, encryption and decryption, routing along the network, RSA, and the architecture of the modules.
- The seminar slides, `docs/Crypto_Microproject_Presentation.pptx`.
- The report figures in `docs/report_figures`. The network pictures are produced by `demo_point2`, `demo_point2d` and `main_demo` (option 7) and saved in `outputs`.

## Note

This is an educational project. Small numbers are used so every step can be checked by hand. It is not meant to protect real data.

## Team

Santanu Barua, M Hariharan, Kushi Pathak, P Abdul Wasim, Someshwar A, Adithya Sampath Kumar
