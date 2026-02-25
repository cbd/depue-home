# Echo ↔ OpenClaw Intent Matrix (v1)

Last updated: 2026-02-24

## Goal

Define which voice requests should:
1. execute directly (deterministic actions),
2. route to `/chat` (reasoning),
3. require confirmation (risky actions).

Bridge host: `100.66.211.57` (Tailscale)

---

## Endpoints

- Primary sync QA: `POST /chat`
- Debug/control: `GET /claude-debug-channel`

Auth header for `/chat`:
`Authorization: Bearer <BRIDGE_TOKEN>`

---

## Intent Classes

### A) Direct deterministic (no LLM interpretation required)

- `time.now`
- `health.status`
- `todo.add`
- `todo.list_today`
- `calendar.next`
- `calendar.today_summary`
- `reminder.create`

Policy:
- If slots parse cleanly, execute immediately.
- Return short voice response (1 sentence preferred).

### B) Routed reasoning (LLM via `/chat`)

- `daily.briefing.generate`
- `project.coach`
- `schedule.recommendation`
- `decision.support`
- `agent.mission.plan`

Policy:
- Keep replies concise by default for voice (`source=echo-ha`).
- Hard cap 1–2 sentences unless explicitly asked for detail.

### C) Protected/confirmation-required

- `message.send`
- `email.send`
- `call.initiate`
- `calendar.create/modify/delete`
- `home.security_action`
- destructive deletes/overwrites

Policy:
- Ask explicit confirmation before execution.
- Log approved action + caller + timestamp.

---

## Response Modes

- `voice_short`: 1 sentence
- `voice_medium`: 2 short sentences
- `voice_briefing`: compact bullet-style summary
- `confirm_then_act`: prompt for confirmation then execute

For Echo path, default to `voice_short`.

---

## Fallback Rules

When confidence is low:
1. Ask one concise clarification question.
2. Do not execute protected actions.
3. Prefer read-only response.

---

## Initial Command Set (Recommended to implement first)

1. What time is it?
2. What’s my next calendar event?
3. Give me my morning summary.
4. Add a personal task: <text>
5. What are my top three things?
6. Remind me at <time> to <task>.
7. Start a mission: <goal>.
8. Mission status.

---

## Example `/chat` payload

```json
{
  "text": "Give me my morning summary in one sentence.",
  "source": "echo-ha"
}
```

Expected response:

```json
{
  "ok": true,
  "reply": "You have 3 priorities today: ..."
}
```
