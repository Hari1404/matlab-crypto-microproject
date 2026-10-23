# MP PROGRESS

## Locked decisions
- Project: MATLAB-Based Public-Key Cryptography and Secure Communication Using Group Theory and Modular Arithmetic (Alliance University micro-project, team of 6)
- Runs on desktop MATLAB. Base MATLAB only unless a packet says otherwise, so it runs on any recent release.
- Demo style: commands and typed prompts in MATLAB, with text output and graphs. No clickable app for now.
- Small numbers for clarity. It is an educational simulation, not real security, and the report says so.
- Code layout: code in src/<module>/, one function per file with the file name equal to the function name; tests in tests/; saved figures in outputs/; report material in docs/.
- Entry commands: setup_project (adds the folders to the path) and main_demo (comes at Point 5). Each point may also have a small demo, for example demo_point1.
- Packet files (.md) are kept in packets/ and committed; zip files in packets/ are not.
- Numbers: prime p = 97 and generator g = 5 (the powers of 5 give every number from 1 to 96). Everything works in the group Z_97* (the numbers 1 to 96 with multiplication mod 97).
- Users: Alice, Bob, Carol, Dave, Frank, Grace (6 users). They are set in define_sets and can be changed there.
- Alphabet: the 95 printable ASCII characters (space to ~). A character with code c is plaintext symbol c - 31, so symbols are 1 to 95. Ciphertext values are 1 to 96. The key set K is 1 to 96.
- Cipher (planned, built in Points 1 and 4): encryption E_k(m) = k*m mod 97 and decryption uses the inverse of k mod 97. The shared Diffie-Hellman secret is the key k itself.
- Code style: it must run in desktop MATLAB and also in GNU Octave. Use only simple base functions, single-quoted text, no toolboxes, and plain ASCII characters in .m files. The planner tests in Octave; the real MATLAB run is at the end.
- The owner has no MATLAB on the working laptop. Antigravity skips the MATLAB checks. All real MATLAB runs happen later on the demo laptop.
- Tests: tests/test_<name>.m are functions; each prints PASS or FAIL lines through summarize_checks. run_all_tests runs them all and ends with ALL TESTS PASSED.

## How we work
1. The project is built in big checkpoints called points. Inside a point the work is cut into small packets (IDs like 1A, 1B, 2A).
2. Before each point, and again before each packet when needed, the planner clones the repo, reads this file and the code, and writes the next packet as a markdown file (packets/PACKET_<ID>_<n>.md, with a files zip when there are files to copy).
3. The owner puts the packet in packets/ and pastes this line into Antigravity: Read packets/PACKET_<ID>_<n>.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.
4. The agent follows AGENTS.md, commits, pushes and reports DONE with the done-checks.
5. The planner tests the code in Octave. The owner runs the whole thing in MATLAB on the demo laptop and tells the planner what happened. Then the planner plans the next packet.

## Points (big checkpoints)
- POINT 0: Start. Repo, rules, README, folders, setup script.
- POINT 1: Sets, Relations and Functions model: users, plaintext, ciphertext and keys as sets, key ownership as a relation, encryption and decryption as functions.
- POINT 2: Graph network: users as vertices and channels as edges, adjacency matrix and list, connectivity, paths and reachability, pictures.
- POINT 3: Group Theory and Modular Arithmetic core: fast modular exponentiation, gcd and inverse, primes, generators, cyclic group checks.
- POINT 4: Diffie–Hellman (Alice and Bob) and encryption and decryption with the shared key.
- POINT 5: The whole system together and main_demo: several users on the network, each connected pair with its own key, typed prompts.
- POINT 6: Tests, figures, flowcharts, technical report and seminar slides.
- Maybe later, decided when we get there: an eavesdropper view, a small RSA module.

## Done
- Packet 0A: project start. The folders (src/ with six module folders, tests/, outputs/, docs/), README.md, .gitignore, AGENTS.md (the agent rules), PROGRESS.md (this file), and setup_project.m (adds the code folders to the MATLAB path).
- Packet 1A: the sets and text conversion. define_sets (users, plaintext, ciphertext, keys, p and g), text_to_symbols and symbols_to_text, show_sets, demo_point1, and the test helpers (summarize_checks, test_sets, run_all_tests).
- Packet 1B: the relations. define_relations (R1 = can talk with, the 6 channels in both directions; R2 = owns, one private key per user), pairs_to_matrix, relation_properties (reflexive, symmetric, antisymmetric, transitive, equivalence, partial order), function_properties (function, one-to-one, onto), show_relations, test_relations, and demo_point1 now shows the relations.

## Next
- Planner: Packet 1C, encryption and decryption as functions, with their properties.
- Owner: later, on the demo laptop, run version, ver, setup_project, run_all_tests and demo_point1, and send what you see.
