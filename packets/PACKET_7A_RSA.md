# PACKET 7A: RSA public-key encryption (the keys, encryption and decryption of numbers and text, why it works)

Project: MATLAB-Based Public-Key Cryptography (repo `matlab-crypto-microproject`)
Point: 7 (RSA public-key encryption), first packet
Goal: add nine files to a new folder `src/rsa/`: `check_rsa_setup` (checks two primes p and q and the public exponent e), `rsa_make_keys` (n, phi and the private exponent d), `rsa_encrypt_number`, `rsa_decrypt_number`, `rsa_encrypt_text`, `rsa_decrypt_text`, `rsa_format_numbers`, `show_rsa` (prints the keys, one number, a text, why it works in the group Z_n* and a wrong key, with 8 checks) and `demo_point7`. Add the test `test_rsa`. Change `run_all_tests`. Update PROGRESS.md and README.md. One commit, then push.

## Rules

- Decide nothing. Do exactly the steps below, in order.
- Touch only the files listed in this packet.
- Do not run `git push --force`, do not rebase, do not change branches.
- If any step fails or any check does not match, STOP and report the full error text. Do not try to fix it yourself.

## Before you start

1. Run `git remote -v`. Origin must be `https://github.com/Hari1404/matlab-crypto-microproject.git` (fetch and push). If not, stop.
2. Run `git branch --show-current`. It must print `main`. If not, stop.
3. Run `git pull`. It must finish without errors.
4. Run `git log -1 --oneline`. It must print exactly: `f7e26c9 Fix test_route_picture: compare decoded pixels, not raw PNG bytes`. If not, stop and report what it printed.
5. Run `git config user.name` and `git config user.email`. Both must print a value. If either is empty, stop and ask the owner. Do not invent one.
6. `packets/PACKET_7A_RSA.md` and `packets/MP7A_files.zip` must exist. If not, stop.
7. Run `git status --short`. It must print exactly one line: `?? packets/PACKET_7A_RSA.md`. If it prints anything else, stop and report it.

## Steps

1. Run this exact command in the repository root (the folder that contains `.git`):
   `Expand-Archive -Path "packets\MP7A_files.zip" -DestinationPath "." -Force`
2. Check that these 13 files exist at these paths:
   - `PROGRESS.md` (this one already existed and is now replaced)
   - `README.md` (this one already existed and is now replaced)
   - `src/rsa/check_rsa_setup.m`
   - `src/rsa/demo_point7.m`
   - `src/rsa/rsa_decrypt_number.m`
   - `src/rsa/rsa_decrypt_text.m`
   - `src/rsa/rsa_encrypt_number.m`
   - `src/rsa/rsa_encrypt_text.m`
   - `src/rsa/rsa_format_numbers.m`
   - `src/rsa/rsa_make_keys.m`
   - `src/rsa/show_rsa.m`
   - `tests/run_all_tests.m` (this one already existed and is now replaced)
   - `tests/test_rsa.m`
3. Check the SHA-256 hash of all 13 files. All 13 must match exactly:

   | File | SHA-256 |
   | --- | --- |
| `PROGRESS.md` | `2cf406763dbb3f86f76cce48efe76ed1dcd0f2e0fe4cdff4c0a49efdce53faae` |
| `README.md` | `46599ec9e3c36f3bd52500d6b23d01e284db1dc41d47762d76e9bd512440f4c1` |
| `src/rsa/check_rsa_setup.m` | `0fc0fcd71e99266e5718c786ca0e17ed8bba3a2dba7db5ca07518781dd592d89` |
| `src/rsa/demo_point7.m` | `dba1c8c9b4c5dc5e5c1e4140106927931207d3e6896bc567055d76b89b7dbce4` |
| `src/rsa/rsa_decrypt_number.m` | `717e65ffc5bbda37039a726c02ab9a125f7be348f239913d648ae01ed5486321` |
| `src/rsa/rsa_decrypt_text.m` | `c8eab286d0ec69ee88d44537e9d5a33674b9e1001a926ad6ac5d014de29cdfd8` |
| `src/rsa/rsa_encrypt_number.m` | `3fdb31ffa699d48612f6debf8afc164581988742bc823c94b3a52738fd16c3d7` |
| `src/rsa/rsa_encrypt_text.m` | `914680d8ae6d0e25600c6a9d9521f82fb458347932685fbfdd4a4ad2bde35b17` |
| `src/rsa/rsa_format_numbers.m` | `55cb32449d286f2e54482f187f145e6b75cf06ca9dd70741259725909d0c1a27` |
| `src/rsa/rsa_make_keys.m` | `4f60c2fa139cea429e535469a57e11df8a36d58914a2db3dcf57b05eaac89474` |
| `src/rsa/show_rsa.m` | `179697afbfc90bf121183b558d2886268fa81887c6090826aa751ff856f64cdb` |
| `tests/run_all_tests.m` | `4f4ab991c2a6b08c6efe0a8c31711f4cd6f459f7a73d4d15a836b9b157aa53d0` |
| `tests/test_rsa.m` | `5444d3b8e59435f5ba2d3e43c48b9947dc76002a27eadc17d8287edc3b2d3663` |

   Run this exact command (it prints one line per file and a last line `ALL_MATCH: True`). Run it exactly as it is written, do not shorten it:

```
python -c "
import hashlib
files = {
 'PROGRESS.md': '2cf406763dbb3f86f76cce48efe76ed1dcd0f2e0fe4cdff4c0a49efdce53faae',
 'README.md': '46599ec9e3c36f3bd52500d6b23d01e284db1dc41d47762d76e9bd512440f4c1',
 'src/rsa/check_rsa_setup.m': '0fc0fcd71e99266e5718c786ca0e17ed8bba3a2dba7db5ca07518781dd592d89',
 'src/rsa/demo_point7.m': 'dba1c8c9b4c5dc5e5c1e4140106927931207d3e6896bc567055d76b89b7dbce4',
 'src/rsa/rsa_decrypt_number.m': '717e65ffc5bbda37039a726c02ab9a125f7be348f239913d648ae01ed5486321',
 'src/rsa/rsa_decrypt_text.m': 'c8eab286d0ec69ee88d44537e9d5a33674b9e1001a926ad6ac5d014de29cdfd8',
 'src/rsa/rsa_encrypt_number.m': '3fdb31ffa699d48612f6debf8afc164581988742bc823c94b3a52738fd16c3d7',
 'src/rsa/rsa_encrypt_text.m': '914680d8ae6d0e25600c6a9d9521f82fb458347932685fbfdd4a4ad2bde35b17',
 'src/rsa/rsa_format_numbers.m': '55cb32449d286f2e54482f187f145e6b75cf06ca9dd70741259725909d0c1a27',
 'src/rsa/rsa_make_keys.m': '4f60c2fa139cea429e535469a57e11df8a36d58914a2db3dcf57b05eaac89474',
 'src/rsa/show_rsa.m': '179697afbfc90bf121183b558d2886268fa81887c6090826aa751ff856f64cdb',
 'tests/run_all_tests.m': '4f4ab991c2a6b08c6efe0a8c31711f4cd6f459f7a73d4d15a836b9b157aa53d0',
 'tests/test_rsa.m': '5444d3b8e59435f5ba2d3e43c48b9947dc76002a27eadc17d8287edc3b2d3663',
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
   `git add PROGRESS.md README.md src/rsa/check_rsa_setup.m src/rsa/demo_point7.m src/rsa/rsa_decrypt_number.m src/rsa/rsa_decrypt_text.m src/rsa/rsa_encrypt_number.m src/rsa/rsa_encrypt_text.m src/rsa/rsa_format_numbers.m src/rsa/rsa_make_keys.m src/rsa/show_rsa.m tests/run_all_tests.m tests/test_rsa.m packets/PACKET_7A_RSA.md`
5. Run `git status --short`. It must print exactly these 14 lines and nothing else:
```
M  PROGRESS.md
M  README.md
A  packets/PACKET_7A_RSA.md
A  src/rsa/check_rsa_setup.m
A  src/rsa/demo_point7.m
A  src/rsa/rsa_decrypt_number.m
A  src/rsa/rsa_decrypt_text.m
A  src/rsa/rsa_encrypt_number.m
A  src/rsa/rsa_encrypt_text.m
A  src/rsa/rsa_format_numbers.m
A  src/rsa/rsa_make_keys.m
A  src/rsa/show_rsa.m
M  tests/run_all_tests.m
A  tests/test_rsa.m
```
6. Commit with exactly this message: `7A: RSA public-key encryption (keys, encryption and decryption of numbers and text, why it works)`
7. Run `git push origin main`.

## Done-checks (all must pass)

1. Hashes: 13 of 13 match.
2. `git log -1 --oneline` shows the message `7A: RSA public-key encryption (keys, encryption and decryption of numbers and text, why it works)`.
3. `git status -sb` prints exactly one line: `## main...origin/main`.
4. `git ls-files packets` prints exactly seventeen lines: `packets/PACKET_0A_START.md`, `packets/PACKET_1A_SETS.md`, `packets/PACKET_1B_RELATIONS.md`, `packets/PACKET_1C_CIPHER.md`, `packets/PACKET_2A_GRAPH.md`, `packets/PACKET_2B_GRAPH.md`, `packets/PACKET_2C_PICTURES.md`, `packets/PACKET_3A_MODULAR.md`, `packets/PACKET_3B_GROUP.md`, `packets/PACKET_4A_DH.md`, `packets/PACKET_4B_ENCRYPT.md`, `packets/PACKET_5A_SYSTEM.md`, `packets/PACKET_5B_MAINDEMO.md`, `packets/PACKET_5C_ROUTEPIC.md`, `packets/PACKET_6A2_FIXES.md`, `packets/PACKET_6A_VERIFY.md` and `packets/PACKET_7A_RSA.md`. No zip is tracked.
5. `git ls-files src/rsa` prints exactly nine lines: `src/rsa/check_rsa_setup.m`, `src/rsa/demo_point7.m`, `src/rsa/rsa_decrypt_number.m`, `src/rsa/rsa_decrypt_text.m`, `src/rsa/rsa_encrypt_number.m`, `src/rsa/rsa_encrypt_text.m`, `src/rsa/rsa_format_numbers.m`, `src/rsa/rsa_make_keys.m` and `src/rsa/show_rsa.m`.
6. If `matlab` works on the command line, run `matlab -batch "setup_project; run_all_tests"`. The last line it prints must be `ALL TESTS PASSED`. If `matlab` is not available, write "MATLAB check skipped, owner will run it".

## Report back

Print: the result of each done-check (PASS or FAIL), the commit hash, and the output of `git log --oneline -3`. Also paste the output of the hash command of step 3.

## Owner check in MATLAB (later, on the demo laptop)

1. In MATLAB, set the current folder to the repo folder.
2. Type `setup_project` and press Enter. Expected: `Project paths added. Project folder: ...`
3. Type `run_all_tests` and press Enter. Expected: 25 lines starting with PASS, then `test_sets: 25 of 25 checks passed`, then 51 lines starting with PASS, then `test_relations: 51 of 51 checks passed`, then 50 lines starting with PASS, then `test_cipher: 50 of 50 checks passed`, then 51 lines starting with PASS, then `test_graph: 51 of 51 checks passed`, then 120 lines starting with PASS, then `test_graph_analysis: 120 of 120 checks passed`, then 129 lines starting with PASS, then `test_graph_pictures: 129 of 129 checks passed`, then 130 lines starting with PASS, then `test_modular: 130 of 130 checks passed`, then 131 lines starting with PASS, then `test_group: 131 of 131 checks passed`, then 71 lines starting with PASS, then `test_dh: 71 of 71 checks passed`, then 101 lines starting with PASS, then `test_encryption: 101 of 101 checks passed`, then 69 lines starting with PASS, then `test_system: 69 of 69 checks passed`, then 59 lines starting with PASS, then `test_main_demo: 59 of 59 checks passed`, then 64 lines starting with PASS, then `test_route_picture: 64 of 64 checks passed`, then 32 lines starting with PASS, then `test_verification: 32 of 32 checks passed`, then 109 lines starting with PASS, then `test_rsa: 109 of 109 checks passed`. Then the last line `ALL TESTS PASSED`. No figure window may stay open after it.
4. Type `demo_point7` and press Enter. It takes a few seconds and opens no window. Expected: the title `##### POINT 7 DEMO: RSA PUBLIC-KEY ENCRYPTION #####`, then `=== RSA PUBLIC-KEY ENCRYPTION ===`, then five parts: `1. Making the keys`, `2. Encrypting and decrypting one number`, `3. Encrypting and decrypting a text`, `4. Why it works: the group Z_n*` and `5. What a wrong key gives`. In part 1: `n = p*q = 61 * 53 = 3233`, `phi = (p-1)*(q-1) = 60 * 52 = 3120` and `Public key: (n, e) = (3233, 17). Private key: d = 2753.` In part 2: `c = m^e mod n = 65^17 mod 3233 = 2790.` and `The decrypted number is the same as the message: yes`. In part 3: 36 numbers in 3 lines of 12 (the first line is `2825  325  325 2310    1 3165  325    1  524 2310    1 2310`) and `It is the same as the message: yes`. In part 4: `gives 3120 numbers, and phi = 3120: yes.`, `Checked for all 3120 elements: yes.` and `gives the number back: yes (3233 numbers).` In part 5: `d = 2752 instead of 2753` and `The decryption stops`. Then `Checks:` and 8 rows. Every row ends with `yes` (none ends with `NO`).
5. Type `K = rsa_make_keys(61, 53, 17); [K.n K.phi K.e K.d]` and press Enter. Expected: `ans =` and the numbers `3233 3120 17 2753`. Type `rsa_encrypt_number(65, 3233, 17)` and press Enter. Expected: `2790`. Type `rsa_decrypt_number(2790, 3233, 2753)` and press Enter. Expected: `65`. Type `rsa_encrypt_text('Hello, RSA!', 3233, 17)` and press Enter. Expected: the 11 numbers `3199 325 3123 3123 2933 47 1 368 529 180 1752`. Type `rsa_decrypt_text(rsa_encrypt_text('Hello, RSA!', 3233, 17), 3233, 2753)` and press Enter. Expected: `Hello, RSA!`.
6. Type `rsa_decrypt_text(rsa_encrypt_text('Hello, RSA!', 3233, 17), 3233, 2752)` and press Enter. This uses a wrong private key on purpose. Expected: an error that ends with `This is not the right key.` Then type `rsa_make_keys(61, 61, 17)` and press Enter. Expected: an error that says `p and q must be two different primes.` Then type `rsa_make_keys(61, 53, 15)` and press Enter. Expected: an error that says `e = 15 and phi = 3120 must have gcd 1, but the gcd is 15.`
7. Type `demo_point6` and press Enter. Expected: `In all: 21 of 21 checks agree.` (Point 6 must still work.) Type `demo_point5` and press Enter. It must still print one `Checks:` block of 7 lines that all end with `yes` (none ends with `NO`).
8. Run `git status --short` in a terminal. It must print nothing (RSA writes no files).

The planner already ran all of this in GNU Octave 8.4.0 on the final files: a fresh clone of main (`f7e26c9`) with `MP7A_files.zip` unpacked and the commit made locally (nothing was pushed). All 15 test files passed and the run ended with `ALL TESTS PASSED` (25 of 25, 51 of 51, 50 of 50, 51 of 51, 120 of 120, 129 of 129, 130 of 130, 131 of 131, 71 of 71, 101 of 101, 69 of 69, 59 of 59, 64 of 64, 32 of 32 and 109 of 109 checks; the 3 test files that draw pictures also ran and passed in this Octave). The same full run in the strict copy (a copy of the code where every operand of `&&` and `||` must be one true or false value, as MATLAB demands) also ended with `ALL TESTS PASSED`, `test_rsa` 109 of 109. After both runs `git status --short` printed nothing, so the tests write no files. `demo_point7` printed the 8 check lines, all `yes`. The commands of steps 5 and 6 of the owner check were run in Octave and printed the values and error texts written above. The RSA numbers (n, phi, d, 65 -> 2790, the 36 numbers of the text, the 11 numbers of `Hello, RSA!`, 7 more key pairs, and the fact that d-1 gives values outside 1 to 95) were also computed by an independent Python program and are the same. The packet itself was tested in a fresh clone: before-you-start steps 4 and 7, the unzip, the hash command and the `git add` command (both taken from the text of this file), the 14 lines of `git status --short`, the commit, and the lists of done-checks 4 and 5 all gave exactly what is written here; the committed files are identical to the planner's files. Not tested: `git push`, `Expand-Archive` in PowerShell (the planner used `unzip`) and anything in MATLAB itself. The planner has no MATLAB. The strict copy checks only the `&&` and `||` rule, so another difference between Octave and MATLAB can still show up in the owner check, as it did in 6A2.

The checks were tested by breaking the code on purpose (planted-bug test, `tools/mutation_test_rsa.py` in the planner's folder, not part of the repo): 18 bugs were put into the 9 new files, one at a time, and `test_rsa` was run on each copy. The first version of `test_rsa` (108 checks) found 17 of the 18: 12 as FAIL lines and 5 as a stop with an error (the test stopped at that point, so its later checks did not run; `run_all_tests` still fails). The bugs: (1) p = q no longer refused, FAIL; (2) n = 91 accepted, FAIL; (3) gcd(e, phi) not checked, FAIL; (4) d found mod n instead of mod phi, error; (5) phi = n-1, error; (6) the self-inverse e (d = e) no longer refused, FAIL; (7) encryption with the exponent e+1, error; (8) m = n accepted, FAIL; (9) decryption as c*d mod n, error; (10) the last character of a text not encrypted, error; (11) a result that is not a symbol no longer refused, FAIL; (12) the value 96 accepted as a symbol, NOT FOUND; (13) numbers printed without a wider field, FAIL; (14) the wrong key is the right key in show_rsa, FAIL; (15) the Euler check looks for 2 instead of 1, FAIL; (16) the printout counts the wrong symbol as the space, FAIL; (17) the example uses e = 7, FAIL; (18) demo_point7 does not call show_rsa, FAIL. Bug 12 was a real gap (the test refused 0 but never tried 96, the first value above the symbols), so one check was added to `test_rsa` (it is now 109 checks) and with it bug 12 is found as a FAIL line (108 of 109). The other 17 bugs were not run again with the added check; one more check cannot make a found bug unfound. This shows the checks react to these 18 changes; it does not show that no bug is left.

Paste line for the agent:

`Read packets/PACKET_7A_RSA.md and execute it exactly. Decide nothing. If anything fails, stop and tell me.`
