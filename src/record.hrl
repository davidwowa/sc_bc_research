-record(pseudonym, {guid, public_key, ip, value, timestamp}).
-record(block, {p_hash, hash, merkle_root, data, timestamp}).
-record(key, {private_key, public_key, timestamp}).
-record(message, {public_key, signature, timestamp}).
-record(candidate, {signature, public_key, hash, message, value, tt, tt_mined}).