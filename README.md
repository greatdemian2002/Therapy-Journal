🧠 Blockchain Therapy Journal Contract

Overview

The Blockchain Therapy Journal Contract is a Clarity smart contract designed to provide an immutable, decentralized journaling system for therapy-related reflections. Each journal entry is permanently recorded on-chain, ensuring transparency and authenticity.
Registered therapists can verify entries, allowing users to prove that their journal records have been reviewed by licensed professionals.

✨ Key Features

Immutable Journal Entries:
Once created, journal entries cannot be edited or deleted, ensuring record integrity.

Therapist Verification:
Therapists registered on-chain can verify entries, adding a trusted layer of authentication.

Decentralized Registry:
Therapists are registered and deactivated through on-chain transactions, with no centralized authority.

Transparent Validation:
Verification includes both the verifying therapist and a blockchain timestamp for auditability.

📚 Contract Components
Constants
Constant	Description
ERR-NOT-AUTHORIZED	Returned when a non-therapist attempts verification
ERR-ENTRY-NOT-FOUND	Returned if an entry doesn’t exist
ERR-ALREADY-VERIFIED	Returned when an entry has already been verified
ERR-EMPTY-CONTENT	Returned when an entry has no content
ERR-INVALID-PRINCIPAL	Returned for invalid principal arguments
ERR-INVALID-ENTRY-ID	Returned for invalid entry ID values
🧩 Data Structures
Data Variables
Variable	Type	Description
next-entry-id	uint	Auto-incrementing ID for journal entries
Data Maps
Map	Key	Value	Description
journal-entries	{ entry-id: uint }	{ author, content, timestamp, is-verified, verified-by, verification-timestamp }	Stores each journal entry
therapist-registry	{ therapist: principal }	{ is-active: bool }	Tracks registered therapists
🔍 Read-Only Functions
Function	Parameters	Returns	Description
get-entry	(entry-id uint)	(optional { ... })	Retrieves a specific journal entry
get-next-entry-id	()	uint	Returns the next available entry ID
is-therapist	(therapist principal)	bool	Checks if a principal is an active therapist
⚙️ Public Functions
Function	Parameters	Returns	Description
create-entry	(content (string-utf8 1000))	(response uint uint)	Creates a new immutable journal entry
register-therapist	(therapist principal)	(response bool uint)	Registers a new therapist as active
deactivate-therapist	(therapist principal)	(response bool uint)	Deactivates an existing therapist
verify-entry	(entry-id uint)	(response bool uint)	Verifies a journal entry (therapist-only)
🔒 Access Control Rules

Anyone can create journal entries.

Only registered therapists can verify entries.

Therapists cannot register or deactivate themselves (must be done by another account).

🧪 Example Workflow

Create a Journal Entry

(contract-call? .therapy-journal create-entry "Today I felt more confident after my session.")


Register a Therapist

(contract-call? .therapy-journal register-therapist 'SP2C2...XYZ)


Verify an Entry

(contract-call? .therapy-journal verify-entry u1)

🧰 Error Handling

All error codes are returned using err responses for consistent error tracking.
Example:

(err u100) ;; Not authorized

✅ Future Enhancements

Add therapist license verification via decentralized identity (DID).

Implement tagging or sentiment metadata for entries.

Add pagination and search features for journal retrieval.

📄 License

MIT License — free to use, modify, and distribute with attribution.