# PACKET 1C: Encryption and decryption as functions

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 1 (Sets, Relations and Functions)
Goal: add encryption and decryption as functions (E_k(m) = k*m mod 97 and D_k(c) = j*c mod 97), the key inverse, the cipher as a relation from P to C with its function properties, the tests, and an updated demo. Update PROGRESS.md and README.md. This finishes Point 1. One commit, then push.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `3fbfcf8 1B: relations and function check`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_1C_CIPHER.md` and `packets/MP1C_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_1C_CIPHER.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP1C_files.zip" -DestinationPath "." -Force`
2. Check that these 12 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `README.md` (this one already existed and is now replaced)
   - `src/sets_relations_functions/cipher_relation.m`
   - `src/sets_relations_functions/decrypt_symbols.m`
   - `src/sets_relations_functions/decrypt_text.m`
   - `src/sets_relations_functions/demo_point1.m` (this one already existed and is now replaced)
   - `src/sets_relations_functions/encrypt_symbols.m`
   - `src/sets_relations_functions/encrypt_text.m`
   - `src/sets_relations_functions/key_inverse.m`
   - `src/sets_relations_functions/show_cipher.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_cipher.m`
3. Check the SHA-256 hash of all 12 files. All 12 must match exactly:

   | File | SHA-256 |
   | --- | --- |
   | `PROGRESS.md` | `02b8e45991320da7fcfcecce54ab7d91c63acaaf7782b767b9878e413509339d` |
   | `README.md` | `fb92252a660e3d357f685e9bf4d171548e4d8fd0c30878918d699435d37114d8` |
   | `src/sets_relations_functions/cipher_relation.m` | `4fe4fc61e63733c4134cc258590e312b7262039364c8e8dd3e458d491e28029a` |
   | `src/sets_relations_functions/decrypt_symbols.m` | `de502c254aee9a90e615a5c676e86fb624012ee278cc7872944448f3234e6667` |
   | `src/sets_relations_functions/decrypt_text.m` | `1b705dcd23c6d2ef6af689f0d9eb8db03bd4c187623d1cb192be818fb389e112` |
   | `src/sets_relations_functions/demo_point1.m` | `54a3e46d51cdccb2d9bca48186db6a5b6efbcfd84cf8ec3c7cf8ab520852f24c` |
   | `src/sets_relations_functions/encrypt_symbols.m` | `b08aa78aba14cb4093871feedaa6263a7ef29b069451251d6552df3c5f0707b2` |
   | `src/sets_relations_functions/encrypt_text.m` | `85dba807bd1af747c6b02250573a4376942807a45f41835809ea1c72593aebc1` |
   | `src/sets_relations_functions/key_inverse.m` | `1761e42e3dccaf51def942fade7b3ffed59f034011056d1a94446b02c83cf8e6` |
   | `src/sets_relations_functions/show_cipher.m` | `5ec3f42e72d1566d84c7956ea20d1f67fe77c9cf43768608ffc052b6c1690396` |
   | `tests/run_all_tests.m` | `2237e84cb8e294e1a7e371a400bd5eea95f4fb4e97febc685010ca995cfdb545` |
   | `tests/test_cipher.m` | `380d7cd192c56705ae9c424284bab5fa09fb55e6ecf3b5c03161a725f244b62e` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`):

```
python -c "
import hashlib
files = {
 'PROGRESS.md': '02b8e45991320da7fcfcecce54ab7d91c63acaaf7782b767b9878e413509339d',
 'README.md': 'fb92252a660e3d357f685e9bf4d171548e4d8fd0c30878918d699435d37114d8',
 'src/sets_relations_functions/cipher_relation.m': '4fe4fc61e63733c4134cc258590e312b7262039364c8e8dd3e458d491e28029a',
 'src/sets_relations_functions/decrypt_symbols.m': 'de502c254aee9a90e615a5c676e86fb624012ee278cc7872944448f3234e6667',
 'src/sets_relations_functions/decrypt_text.m': '1b705dcd23c6d2ef6af689f0d9eb8db03bd4c187623d1cb192be818fb389e112',
 'src/sets_relations_functions/demo_point1.m': '54a3e46d51cdccb2d9bca48186db6a5b6efbcfd84cf8ec3c7cf8ab520852f24c',
 'src/sets_relations_functions/encrypt_symbols.m': 'b08aa78aba14cb4093871feedaa6263a7ef29b069451251d6552df3c5f0707b2',
 'src/sets_relations_functions/encrypt_text.m': '85dba807bd1af747c6b02250573a4376942807a45f41835809ea1c72593aebc1',
 'src/sets_relations_functions/key_inverse.m': '1761e42e3dccaf51def942fade7b3ffed59f034011056d1a94446b02c83cf8e6',
 'src/sets_relations_functions/show_cipher.m': '5ec3f42e72d1566d84c7956ea20d1f67fe77c9cf43768608ffc052b6c1690396',
 'tests/run_all_tests.m': '2237e84cb8e294e1a7e371a400bd5eea95f4fb4e97febc685010ca995cfdb545',
 'tests/test_cipher.m': '380d7cd192c56705ae9c424284bab5fa09fb55e6ecf3b5c03161a725f244b62e',
}
ok = True
for f, h in files.items():
    actual = hashlib.sha256(open(f, 'rb').read()).hexdigest()
    same = (actual == h)
    ok = ok and same
    print(f, same)
print('ALL_MATCH:', ok)
"
```

   If the last line is not `ALL_MATCH: True`, stop.
4. Stage only these paths, with this exact command:
   `git add PROGRESS.md README.md src/sets_relations_functions/cipher_relation.m src/sets_relations_functions/decrypt_symbols.m src/sets_relations_functions/decrypt_text.m src/sets_relations_functions/demo_point1.m src/sets_relations_functions/encrypt_symbols.m src/sets_relations_functions/encrypt_text.m src/sets_relations_functions/key_inverse.m src/sets_relations_functions/show_cipher.m tests/run_all_tests.m tests/test_cipher.m packets/PACKET_1C_CIPHER.md`
5. Run `git status --short`. It must print exactly these 13 lines and nothing else:
```
M  PROGRESS.md
M  README.md
A  packets/PACKET_1C_CIPHER.md
A  src/sets_relations_functions/cipher_relation.m
A  src/sets_relations_functions/decrypt_symbols.m
A  src/sets_relations_functions/decrypt_text.m
M  src/sets_relations_functions/demo_point1.m
A  src/sets_relations_functions/encrypt_symbols.m
A  src/sets_relations_functions/encrypt_text.m
A  src/sets_relations_functions/key_inverse.m
A  src/sets_relations_functions/show_cipher.m
M  tests/run_all_tests.m
A  tests/test_cipher.m
```
6. Commit with exactly this message: `1C: encryption and decryption functions`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 12 of 12 match.
2. `git log -1 --oneline` shows the message `1C: encryption and decryption functions`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly four lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md` and `packets/PACKET_1C_CIPHER.md`. No zip is tracked.
5. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then 50 lines starting with PASS, then `test_cipher: 50 of 50 checks passed`, then `ALL TESTS PASSED`.
4. Type `demo_point1` and press Enter. Expected: everything from 1A and 1B as before, then ENCRYPTION AND DECRYPTION AS FUNCTIONS with the example key 85: its inverse is 8 (`85 * 8 = 680 = 1 (mod 97)`); a small table where m = 1, 2, 3, 34, 95 gives E_85(m) = 85, 73, 61, 77, 24 and D_k(E_k(m)) gives m back; function yes, one-to-one yes, onto no (`95 of 96 values are used, 12 is left out`); then `D_k(E_k(m)) = m for all 95 symbols of P : yes`. Last, ENCRYPTING A MESSAGE: `Hello Bob` becomes `[90 33 46 46 10 85 65 10 69]`, decrypting with key 85 gives `Hello Bob`, and decrypting with the wrong key 2 gives the garbage text `` L`66$zp$r `` (it contains a backtick, that is normal).

The planner already ran steps 2 to 4 in GNU Octave 8.4: 25 of 25, 51 of 51 and 50 of 50 passed. The numbers in the tests and the demo were also checked by hand in Python.

Paste line for the agent:

`Read packets/PACKET_1C_CIPHER.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
