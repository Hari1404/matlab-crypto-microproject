# MP PROGRESS

## Locked decisions
- Project: MATLAB-Based Public-Key Cryptography and Secure Communication Using Group Theory and Modular Arithmetic (Alliance University micro-project, team of 6)
- Runs on desktop MATLAB. Base MATLAB only unless a packet says otherwise, so it runs on any recent release.
- Demo style: commands and typed prompts in MATLAB, with text output and graphs. No clickable app for now.
- Small numbers for clarity. It is an educational simulation, not real security, and the report says so.
- Code layout: code in src/<module>/, one function per file with the file name equal to the function name; tests in tests/; saved figures in outputs/; report material in docs/.
- Entry commands: setup_project (adds the folders to the path) and main_demo (comes at Point 5).
- Packet files (.md) are kept in packets/ and committed; zip files in packets/ are not.

## How we work
1. The project is built in big checkpoints called points. Inside a point the work is cut into small packets (IDs like 1A, 1B, 2A).
2. Before each point, and again before each packet when needed, the planner clones the repo, reads this file and the code, and writes the next packet as a markdown file (packets/PACKET_<ID>_<NAME>.md, with a files zip when there are files to copy).
3. The owner puts the packet in packets/ and pastes this line into Antigravity: Read packets/PACKET_<ID>_<NAME>.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.
4. The agent follows AGENTS.md, commits, pushes and reports DONE with the done-checks.
5. The owner runs the new part in MATLAB, checks it by eye, and tells the planner what happened. Then the planner plans the next packet.

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

## Next
- Owner: run version and ver in MATLAB on the laptop that will show the final demo, and send the output. It decides which functions are safe to use.
- Plan POINT 1: the planner clones the repo, reads this file and writes Packet 1A.
