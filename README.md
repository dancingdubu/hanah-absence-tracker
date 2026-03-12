# Hanah One — Internal Tools

Internal tooling and automation for Hanah One.

## Absence Tracker

Reads absence announcements from the `#99-whereabout` Slack channel, parses them into structured records, and displays them in an interactive HTML calendar.

- **`absence_calendar.html`** — Self-contained calendar UI (color-coded by person, month navigation, detail panel, summary view)
- **Scheduled task** — Runs daily at 6 PM, fetches new Slack messages and updates `absences.json`
