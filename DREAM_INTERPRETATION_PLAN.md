# Dream Interpretation (تفسير الأحلام) — Plan

**Status: deferred to Phase 2 (post-MVP).** Not in any current slice.

This doc captures the design so it doesn't live only in chat history.
Before any implementation, the religious-sensitivity concerns at the
bottom must be addressed with a qualified scholar.

## Scope (MVP version of the feature)

- Arabic-only UI initially
- 4 screens: Warning, Input, Result, History
- Database of pre-approved dream symbols (scraped, then admin-reviewed)
- Daily usage limits (1/day guest, 3/day registered)
- AI fallback (OpenAI) only for dreams not matched in the symbol DB
- Strict safety rules — no definitive predictions, no accusations, no
  death/illness/divorce predictions

## User flow

```
User taps "تفسير الأحلام" tile
  ↓
Warning screen (must accept)
  ↓
Input screen (dream text + marital status + gender + dream time + emotion)
  ↓
Submit
  ├─ Daily limit hit  → block with friendly message
  ├─ Blocked content  → refuse, suggest professional help
  ├─ Symbol DB match  → return saved interpretation (free)
  └─ No match         → OpenAI with safety system prompt → save → return
  ↓
Result screen (general + possible meanings + Islamic advice + disclaimer)
  ↓
Optional: save to History
```

## Screens

### 1. Warning Screen
- Large warning icon, "تنبيه مهم" header
- Body: "تفسير الأحلام ليس علماً قطعياً. لا تعتمد عليه في قرارات الزواج،
  الطلاق، المال، العلاج، أو اتهام الآخرين. إذا كان الحلم مزعجاً أو
  متكرراً بشكل يؤثر عليك، استشر مختصاً أو شيخاً موثوقاً."
- "أوافق وأبدأ" gold button → routes to Input

### 2. Input Screen
- TextField for dream text (no max length but soft target ~500 chars)
- Radio groups:
  - حالة الرائي: أعزب / متزوج / مطلق / أرمل
  - الجنس: ذكر / أنثى
  - وقت الحلم: قبل الفجر / بعد الفجر / نهاراً / لا أتذكر
  - الشعور: خوف / راحة / حزن / فرح / لا أعرف
- Submit → "فسّر الحلم"

### 3. Result Screen
- التفسير العام: general soft interpretation
- المعنى المحتمل: possible meanings (NEVER definitive)
- نصيحة إيمانية: Islamic advice (dua, dhikr, sadaqah)
- ⚠️ تنبيه: "هذا تفسير عام وليس أمراً مؤكداً. لا تبني عليه قرارات مصيرية."
- Actions: حلم جديد | حفظ

### 4. History Screen
- List of past dreams (date + truncated text + status)
- Tap to re-open the saved Result

## Data model

### `dream_symbols` (Firestore — public read, admin write)
```ts
{
  id: string;
  symbol_ar: string;          // e.g., "الماء"
  symbol_en?: string;
  category: string;           // الطبيعة، الأشخاص، الحيوانات...
  meaning_general_ar: string; // soft, possibility-framed
  meaning_safe_ar: string;    // ultra-conservative variant
  source_name: string;
  source_url: string;
  source_type: 'public_domain' | 'permitted' | 'admin_authored';
  confidence_level: 'low' | 'medium' | 'high';
  approved: boolean;
  scholar_reviewed: boolean;
  created_at, updated_at: Timestamp;
}
```

### `dream_interpretations` (Firestore — owner-scoped private)
```ts
{
  user_id: string;
  dream_text: string;
  detected_symbols: string[];
  marital_status, gender, dream_time, emotion: string;
  answer_text: string;
  matched_symbols: string[];   // refs into dream_symbols
  used_ai: boolean;
  status: 'answered' | 'blocked' | 'limit_hit';
  created_at: Timestamp;
}
```

### `daily_dream_limits` (Firestore — owner-scoped)
Doc id = `${user_id}_${YYYY-MM-DD}`. Field: `count`, `limit`.

Add all three to `firestore.rules` when implementing — owner-scoped tier
for `dream_interpretations` and `daily_dream_limits`; public-read /
admin-write for `dream_symbols`.

## Safety rules

### Blocked content (refuse before reaching AI)
Reject input that contains:
- Sexual content keywords
- Explicit accusations of others (يخونني، يسحرني، يكرهني)
- Self-harm or suicide language → route to crisis-support flow

### OpenAI system prompt (when invoked)
```
You are a gentle Islamic dream interpreter.

STRICT RULES:
1. NEVER use definitive language ("سيحدث", "هذا مؤكد"). Always soft:
   "قد يدل", "ربما يشير", "من المعاني المحتملة".
2. NEVER accuse anyone ("فلان يخونك", "شخص يؤذيك").
3. NEVER predict death, illness, divorce, or specific disasters.
4. NEVER attribute to magic or evil eye as a definite cause.
5. Default toward general positive interpretations when ambiguous.
6. End with Islamic advice: dua, dhikr, sadaqah.

OUTPUT FORMAT:
التفسير العام: <soft general reading>
المعنى المحتمل: <possible meanings>
نصيحة إيمانية: <Islamic advice>
تنبيه: هذا تفسير عام وليس أمراً مؤكداً.
```

### Post-generation safety pass
Same idea as Ask Sheikh — block answers containing forbidden phrasings
even if they slip past the system prompt.

## Scraper

Add `dream_scraper.py` to `rahma_scraper/` when implementing. The
scraper targets public-domain dream-interpretation books (e.g. Ibn
Sirin's published works). All scraped entries land in a "pending review"
queue — admin must approve before they reach `dream_symbols.approved =
true`.

The `_make_safe()` helper in the spec rewrites definitive language into
possibility-framed language and appends a disclaimer. That logic should
also be applied at admin-review time, not only at scrape time.

## Cloud Function

`interpretDream(data, context)`:
1. Verify auth
2. Check daily limit (Firestore counter)
3. Check blocked content
4. Extract symbols (keyword tokenizer over normalized text)
5. Search `dream_symbols` for matches
6. If matched → assemble response from DB + return
7. Else → OpenAI with system prompt above
8. Post-generation safety pass
9. Persist to `dream_interpretations`
10. Return `{ general, possible, advice, disclaimer }`

## Religious-sensitivity concerns to resolve before launch

- Some Muslim scholars discourage casual dream interpretation by
  non-specialists. **A qualified scholar should bless the feature
  before it ships.** "We added a warning screen" is necessary but not
  sufficient.
- The seed `dream_symbols` content will likely come from classical works
  (e.g. Ibn Sirin attributions). Modern scholars dispute many specific
  attributions — seed only well-attested entries.
- The OpenAI fallback can still produce religiously incorrect content
  even with a strong system prompt. Treat AI dream interpretation as
  experimental and visibly flag it (badge: "تفسير ذكاء صناعي - قيد
  المراجعة").
- Daily limits keep cost down but the bigger reason is responsibility:
  the app shouldn't encourage users to seek dream interpretations
  multiple times a day.

## Mandatory answer template

The Result screen and AI output must always conform to this Arabic
template — verbatim section headers:

```
التفسير العام:
[simple explanation, possibility-framed]

المعاني المحتملة:
- [possibility 1]
- [possibility 2]
- [possibility 3]

نصيحة إيمانية:
[Islamic advice: dua, dhikr, sadaqah]

تنبيه مهم:
هذا تفسير عام وليس حكماً مؤكداً، والله أعلم.
```

The post-generation safety pass should verify that all four section
headers are present and that the body uses the soft-language phrases
(قد يدل / ربما يشير / من المعاني المحتملة / لا يمكن الجزم) rather than
the forbidden definitive phrases.

## Backend API contract

Cloud Function HTTPS endpoints (TypeScript). All require Firebase Auth.

| Method | Path | Caller | Purpose |
|---|---|---|---|
| `POST` | `/dreams/interpret` | user | Submit a dream → returns interpretation |
| `GET`  | `/dreams/history/:userId` | user | Owner's dream history |
| `GET`  | `/admin/pending-dreams` | admin | Queue of AI-generated answers awaiting review |
| `POST` | `/admin/approve-dream` | admin | Approve a pending answer (publishes to user) |
| `POST` | `/admin/reject-dream` | admin | Reject + reason |
| `GET`  | `/admin/symbols` | admin | List/search dream_symbols |
| `POST` | `/admin/symbols` | admin | Create or update a symbol |

Admin endpoints check membership in `admin_users` Firestore collection
(per `firestore.rules` admin tier).

## Flutter folder structure (for when implementation begins)

Per project convention, code lives under `lib/features/tafseer_ahlam/`:

```
lib/features/tafseer_ahlam/
├── screens/
│   ├── dream_warning_screen.dart
│   ├── dream_input_screen.dart
│   ├── dream_result_screen.dart
│   └── dream_history_screen.dart
├── widgets/
│   ├── dream_card.dart           // Reused in History
│   ├── radio_group_field.dart    // Used by Input form
│   └── disclaimer_banner.dart    // Reused on Warning + Result
├── models/
│   ├── dream.dart                // Submitted dream entity
│   ├── dream_interpretation.dart // Result entity
│   └── dream_symbol.dart         // DB symbol entity
├── services/
│   ├── dream_repository.dart     // Calls Cloud Function endpoints
│   └── dream_safety.dart         // Local content filter (pre-submit guard)
└── controllers/
    └── dream_controller.dart     // Riverpod StateNotifier
```

Note: existing slices use `lib/presentation/screens/<feature>/` + a
shared `lib/data/repositories/` rather than per-feature folders. When
implementing this feature, decide whether to follow that pattern or
move to per-feature foldering — pick one and apply consistently.

## Admin panel (separate web app, not in mobile repo)

Six screens; build as a tiny React or Next.js app, deployed to Firebase
Hosting:

1. **Login** — Firebase Auth with admin claim required
2. **Dashboard** — counts (pending dreams, approved symbols today,
   blocked submissions today, daily-limit trips)
3. **Pending Interpretations** — review queue for AI answers; approve /
   reject / edit-then-approve
4. **Dream Symbol Database** — search, create, edit, deprecate symbols
5. **Scraper Review** — approve/reject items from `scraped_sources`
6. **User Limits Settings** — adjust per-tier daily caps; manual
   override per user (rare)

Admin panel is **not** part of the mobile app codebase. Separate repo.

## Status

Not in any current slice. Implement after the MVP slices (5–7) ship
and after a scholar review of the architecture and seed content.
