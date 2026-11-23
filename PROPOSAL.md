# Reading Tracker — Proposal (draft, instructor approval required)

**User and purpose:** A student who reads several books tracks what to read next,
reading progress, ratings and personal notes in one app.

**Features:** Catalogue search and detail (Open Library); personal reading collection
(CRUD on a hosted mock backend in week 2); authentication; profile settings and statistics.

**Screens:** Login; catalogue; book detail; personal library; reading-entry details;
add/edit form; statistics; settings; About (9 screens).

**Data:** `Book(id,title,authors[],description?,coverUrl?,firstPublishYear?,subjects[],language?)`;
`ReadingEntry(id,bookId,title,status,pagesRead,totalPages,rating?,notes?,startDate?,finishDate?)`.

**Storage:** token → secure storage; theme/filter and development fake collection → preferences;
real catalogue cache → application documents directory in week 2. Device feature:
profile photo using camera/gallery with runtime permission, week 2.

**Solo arrangement:** teacher permitted individual development. All source, tests and releases
are owned by one student. Confirm how peer PR review / per-person contribution requirements
are waived or adapted. No fabricated reviewers.

**Risks:** third-party API or hosted backend unavailable → fake-mode demonstration;
Android keystore/build configuration delays → perform release checklist early.

**Approval:** pending explicit confirmation from the instructor.
