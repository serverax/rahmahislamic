# Ask Sheikh — Architecture Plan (Slice 7)

This is the planning doc for the Ask Sheikh feature. Implementation is
deferred to Slice 7 per the roadmap. Stored here so the architectural
decisions don't live only in chat history.

## Three-tier answer flow

```
User asks question
        │
        ▼
1. Local approved_answers DB lookup
   ├─ match → return saved answer (free, instant)
   └─ no match
        │
        ▼
2. IslamWeb.net cached fatwas (already in our DB from initial scrape)
   ├─ match → return + persist to approved_answers (free)
   └─ no match
        │
        ▼
3. OpenAI API (only for unanswered questions)
   ├─ generate answer
   ├─ run safety validator
   ├─ flag pending scholar review
   └─ return with "AI-generated, pending review" disclaimer (~$0.02)
```

Expected economics at 1k questions/day: ~70% local DB / ~20% IslamWeb /
~10% OpenAI ≈ **$2/day instead of $20/day** if every question hit OpenAI.

## Phase 1 — Scrape IslamWeb (one-time, offline)

Tooling: Python + BeautifulSoup or Scrapy. Runs locally on the developer
machine, not in the app or backend.

Targets:
- Arabic: `https://www.islamweb.net/ar/fatwa/<id>`
- English: `https://www.islamweb.net/en/fatwa/<id>`

Fields per fatwa: `fatwa_id`, `category`, `question`, `answer_full`,
`answer_short`, `evidence`, `source_url`, `language`, `scraped_at`.

Compliance:
- 2–3s sleep between requests; respect `robots.txt`
- Educational/non-commercial use; full attribution + back-link in UI
- Email `webmaster@islamweb.net` requesting permission before going live
  (template in chat history)

Target volume: 5k AR + 5k EN ≈ 20MB Firestore (~$0.001/month).

## Phase 2 — Import to Firestore

Collection: `approved_answers` with the schema below. Batched writes
(500/batch). Use `normalizeArabic()` (strip diacritics, normalize
hamzas/ta-marbuta/alif-maqsura) to produce `question_normalized` for
matching.

```ts
{
  fatwa_id: string;
  source: 'admin' | 'islamweb' | 'islamqa' | 'ai';
  source_url?: string;
  language: 'ar' | 'en';
  category: string;
  question_original: string;
  question_normalized: string;
  answer_short: string;
  answer_full: string;
  evidence: string;
  keywords: string[];
  approved: boolean;
  scholar_reviewed: boolean;
  created_at: Timestamp;
  updated_at: Timestamp;
}
```

Add `approved_answers` to `firestore.rules` as **public read, admin
write only** (same tier as `evidence_sources`).

## Phase 3 — Cloud Function `askSheikh`

Steps inside the function (running on the backend, NOT the app):
1. `checkDailyLimit(userId)` — free tier 7/month, premium unlimited
2. `validateIslamicQuestion(question)` — reject off-topic
3. `classifyRisk(question)` — high-risk topics route to scholar; AI
   never answers them
4. `normalize(question, language)`
5. Search `approved_answers` for ≥0.7 Jaccard similarity
6. If miss → call OpenAI; safety-validate output; persist as
   `source: 'ai_pending_review'`
7. Return `{ source, answer, source_url?, disclaimer }`

Final safety pass blocks forbidden phrasings ("your divorce happened",
"this person is a kafir", etc.) per SECURITY.md.

## Phase 4 — Flutter UI (5 screens)

Per the spec sent earlier:
- Ask Sheikh Home (warning + Ask + My Questions + popular)
- Choose Category (9 categories)
- Ask Question Form (≤500 chars, country, madhhab, urgency)
- Clarification Screen (conditional follow-ups)
- Answer Screen (label, short answer, evidence, practical steps,
  caution, request scholar review, save/share/report)
- My Questions (Pending / AI Guidance / Scholar Verified)

Visuals: use the new `IconAssets.sheikh3D` (already in `assets/icons/`)
for the home header, empty state, and loading state.

## Hard rules (mirror from SECURITY.md)

- **Mobile NEVER calls OpenAI directly.** All AI calls go through the
  Cloud Function.
- **Sources must come from our DB**, not invented. AI may not cite
  Quran/Hadith refs that don't exist in `evidence_sources` or
  `approved_answers`.
- **High-risk topics** (divorce, takfir, violence, complex inheritance,
  abuse, self-harm, legal disputes, complex finance contracts) route
  to scholar — no AI answer ever returned.
- **Crisis detection** (self-harm/suicide/abuse): show support
  resources, not religious ruling.
- **Privacy**: questions are user-private. User can delete history.
  Never used for AI training. Don't log question text.

## Status

Slice 7 — not started. Entry tile (`AskSheikhTile` with disclaimer
dialog) lives on home as a placeholder (Phosphor `chatCircleDots`
glyph; will swap to `IconAssets.sheikh3D` when screens land).
